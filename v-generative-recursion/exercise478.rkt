;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname exercise478) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
#|
When n = 3 for an n * n square, a queen placed in any square in the top-most row, the right-most column,
and the bottom-most row will threaten 7 squares, leaving two squares for the placement of another queen.

A queen placed in the central square will threaten all 9 squares.
|#