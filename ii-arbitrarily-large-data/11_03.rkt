;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-abbr-reader.ss" "lang")((modname 11_03) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; List-of-numbers -> List-of-numbers 
; rearranges alon in descending order
 
(check-expect (sort> '()) '())
(check-expect (sort> (list 3 2 1)) (list 3 2 1))
(check-expect (sort> (list 1 2 3)) (list 3 2 1))
(check-expect (sort> (list 12 20 -5))
              (list 20 12 -5))
(check-satisfied (sort> '()) sorted>?)
(check-satisfied (sort> (list 3 2 1)) sorted>?)
(check-satisfied (sort> (list 1 2 3)) sorted>?)
(check-satisfied (sort> (list 12 20 -5)) sorted>?)
(define (sort> alon)
  (cond
    [(empty? alon) '()]
    [else
     (insert (first alon) (sort> (rest alon)))]))

; Number List-of-numbers -> List-of-numbers
; inserts n into the sorted list of numbers alon
(check-expect (insert 5 '()) (list 5))
(check-expect (insert 5 (list 6)) (list 6 5))
(check-expect (insert 5 (list 4)) (list 5 4))
(check-expect (insert 12 (list 20 -5))
              (list 20 12 -5))
(check-expect (insert 3 (list 2 1))
              (list 3 2 1))
(check-expect (insert 1 (list 3 2))
              (list 3 2 1))
(define (insert n alon)
  (cond
    [(empty? alon) (list n)]
    [else (if (>= n (first alon))
              (cons n alon)
              (cons (first alon ) (insert n (rest alon))))]))

; NEList-of-temperatures -> Boolean
; yields #true if the temperatures are sorted in descending order
(check-expect (sorted>? '()) #true)
(check-expect (sorted>? (cons 1 '())) #true)
(check-expect (sorted>? (cons 3 (cons 2 (cons 1 '())))) #true)
(check-expect (sorted>? (cons 1 (cons 2 (cons 3 '())))) #false)
(define (sorted>? ne-l)
  (cond
    [(empty? ne-l) #true]
    [(empty? (rest ne-l)) #true]
    [else (and (> (first ne-l) (first (rest ne-l)))
                  (sorted>? (rest ne-l)))]))

;; exercise 186
; List-of-numbers -> List-of-numbers
; produces a sorted version of l
#;(check-satisfied (sort>/bad (list 2 3 1)) sorted>?) ; I don't think you can use check-satisfied...?
#;(check-expect (sort>/bad (list 3 2 1)) (list 1 2 3))
(check-expect (sort>/bad (list 3 2 1)) (list 9 8 7 6 5 4 3 2 1 0))
#;(check-satisfied (sort>/bad '()) sorted>?)
(define (sort>/bad l)
  (list 9 8 7 6 5 4 3 2 1 0))

;; exercise 187
(define-struct gp [name score])
; A GamePlayer is a structure: 
;    (make-gp String Number)
; interpretation (make-gp p s) represents player p who 
; scored a maximum of s points
; examples:
(define gp1 (make-gp "W" 100))
(define gp2 (make-gp "K" 150))
(define gp3 (make-gp "L" 0))

;; exercise 187
; A List-of-GamePlayer is one of:
; - '()
; - (cons GamePlayer List-of-GamePlayer)
; examples:
(define logp0 '())
(define logp1 (list gp1))
(define logp2 (list gp1 gp2))
(define sorted-logp2 (list gp2 gp1))
(define logp3 (list gp1 gp2 gp3))
(define sorted-logp3 (list gp2 gp1 gp3))

; List-of-GamePlayer -> List-of-GamePlayer
; sorts a list of game players by score
; in descending order
(check-expect (sort-score> '()) '())
(check-expect (sort-score> logp1) logp1)
(check-expect (sort-score> logp2) sorted-logp2)
(check-expect (sort-score> logp3) sorted-logp3)
(define (sort-score> logp)
  (cond
    [(empty? logp) '()]
    [else
     (insert-player (first logp) (sort-score> (rest logp)))]))

; GamePlayer List-of-GamePlayer -> List-of-GamePlayer
; inserts gp into the sorted list of game players logp
(check-expect (insert-player gp1 '()) logp1)
(check-expect (insert-player gp2 logp1) sorted-logp2)
(check-expect (insert-player gp1 (list gp2 gp3))
              sorted-logp3)
(define (insert-player gp logp)
  (cond
    [(empty? logp) (list gp)]
    [else
     (if (>= (gp-score gp) (gp-score (first logp)))
         (cons gp logp)
         (cons (first logp) (insert-player gp (rest logp))))]))

;; exercise 188
(define-struct email [from date message])
; An Email Message is a structure: 
;   (make-email String Number String)
; interpretation (make-email f d m) represents text m 
; sent by f, d seconds after the beginning of time
; examples;
(define em1 (make-email "W" 100 "Hi"))
(define em2 (make-email "K" 10021 "Hello"))
(define em3 (make-email "L" 230198 "woof"))

; A List-of-Email Message is one of:
; - '()
; - (cons Email Message List-of-Email Message)
; examples:
(define loem0 '())
(define loem1 (list em1))
(define loem2 (list em1 em2))
(define loem3 (list em1 em2 em3))

; List-of-Email Message -> List-of-Email Message
; sorts a list of email messages in descending order by date
(check-expect (sort-emails-date> '()) '())
(check-expect (sort-emails-date> loem1) loem1)
(check-expect (sort-emails-date> loem2) (list em2 em1))
(check-expect (sort-emails-date> loem3) (list em3 em2 em1))
(define (sort-emails-date> loem)
  (cond
    [(empty? loem) loem]
    [else
     (insert-email-date> (first loem)
                        (sort-emails-date> (rest loem)))]))

; Email Message List-of-Email Message -> List-of-Email Message
; inserts Email Message em into sorted List-of Email Message loem
; based on date in descending order
(check-expect (insert-email-date> em1 '()) (list em1))
(check-expect (insert-email-date> em2 (list em1)) (list em2 em1))
(check-expect (insert-email-date> em2 (list em3 em1)) (list em3 em2 em1))
(define (insert-email-date> em loem)
  (cond
    [(empty? loem) (list em)]
    [else
     (if (>= (email-date em) (email-date (first loem)))
         (cons em loem)
         (cons (first loem) (insert-email-date> em (rest loem))))]))

; List-of-Email Message -> List-of-Email Message
; sorts a list of email messages in ascending order by name
(check-expect (sort-emails-name< '()) '())
(check-expect (sort-emails-name< loem1) loem1)
(check-expect (sort-emails-name< loem2) (list em2 em1))
(check-expect (sort-emails-name< loem3) (list em2 em3 em1))
(define (sort-emails-name< loem)
  (cond
    [(empty? loem) loem]
    [else
     (insert-email-name< (first loem) (sort-emails-name< (rest loem)))]))

; Email Message List-of-Email Message -> List-of-Email Message
; inserts Email Message em into sorted List-of-Email Message loem
; in ascending alphabetical order by name
(check-expect (insert-email-name< em1 '()) (list em1))
(check-expect (insert-email-name< em2 (list em1)) (list em2 em1))
(check-expect (insert-email-name< em3 (list em2 em1)) (list em2 em3 em1))
(define (insert-email-name< em loem)
  (cond
    [(empty? loem) (list em)]
    [else
     (if (string<? (email-from em) (email-from (first loem)))
         (cons em loem)
         (cons (first loem) (insert-email-name< em (rest loem))))]))

;; exercise 189
; Number List-of-numbers -> Boolean
(define (search n alon)
  (cond
    [(empty? alon) #false]
    [else (or (= (first alon) n)
              (search n (rest alon)))]))

; Number List-of-Numbers -> Boolean
; determines whether a number occurs in a sorted list of numbers
; assume aslon is sorted in descending order
(check-expect (search-sorted 1 '()) #false)
(check-expect (search-sorted 1 (list 1)) #true)
(check-expect (search-sorted 2 (list 1)) #false)
(check-expect (search-sorted 3 (list 3 2 1)) #true)
(check-expect (search-sorted 2 (list 3 2 1)) #true)
(check-expect (search-sorted 1 (list 3 2 1)) #true)
(check-expect (search-sorted 4 (list 3 2 1)) #false)
(check-expect (search-sorted 2 (list 4 3 1)) #false)
(define (search-sorted n aslon)
  (cond
    [(empty? aslon) #false]
    [(< (first aslon) n) #false]
    [else (or (= (first aslon) n)
              (search-sorted n (rest aslon)))]))

;; exercise 190
; List-of-1Strings -> List-of-List-of-1Strings
; produces the list of prefixes of the given List-of-1Strings
(check-expect (prefixes '()) '())
(check-expect (prefixes (list "a")) (list (list "a")))
(check-expect (prefixes (list "a" "b"))
               (list
                (list "a" "b")
                (list "a")))
(check-expect (prefixes (list "a" "b" "c" "d"))
               (list
                (list "a" "b" "c" "d")
                (list "a" "b" "c")
                (list "a" "b")
                (list "a")))
(define (prefixes lo1s)
   (cond
     [(empty? lo1s) '()]
     [else
      (cons lo1s (prefixes (reverse (rest (reverse lo1s)))))]))

; List-of-1Strings -> List-of-List-of-1Strings
; produces list of prefixes of the given List-of-1Strings
(check-expect (suffixes '()) '())
(check-expect (suffixes (list "a")) (list (list "a")))
(check-expect (suffixes (list "a" "b")) (list (list "a" "b") (list "b")))
(check-expect (suffixes (list "a" "b" "c" "d"))
              (list
               (list "a" "b" "c" "d")
               (list "b" "c" "d")
               (list "c" "d")
               (list "d")))
(define (suffixes lo1s)
  (cond
    [(empty? lo1s) '()]
    [else
     (cons lo1s (suffixes (rest lo1s)))]))