;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname exercise396) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/batch-io)
(require 2htdp/image)
(require 2htdp/universe)

(define LOCATION "/usr/share/dict/words") ; on OS X
(define AS-LIST (read-lines LOCATION))
(define SIZE (length AS-LIST))
(define LETTERS (append
                 (explode "ABCDEFGHIJKLMNOPQRSTUVWXYZ")
                 (explode "abcdefghijklmnopqrstuvwxyz")))

; An HM-Word is a [List-of Letter or "_"]
; interpretation "_" represents a letter to be guessed 
 
; HM-Word N -> String
; runs a simplistic hangman game, produces the current state
(define (play the-pick time-limit)
  (local ((define the-word  (explode the-pick))
          (define the-guess (make-list (length the-word) "_"))
          ; HM-Word -> HM-Word
          (define (do-nothing s) s)
          ; HM-Word KeyEvent -> HM-Word 
          (define (checked-compare current-status ke)
            (if (member? ke LETTERS)
                (compare-word the-word current-status ke)
                current-status)))
    (implode
     (big-bang the-guess ; HM-Word
       [to-draw render-word]
       [on-tick do-nothing 1 time-limit]
       [on-key  checked-compare]))))
 
; HM-Word -> Image
(define (render-word w)
  (text (implode w) 22 "black"))

; HM-Word HM-Word KeyEvent -> HM-Word
; produces a new HM-Word with "_" removed where guess
; revealed a letter
(check-expect (compare-word (list "b" "o" "t" "s") (list "_" "_" "_" "_") "b")
              (list "b" "_" "_" "_"))
(check-expect (compare-word (list "d" "o" "g" "s") (list "d" "_" "g" "s") "o")
              (list "d" "o" "g" "s"))
(check-expect (compare-word (list "g" "o" "o" "d") (list "g" "_" "_" "d") "o")
              (list "g" "o" "o" "d"))
(check-expect (compare-word (list "s" "m" "a" "l" "l") (list "s" "m" "_" "l" "l") "e")
              (list "s" "m" "_" "l" "l"))
(define (compare-word word s guess)
  (cond
    [(empty? word) '()]
    [else
     (local
       ((define next-guess (compare-word (rest word) (rest s) guess)))
       (if (string=? (first word) guess)
           (cons (first word) next-guess)
           (cons (first s) next-guess)))]))

;(play (list-ref AS-LIST (random SIZE)) 60)