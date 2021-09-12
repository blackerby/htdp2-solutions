;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname exercise343) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
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

; A Path is [List-of String].
; interpretation directions into a directory tree

; Dir -> [List-of Path]
; list paths to all files contained in dir
(check-expect (ls-R Code) (list (list "Code" "hang")
                                (list "Code" "draw")))
(check-expect (ls-R Docs) (list (list "Docs" "read!")))
(check-expect (ls-R Libs) (list (list "Libs" "Code" "hang")
                                (list "Libs" "Code" "draw")
                                (list "Libs" "Docs" "read!")))
(define (ls-R dir)
  (foldr (lambda (f b) (cons (list (dir-name dir) (file-name f)) b))
         (foldr (lambda (d b)
                  (append
                   (map (lambda (f) (cons (dir-name dir) f)) (ls-R d))
                   b))
                  '()
                  (dir-dirs dir))
         (dir-files dir)))
          