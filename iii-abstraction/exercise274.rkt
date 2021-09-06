;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname exercise274) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; [List-of 1Strings] -> [List-of [List-of 1Strings]
; produces the list of prefixes from l
(check-expect (prefixes '()) '())
(check-expect (prefixes (list "a")) (list (list "a")))
(check-expect (prefixes (list "a" "b"))
               (list
                (list "a" "b")
                (list "a")))
(check-expect (prefixes (list "a" "b" "c" "d"))
               (list
                (list "a" "b" "c" "d")
                (list "a" "b" "c")
                (list "a" "b")
                (list "a")))
(define (prefixes l)
  (local ((define (merge item b)
            (local ((define (add-at-end lst)
                      (cons item lst)))
              (map add-at-end (cons '() b)))))
    (reverse (foldr merge '() l))))

; [List-of 1Strings] -> [List-of [List-of 1Strings]
; produces the list of suffixes from l
(check-expect (suffixes '()) '())
(check-expect (suffixes (list "a")) (list (list "a")))
(check-expect (suffixes (list "a" "b")) (list (list "a" "b") (list "b")))
(check-expect (suffixes (list "a" "b" "c" "d"))
              (list
               (list "a" "b" "c" "d")
               (list "b" "c" "d")
               (list "c" "d")
               (list "d")))
(define (suffixes l)
  (local ((define (merge item b)
            (local ((define (add-at-end lst)
                      (reverse (cons item (reverse lst)))))
              (map add-at-end (cons '() b)))))
    (reverse (foldl merge '() l))))

; https://github.com/bgusach/exercises-htdp2e/blob/master/3-abstraction/ex-274.rkt
; solutions are based on the one found at the above URL
; I'd estimate I understand about 60% of what's going on here
; the list in the call to map is tripping me up
; that said, I understand that fold functions can be used here, and that map is useful here
; the finer grained details of what happens in the helper functions passed to map and fold
; are still somewhat elusive to me.

; All in all, I have spent enough time banging my head against the wall on this exercise, so I'm pushing it
; and moving on