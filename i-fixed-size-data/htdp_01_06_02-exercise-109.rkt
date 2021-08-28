;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname htdp_01_06_02-exercise-109) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/image)
(require 2htdp/universe)

(define SIZE 100)
(define BACKGROUND (empty-scene SIZE SIZE))

; ExpectsToSee.v2 is one of:
; – AA
; – BB
; – DD 
; – ER

(define AA "start, expect an 'a'")
(define BB "expect 'b', 'c', or 'd'")
(define DD "finished")
(define ER "error, illegal key")

; ExpectsToSee.v2 KeyEvent -> ExpectsToSee.v2
; given current ets yields next state based on ke
(check-expect (next AA "a") BB)
(check-expect (next AA "b") ER)
(check-expect (next BB "b") BB)
(check-expect (next BB "c") BB)
(check-expect (next BB "d") DD)
(check-expect (next BB "a") ER)
(check-expect (next DD "a") DD)
(check-expect (next ER "a") ER)
(define (next ets ke)
  (cond
    [(equal? ets AA)
     (cond
       [(key=? ke "a") BB]
       [else ER])]
    [(equal? ets BB)
     (cond
       [(key=? ke "b") BB]
       [(key=? ke "c") BB]
       [(key=? ke "d") DD]
       [else ER])]
    [(equal? ets DD) DD]
    [(equal? ets ER) ER]))

; ExpectsToSee.v2 -> Image
; renders current state as an image
(check-expect (render AA) BACKGROUND)
(check-expect (render BB) (overlay (square SIZE "solid" "yellow") BACKGROUND))
(check-expect (render DD) (overlay (square SIZE "solid" "green") BACKGROUND))
(check-expect (render ER) (overlay (square SIZE "solid" "red") BACKGROUND))
(define (render ets)
  (cond
    [(equal? AA ets) BACKGROUND]
    [(equal? BB ets) (overlay (square SIZE "solid" "yellow") BACKGROUND)]
    [(equal? DD ets)(overlay (square SIZE "solid" "green") BACKGROUND)]
    [(equal? ER ets) (overlay (square SIZE "solid" "red") BACKGROUND)]))

; ExpectsToSee.v2 -> Boolean
; ends program when #true
(check-expect (stop? AA) #false)
(check-expect (stop? BB) #false)
(check-expect (stop? DD) #true)
(check-expect (stop? ER) #true)
(define (stop? ets)
  (cond
    [(equal? AA ets) #false]
    [(equal? BB ets) #false]
    [(equal? DD ets) #true]
    [(equal? ER ets) #true]))

; ExpectsToSee.v2 -> Image
; renders final state. if ets is DD, renders green.
; if ets is ER, renders red. otherwise renders given state.
(check-expect (last-picture DD) (overlay (square SIZE "solid" "green") BACKGROUND))
(check-expect (last-picture ER) (overlay (square SIZE "solid" "red") BACKGROUND))
(define (last-picture ets)
  (cond
    [(equal? ets DD) (overlay (square SIZE "solid" "green") BACKGROUND)]
    [(equal? ets ER) (overlay (square SIZE "solid" "red") BACKGROUND)]))


(define (main ets)
  (big-bang ets
    [on-key next]
    [to-draw render]
    [stop-when stop? last-picture]))