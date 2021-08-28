;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname 10_03) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/batch-io)

; A List-of-strings is one of:
; - '()
; - (cons String List-of-strings)
; interpretation: a list of strings
; examples:
(define los1 (cons "TTT"
                   (cons "\n"
                         (cons "Put up in a place"
                               (cons "where it's easy to see"
                                     (cons "the cryptic admonishment"
                                           (cons "T.T.T."
                                                 (cons "\n"
                                                       (cons "When you feel how depressingly"
                                                             (cons "slowly you climb,"
                                                                   (cons "it's well to remember that"
                                                                         (cons "Things Take Time."
                                                                               (cons "\n"
                                                                                     (cons "Piet Hein" '()))))))))))))))

(check-expect (read-lines "ttt.txt") los1) ; fails because space instead of \n??

(define los2 (cons "TTT" (cons "Put" (cons "up" (cons "in" (cons "a" (cons "place"
            (cons "where" (cons "it's" (cons "easy" (cons "to" (cons "see"
                          (cons "the" (cons "cryptic" (cons "admonishment" (cons "T.T.T."
  
(cons "When" (cons "you" (cons "feel" (cons "how" (cons "depressingly"
(cons "slowly" (cons "you" (cons "climb,"
(cons "it's" (cons "well" (cons "to" (cons "remember" (cons "that"
(cons "Things" (cons "Take" (cons "Time." (cons "Piet" (cons "Hein" '()))))))))))))))))))))))))))))))))))

(check-expect (read-words "ttt.txt") los2)

; A List-of-list-of-strings is one of:
; - '()
; (cons List-of-strings List-of-list-of-strings)

(define lolos ; incorrect represenation: '() represents an empty line
  (cons (cons "TTT" '())
        (cons (cons "Put" (cons "up" (cons "in" (cons "a" (cons "place" '())))))
              (cons (cons "where" (cons "it's" (cons "easy" (cons "to" (cons "see" '())))))
                    (cons (cons "the" (cons "cryptic" (cons "admonishment" '())))
                          (cons (cons "T.T.T." '())
                                (cons (cons "When" (cons "you" (cons "feel" (cons "how" (cons "depressingly" '())))))
                                      (cons (cons "slowly" (cons "you" (cons "climb," '())))
                                            (cons (cons "it's" (cons "well" (cons "to" (cons "remember" (cons "that" '())))))
                                                  (cons (cons "Things" (cons "Take" (cons "Time." '())))
                                                        (cons (cons "Piet" (cons "Hein" '())) '())))))))))))

(check-expect (read-words/line "ttt.txt") lolos)