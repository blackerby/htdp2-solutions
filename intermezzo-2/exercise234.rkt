;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-abbr-reader.ss" "lang")((modname exercise234) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/web-io)

; A Song-Title is a String

; A Rank is a N

; A Ranking is a list:
; - (list N Song-Title)

; A List-of-Rankings is one of:
; - '()
; - (cons Ranking List-of-Rankings)

; A List-of-Ranked-Song-Titles is one of:
; - '()
; - (cons Song-Title List-of-Ranked-Song-Titles)
; interpretation: a list of song titles in rank order
; example:
(define one-list
  '("Asia: Heat of the Moment"
    "U2: One"
    "The White Stripes: Seven Nation Army"))

; List-of-Ranked-Song-Titles -> ... nested list ...
; produces a list representation of the song titles as an HTML table
(check-expect (make-ranking one-list)
              '(table ((border "1"))
                      (tr ((width "200") (style "text-align:center"))
                          (td "1") (td "Asia: Heat of the Moment"))
                      (tr ((width "200") (style "text-align:center"))
                          (td "2") (td "U2: One"))
                      (tr ((width "200") (style "text-align:center"))
                          (td "3") (td "The White Stripes: Seven Nation Army"))))
(define (make-ranking lors)
  `(table ((border "1"))
          ,@(make-rows (ranking lors))))

; List-of-Rankings -> ... nested list ...
; produces a list representation of ranks and song titles as rows for an HTML table
(check-expect (make-rows (ranking one-list))
              '((tr ((width "200") (style "text-align:center"))
                    (td "1") (td "Asia: Heat of the Moment"))
                (tr ((width "200") (style "text-align:center"))
                    (td "2") (td "U2: One"))
                (tr ((width "200") (style "text-align:center"))
                    (td "3") (td "The White Stripes: Seven Nation Army"))))
(define (make-rows lor)
  (cond
     [(empty? lor) '()]
     [else
      (cons `(tr ((width "200") (style "text-align:center")) ,@(make-row (first lor)))
            (make-rows (rest lor)))]))

; Ranking -> ... nested list ...
; creates a row for an HTML table from r
(check-expect (make-row (list 1 "Asia: Heat of the Moment"))
              (list '(td "1") '(td "Asia: Heat of the Moment")))
(define (make-row r)
  (list `(td ,(number->string (first r)))
        `(td ,(second r))))

;; provided helpers
; List-of-Ranked-Song-Titles -> List-of-Rankings
(define (ranking los)
  (reverse (add-ranks (reverse los))))
 
(define (add-ranks los)
  (cond
    [(empty? los) '()]
    [else (cons (list (length los) (first los))
                (add-ranks (rest los)))]))