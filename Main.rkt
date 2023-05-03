#lang racket

;; 

(require net/http-client)
(require json)

;; looking for '("HTTP/1.1" "200" "OK")
;; returning (status reason)
(define (parse-status-line status-line)
  (let ([parts ((compose1 string-split bytes->string/utf-8) status-line)])
    (values ((compose string->number second) parts) (string-join (drop parts 2)))))

;; API entry point
(define (create-uri)
  (string-append "/v1/chat/completions"))

;; API Key
(define (load-authorization api-key)
  (string-append "Bearer " api-key))

;; return query results
(define (query api-key)
  (let-values ([(status-line header-list data-port)
                (http-sendrecv
                 "api.openai.com"
                 (create-uri)
                 #:ssl? #t
                 #:method #"POST"
                 #:headers (list
                            (string-append "Authorization: " (load-authorization api-key))
                            "Content-Type: application/json")
                 #:data #"{
 \"model\": \"gpt-3.5-turbo\",
 \"messages\": [{\"role\": \"user\", \"content\": \"What is the OpenAI mission?\"}]
}")])
    (let-values ([(status reason) (parse-status-line status-line)])
      (unless (= 200 status)
        (error (format "invalid HTTP status ~s; ~s" status reason))))
    (let ([result-hash (read-json data-port)])
      (print result-hash)
      (hash-keys result-hash))))
