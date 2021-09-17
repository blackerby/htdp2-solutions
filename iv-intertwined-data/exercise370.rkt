;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname exercise370) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; An Xexpr is a list: 
; – (cons Symbol Body)
; – (cons Symbol (cons [List-of Attribute] Body))
; where Body is short for [List-of Xexpr]
; An Attribute is a list of two items:
;   (cons Symbol (cons String '()))

(define a0 '((initial "X")))
 
(define e0 '(machine))
(define e1 `(machine ,a0))
(define e2 '(machine (action)))
(define e3 '(machine () (action)))
(define e4 `(machine ,a0 (action) (action)))

; Xexpr -> [List-of Attribute]
; retrieves the list of attributes of xe
(check-expect (xexpr-attr e0) '())
(check-expect (xexpr-attr e1) '((initial "X")))
(check-expect (xexpr-attr e2) '())
(check-expect (xexpr-attr e3) '())
(check-expect (xexpr-attr e4) '((initial "X")))
(define (xexpr-attr xe)
  (local ((define optional-loa+content (rest xe)))
    (cond
      [(empty? optional-loa+content) '()]
      [else
       (local ((define loa-or-x
                 (first optional-loa+content)))
         (if (list-of-attributes? loa-or-x)
             loa-or-x
             '()))])))

; A LOA-or-X is one of:
; - [List-of Attribute]
; - Xexpr

; LOA-or-X -> Boolean
; is x a list of attributes
(define (list-of-attributes? x)
  (cond
    [(empty? x) #true]
    [else
     (local ((define possible-attribute (first x)))
       (cons? possible-attribute))]))

; Xexpr -> Symbol
; retrieves the name of xe
(check-expect (xexpr-name e0) 'machine)
(check-expect (xexpr-name '(transition ((from "seen-e") (to "seen-f")))) 'transition)
(check-expect (xexpr-name '(ul (li (word) (word))
                               (li (word)))) 'ul)
(check-error (xexpr-name a0) "not an x-expression")
(define (xexpr-name xe)
  (cond
    [(and (cons? xe) (symbol? (first xe)))
     (first xe)]
    [else (error "not an x-expression")]))

; Xexpr -> [List-of Xexpr]
; extracts the list of content elements from xe
(check-expect (xexpr-content e0) '())
(check-expect (xexpr-content e1) '())
(check-expect (xexpr-content e2) '((action)))
(check-expect (xexpr-content e3) '((action)))
(check-expect (xexpr-content e4) '((action) (action)))
(define (xexpr-content xe)
  (local ((define optional-loa+content (rest xe)))
    (cond
      [(empty? optional-loa+content) '()]
      [else
       (local ((define loa-or-x
                 (first optional-loa+content)))
         (if (list-of-attributes? loa-or-x)
             (rest optional-loa+content)
             (rest xe)))])))

; [List-of Attribute] Symbol -> [Maybe String]
; returns a string if attr has a string associated to it
; otherwise returns #false
(check-expect (find-attr '() 'pizza) #false)
(check-expect (find-attr a0 'initial) "X")
(check-expect (find-attr a0 'pizza) #false)
(check-expect (find-attr '((dogs "good") (fish "neutral") (cats "bad")) 'fish) "neutral")
(define (find-attr loa attr)
  (local ((define attr-or-false (assq attr loa)))
    (if (cons? attr-or-false)
        (second (assq attr loa))
        #false)))

; An XWord is '(word ((text String))).
; examples:
'(word ((text "pizza")))
'(word ((text "pasta")))
'(word ((text "fishsticks")))

; Any -> Boolean
; is x an XWord
(check-expect (word? '(word ((text "pizza")))) #true)
(check-expect (word? 'dog) #false)
(check-expect (word? 1) #false)
(check-expect (word? '(word ((text "100")))) #true)
(check-expect (word? '(1)) #false)
(define (word? x)
  (and (cons? x)
       (symbol? (first x))
       (symbol=? 'word (first x))))

; XWord -> String
; extracts the string from xw
(check-expect (word-text '(word ((text "pizza")))) "pizza")
(define (word-text xw)
  (find-attr (xexpr-attr xw) 'text))
