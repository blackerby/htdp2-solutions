;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname ex-65) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(define-struct movie [title producer year])

(define my-movie (make-movie "my movie" "me" 1992))
(movie-title my-movie)
(movie-producer my-movie)
(movie-year my-movie)
(movie? my-movie)
(movie? 1992)