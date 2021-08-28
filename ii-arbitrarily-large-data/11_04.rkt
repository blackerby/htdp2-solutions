;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-abbr-reader.ss" "lang")((modname 11_04) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/image)

; A Polygon is one of:
; – (list Posn Posn Posn)
; – (cons Posn Polygon)

(define triangle-p
  (list
    (make-posn 20 10)
    (make-posn 20 20)
    (make-posn 30 20)))

(define square-p
  (list
    (make-posn 10 10)
    (make-posn 20 10)
    (make-posn 20 20)
    (make-posn 10 20)))

; a plain background image 
(define MT (empty-scene 50 50))
 
; Image Polygon -> Image
; renders the given polygon p into img
(check-expect
  (render-poly MT triangle-p)
  (scene+line
    (scene+line
      (scene+line MT 20 10 20 20 "red")
      20 20 30 20 "red")
    30 20 20 10 "red"))
(check-expect
  (render-poly MT square-p)
  (scene+line
    (scene+line
      (scene+line
        (scene+line MT 10 10 20 10 "red")
        20 10 20 20 "red")
      20 20 10 20 "red")
    10 20 10 10 "red"))
(define (render-poly img p) ; doesn't pass second test!
  (render-line (connect-dots img p)
               (first p)
               (last p)))
;; exercise 193
; Image Polygon -> Image
; renders the given polygon p into img
(check-expect
  (render-poly-b MT triangle-p)
  (scene+line
    (scene+line
      (scene+line MT 20 10 20 20 "red")
      20 20 30 20 "red")
    30 20 20 10 "red"))
(check-expect
  (render-poly-b MT square-p)
  (scene+line
    (scene+line
      (scene+line
        (scene+line MT 10 10 20 10 "red")
        20 10 20 20 "red")
      20 20 10 20 "red")
    10 20 10 10 "red"))
(define (render-poly-b img p)
  (connect-dots img (cons (last p) p)))

(check-expect
  (render-poly-c MT triangle-p)
  (scene+line
    (scene+line
      (scene+line MT 20 10 20 20 "red")
      20 20 30 20 "red")
    30 20 20 10 "red"))
(check-expect
  (render-poly-c MT square-p)
  (scene+line
    (scene+line
      (scene+line
        (scene+line MT 10 10 20 10 "red")
        20 10 20 20 "red")
      20 20 10 20 "red")
    10 20 10 10 "red"))
(define (render-poly-c img p)
  (connect-dots img (add-at-end p (first p))))

; NELoP -> Posn
; extracts the last item from p
(check-expect (last (list (make-posn 10 20))) (make-posn 10 20))
(check-expect (last triangle-p) (make-posn 30 20))
(check-expect (last square-p) (make-posn 10 20))
(define (last p)
  (cond
    [(empty? (rest p)) (first p)]
    [else (last (rest p))]))
  #;(first p) ; acceptable stub because it returns an individual point

;; exercise 192
; it is acceptable to use last on Polygons because Polygons are a subclass (so to speak) of
; NELoP, for which last is defined. we can use the template for connect-dots for last because
; it is just the template for functions for NELoP.

; Image Posn Posn -> Image 
; draws a red line from Posn p to Posn q into im
(check-expect (render-line MT (make-posn 20 10) (make-posn 20 20))
              (scene+line MT 20 10 20 20 "red"))
(define (render-line img p q)
  (scene+line
    img
    (posn-x p) (posn-y p) (posn-x q) (posn-y q)
    "red"))

; An NELoP is one of: 
; – (cons Posn '())
; – (cons Posn NELoP)

; Image NELoP -> Image
; connects the dots in p by rendering lines in img
(check-expect (connect-dots MT triangle-p)
              (scene+line
               (scene+line MT 20 20 30 20 "red")
               20 10 20 20 "red"))
(check-expect (connect-dots MT square-p) ; exercise 191
  ;(scene+line
    (scene+line
      (scene+line
        (scene+line MT 10 10 20 10 "red")
        20 10 20 20 "red")
      20 20 10 20 "red"))
    ;10 20 10 10 "red"))
(define (connect-dots img p)
  (cond
    [(empty? (rest p)) img]
    [else
     (render-line
      (connect-dots img (rest p))
      (first p)
      (second p))]))

;; exercise 194
; Image NELoP Posn -> Image
; connects the dots in p to pt by rendering lines in img
(check-expect (connect-dots-b MT triangle-p (first triangle-p))
              (scene+line
               (scene+line
                (scene+line MT 20 20 30 20 "red")
                20 10 20 20 "red")
               30 20 20 10 "red"))
(check-expect (connect-dots-b MT square-p (first square-p))
  (scene+line
    (scene+line
      (scene+line
        (scene+line MT 10 10 20 10 "red")
        20 10 20 20 "red")
      20 20 10 20 "red")
    10 20 10 10 "red"))
(define (connect-dots-b img p pt)
  (cond
    [(empty? (rest p)) (render-line img (first p) pt)]
    [else
     (render-line
      (connect-dots-b img (rest p) pt)
      (first p)
      (second p))]))

; Image Polygon -> Image
; renders the given polygon p into img
(check-expect
  (render-poly-d MT triangle-p)
  (scene+line
    (scene+line
      (scene+line MT 20 10 20 20 "red")
      20 20 30 20 "red")
    30 20 20 10 "red"))
(check-expect
  (render-poly-d MT square-p)
  (scene+line
    (scene+line
      (scene+line
        (scene+line MT 10 10 20 10 "red")
        20 10 20 20 "red")
      20 20 10 20 "red")
    10 20 10 10 "red"))
(define (render-poly-d img p)
  (connect-dots-b img p (first p)))

; NELoP Posn -> NELoP
; creates a new non-empty list of posn by adding p to the end of l
(check-expect
  (add-at-end (list (make-posn 0 0) (make-posn 10 10)) (make-posn 20 20))
  (list (make-posn 0 0) (make-posn 10 10) (make-posn 20 20)))
(define (add-at-end l p)
  (cond
    [(empty? (rest l)) (cons (first l) (cons p (rest l)))]
    [else
     (cons (first l) (add-at-end (rest l) p))]))
