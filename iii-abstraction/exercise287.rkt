;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname exercise287) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(define-struct IR [name desc ac-price sale-price])
; An IR is a structure:
;   (make-IR String String Number Number)
; examples:
(make-IR "pizza" "food" 12 15)
(make-IR "headphones" "electronics" 50 100)
(make-IR "Metadata" "books" 15 16)

(define inventory (list (make-IR "pizza" "food" 12 15)
                        (make-IR "headphones" "electronics" 50 100)
                        (make-IR "Metadata" "books" 15 16)))

(define inventory2 (list (make-IR "pizza" "food" 12 15)
                        (make-IR "headphones" "electronics" 50 100)
                        (make-IR "Metadata" "books" 15 16)
                        (make-IR "Tesla" "cars" 1000 500)))

; Number [List-of IR] -> [List-of IR]
; produces a list of IRs whose sale price
; is below ua
(check-expect (eliminate-expensive 100 inventory)
              (list (make-IR "pizza" "food" 12 15)
                    (make-IR "Metadata" "books" 15 16)))
(check-expect (eliminate-expensive 400 inventory2) inventory)
(define (eliminate-expensive ua inv)
  (filter (lambda (item) (< (IR-sale-price item) ua)) inv))

; String [List-of IR] -> [List-of IR]
; filters out IRs with name ty
(check-expect (recall "Tesla" inventory2)
              inventory)
(check-expect (recall "headphones" inventory)
              (list (make-IR "pizza" "food" 12 15)
                    (make-IR "Metadata" "books" 15 16)))
(define (recall ty inv)
  (filter (lambda (item) (not (string=? (IR-name item) ty))) inv))

; [List-of String] [List-of String] -> [List-of String]
; selects all members of k that are also members of l
(check-expect (selection (list "hello" "there" "everyone") '()) '())
(check-expect (selection (list "hello" "there" "everyone")
                         (list "hello" "everyone" "there"))
              (list "hello" "everyone" "there"))
(check-expect (selection (list "hello" "there" "everyone")
                         (list "hello" "there" "peter"))
              (list "hello" "there"))
(check-expect (selection (list "hello" "there" "everyone")
                         (list "hello" "world" "everyone"))
              (list "hello" "everyone"))
(define (selection l k)
  (filter (lambda (e) (member? e l)) k))
