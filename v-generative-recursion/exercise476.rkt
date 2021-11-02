;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname exercise476) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(define-struct transition [current key next])
(define-struct fsm [initial transitions final])
 
; An FSM is a structure:
;   (make-fsm FSM-State [List-of 1Transition] FSM-State)
; A 1Transition is a structure:
;   (make-transition FSM-State 1String FSM-State)
; An FSM-State is String.
 
; data example: see exercise 109
 
(define fsm-a-bc*-d
  (make-fsm
   "AA"
   (list (make-transition "AA" "a" "BC")
         (make-transition "BC" "b" "BC")
         (make-transition "BC" "c" "BC")
         (make-transition "BC" "d" "DD"))
   "DD"))

; FSM String -> Boolean 
; does an-fsm recognize the given string
(check-expect (fsm-match? fsm-a-bc*-d "acbd") #true)
(check-expect (fsm-match? fsm-a-bc*-d "abcd") #true)
(check-expect (fsm-match? fsm-a-bc*-d "ad") #true)
(check-expect (fsm-match? fsm-a-bc*-d "abbbbccccbcbcd") #true)
(check-expect (fsm-match? fsm-a-bc*-d "da") #false)
(check-expect (fsm-match? fsm-a-bc*-d "aa") #false)
(check-expect (fsm-match? fsm-a-bc*-d "d") #false)
(check-expect (fsm-match? fsm-a-bc*-d "abcda") #false) ; https://github.com/S8A/htdp-exercises/blob/master/ex476.rkt
(define (fsm-match? an-fsm a-string)
  (local ((define current (fsm-initial an-fsm))
          (define keys (explode a-string))
          (define all-transitions (fsm-transitions an-fsm))
          (define transitions (filter (lambda (t)
                                        (and (string=? current (transition-current t))
                                             (string=? (first keys) (transition-key t))))
                                      all-transitions)))
          (cond
            [(empty? keys) #true]
            [(empty? transitions) #false]
            [else
             (local ((define next-state (transition-next (first transitions))))
               (fsm-match?
                (make-fsm
                 next-state
                 (filter (lambda (t) (string=? next-state (transition-current t))) all-transitions)
                 (fsm-final an-fsm))
                (implode (rest keys))))])))

; ended up not needing an auxiliary function. don't love this solution, feel like I'm missing something
; is there way to do this without generating a new FSM on each call?