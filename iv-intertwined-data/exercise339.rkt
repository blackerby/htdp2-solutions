;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname exercise339) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require htdp/dir)

(define A (create-dir "/Users/wm/grossman-pl/"))

; Dir String -> Boolean
; determines whether a file with name name occurs in dir
(check-expect (find? A "hw6assignment.rb") #true)
(check-expect (find? A "bingbong") #false)
(define (find? dir name)
  #;(local ((define (find-dirs*? lod n)
            (cond
              [(empty? lod) #false]
              [else
               (or
                (find? (first lod) name)
                (find-dirs*? (rest lod) name))])))
    (or (member? name (map file-name (dir-files dir)))
        (find-dirs*? (dir-dirs dir) name)))
  ; --------------------------------------------------
  (foldr (lambda (d b)
           (or (find? d name) b))
         (member? name (map file-name (dir-files dir)))
         (dir-dirs dir))) ; this is basically ormap, see below

; great solution, again: https://github.com/S8A/htdp-exercises/blob/master/ex339.rkt
; ormap!

