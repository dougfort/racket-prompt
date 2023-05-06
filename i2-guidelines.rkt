#lang racket

;; 

(require "chat.rkt")

(define content "What is the OpenAI mission?")

(define text
  "You should express what you want a model to do by 
providing instructions that are as clear and
specific as you can possibly make them.
This will guide the model towards the desired output,
and reduce the chances of receiving irrelevant
or incorrect responses. Don't confuse writing a 
clear prompt with writing a short prompt. 
In many cases, longer prompts provide more clarity 
and context for the model, which can lead to 
more detailed and relevant outputs.")

;; Tactic 1: Use delimiters to clearly indicate distinct parts of the input¶
(define i2-prompt-1
  (string-join
   (list
    "Summarize the text delimited by triple backticks into a single sentence."
    "```"
    text
    "```")))

;; Tactic 2: Ask for a structured output
(define i2-prompt-2
  "Generate a list of three made-up book titles along 
with their authors and genres. 
Provide them in JSON format with the following keys: 
book_id, title, author, genre.")

;; Tactic 3: Ask the model to check whether conditions are satisfied
(define text_1
  "Making a cup of tea is easy! First, you need to get some  
water boiling. While that's happening,  
grab a cup and put a tea bag in it. Once the water is  
hot enough, just pour it over the tea bag.  
Let it sit for a bit so the tea can steep. After a  
few minutes, take out the tea bag. If you  
like, you can add some sugar or milk to taste.  
And that's it! You've got yourself a delicious  
cup of tea to enjoy.")

(define i2-prompt-3
  (string-join
   (list
    "You will be provided with text delimited by triple quotes. 
If it contains a sequence of instructions, 
re-write those instructions in the following format:

Step 1 - ...
Step 2 - ...
...
Step N - ...

If the text does not contain a sequence of instructions, 
then simply write \"No steps provided.\"

\"\"\""
text_1
"\"\"\"")))
