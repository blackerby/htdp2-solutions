;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname htdp_01_05_10) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/image)
(require 2htdp/universe)

(define EDITOR-HEIGHT 20)
(define EDITOR-WIDTH 200)
(define BACKGROUND (empty-scene EDITOR-WIDTH EDITOR-HEIGHT))
(define TEXT-SIZE 16)
(define TEXT-COLOR "black")
(define CURSOR (rectangle 1 20 "solid" "red"))

(define-struct editor [pre post])
; An Editor is a structure:
;   (make-editor String String)
; interpretation (make-editor s t) describes an editor
; whose visible text is (string-append s t) with 
; the cursor displayed between s and t
; examples:
(define e0 (make-editor "" ""))
(define e1 (make-editor "hello" "world"))
(define e2 (make-editor "hello " "world"))
(define e3 (make-editor "hello world" ""))
(define e4 (make-editor "h" ""))
(define e5 (make-editor "" "h"))
(define e6 (make-editor "" "hello world"))
(define e7 (make-editor "h" "ello world"))

;; exercise 83
; Editor -> Image
; renders given text on an empty scene with a cursor
(check-expect (render e0)
              (overlay/align "left" "center"
                             (beside (text (editor-pre e0) TEXT-SIZE TEXT-COLOR)
                                     CURSOR
                                     (text (editor-post e0) TEXT-SIZE TEXT-COLOR))
                             BACKGROUND))
(check-expect (render e1)
              (overlay/align "left" "center"
                             (beside (text (editor-pre e1) TEXT-SIZE TEXT-COLOR)
                                     CURSOR
                                     (text (editor-post e1) TEXT-SIZE TEXT-COLOR))
                             BACKGROUND))
(check-expect (render e2)
              (overlay/align "left" "center"
                             (beside (text (editor-pre e2) TEXT-SIZE TEXT-COLOR)
                                     CURSOR
                                     (text (editor-post e2) TEXT-SIZE TEXT-COLOR))
                             BACKGROUND))
(check-expect (render e3)
              (overlay/align "left" "center"
                             (beside (text (editor-pre e3) TEXT-SIZE TEXT-COLOR)
                                     CURSOR
                                     (text (editor-post e3) TEXT-SIZE TEXT-COLOR))
                             BACKGROUND))
(define (render ed)
  (overlay/align "left" "center"
                 (beside (draw-text (editor-pre ed))
                         CURSOR
                         (draw-text (editor-post ed)))
                 BACKGROUND))

; String -> Image
; renders given string as a text image
(check-expect (draw-text "") (text "" TEXT-SIZE TEXT-COLOR))
(check-expect (draw-text "hello") (text "hello" TEXT-SIZE TEXT-COLOR))
(check-expect (draw-text "hello world") (text "hello world" TEXT-SIZE TEXT-COLOR))
(define (draw-text s)
  (text s TEXT-SIZE TEXT-COLOR))

;; exercise 84
; Editor KeyEvent -> Editor
; adds single character ke to the end of (editor-pre ed),
; unless the width of the rendered text will exceed the width
; of the rendered editor.
; if ke denotes the backspace "\b", it deletes the character
; immediately to the left of the cursor if there is one.
; it ignores tab ("\t") and return ("\r"). The KeyEvent "left"
; moves the cursor one character to the left and "right" moves
; it one character to the right, if there are any characters.
(check-expect (edit e0 "left") e0)
(check-expect (edit e0 "right") e0)
(check-expect (edit e6 "left") e6)
(check-expect (edit e6 "right") e7)
(check-expect (edit e4 "left") e5)
(check-expect (edit e5 "right") e4)
(check-expect (edit e1 "\t") e1)
(check-expect (edit e1 "\r") e1)
(check-expect (edit e0 "a") (make-editor "a" ""))
(check-expect (edit (make-editor "a" "") "b") (make-editor "ab" ""))
(check-expect (edit e1 " ") e2)
(check-expect (edit e0 "\b") e0)
(check-expect (edit e4 "\b") e0)
(check-expect (edit e5 "\b") e5)
(check-expect (edit e3 "\b") (make-editor "hello worl" ""))
(check-expect (edit e2 "\b") e1)
(check-expect (edit e1 "\b") (make-editor "hell" "world"))
(check-expect (edit e1 "up") e1)
(check-expect (edit e1 "down") e1)
(check-expect (edit (make-editor "aaaaaaaaaaaaaaaaaaaaaa" "") "a")
              (make-editor "aaaaaaaaaaaaaaaaaaaaaa" ""))

