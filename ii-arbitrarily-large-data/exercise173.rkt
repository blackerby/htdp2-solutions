;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname exercise173) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/batch-io)

; A FileName is a string.
; interpretation: the name of a file

; An Article is one of the following strings
(define A "a")
(define AN "an")
(define THE "the")
; interpretation: the three articles in the English language.

;; exercise 173
; FileName -> File
; consumes the name of file, removes the articles
; and writes to a file prefixed "no-articles-" with n.
(check-expect (remove-articles "ttt.txt") "no-articles-ttt.txt")
(define (remove-articles n)
  (write-file
   (string-append "no-articles-" n)
   (collapse (remove-articles-ln
              (read-words/line n)))))

; LN -> LN
; removes the Articles from the given LN
(check-expect (remove-articles-ln
               (cons
                (cons "TTT" '())
                (cons
                 (cons "Put" (cons "up" (cons "in" (cons "a" (cons "place" '())))))
                 (cons
                  (cons "where" (cons "it's" (cons "easy" (cons "to" (cons "see" '())))))
                  (cons
                   (cons "the" (cons "cryptic" (cons "admonishment" '())))
                   (cons
                    (cons "T.T.T." '())
                    (cons
                     (cons "When" (cons "you" (cons "feel" (cons "how" (cons "depressingly" '())))))
                     (cons
                      (cons "slowly" (cons "you" (cons "climb," '())))
                      (cons
                       (cons "it's" (cons "well" (cons "to" (cons "remember" (cons "that" '())))))
                       (cons (cons "Things" (cons "Take" (cons "Time." '()))) (cons (cons "Piet" (cons "Hein" '())) '())))))))))))
              (cons
               (cons "TTT" '())
               (cons
                (cons "Put" (cons "up" (cons "in" (cons "place" '()))))
                (cons
                 (cons "where" (cons "it's" (cons "easy" (cons "to" (cons "see" '())))))
                 (cons
                  (cons "cryptic" (cons "admonishment" '()))
                  (cons
                   (cons "T.T.T." '())
                   (cons
                    (cons "When" (cons "you" (cons "feel" (cons "how" (cons "depressingly" '())))))
                    (cons
                     (cons "slowly" (cons "you" (cons "climb," '())))
                     (cons
                      (cons "it's" (cons "well" (cons "to" (cons "remember" (cons "that" '())))))
                      (cons (cons "Things" (cons "Take" (cons "Time." '()))) (cons (cons "Piet" (cons "Hein" '())) '())))))))))))
(define (remove-articles-ln ln)
  (cond
    [(empty? ln) '()]
    [else
     (cons (remove-articles-los (first ln)) (remove-articles-ln (rest ln)))]))

; Los -> Los
; removes the Articles from the given Los
(check-expect (remove-articles-los (cons "Put" (cons "up" (cons "in" (cons "a" (cons "place" '()))))))
              (cons "Put" (cons "up" (cons "in" (cons "place" '())))))
(define (remove-articles-los los)
  (cond
    [(empty? los) '()]
    [else
     (if (article? (first los))
         (remove-articles-los (rest los))
         (cons (first los) (remove-articles-los (rest los))))]))

; String -> Boolean
; returns #true if given string is an Article
(check-expect (article? A) #true)
(check-expect (article? AN) #true)
(check-expect (article? THE) #true)
(check-expect (article? "to") #false)
(define (article? s)
  (or
   (string=? A s)
   (string=? AN s)
   (string=? THE s)))

; An LN is one of: 
; – '()
; – (cons Los LN)
; interpretation a list of lines, each is a list of Strings
 
(define line0 (cons "hello" (cons "world" '())))
(define line1 '())
 
(define ln0 '())
(define ln1 (cons line0 (cons line1 '())))

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
(check-expect (line->string '()) "")
(check-expect (line->string line0) "hello world\n")
(define (line->string los)
  (cond
    [(empty? los) ""]
    [(empty? (rest los)) (string-append (first los) "\n")] 
    [else
     (string-append
      (first los) " " (line->string (rest los)))]))