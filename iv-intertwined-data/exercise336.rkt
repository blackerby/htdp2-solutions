;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname exercise336) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(define-struct file [name size content])
; A File.v3 is a structure: 
;   (make-file String N String)

(define-struct dir.v3 [name dirs files])
; A Dir.v3 is a structure: 
;   (make-dir.v3 String Dir* File*)
 
; A Dir* is one of: 
; – '()
; – (cons Dir.v3 Dir*)
 
; A File* is one of: 
; – '()
; – (cons File.v3 File*)

(define Text
  (make-dir.v3 "Text" '() (list (make-file "part1" 99 "")
                                (make-file "part2" 52 "")
                                (make-file "part3" 17 ""))))
(define Code
  (make-dir.v3 "Code" '() (list (make-file "hang" 8 "")
                            (make-file "draw" 2 ""))))

(define Docs
  (make-dir.v3 "Docs" '() (list (make-file "read!" 19 ""))))

(define Libs
  (make-dir.v3 "Libs" (list Code Docs) '()))

(define TS
  (make-dir.v3 "TS" (list Text Libs) (list (make-file "read!" 10 ""))))

; Dir.v3 -> Number
; determines the number of files dir contains
(check-expect (how-many Text) 3)
(check-expect (how-many Code) 2)
(check-expect (how-many Docs) 1)
(check-expect (how-many Libs) 3)
(check-expect (how-many TS) 7)
(define (how-many dir)
  (local ((define (how-many-dir* lod)
            (cond
              [(empty? lod) 0]
              [else
               (+ (how-many (first lod))
                  (how-many-dir* (rest lod)))])))
  (+ (length (dir.v3-files dir))
     (how-many-dir* (dir.v3-dirs dir)))))

; Q: Given the complexity of the data definition, contemplate how anyone can design correct functions.
;    Why are you confident that how-many produces correct results?
; A: testing and the design recipe?