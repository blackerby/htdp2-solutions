;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname exercise508) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/image)

(define FONT-SIZE 11)
(define FONT-COLOR "black")
 
; [List-of 1String] -> Image
; renders a string as an image for the editor 
(define (editor-text s)
  (text (implode s) FONT-SIZE FONT-COLOR))
 
(define-struct editor [pre post])
; An Editor is a structure:
;   (make-editor [List-of 1String] [List-of 1String])
; interpretation if (make-editor p s) is the state of 
; an interactive editor, (reverse p) corresponds to
; the text to the left of the cursor and s to the
; text on the right

; this is the accumulator version, basically S8A's version
; https://github.com/S8A/htdp-exercises/blob/master/ex509.rkt
; [List-of 1String] N -> Editor
; consumes ed, the representation of the string in an editor
;          x, the x-coordinate of a mouse click
; produces (make-editor p s) where
; p is the prefix [List-of 1String] that fits before the mouse click
; s is the suffix [List-of 1String] that fits after the mouse click
(check-expect (split '() 50) (make-editor '() '()))
(check-expect (split (list "a") 50) (make-editor (list "a") '()))
(check-expect (split (list "a") 7) (make-editor (list "a") '()))
(check-expect (split (list "a") 6) (make-editor (list "a") '()))
(check-expect (split (list "a") 5) (make-editor '() (list "a")))
(check-expect (split (list "a" "b") 11) (make-editor (list "a") (list "b")))
(define (split ed x)
  (local (; [List-of 1String] [List-of 1String] -> Editor
          (define (split p s)
            (cond
              [(<= (image-width (editor-text p))
                   x
                   (if (cons? s)
                       (image-width (editor-text (append p (list (first s))))) ; thank you S8A!
                       x))
               (make-editor p s)]
              [else (split (rest p) (cons (first p) s))])))
    (split (reverse ed) '())))
