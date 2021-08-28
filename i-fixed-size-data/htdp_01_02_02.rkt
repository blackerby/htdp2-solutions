;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname htdp_01_02_02) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/image)

(define (f x ) 1)

(define (ff a)
  (* 10 a))

(ff (+ 1 1))

;; exercise 21
(ff (ff 1))
(+ (ff 1) (ff 1)) ; each call to (ff 1) is evaluated separately

;; exercise 22
(define (distance-to-origin x y)
  (sqrt (+ (sqr x) (sqr y))))

(distance-to-origin 3 4) ; the explanation matches my intuition

;; exercise 23

(define (string-first s)
  (substring s 0 1))

(string-first "hello world")

;; exercise 24
(define (==> x y)
  (or (not x) y))

(==> #true #false)

;; exercise 25
(define (image-classify img)
  (cond
    [(> (image-height img) (image-width img)) "tall"]
    [(= (image-height img) (image-width img)) "square"]
    [(< (image-height img) (image-width img)) "wide"]))

(image-classify (rectangle 100 10 "solid" "blue"))

;; exercise 26
(define (string-insert s i)
  (string-append (substring s 0 i)
                 "_"
                 (substring s i)))

;(check-expect (string-insert "helloworld" 6) "hellow_orld")
(string-insert "helloworld" 6)