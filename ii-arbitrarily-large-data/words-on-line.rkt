;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname words-on-line) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/batch-io)

; An LN is one of: 
; – '()
; – (cons Los LN)
; interpretation a list of lines, each is a list of Strings
 
(define line0 (cons "hello" (cons "world" '())))
(define line1 '())
 
(define ln0 '())
(define ln1 (cons line0 (cons line1 '())))
 
; LN -> List-of-numbers
; determines the number of words on each line 
 
(check-expect (words-on-line ln0) '())
(check-expect (words-on-line ln1) (cons 2 (cons 0 '())))
 
(define (words-on-line ln)
  (cond
    [(empty? ln) '()]
    [else (cons (length (first ln))
                (words-on-line (rest ln)))]))

; String -> List-of-numbers
; counts the words on each line in the given file
(define (file-statistic file-name)
  (words-on-line
    (read-words/line file-name)))

;; exercise 172
; LN -> String
; converts a list of lines into a string
(check-expect (collapse ln0) "")
(check-expect (collapse ln1) "hello world\n")
(define (collapse ln)
  (cond
    [(empty? ln) ""]
    [else
     (string-append (line->string (first ln))
                    (collapse (rest ln)))]))

; Los -> String
; converts a line into a string
(check-expect (line->string '()) "\n")
(check-expect (line->string line0) "hello world")
(define (line->string los)
  (cond
    [(empty? los) "\n"]
    ;[(empty? (rest los)) (string-append (first los) ()] 
    [else
     (string-append
      (first los)
      (if (empty? (rest los))
          ""
          (string-append " " (line->string (rest los)))))]))

(check-expect (read-file "ttt.dat") (read-file "ttt.txt"))