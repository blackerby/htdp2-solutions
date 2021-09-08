;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname for-practice) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/abstraction)

(check-expect (and-map odd? '(1 3 5 7 9)) 9)
(define (and-map p l)
  (if (andmap p l)
      (first (reverse l))
      #false))

(check-expect (or-map odd? '(2 3 4 6 8)) 3)
(define (or-map p l)
  (if (ormap p l)
      (first (filter p l))
      #false))

(check-expect (for/and ([i 10]) (> (- 9 i) 0))
              (my-for/and 10 (lambda (i) (> (- 9 i) 0))))
(check-expect (for/and ([i 10]) (if (>= i 0) i #false))
              (my-for/and 10 (lambda (i) (>= i 0))))
(define (my-for/and x p)
  (and-map p (build-list x (lambda (i) i))))

(check-expect (for/or ([i 10]) (if (= (- 9 i) 0) i #false))
              (my-for/or 10 (lambda (i) (= (- 9 i) 0))))
(check-expect (for/or ([i 10]) (if (< i 0) i #false))
              (my-for/or 10 (lambda (i) (< i 0))))
(define (my-for/or x p)
  (or-map p (build-list x (lambda (i) i))))

(check-expect (for/sum ([c "abc"]) (string->int c))
              (my-for/sum "abc" (lambda (c) (string->int c))))
(define (my-for/sum s f)
  (foldr + 0 (build-list (string-length s) (lambda (i) (f (list-ref (explode s) i))))))

(check-expect (for/product ([c "abc"]) (+ (string->int c) 1))
              (my-for/product "abc" (lambda (c) (+ (string->int c) 1))))
(define (my-for/product s f)
  (foldr * 1 (build-list (string-length s) (lambda (i) (f (list-ref (explode s) i))))))

(define a (string->int "a"))
(check-expect (for/string ([j 10]) (int->string (+ a j)))
              (my-for/string 10 (lambda (j) (int->string (+ a j)))))
(define (my-for/string i f)
  (foldr string-append "" (build-list i f)))

; no idea at all if this is what they were going for, but here they are!
