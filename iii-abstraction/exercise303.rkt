;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname exercise303) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(lambda (x y)
  (+ x (* x y)))

(lambda (x y) (+ x
                 (local ((define x (* y y))) ; introduces whole in scope of first binding occurrence of x
                   (+ (* 3 x) (/ 1 x)))))

(lambda (x y)
  (+ x ((lambda (x) ; introduces whole in scope of first binding occurrence of x
          (+ (* 3 x)
             (/ 1 x))) (* y y))))
