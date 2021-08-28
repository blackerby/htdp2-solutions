;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname htpd_01_05_10-exercise-87) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/image)
(require 2htdp/universe)

(define EDITOR-HEIGHT 20)
(define EDITOR-WIDTH 200)
(define Y-CURSOR (/ EDITOR-HEIGHT 2))
(define BACKGROUND (empty-scene EDITOR-WIDTH EDITOR-HEIGHT))
(define TEXT-SIZE 16)
(define TEXT-COLOR "black")
(define CURSOR (rectangle 1 20 "solid" "red"))

(define-struct editor [text index])
; An Editor is a structure:
;   (make-editor String Number)
; interpretation (make-editor s n) describes an editor
; whose visible text is s with 
; the cursor displayed between n characters to the right
; of the first character
; examples:
(define e0 (make-editor "" 0))
(define e1 (make-editor "h" 0))
(define e2 (make-editor "h" 1))
(define e3 (make-editor "hello world" 5))
(define e4 (make-editor "hello world" 11))
(define e5 (make-editor "hello world" 0))

; Editor -> Image
; renders given text on an empty scene with a cursor
(check-expect (render e0)
              (overlay/align "left" "center"
                 (place-image CURSOR
                              (image-width (draw-text (substring (editor-text e0) 0 (editor-index e0))))
                              Y-CURSOR
                              (draw-text (editor-text e0)))
                 BACKGROUND))
(check-expect (render e1)
              (overlay/align "left" "center"
                 (place-image CURSOR
                              (image-width (draw-text (substring (editor-text e1) 0 (editor-index e1))))
                              Y-CURSOR
                              (draw-text (editor-text e1)))
                 BACKGROUND))
(check-expect (render e2)
              (overlay/align "left" "center"
                             (place-image CURSOR
                                          (image-width (draw-text (substring (editor-text e2) 0 (editor-index e2))))
                                          Y-CURSOR
                                          (draw-text (editor-text e2)))
                             BACKGROUND))
(check-expect (render e3)
              (overlay/align "left" "center"
                             (place-image CURSOR
                                          (image-width (draw-text (substring (editor-text e3) 0 (editor-index e3))))
                                          Y-CURSOR
                                          (draw-text (editor-text e3)))
                             BACKGROUND))
(check-expect (render e4)
              (overlay/align "left" "center"
                             (place-image CURSOR
                                          (image-width (draw-text (substring (editor-text e4) 0 (editor-index e4))))
                                          Y-CURSOR
                                          (draw-text (editor-text e4)))
                             BACKGROUND))
(check-expect (render e5)
              (overlay/align "left" "center"
                             (place-image CURSOR
                                          (image-width (draw-text (substring (editor-text e5) 0 (editor-index e5))))
                                          Y-CURSOR
                                          (draw-text (editor-text e5)))
                             BACKGROUND))
(define (render ed)
  (overlay/align "left" "center"
                             (place-image CURSOR
                                          (image-width (draw-text (substring (editor-text ed) 0 (editor-index ed))))
                                          Y-CURSOR
                                          (draw-text (editor-text ed)))
                             BACKGROUND))

; Editor KeyEvent -> Editor
; adds single character ke to the end of (editor-text ed),
; unless the width of the rendered text will exceed the width
; of the rendered editor.
; if ke denotes the backspace "\b", it deletes the character
; immediately to the left of the cursor if there is one.
; it ignores tab ("\t") and return ("\r"). The KeyEvent "left"
; moves the cursor one character to the left and "right" moves
; it one character to the right, if there are any characters.
(check-expect (edit e0 "left") e0)
(check-expect (edit e0 "right") e0)
(check-expect (edit e1 "left") e1)
(check-expect (edit e1 "right") e2)
(check-expect (edit e3 "left")
              (make-editor "hello world" 4))
(check-expect (edit e3 "right")
              (make-editor "hello world" 6))
(check-expect (edit e3 "\t") e3)
(check-expect (edit e3 "\r") e3)
(check-expect (edit e0 "\b") e0)
(check-expect (edit e2 "\b") e0)
(check-expect (edit e3 "\b")
              (make-editor "hell world" 4))
(check-expect (edit e0 "a") (make-editor "a" 1))
(check-expect (edit (make-editor "a" 1) "b") (make-editor "ab" 2))
(check-expect (edit e0 " ") (make-editor " " 1))
(check-expect (edit (make-editor "helloworld" 5) " ") (make-editor "hello world" 6))
(check-expect (edit (make-editor "hello world" 11) "!") (make-editor "hello world!" 12))
(check-expect (edit (make-editor "aaaaaaaaaaaaaaaaaaaaaa" 22) "a")
              (make-editor "aaaaaaaaaaaaaaaaaaaaaa" 22))

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
         (insert-character ed ke))]
    [else ed]))

; Editor -> Editor
; moves "cursor" in ed one character to the left if there are
; any characters left of the cursor, otherwise does nothing
(check-expect (cursor-left e0) e0)
(check-expect (cursor-left e1) e1)
(check-expect (cursor-left e2) e1)
(check-expect (cursor-left e4)
              (make-editor "hello world" 10))
(define (cursor-left ed)
  (make-editor (editor-text ed)
               (cond
                 [(zero? (editor-index ed)) (editor-index ed)]
                 [else (- (editor-index ed) 1)])))

; Editor -> Editor
; moves "cursor" in ed one character to the right if there are
; any characters right of the cursor, otherwise does nothing
(check-expect (cursor-right e0) e0)
(check-expect (cursor-right e1) e2)
(check-expect (cursor-right e2) e2)
(define (cursor-right ed)
  (make-editor (editor-text ed)
               (cond
                 [(= (editor-index ed) (string-length (editor-text ed)))
                  (editor-index ed)]
                 [else (+ (editor-index ed) 1)])))

; Editor -> Editor
; deletes the character immediately to the left of
; the cursor if there is one
(check-expect (delete-previous e0) e0)
(check-expect (delete-previous e1) e1)
(check-expect (delete-previous e2) e0)
(check-expect (delete-previous e3)
              (make-editor
               "hell world"
               4))
(define (delete-previous ed)
  (cond
    [(= 0 (editor-index ed)) ed]
    [else (make-editor
           (string-append
            (substring (editor-text ed)
                       0
                       (- (editor-index ed) 1))
            (substring (editor-text ed) (editor-index ed)))
           (- (editor-index ed) 1))]))

; Editor 1String -> Editor
; inserts given char immediately to the left of "cursor"
(check-expect (insert-character e0 "h") e2)
(check-expect (insert-character e2 " ") (make-editor "h " 2))
(check-expect (insert-character e4 "!") (make-editor "hello world!" 12))
(check-expect (insert-character (make-editor "helloworld" 5) " ") (make-editor "hello world" 6))
(define (insert-character ed c)
  (make-editor
   (string-append
    (substring (editor-text ed)
               0
               (editor-index ed))
    c
    (substring (editor-text ed) (editor-index ed)))
   (+ (editor-index ed) 1)))

; String -> Image
; renders given string as a text image
(check-expect (draw-text "") (text "" TEXT-SIZE TEXT-COLOR))
(check-expect (draw-text "hello") (text "hello" TEXT-SIZE TEXT-COLOR))
(check-expect (draw-text "hello world") (text "hello world" TEXT-SIZE TEXT-COLOR))
(define (draw-text s)
  (text s TEXT-SIZE TEXT-COLOR))

; Editor -> Editor
(define (run ed)
  (big-bang ed
    [to-draw render]
    [check-with editor?]
    [on-key edit]))
