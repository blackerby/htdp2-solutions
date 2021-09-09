;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname exercise315) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(define-struct no-parent [])
(define-struct child [father mother name date eyes])
; An FT (short for family tree) is one of: 
; – (make-no-parent)
; – (make-child FT FT String N String)

(define NP (make-no-parent))
; An FT is one of: 
; – NP
; – (make-child FT FT String N String)

; Oldest Generation:
(define Carl (make-child NP NP "Carl" 1926 "green"))
(define Bettina (make-child NP NP "Bettina" 1926 "green"))
 
; Middle Generation:
(define Adam (make-child Carl Bettina "Adam" 1950 "hazel"))
(define Dave (make-child Carl Bettina "Dave" 1955 "black"))
(define Eva (make-child Carl Bettina "Eva" 1965 "blue"))
(define Fred (make-child NP NP "Fred" 1966 "pink"))
 
; Youngest Generation: 
(define Gustav (make-child Fred Eva "Gustav" 1988 "brown"))

; FT -> Number
; produces number of people in the family tree
(check-expect (count-persons Gustav) 5)
(check-expect (count-persons Fred) 1)
(check-expect (count-persons Eva) 3)
(define (count-persons an-ftree)
  (cond
    [(no-parent? an-ftree) 0]
    [else
     (add1
      (+
       (count-persons (child-father an-ftree))
       (count-persons (child-mother an-ftree))))]))

; FT Number -> Number
; produces the average age of the members of the family tree
; (/ (+ (- 2021 1988) (- 2021 1966) (- 2021 1965) (- 2021 1926) (- 2021 1926)) 5)
(check-expect (average-age-tree Gustav 2021) 66.8)
(check-expect (average-age-tree Bettina 2021) (- 2021 1926))
(define (average-age-tree an-ftree year)
  (local ((define (sum-ages ft)
            (cond
              [(no-parent? ft) 0]
              [else
               (+
                (- year (child-date ft))
                (sum-ages (child-father ft))
                (sum-ages (child-mother ft)))])))
    (/ (sum-ages an-ftree) (count-persons an-ftree))))

(define ff1 (list Carl Bettina))
(define ff2 (list Fred Eva))
(define ff3 (list Fred Eva Carl))

; [List-of FT] N -> N
; produces average age of all child instances in a-forest
(check-expect (average-age ff1 2021) (/ (+ (average-age-tree Carl 2021) (average-age-tree Bettina 2021)) 2))
(define (average-age a-forest year)
  (/ (foldr (lambda (f b)
         (+ (average-age-tree f year) b)) 0 a-forest)
     (length a-forest)))
