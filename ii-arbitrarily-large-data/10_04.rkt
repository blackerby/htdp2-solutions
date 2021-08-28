;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname 10_04) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/image)
(require 2htdp/universe)

(define-struct editor [pre post])
; An Editor is a structure:
;   (make-editor Lo1S Lo1S) 
; An Lo1S is one of: 
; – '()
; – (cons 1String Lo1S)

(define good
  (cons "g" (cons "o" (cons "o" (cons "d" '())))))
(define all
  (cons "a" (cons "l" (cons "l" '()))))
(define lla
  (cons "l" (cons "l" (cons "a" '()))))

; data example 1: 
(make-editor all good)
 
; data example 2:
(make-editor lla good)

; Lo1s -> Lo1s 
; produces a reverse version of the given list 
 
(check-expect
  (rev (cons "a" (cons "b" (cons "c" '()))))
  (cons "c" (cons "b" (cons "a" '()))))
(check-expect (rev '()) '())
(check-expect (rev (cons "a" '())) (cons "a" '()))
(check-expect (rev (cons "a" (cons "b" '())))
              (cons "b" (cons "a" '())))

(define (rev l)
  (cond
    [(empty? l) '()]
    [else (add-at-end (rev (rest l)) (first l))]))

; Lo1s 1String -> Lo1s
; creates a new list by adding s to the end of l
 
(check-expect
  (add-at-end (cons "c" (cons "b" '())) "a")
  (cons "c" (cons "b" (cons "a" '()))))
(check-expect (add-at-end '() "a") (cons "a" '()))
(define (add-at-end l s)
  (cond
    [(empty? l) (cons s l)]
    [else (cons (first l)
                (add-at-end (rest l) s))]))

; String String -> Editor
; consumes to strings, the first being the text before the cursor
; and the second being the text after the cursor
(check-expect (create-editor "all" "good") (make-editor lla good))
(define (create-editor s1 s2)
  (make-editor
   (reverse (explode s1)) ; should this use reverse?
   (explode s2)))

(define HEIGHT 20) ; the height of the editor 
(define WIDTH 200) ; its width 
(define FONT-SIZE 16) ; the font size 
(define FONT-COLOR "black") ; the font color 
 
(define MT (empty-scene WIDTH HEIGHT))
(define CURSOR (rectangle 1 HEIGHT "solid" "red"))

(define INITAL-EDITOR (create-editor "" ""))

; Editor -> Image
; renders an editor as an image of the two texts 
; separated by the cursor
(check-expect (editor-render (make-editor '() '()))
              (place-image/align
               (beside (text "" FONT-SIZE FONT-COLOR)
                       CURSOR
                       (text "" FONT-SIZE FONT-COLOR))
               1 1
               "left" "top"
               MT))
(check-expect (editor-render (make-editor lla good))
              (place-image/align
               (beside (text "all" FONT-SIZE FONT-COLOR)
                       CURSOR
                       (text "good" FONT-SIZE FONT-COLOR))
               1 1
               "left" "top"
               MT))
(define (editor-render e)
  (place-image/align
   (beside (editor-text (reverse (editor-pre e)))
           CURSOR
           (editor-text (editor-post e)))
   1 1
   "left" "top"
   MT))

; Lo1s -> Image
; renders a list of 1Strings as a text image
(check-expect
  (editor-text
   (cons "p" (cons "o" (cons "s" (cons "t" '())))))
  (text "post" FONT-SIZE FONT-COLOR))
(check-expect
 (editor-text
  (cons "e" (cons "r" (cons "p" '()))))
 (text "erp" FONT-SIZE FONT-COLOR))
(define (editor-text s)
  (text (implode s) FONT-SIZE FONT-COLOR))

;; exercise 180
#;(define (editor-text s)
  (text (list1s->string s) FONT-SIZE FONT-COLOR))

; Lo1s -> String
; converts a list of 1Strings to a String
(check-expect (list1s->string '()) "")
(check-expect (list1s->string (cons "a" '())) "a")
(check-expect (list1s->string (cons "a" (cons "b" (cons "c" '()))))
              "abc")
(define (list1s->string s)
  (cond
    [(empty? s) ""]
    [else (string-append (first s)
                         (list1s->string (rest s)))]))

; Editor KeyEvent -> Editor
; deals with a key event, given some editor
;(check-expect (editor-kh (create-editor "" "") "e")
;              (create-editor "e" ""))
;(check-expect
;  (editor-kh (create-editor "cd" "fgh") "e")
;  (create-editor "cde" "fgh"))
;(check-expect
; (editor-kh (create-editor "cd" "fgh") "\b")
; (create-editor "c" "fgh"))
;(check-expect
; (editor-kh (create-editor "" "") "\b")
; (create-editor "" ""))
;(check-expect
; (editor-kh (create-editor "cd" "fgh") "left")
; (create-editor "c" "dfgh"))
;(check-expect
; (editor-kh (create-editor "cd" "fgh") "right")
; (create-editor "cdf" "gh"))
;(check-expect
; (editor-kh (create-editor "" "") "left")
; (create-editor "" ""))
;(check-expect
; (editor-kh (create-editor "" "") "right")
; (create-editor "" ""))
;(check-expect
; (editor-kh (create-editor "abc" "") "\b")
; (create-editor "ab" ""))
;(check-expect
; (editor-kh (create-editor "" "abc") "\b")
; (create-editor "" "abc"))
;(check-expect
; (editor-kh (create-editor "" "abc") "left")
; (create-editor "" "abc"))
;(check-expect
; (editor-kh (create-editor "" "abc") "right")
; (create-editor "a" "bc"))
;(check-expect
; (editor-kh (create-editor "abc" "") "right")
; (create-editor "abc" ""))
;(check-expect
; (editor-kh (create-editor "abc" "") "left")
; (create-editor "ab" "c"))
(define (editor-kh ed k)
  (cond
    [(key=? k "left") (editor-lft ed)]
    [(key=? k "right") (editor-rgt ed)]
    [(key=? k "\b") (editor-del ed)]
    [(key=? k "\t") ed] ; exercise 177: \t and \r have string length of 1, so need to be accounted for
    [(key=? k "\r") ed]
    [(= (string-length k) 1) (editor-ins ed k)]
    [else ed]))

;; exercise 179

; Editor -> Editor
; moves cursor one character to the left
(check-expect (editor-lft (make-editor '() '())) (make-editor '() '()))
(check-expect (editor-lft (make-editor '() (cons "a" '()))) (make-editor '() (cons "a" '())))
(check-expect (editor-lft (make-editor (cons "a" '()) '())) (make-editor '() (cons "a" '())))
(check-expect (editor-lft (make-editor (cons "a" (cons "b" (cons "c" '()))) (cons "d" '())))
              (make-editor (cons "b" (cons "c" '())) (cons "a" (cons "d" '()))))
(define (editor-lft ed)
  (cond
    [(empty? (editor-pre ed)) ed]
    [else
     (make-editor (rest (editor-pre ed))
                  (cons (first (editor-pre ed))
                        (editor-post ed)))]))

; Editor -> Editor
; moves cursor one character to the right
(check-expect (editor-rgt (make-editor '() '())) (make-editor '() '()))
(check-expect (editor-rgt (make-editor '() (cons "a" '()))) (make-editor (cons "a" '()) '()))
(check-expect (editor-rgt (make-editor (cons "a" '()) '())) (make-editor (cons "a" '()) '()))
(check-expect (editor-rgt (make-editor (cons "b" (cons "c" '())) (cons "a" (cons "d" '()))))
              (make-editor (cons "a" (cons "b" (cons "c" '()))) (cons "d" '())))
(define (editor-rgt ed)
  (cond
    [(empty? (editor-post ed)) ed]
    [else
     (make-editor
      (cons (first (editor-post ed))
            (editor-pre ed))
      (rest (editor-post ed)))]))

; Editor -> Editor
; removes the character directly in front of the cursor
(check-expect (editor-del (make-editor '() '())) (make-editor '() '()))
(check-expect (editor-del (make-editor '() (cons "a" '()))) (make-editor '() (cons "a" '())))
(check-expect (editor-del (make-editor (cons "a" '()) '())) (make-editor '() '()))
(check-expect (editor-del (make-editor (cons "a" (cons "b" (cons "c" '()))) (cons "d" '())))
              (make-editor (cons "b" (cons "c" '())) (cons "d" '())))
(define (editor-del ed)
  (cond
    [(empty? (editor-pre ed)) ed]
    [else
     (make-editor
      (rest (editor-pre ed))
      (editor-post ed))]))

; Editor 1String -> Editor
; insert the 1String k between pre and post
(check-expect
  (editor-ins (make-editor '() '()) "e")
  (make-editor (cons "e" '()) '()))
 
(check-expect
  (editor-ins
    (make-editor (cons "d" '())
                 (cons "f" (cons "g" '())))
    "e")
  (make-editor (cons "e" (cons "d" '()))
               (cons "f" (cons "g" '()))))
(define (editor-ins ed k)
  (make-editor (cons k (editor-pre ed))
               (editor-post ed)))

; main : String -> Editor
; launches the editor given some initial string 
(define (main s)
   (big-bang (create-editor s "")
     [on-key editor-kh]
     [to-draw editor-render]))

