;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname exercise340) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require htdp/dir)

(define A (create-dir "/Users/wm/grossman-pl/"))
(define B (create-dir "/Users/wm/grossman-pl/part-a"))
(define Empty (make-dir "empty" '() '()))

; Dir -> [List-of String]
; lists the names of all files and directories in dir
(check-expect (ls Empty) '())
(check-expect (ls A) (list ".DS_Store" "part-a" "part-b" "part-c"))
(define (ls dir)
  (append (map file-name (dir-files dir))
          (map dir-name (dir-dirs dir))))

; could benefit from more thorough testing: disregard order, etc.
