;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname htdp_01_06-exercise-103-and-following) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;; exercise 103

; Space is a Number(0,100]
; interpretation: the amount of space in square feet an animal needs
; in case of transport

(define-struct spider [legs space])
; A Spider is a structure:
;   (make-spider Number(0,8] Space)
; interpretation: (make-spider legs space) describes a spider
; where legs denotes number of remaining legs and space denotes
; amount of space needed in case of transport

(define-struct elephant [space])
; An Elephant is a structure:
;   (make-elephant Space)
; interpretation: (make-elephant space) describes an elephant
; where space denotes amount of space need in case of transport

(define-struct boa [length girth space])
; A Boa is a structure:
;   (make-boa NonnegativeNumber NonnegativeNumber Space)
; interpretation: (make-boa length girth space) describes
; a boa constrictor where length is its length, girth is its
; girth, and space is the space needed for transport

(define-struct armadillo [length shell space])
; An Armadillo is a structure:
;   (make-armadillo NonnegativeNumber NonnegativeNumber Space)
; interpretation: (make-boa length shell space) describes
; an armadillo where length is how long it is from nose to tail tip,
; shell is the strength of its shell, and space is the space needed
; to transport it.

; A ZooAnimal is one of:
; - Spider
; - Elephant
; - Boa
; - Armadillo
; interpretation: a zoo animal whose attributes are specified according
; to the types described above
; examples:
(make-spider 7 10)
(make-elephant 80)
(make-boa 20 5 20)
(make-armadillo 5 10 9)


#;(define (fn-for-za za)
  (cond
    [(spider? za) (... (spider-legs za) ... (spider-space za) ...)]
    [(elephant? za) (... (elephant-space za) ...)]
    [(boa? za) (... (boa-length za) ... (boa-girth za) ... (boa-space za) ...)]
    [(armadillo? za) (... (armadillo-length za) ... (armadillo-shell za) ... (armadillo-space za)...)]))

(define-struct cage [length width])
; A Cage is a struct:
;   (make-cage NonnegativeNumber NonnegativeNumber)
; interpretation: a cage for animal transport where length is its length and width is its width
; examples:
; - (make-cage 10 10)
; - (make-cage 5 11)

; ZooAnimal Cage -> Boolean
; returns #true if the space of the ZooAnimal is less than
; the square footage of the cage
(check-expect (fits?
               (make-spider 7 10)
               (make-cage 10 10))
              #true)
(check-expect (fits?
               (make-elephant 80)
               (make-cage 5 11))
              #false)
(check-expect (fits?
               (make-boa 20 50 20)
               (make-cage 5 11))
              #true)
(check-expect (fits?
               (make-armadillo 5 10 9)
               (make-cage 5 1))
              #false)
(define (fits? za cage)
  (> (* (cage-length cage) (cage-width cage))
      (cond
        [(spider? za) (spider-space za)]
        [(elephant? za) (elephant-space za)]
        [(boa? za) (boa-space za)]
        [(armadillo? za) (armadillo-space za)])))

;; exercise 104
(define-struct vehicle [passengers plate mpg])
; A Vehicle is a struct:
;   (make-vehicle Number(0,55] String Number[8,30])
; interpretation: a member of the town vehicle fleet
; passengers is the maximum number of passengers it can carry
; plate is the license plate number
; mpg is its fuel consumption
; examples:
(make-vehicle 10 "1AF65" 15)
(make-vehicle 40 "SCH00L15C00L" 12)

#;(define (fn-for-vehicle v)
  (... (vehicle-passengers v) ... (vehicle-plate v) ... (vehicle-mpg v)...))

;; exercise 105
; A Coordinate is one of: 
; – a NegativeNumber 
; interpretation on the y axis, distance from top
; examples:
; - -1
; - -20
; – a PositiveNumber 
; interpretation on the x axis, distance from left
; examples:
; - 1
; - 20
; – a Posn
; interpretation an ordinary Cartesian point
; examples:
(make-posn 1 -20)
(make-posn 20 -1)
; do the first two have meaning on their own?
; see paper

; Any -> Boolean
; is v a Coordinate?
(check-expect (coordinate? -1) #true)
(check-expect (coordinate? 1) #true)
(check-expect (coordinate? 0) #false)
(check-expect (coordinate? (make-posn 1 -20)) #true)
(check-expect (coordinate? (make-posn 0 -20)) #false)
(check-expect (coordinate? (make-posn 1 -0)) #false)
(define (coordinate? v)
  (cond
    [(number? v) (not (zero? v))]
    [(posn? v) (and (not (zero? (posn-x v))) (not (zero? (posn-y v))))]))