;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname exercise453) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; A Line is a [List-of 1String].

; A Token is one of
; - 1String (a lower-case letter
; - String (only lower-case letters)

; Line -> [List-of Token]
; turns a line into a list of tokens
(check-expect (tokenize (list "h" "o" "w" " " "a" "r" "e" " " "y" "o" "u"))
              (list "how" "are" "you"))
(define (tokenize line)
  (cond
    [(empty? line) '()]
    [else (cons (first-word line)
           (tokenize (remove-first-word line)))]))

; Line -> String
; returns the first token from a line
(check-expect (first-word (list "h" "o" "w" " " "a" "r" "e" " " "y" "o" "u")) "how")
(define (first-word line)
  (cond
    [(empty? line) ""]
    [(string-whitespace? (first line)) ""]
    [else (string-append (first line)
                         (first-word (rest line)))]))

; Line -> Line
; returns the line less the first token
(check-expect (remove-first-word (list "h" "o" "w" " " "a" "r" "e" " " "y" "o" "u"))
              (list "a" "r" "e" " " "y" "o" "u"))
(define (remove-first-word line)
  (cond
    [(empty? line) '()]
    [(string-whitespace? (first line)) (rest line)]
    [else (remove-first-word (rest line))]))