;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname exercise342) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require htdp/dir)

(define A (create-dir "/Users/wm/grossman-pl/"))
(define B (create-dir "/Users/wm/grossman-pl/part-a"))
(define Empty (make-dir "empty" '() '()))

(define Text
  (make-dir "Text" '() (list (make-file "part1" 99 "")
                             (make-file "part2" 52 "")
                             (make-file "part3" 17 ""))))
(define Code
  (make-dir "Code" '() (list (make-file "hang" 8 "")
                             (make-file "draw" 2 ""))))

(define Docs
  (make-dir "Docs" '() (list (make-file "read!" 19 ""))))

(define Libs
  (make-dir "Libs" (list Code Docs) '()))

(define TS
  (make-dir "TS" (list Text Libs) (list (make-file "read!" 10 ""))))

; Dir String -> Boolean
; determines whether a file with name name occurs in dir
(check-expect (find? A "hw6assignment.rb") #true)
(check-expect (find? A "bingbong") #false)
(define (find? dir name) ; https://github.com/S8A/htdp-exercises/blob/master/ex339.rkt
  (or (member? name (map file-name (dir-files dir)))
      (ormap (lambda (d) (find? d name)) (dir-dirs dir))))

; A Path is [List-of String].
; interpretation directions into a directory tree

; A [Maybe Path] is one of:
; - #false
; - Path

; Dir String -> [Maybe Path]
; produces path to f
(check-expect (find TS "read!") (list "TS" "read!"))
(check-expect (find Text "part1") (list "Text" "part1"))
(check-expect (find TS "part1") (list "TS" "Text" "part1"))
(check-expect (find TS "hang") (list "TS" "Libs" "Code" "hang"))
(check-expect (find TS "dogs") #false)
(define (find d f)
  (cond
    [(member? f (map file-name (dir-files d))) (list (dir-name d) f)]
    [(ormap (lambda (sub) (find? sub f)) (dir-dirs d))
     (first (map
             (lambda (sub) (cons (dir-name d) (find sub f)))
             (filter (lambda (sub) (find? sub f)) (dir-dirs d))))]
    [else #false]))

; Dir String -> [List-of Path]
; produces list of all paths to f
(check-expect (find-all TS "read!") (list (list "TS" "read!") (list "TS" "Libs" "Docs" "read!")))
(check-expect (find-all Text "part1") (list (list "Text" "part1")))
(check-expect (find-all TS "part1") (list (list "TS" "Text" "part1")))
(check-expect (find-all TS "hang") (list (list "TS" "Libs" "Code" "hang")))
(check-expect (find-all TS "dogs") '())
(define (find-all d f)
  (foldr (lambda (sub b)
           (append b (list (cons (dir-name d) (find sub f)))))
         (if (member? f (map file-name (dir-files d)))
             (list (list (dir-name d) f))
             '())
         (filter (lambda (sub) (find? sub f)) (dir-dirs d))))
