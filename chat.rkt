#lang racket

;; 

(require net/http-client)
(require json)

(provide query)

;; looking for '("HTTP/1.1" "200" "OK")
;; returning (status reason)
(define (parse-status-line status-line)
  (let ([parts ((compose1 string-split bytes->string/utf-8) status-line)])
    (values ((compose string->number second) parts) (string-join (drop parts 2)))))

;; API entry point
(define (create-uri)
  (string-append "/v1/chat/completions"))

;; define the query POST data as a hash
;; which can be coinverted to JSON
(define (query-hash query-content)
  (hash
   'model "gpt-3.5-turbo"
   'messages (list (hash
                    'role "user"
                    'content query-content))))                      

;; return query results
(define (query api-key content)
  (let-values ([(status-line header-list data-port)
                (http-sendrecv
                 "api.openai.com"
                 (create-uri)
                 #:ssl? #t
                 #:method #"POST"
                 #:headers (list
                            (string-append "Authorization: " (string-append "Bearer " api-key))
                            "Content-Type: application/json")
                 #:data (jsexpr->string (query-hash content)))])
    (let-values ([(status reason) (parse-status-line status-line)])
      (unless (= 200 status)
        (error (format "invalid HTTP status ~s; ~s" status reason))))
    (read-json data-port)))

(define (get-content qr)
  (hash-ref (hash-ref (first (hash-ref qr 'choices)) 'message) 'content))