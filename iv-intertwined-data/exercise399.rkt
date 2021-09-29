;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname exercise399) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; [List-of String] -> [List-of String] 
; picks a random non-identity arrangement of names
(define (gift-pick names)
  (random-pick
    (non-same names (arrangements names))))
 
; [NEList-of X] -> X 
; returns a random item from the list 
(define (random-pick l)
  (list-ref l (random (length l)))) 
 
; [List-of String] [List-of [List-of String]] 
; -> 
; [List-of [List-of String]]
; produces the list of those lists in ll that do 
; not agree with names at any place
(check-expect (non-same (list "William") (arrangements (list "William"))) '())
(check-expect (non-same (list "William" "Kristin") (arrangements (list "William" "Kristin")))
              (list (list "Kristin" "William")))
(check-expect (non-same (list "William" "Kristin" "Lilly") (arrangements (list "William" "Kristin" "Lilly")))
              (list
               (list "Kristin" "Lilly" "William")
               (list "Lilly" "William" "Kristin")))
(define (non-same names ll)
  (cond
    [(empty? ll) '()]
    [else
     (local ((define (non-same? names l) ; so simple and elegant! wish i'd thought of it.
               ; if the first element of names is the same as the first element of l
               ; then they are in the same position.
               (cond
                 [(empty? l) #true]
                 [else (and (not (string=? (first names) (first l))) ; note use of and with not
                            (non-same? (rest names) (rest l)))])))
             (append
              (if (non-same? names (first ll))
                  (list (first ll))
                  '())
              (non-same names (rest ll))))]))

; This solution is not my work, it is adapted from the following.
; https://gitlab.com/cs-study/htdp/-/blob/main/04-Intertwined-Data/23-Simultaneous-Processing/Exercise-399.rkt
; The solution found there DOES NOT work. The second cond clause needed to be rewritten.
; Overall, it's an elegant and simple solution. The original author is a very good Lisp programmer.

;; Auxiliary Functions
;; (arrangements is trash! need to rewrite)

; [List-of X] X -> N
; produces the index of the given item
(check-error (index '() 'a) "item not found")
(check-expect (index '(a) 'a) 0)
(check-expect (index '(b a) 'a) 1)
(check-expect (index '(c b a) 'a) 2)
(define (index l x)
  (cond
    [(empty? l) (error "item not found")]
    [else
     (if (equal? (first l) x)
         0
         (add1 (index (rest l) x)))]))

; [List-of String] -> [List-of [List-of String]]
; creates all rearrangements of the letters in w
(check-expect (arrangements (list "e" "d"))
              (list (list "e" "d")
                    (list "d" "e")))
(define (arrangements w)
  (cond
    [(empty? w) (list '())]
    [else (insert-everywhere/in-all-words (first w)
            (arrangements (rest w)))]))

; String [List-of String] -> [List-of [List-of String]]
; inserts the 1String s at the beginning, between all letters, and at the end
; of every word in the List-of-words low
(check-expect (insert-everywhere/in-all-words "a" '()) '())
(check-expect (insert-everywhere/in-all-words "a" (list (list "b")))
              (list
               (list "a" "b")
               (list "b" "a")))
(check-expect (insert-everywhere/in-all-words "a" (list (list "b" "c")))
              (list
               (list "a" "b" "c")
               (list "b" "a" "c")
               (list "b" "c" "a")))
(check-expect (insert-everywhere/in-all-words "d" (list (list "a" "b" "c")))
              (list
               (list "d" "a" "b" "c")
               (list "a" "d" "b" "c")
               (list "a" "b" "d" "c")
               (list "a" "b" "c" "d")))
(check-expect (insert-everywhere/in-all-words "d"
                                              (list (list "e" "r")
                                                    (list "r" "e")))
              (list
               (list "d" "e" "r")
               (list "e" "d" "r")
               (list "e" "r" "d")
               (list "d" "r" "e")
               (list "r" "d" "e")
               (list "r" "e" "d")))
(define (insert-everywhere/in-all-words s low)
  (cond
    [(empty? low) '()]
    [else
     (append (insert-everywhere/in-one-word s (first low))
             (insert-everywhere/in-all-words s (rest low)))]))

; String [List-of String] -> [List-of [List-of String]]
; inserts 1String in all positions of given word
(check-expect (insert-everywhere/in-one-word "d" (list "e" "r"))
              (list
               (list "d" "e" "r")
               (list "e" "d" "r")
               (list "e" "r" "d")))
(define (insert-everywhere/in-one-word s w)
  (append
   (list (cons s w))
   (insert-between s w)))
  
; String [List-of String] -> [List-of [List-of String]]
; inserts 1String between and at end of letters of given word
(check-expect (insert-between "a" '()) '())
(check-expect (insert-between "a" (list "b"))
              (list (list "b" "a")))
(check-expect (insert-between "a" (list "b" "c"))
              (list (list "b" "a" "c")
                    (list "b" "c" "a")))
(check-expect (insert-between "a" (list "b" "c" "d"))
              (list (list "b" "a" "c" "d")
                    (list "b" "c" "a" "d")
                    (list "b" "c" "d" "a")))
(check-expect (insert-between "a" (list "b" "c" "d" "e"))
              (list (list "b" "a" "c" "d" "e")
                    (list "b" "c" "a" "d" "e")
                    (list "b" "c" "d" "a" "e")
                    (list "b" "c" "d" "e" "a")))
(define (insert-between s w)
  (cond
    [(empty? w) '()]
    [else (cons (cons (first w) (cons s (rest w)))
                (insert-between-rest (list (first w)) s (rest w)))]))

; String [List-of String] [List-of String] -> [List-of [List-of String]]
; appends word m to result of inserting s between and at end of members of w
(check-expect (insert-between-rest (list "b") "a" (list "c" "d"))
              (list (list "b" "c" "a" "d")
                    (list "b" "c" "d" "a")))
(check-expect (insert-between-rest (list "b") "a" (list "c" "d" "e"))
              (list
               (list "b" "c" "a" "d" "e")
               (list "b" "c" "d" "a" "e")
               (list "b" "c" "d" "e" "a")))
(define (insert-between-rest m s w)
  (cond
    [(empty? w) '()]
    [else
     (cons (append m (cons (first w) (cons s (rest w))))
     (insert-between-rest (add-at-end (first w) m) s (rest w)))]))

; String [List-of String] -> [List-of String]
; adds 1String s to end of word w
(check-expect (add-at-end "a" '()) (list "a"))
(check-expect (add-at-end "a" (list "b")) (list "b" "a"))
(check-expect (add-at-end "a" (list "b" "c")) (list "b" "c" "a"))
(check-expect (add-at-end "d" (list "a" "b" "c")) (list "a" "b" "c" "d"))
(define (add-at-end s w)
  (cond
    [(empty? w) (cons s '())]
    [else (cons (first w) (add-at-end s (rest w)))]))