(define (edit ed ke)
  (cond
    [(key=? "left" ke) (cursor-left ed)]
    [(key=? "right" ke) (cursor-right ed)]
    [(key=? "\b" ke) (delete-previous ed)]
    [(key=? "\t" ke) ed]
    [(key=? "\r" ke) ed]
    [(= 1 (string-length ke))
     (if (> (image-width (render (insert-character ed ke))) EDITOR-WIDTH)
         ed
         (insert-character ed ke))] ; exercise 86
    [else ed]))

;; exercise 85
; String -> Editor
(define (run pre)
  (big-bang (make-editor pre "")
    [to-draw render]
    [on-key edit]))

; Editor 1String -> Editor
; inserts given char immediately to the left of "cursor"
(check-expect (insert-character e0 "h") e4)
(check-expect (insert-character e1 " ") e2)
(check-expect (insert-character e3 "!") (make-editor "hello world!" ""))
(define (insert-character ed c)
  (make-editor
   (string-append (editor-pre ed) c)
   (editor-post ed)))

; Editor -> Editor
; moves "cursor" in ed one character to the left if there are
; any characters left of the cursor, otherwise does nothing
(check-expect (cursor-left e0) e0)
(check-expect (cursor-left e4) e5)
(check-expect (cursor-left e5) e5)
(check-expect (cursor-left e7) e6)
(check-expect (cursor-left e6) e6)
(define (cursor-left ed)
  (cond
    [(zero? (string-length (editor-pre ed))) ed]
    [else (make-editor (string-remove-last (editor-pre ed))
                       (string-append (string-last (editor-pre ed)) (editor-post ed)))]))

; Editor -> Editor
; moves "cursor" in ed one character to the right if there are
; any characters right of the cursor, otherwise does nothing
(check-expect (cursor-right e0) e0)
(check-expect (cursor-right e3) e3)
(check-expect (cursor-right e5) e4)
(check-expect (cursor-right e4) e4)
(check-expect (cursor-right e6) e7)
(check-expect (cursor-right e7)
              (make-editor "he" "llo world"))
(define (cursor-right ed)
  (cond
    [(zero? (string-length (editor-post ed))) ed]
    [else (make-editor
           (string-append (editor-pre ed)
                          (string-first (editor-post ed)))
           (string-rest (editor-post ed)))]))

; Editor -> Editor
; deletes the character immediately to the left of
; the cursor if there is one
(check-expect (delete-previous e0) e0)
(check-expect (delete-previous e4) e0)
(check-expect (delete-previous e5) e5)
(check-expect (delete-previous e2) e1)
(check-expect (delete-previous e1)
              (make-editor "hell" "world"))
(define (delete-previous ed)
  (make-editor
   (string-remove-last (editor-pre ed))
   (editor-post ed)))

; String -> 1String
; extracts the first character from s
; given: "hello", expect: "h"
; given: "world", expect: "w"
(define (string-first s)
  (substring s 0 1))

; String -> 1String
; extracts the last character from s
; given "hello", expect: "o"
; given "world", expect: "d"
(define (string-last s)
  (substring s (- (string-length s) 1)))

; String -> String
; produces s without the first character
; given "hello", expect: "ello"
; given "world", expect: "world"
(define (string-rest s)
  (substring s 1))

; String -> String
; produces s without the last character
; given "hello", expect: "hell"
; given "world", expect: "worl"
(check-expect (string-remove-last "") "")
(define (string-remove-last s)
  (if (zero? (string-length s))
      s
      (substring s 0 (- (string-length s) 1))))