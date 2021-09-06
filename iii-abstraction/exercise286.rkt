;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname exercise286) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
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

; [List-of IR] -> [List-of IR]
; sorts a list of inventory records by the difference between
; the acquisition price and the sale price
(check-expect (sort-inventory-price-diff '()) '())
(check-expect (sort-inventory-price-diff (list (make-IR "Metadata" "books" 15 16)))
              (list (make-IR "Metadata" "books" 15 16)))
(check-expect (sort-inventory-price-diff inventory)
              (list (make-IR "Metadata" "books" 15 16)
                    (make-IR "pizza" "food" 12 15)
                    (make-IR "headphones" "electronics" 50 100)))
(check-expect (sort-inventory-price-diff inventory2)
              (list (make-IR "Tesla" "cars" 1000 500)
                    (make-IR "Metadata" "books" 15 16)
                    (make-IR "pizza" "food" 12 15)
                    (make-IR "headphones" "electronics" 50 100)))
(define (sort-inventory-price-diff i)
  (sort
   i
   (lambda (item1 item2)
     (< (- (IR-sale-price item1) (IR-ac-price item1))
        (- (IR-sale-price item2) (IR-ac-price item2))))))