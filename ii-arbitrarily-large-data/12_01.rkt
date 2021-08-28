;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-abbr-reader.ss" "lang")((modname 12_01) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/batch-io)

(define LOCATION "/usr/share/dict/words")

; A Dictionary is a List-of-strings.
(define AS-LIST (read-lines LOCATION))

; A Letter is a member? of this list:
(define LETTERS
  (explode "abcdefghijklmnopqrstuvwxyz"))

;; exercise 195
; Letter Dictionary -> Number
; counts how many words in the given dictionary start with
; the given letter
(check-expect (starts-with# "a" (list "apple" "banana" "pear")) 1)
(check-expect (starts-with# "b" (list "bing" "bong" "boop")) 3)
(check-expect (starts-with# "c" (list "bing" "bong" "boop")) 0)
(check-expect (starts-with# "d" '()) 0)
(check-expect (starts-with# "e" (list "couch" "potato" "elephant")) 1)
(define (starts-with# lt dict)
  (cond
    [(empty? dict) 0]
    [else
     (if (starts-with? (first dict) lt)
         (+ 1 (starts-with# lt (rest dict)))
         (starts-with# lt (rest dict)))]))

; String Letter -> Boolean
; returns true if String s starts with letter lt
(check-expect (starts-with? "pizza" "p") #true)
(check-expect (starts-with? "pizza" "f") #false)
(define (starts-with? s lt)
  (string=? lt (first (explode s))))

(define STARTS-WITH-E# (starts-with# "e" AS-LIST))
(define STARTS-WITH-Z# (starts-with# "z" AS-LIST))

;; exercise 196
(define-struct lc [letter count])
; A Letter-Count is a structure:
;   (make-lc Letter Number)
; interpretation: a letter and the number of times words starting with that letter
; appear in the dictionary.

; A List-of-Letter-Counts is one of:
; - '()
; - (cons Letter-Count List-of-Letter-Counts)

;; exercise 196
; Dictionary List-of-Letters -> List-of-Letter-Counts
; counts how often each Letter is used as the first letter of a word
; in a given dictionary
(check-expect (count-by-letter '() '()) '())
(check-expect (count-by-letter (list "apple" "aardvark" "banana" "zounds") (list "a" "b" "z"))
              (list (make-lc "a" 2) (make-lc "b" 1) (make-lc "z" 1)))
(define (count-by-letter dict lol)
  (cond
    [(empty? lol) '()]
    [else
     (cons
      (make-lc (first lol) (starts-with# (first lol) dict))
      (count-by-letter dict (rest lol)))]))

; Dictionary List-of-Letters -> List-of-Letter-Counts
; counts how often each Letter is used as the first letter of a word
; in a given dictionary
(check-expect (count-by-letter-b '()) '())
(check-expect (count-by-letter-b (list "apple" "aardvark" "banana" "zounds"))
              (list (make-lc "a" 2) (make-lc "b" 1) (make-lc "z" 1)))
(define (count-by-letter-b dict)
  (cond
    [(empty? dict) '()]
    [else (count-by-letter dict (unique (firsts dict)))]))
                       
; String -> 1String
; produces first letter of given string
(check-expect (first-letter "pizza") "p")
(define (first-letter s)
  (first (explode s)))

; List-of-Strings -> List-of-1Strings
; returns the first letter of each string in the input
(check-expect (firsts (list "apple" "banana" "cookie")) (list "a" "b" "c"))
(define (firsts lls)
  (cond
    [(empty? lls) '()]
    [else
     (cons (first-letter (first lls))
           (firsts (rest lls)))]))

; List-of-1Strings -> List-of-1Strings
; returns unique 1Strings
(check-expect (unique '()) '())
(check-expect (unique (list "a" "a" "b" "c")) (list "a" "b" "c"))
(define (unique l)
  (cond
    [(empty? l) '()]
    [else
     (cond
       [(member? (first l) (rest l)) (unique (rest l))]
       [else (cons (first l) (unique (rest l)))])]))

;; improvements to exercise 196 can be found in exercise197.rkt