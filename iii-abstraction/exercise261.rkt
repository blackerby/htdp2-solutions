;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname exercise261) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(define-struct IR
  [name price])
; An IR is a structure:
;   (make-IR String Number)
; An Inventory is one of: 
; – '()
; – (cons IR Inventory)

; Inventory -> Inventory
; creates an Inventory from an-inv for all
; those items that cost less than a dollar
(check-expect (extract1 (list (make-IR "stuff" 2) (make-IR "things" 1) (make-IR "pizza" 7)))
              (list (make-IR "things" 1)))
(define (extract1 an-inv)
  (cond
    [(empty? an-inv) '()]
    [else
     (cond
       [(<= (IR-price (first an-inv)) 1.0)
        (cons (first an-inv) (extract1 (rest an-inv)))]
       [else (extract1 (rest an-inv))])]))

; Inventory -> Inventory
; creates an Inventory from an-inv for all
; those items that cost less than a dollar
(check-expect (extract2 (list (make-IR "stuff" 2) (make-IR "things" 1) (make-IR "pizza" 7)))
              (list (make-IR "things" 1)))
(define (extract2 an-inv)
  (cond
    [(empty? an-inv) '()]
    [else
     (local ((define extracted-from-rest (extract2 (rest an-inv))))
             (cond
               [(<= (IR-price (first an-inv)) 1.0)
                (cons (first an-inv) extracted-from-rest)]
               [else extracted-from-rest]))]))

; maybe speeds up computing the function, but would need to test it in much larger input (too lazy right now)
