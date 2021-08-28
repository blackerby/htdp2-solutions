;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname htdp_01_05_07) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(define-struct ball [location velocity])

(make-ball -1 0)
(make-ball "bye" #t)
(make-ball (make-posn 1 1) (make-posn 0 0))

;; exercise 76
(define-struct movie [title producer year])
; A Movie is a struct:
;   (make-movie String String Number[0,9999])
; interpretation: (make-movie title producer year) is a movie
; with title, and was produced by producer in year

(define-struct person [name hair eyes phone])
; A Person is a struct:
;   (make-person String String String String)
; interpretation: (make-person name hair eyes phone) is a person
; with name, hair-color hair, eye-color eyes, and phone number phone

(define-struct pet [name number])
; A Pet is a struct:
;   (make-pet String Number)
; interpretation: (make-pet name number) is a pet with name and ID number

(define-struct CD [artist title price])
; A CD is a struct:
;   (make-CD String String Number[0,100])
; interpreation: (make-CD artist title price) is a CD with artist, title, and price

; A Size is one of:
; - "extra small"
; - "small"
; - "medium"
; - "large"
; - "extra large"

(define-struct sweater [material size producer])
; A Sweater is a struct:
;   (make-sweater String Size String)
; interpretation: (make-sweater material size producer) is a sweater made of material, with given size,
; made by producer

;; exercise 77
(define-struct time [hours minutes seconds])
; A Time is a struct:
;   (make-time Number[0,23] Number[0,59] Number[0,59])
; interpretation: (make-sweater hours minutes seconds) represents a point in time since midnight
; where hours is a number between 0 and 23, minutes is a number between 0 and 59, and seconds is
; a number between 0 and 59.

;; exercise 78
; A LowerCaseLetter is one of:
; - "a"
; - "b"
; - "c"
; - "d"
; - "e"
; - "f"
; - "g"
; - "h"
; - "i"
; - "j"
; - "k"
; - "l"
; - "m"
; - "n"
; - "o"
; - "p"
; - "q"
; - "r"
; - "s"
; - "t"
; - "u"
; - "v"
; - "w"
; - "x"
; - "y"
; - "z"
; - #false

; A LowercaseLetter is one of:
; - Lowercase1String
; - #false

(define-struct three-letter-word [first second third])
; A ThreeLetterWord is a struct:
;   (make-three-letter-word LowercaseLetter LowercaseLetter LowercaseLetter)
; interpretation: a three letter word, where first is the first is the first letter, second the second
; and third the third

;; exercise 79
; A Color is one of:
; — "white"
; — "yellow"
; — "orange"
; — "green"
; — "red"
; — "blue"
; — "black"
; examples:
; - "white"
; - "black"
; - "blue"

; H is a Number between 0 and 100.
; interpretation represents a happiness value
; examples:
; 0
; 5
; 71
; 100

(define-struct person [fstname lstname male?])
; A Person is a structure:
;   (make-person String String Boolean)
; examples:
; (make-person "Tom" "Brady" #true)
; (make-person "Lisa" "Loeb" #false
;; I think it is a good idea to use a field name that looks like the name of a predicate
;; because it can act as a predicate, e.g.:
; (person-male? (make-person "Tom" "Brady" #true)) == #true
; in other words, the person-male? selector is a predicate

(define-struct dog [owner name age happiness])
; A Dog is a structure:
;   (make-dog Person String PositiveInteger H)
; interpretation: a dog with owner, name, age, and happiness level
; examples:
;   (make-dog (make-person "William" "Blackerby" #true) "Lilly" 4 71)
;   (make-dog (make-person "Anne" "Blackerby" #false) "Aoife" 7 89)
