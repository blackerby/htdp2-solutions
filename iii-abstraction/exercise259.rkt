;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname exercise259) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/batch-io)

(define LOCATION "/usr/share/dict/words")

; A Dictionary is a List-of-strings.
(define AS-LIST (read-lines LOCATION))

; List-of-strings -> Boolean
(define (all-words-from-rat? w)
  (and
    (member? "rat" w) (member? "art" w) (member? "tar" w)))
 
; String -> List-of-strings
; finds all words that the letters of some given word spell
 
(check-member-of (alternative-words "cat")
                 (list "act" "cat")
                 (list "cat" "act"))
 
(check-satisfied (alternative-words "rat")
                 all-words-from-rat?)
 
(define (alternative-words s)
  (create-set
   (in-dictionary
    (words->strings (arrangements (string->word s))))))
 
; List-of-words -> List-of-strings
; turns all Words in low into Strings
(check-expect (words->strings '()) '())
(check-expect (words->strings (list (list "c" "a" "t")
                                    (list "a" "n" "i" "m" "a" "l")))
              (list "cat" "animal"))
(define (words->strings low)
  (cond
    [(empty? low) '()]
    [else (cons (word->string (first low)) (words->strings (rest low)))]))
 
; List-of-strings -> List-of-strings
; picks out all those Strings that occur in the dictionary
(check-expect (in-dictionary (list "asdfas" "pizza" "ertw")) (list "pizza"))
(check-satisfied (in-dictionary (list "rat" "tra" "tar" "art" "atr")) all-words-from-rat?)
(define (in-dictionary los)
  (cond
    [(empty? los) '()]
    [else
     (if (member? (first los) AS-LIST)
         (cons (first los) (in-dictionary (rest los)))
         (in-dictionary (rest los)))]))
 
; Word -> List-of-words
; creates all rearrangements of the letters in w
(check-expect (arrangements (list "e" "d"))
              (list (list "e" "d")
                    (list "d" "e")))
(define (arrangements w)
  (local
    ; 1String List-of-words -> List-of-words
    ; inserts the 1String s at the beginning, between all letters, and at the end
    ; of every word in the List-of-words low
    ((define (insert-everywhere/in-all-words s low)
       (cond
         [(empty? low) '()]
         [else
          (append (insert-everywhere/in-one-word s (first low))
                  (insert-everywhere/in-all-words s (rest low)))]))

     ; 1String Word -> List-of-words
     ; inserts 1String in all positions of given word
     (define (insert-everywhere/in-one-word s w)
       (append
        (list (cons s w))
        (insert-between s w)))
    
     ; 1String Word -> List-of-words
     ; inserts 1String between and at end of letters of given word
     (define (insert-between s w)
       (cond
         [(empty? w) '()]
         [else (cons (cons (first w) (cons s (rest w)))
                     (insert-between-rest (list (first w)) s (rest w)))]))

     ; 1String Word Word -> List-of-words
     ; appends word m to result of inserting s between and at end of members of w
     (define (insert-between-rest m s w)
       (cond
         [(empty? w) '()]
         [else
          (cons (append m (cons (first w) (cons s (rest w))))
                (insert-between-rest (add-at-end (first w) m) s (rest w)))])))
    
     (cond
       [(empty? w) (list '())]
       [else (insert-everywhere/in-all-words (first w)
                                             (arrangements (rest w)))])))

; 1String Word -> Word
; adds 1String s to end of word w
(check-expect (add-at-end "a" '()) (list "a"))
(check-expect (add-at-end "a" (list "b")) (list "b" "a"))
(check-expect (add-at-end "a" (list "b" "c")) (list "b" "c" "a"))
(check-expect (add-at-end "d" (list "a" "b" "c")) (list "a" "b" "c" "d"))
(define (add-at-end s w)
  (cond
    [(empty? w) (cons s '())]
    [else (cons (first w) (add-at-end s (rest w)))]))

; A Word is one of:
; – '() or
; – (cons 1String Word)
; interpretation a Word is a list of 1Strings (letters)
; examples:
(define cat (list "c" "a" "t"))
(define animal (list "a" "n" "i" "m" "a" "l"))

; A List-of-words is one of:
; - '()
; - (cons Word List-of-words)
; interpretation: a list-of-words is a list of lists of 1Strings
; examples:
(define low0 '())
(define low1 (list cat))
(define low2 (list cat animal))

; String -> Word
; converts s to the chosen word representation
(check-expect (string->word "") '())
(check-expect (string->word "cat") (list "c" "a" "t"))
(check-expect (string->word "animal") (list "a" "n" "i" "m" "a" "l"))
(define (string->word s) (explode s))
 
; Word -> String
; converts w to a string
(check-expect (word->string '()) "")
(check-expect (word->string (list "c" "a" "t")) "cat")
(check-expect (word->string (list "a" "n" "i" "m" "a" "l")) "animal")
(define (word->string w) (implode w))

; List-of-strings -> List-of-strings
; produces list of strings that contains each string from given list exactly once
(check-expect (create-set '()) '())
(check-expect (create-set (list "dogs")) (list "dogs"))
(check-expect (create-set (list "pizza" "fishsticks" "pasta" "pizza"))
              (list "fishsticks" "pasta" "pizza"))
(check-expect (create-set (list "pizza" "fishsticks" "pasta" "pizza" "pizza"))
              (list "fishsticks" "pasta" "pizza"))
(check-expect (create-set (list "pizza" "fishsticks" "pasta" "fishsticks" "pizza" "pizza"))
              (list "pasta" "fishsticks" "pizza"))
(define (create-set lt)
  (cond
    [(empty? lt) '()]
    [(empty? (rest lt)) lt]
    [else (if (member? (first lt) (rest lt))
              (create-set (rest lt))
              (cons (first lt) (create-set (rest lt))))]))