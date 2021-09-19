;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname exercise377) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/image)

; An Xexpr is a list: 
; – (cons Symbol Body)
; – (cons Symbol (cons [List-of Attribute] Body))
; - XWord
; where Body is short for [List-of Xexpr]
; An Attribute is a list of two items:
;   (cons Symbol (cons String '()))
; An XWord is '(word ((text String))).

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

; Any -> Boolean
; is x an XWord
(check-expect (word? '(word ((text "pizza")))) #true)
(check-expect (word? 'dog) #false)
(check-expect (word? 1) #false)
(check-expect (word? '(word ((text "100")))) #true)
(check-expect (word? '(1)) #false)
(check-expect (word? '(word ((text 100)))) #false)
(define (word? x)
  (and (cons? x)
       (symbol? (first x))
       (symbol=? 'word (first x))
       (cons? (second x))
       (symbol? (first (first (second x))))
       (symbol=? 'text (first (first (second x))))
       (string? (second (first (second x))))))

; XWord -> String
; extracts the string from xw
(check-expect (word-text '(word ((text "pizza")))) "pizza")
(define (word-text xw)
  (find-attr (xexpr-attr xw) 'text))

; An XItem.v2 is one of: 
; – (cons 'li (cons XWord '()))
; – (cons 'li (cons [List-of Attribute] (list XWord)))
; – (cons 'li (cons XEnum.v2 '()))
; – (cons 'li (cons [List-of Attribute] (list XEnum.v2)))
; 
; An XEnum.v2 is one of:
; – (cons 'ul [List-of XItem.v2])
; – (cons 'ul (cons [List-of Attribute] [List-of XItem.v2]))

; example:
(define enum0
  '(ul
    (li (word ((text "one"))))
    (li (word ((text "two"))))))

(define SIZE 12) ; font size 
(define COLOR "black") ; font color 
(define BT ; a graphical constant 
  (beside (circle 1 'solid 'black) (text " " SIZE COLOR)))
 
; Image -> Image
; marks item with bullet
(check-expect (bulletize (text "one" SIZE 'black))
              (beside/align 'center BT (text "one" SIZE 'black)))
(define (bulletize item)
  (beside/align 'center BT item))
 
; XEnum.v2 -> Image
; renders an XEnum.v2 as an image
(check-expect (render-enum enum0)
              (above/align 'left (render-item '(li (word ((text "one")))))
                           (render-item '(li (word ((text "two")))))))
(define (render-enum xe)
  (local ((define content (xexpr-content xe))
          ; XItem.v2 Image -> Image 
          (define (deal-with-one item so-far)
            (above/align 'left (render-item item) so-far)))
    (foldr deal-with-one empty-image content)))
 
; XItem.v2 -> Image
; renders one XItem.v2 as an image
(check-expect (render-item '(li (word ((text "one")))))
              (bulletize (text "one" SIZE 'black)))
(check-expect (render-item
               '(li
                 (ul
                  (li (word ((text "one"))))
                  (li (word ((text "two")))))))
              (bulletize (above/align 'left (render-item '(li (word ((text "one")))))
                                      (render-item '(li (word ((text "two"))))))))
(define (render-item an-item)
  (local ((define content (first (xexpr-content an-item))))
    (bulletize
      (cond
        [(word? content)
         (text (word-text content) SIZE 'black)]
        [else (render-enum content)]))))

(define hello-enum
  '(ul
    (li (word ((text "hello"))))
    (li (ul
         (li (word ((text "goodbye"))))
         (li
          (ul
           (li (word ((text "hello"))))
           (li (word ((text "hello"))))))))))

; XItem.v2 -> Number
; counts occurrence of the string "hello" in xi
(define (count-hello-item xi)
  (local ((define content (first (xexpr-content xi))))
    (cond
      [(word? content) (if (string=? "hello" (word-text content)) 1 0)]
      [else (count-hello-enum content)])))

; XEnum.v2 -> Number
; counts all occurrences of the string "hello" in xe
(check-expect (count-hello-enum hello-enum) 3)
(define (count-hello-enum xe)
  (local ((define content (xexpr-content xe)))
    (foldr (lambda (item count)
             (+ (count-hello-item item) count))
             0 content)))
      
; XItem.v2 -> XItem.v2
; replaces occurrence of the string "hello" in xi with "bye"
(check-expect (replace-hello-item '(li (word ((text "hello")))))
              '(li (word ((text "bye")))))
(define (replace-hello-item xi)
  (local ((define content (first (xexpr-content xi))))
    (cond
      [(word? content) (if (string=? "hello" (word-text content))
                           '(li (word ((text "bye"))))
                           `(li ,content))]
      [else `(li ,(replace-hello-enum content))])))

; XEnum.v2 -> XEnum.v2
; replaces all occurrences of the string "hello" with "bye" in xe
(check-expect (replace-hello-enum hello-enum)
              '(ul
                (li (word ((text "bye"))))
                (li (ul
                     (li (word ((text "goodbye"))))
                     (li
                      (ul
                       (li (word ((text "bye"))))
                       (li (word ((text "bye"))))))))))
(define (replace-hello-enum xe)
  (local ((define content (xexpr-content xe)))
    `(ul
      ,@(foldr (lambda (item base)
               (cons (replace-hello-item item)
                     base))
               '() content))))
        
