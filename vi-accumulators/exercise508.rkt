;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname exercise508) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
#|

This one stumped me. I looked at both S8A's and Y. E.'s solutions for this exercise and exercise 509.
First, it is interesting that Y. E.'s solutions to 508 and 509 are the same, they just use different names for
the two functions. The accumulator approach is simple and intuitive, in my opinion.

I'm giving up on a structural solution to 508. Without running it myself, it looks like S8A' solution works, but it is
complicated because of the information loss that happens in the structural recursion. His suffix generating solution
works nicely.

One of my other challenges was not fully understanding the problem, which is my own fault due to multi-tasking and
sending my attention elsewhere when the problem got challenging.

I'm disappointed not to have come up with a solution to this problem myself, but I did learn from the other solutions
I found.

Here is S8A's solution: https://github.com/S8A/htdp-exercises/blob/master/ex508.rkt

Below is a rewrite of his solution that made a little more sense to me.

|#

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

; [List-of 1String] N -> Editor
; consumes ed, the representation of the string in an editor
;          x, the x-coordinate of a mouse click
; produces (make-editor p s) where
; p is the prefix [List-of 1String] that fits before the mouse click
; s is the suffix [List-of 1String] that fits after the mouse click
(check-expect (split-structural '() 50) (make-editor '() '()))
(check-expect (split-structural (list "a") 50) (make-editor (list "a") '()))
(check-expect (split-structural (list "a") 7) (make-editor (list "a") '()))
(check-expect (split-structural (list "a") 6) (make-editor (list "a") '()))
(check-expect (split-structural (list "a") 5) (make-editor '() (list "a")))
(check-expect (split-structural (list "a" "b") 11) (make-editor (list "a") (list "b")))
(define (split-structural ed x)
  (local (; N -> [List-of String]
          (define (post n) (explode (substring (implode ed) n)))
          ; [List-of 1String] -> [List-of 1String]
          ; produces prefix of lo1s that fits at x
          (define (fit lo1s)
            (cond
              [(empty? lo1s) '()]
              [else (local ((define p lo1s)
                            (define s (post (length p))))
                      (if (<= (image-width (editor-text p))
                              x
                              (if (cons? s)
                                  (image-width (editor-text (append p (list (first s)))))
                                  x))
                          p
                          (fit (rest p))))]))
          (define pre (fit (reverse ed))))
    (make-editor pre (post (length pre)))))
