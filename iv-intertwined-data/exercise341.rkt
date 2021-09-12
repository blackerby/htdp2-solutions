;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname exercise341) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
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

; Dir -> Number
; computes the total size of all files in the entire directory tree
(check-expect (du Text) (+ 99 52 17))
(check-expect (du Code) (+ 8 2))
(check-expect (du Docs) 19)
(check-expect (du Libs) (+ 2 10 19))
(check-expect (du TS) (+ 2 ; number of sub-dirs
                         10 ; file in dir
                         (+ 99 52 17) ; du of Text (sub-dir)
                         (+ 2 10 19)  ; du of Libs (sub-dir)
                         ))
(define (du dir)
  #;(+ (length (dir-dirs dir)) ; 1 file storage unit per directory
     (foldr +
            (foldr + 0 (map file-size (dir-files dir))) ; sum of file sizes
            (map du (dir-dirs dir)))) ; du of nested dirs
  ; ----------------------------------------------------------------------
     (foldr +
            (foldr + 1 (map file-size (dir-files dir))) ; sum of file sizes
            (map du (dir-dirs dir))))

; https://github.com/S8A/htdp-exercises/blob/master/ex341.rkt
; use 1 to represent the size of each directory
; avoids nested folds: appends 2 lists and folds just that

; my tests as written fail (off by one)