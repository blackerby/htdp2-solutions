;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-abbr-reader.ss" "lang")((modname exercise197) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
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

;(define STARTS-WITH-E# (starts-with# "e" AS-LIST))
;(define STARTS-WITH-Z# (starts-with# "z" AS-LIST))

(define-struct lc [letter count])
; A Letter-Count is a structure:
;   (make-lc Letter Number)
; interpretation: a letter and the number of times words starting with that letter
; appear in the dictionary.

; A List-of-Letter-Counts is one of:
; - '()
; - (cons Letter-Count List-of-Letter-Counts)

; Dictionary -> List-of-Letter-Counts
; counts how often each Letter is used as the first letter of a word
; in a given dictionary
(check-expect (count-by-letter '()) '())
(check-expect (count-by-letter (list "apple" "aardvark" "banana" "zounds"))
              (list (make-lc "z" 1) (make-lc "b" 1) (make-lc "a" 2)))
(define (count-by-letter dict)
  (cond
    [(empty? dict) '()]
    [else
     (update-lc (first-letter (first dict)) (count-by-letter (rest dict)))]))

; some assistance sought here:
; https://gitlab.com/cs-study/htdp/-/blob/main/02-Arbitrarily-Large-Data/12-Projects-Lists/Exercise-196.rkt

; Letter List-of-Letter-Counts -> List-of-Letter-Counts
; updates letter count for given letter
(check-expect (update-lc "a" (list (make-lc "a" 1)))
              (list (make-lc "a" 2)))
(check-expect (update-lc "b" '())
              (list (make-lc "b" 1)))
(check-expect (update-lc "z" (list
                              (make-lc "a" 2)
                              (make-lc "b" 1)
                              (make-lc "z" 1)))
              (list
               (make-lc "a" 2)
               (make-lc "b" 1)
               (make-lc "z" 2)))
(define (update-lc lt llc)
  (cond
    [(empty? llc) (cons (make-lc lt 1) llc)]
    [else
     (if (string=? lt (lc-letter (first llc)))
         (cons (make-lc (lc-letter (first llc))
                        (+ (lc-count (first llc)) 1))
               (rest llc))
         (cons (first llc) (update-lc lt (rest llc))))]))
  
; String -> 1String
; produces first letter of given string
(check-expect (first-letter "pizza") "p")
(define (first-letter s)
  (substring s 0 1))

; Dictionary -> Letter-Count
; produces Letter-Count for the letter that occurs most often
; as the first letter in the given Dictionary.
(check-expect (most-frequent (list "apple" "aardvark" "banana" "zounds"))
              (make-lc "a" 2))
(define (most-frequent dict)
  (max-count (count-by-letter dict)))

; A NEList-of-Letter-Counts is one of:
; (list Letter-Count)
; (cons Letter-Count NEList-of-Letter-Counts)

; NEList-of-Letter-Counts -> Letter-Count
; returns the Letter-Count with the highest count value
(check-expect (max-count (list (make-lc "z" 1) (make-lc "b" 1) (make-lc "a" 2)))
              (make-lc "a" 2))
(check-expect (max-count (list (make-lc "a" 2) (make-lc "b" 1) (make-lc "z" 1)))
              (make-lc "a" 2))
(define (max-count llc)
  (cond
    [(empty? (rest llc)) (first llc)]
    [else
     (if (> (lc-count (first llc)) (lc-count (second llc)))
         (max-count (cons (first llc) (rest (rest llc))))
         (max-count (rest llc)))]))

; Dictionary -> Letter-Count
; produces Letter-Count for the letter that occurs most often
; as the first letter in the given Dictionary.
(check-expect (most-frequent-b (list "apple" "aardvark" "banana" "zounds"))
              (make-lc "a" 2))
(define (most-frequent-b dict)
  (first (sort> (count-by-letter dict))))

; I prefer this option. sort> is a somewhat abstract, reusable function,
; this implementation is easier to understand.


; List-of-Letter-Counts -> List-of-Letter-Counts
; sort a list of Letter-Counts in descending order
(define (sort> llc)
  (cond
    [(empty? llc) '()]
    [else
     (insert (first llc) (sort> (rest llc)))]))

; Letter-Count List-of-Letter-Counts -> List-of-Letter-Counts
; insert count into sorted list of letter counts llc
(define (insert count llc)
  (cond
    [(empty? llc) (list count)]
    [else
     (if (>= (lc-count count) (lc-count (first llc)))
         (cons count llc)
         (cons (first llc) (insert count (rest llc))))]))

;(check-expect (most-frequent AS-LIST) (most-frequent-b AS-LIST))

; Dictionary -> List-of-Dictionary
; consumes a dictionary and produces a list of dictionaries, one per letter
(check-expect (words-by-first-letter (list "apple" "aardvark" "banana" "zounds"))
              (list
               (list "zounds")
               (list "banana")
               (list "apple" "aardvark")))
(define (words-by-first-letter d)
  (cond
    [(empty? d) '()]
    [else
     (add-dict (first d) (words-by-first-letter (rest d)))]))

; String List-of-Dictionary -> List-of-Dictionary
; adds string to appro[riate dictionary by first letter, or creates
; new dictionary if appropriate one doesn't exist
(check-expect (add-dict "aardvark" (list (list "apple")
                                         (list "banana")
                                         (list "zounds")))
             (list
              (list "aardvark" "apple")
              (list "banana")
              (list "zounds")))
(check-expect (add-dict "banana" (list (list "apple")
                                       (list "zounds")))
              (list
               (list "apple")
               (list "zounds")
               (list "banana")))
(define (add-dict s lod)
  (cond
    [(empty? lod) (list (list s))]
    [else
     (if (string=? (first-letter s) (first-letter (first (first lod))))
         (cons (cons s (first lod)) (rest lod))
         (cons (first lod) (add-dict s (rest lod))))]))

; Dictionary -> Letter-Count
; produces Letter-Count for the letter that occurs most often
; as the first letter in the given Dictionary.
(check-expect (most-frequent.v2 (list "apple" "aardvark" "banana" "zounds"))
              (make-lc "a" 2))
(define (most-frequent.v2 d)
  (first (sort> (letter-counts-first (words-by-first-letter d)))))

; List-of-Dictionary -> List-of-Letter-Counts
; returns first Letter-Count for each dictionary in a list of dictionaries
(check-expect (letter-counts-first (list
                              (list "aardvark" "apple")
                              (list "banana")
                              (list "zounds")))
              (list (make-lc "a" 2)
                    (make-lc "b" 1)
                    (make-lc "z" 1)))
(define (letter-counts-first lod)
  (cond
    [(empty? lod) '()]
    [else
     (cons (first (count-by-letter (first lod)))
           (letter-counts-first (rest lod)))]))

(check-expect
  (most-frequent AS-LIST)
  (most-frequent.v2 AS-LIST))