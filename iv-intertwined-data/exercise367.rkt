;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname exercise367) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
#;(define (xexpr-attr xe)
  (local ((define optional-loa+content (rest xe)))
    (cond
      [(empty? optional-loa+content) ...]
      [else (... (first optional-loa+content)
             ... (xexpr-attr (rest optional-loa+content)) ...)])))

; the finished parsing function does not need the self-reference because we can think of the attribute list
; as a single data item: it's there or it's not, and if it's there, it will always/only hold the second position
; in the list.
