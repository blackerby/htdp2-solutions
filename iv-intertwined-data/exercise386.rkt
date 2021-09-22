;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname exercise386) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/batch-io)
(require 2htdp/universe)
(require 2htdp/image)

(read-plain-xexpr/web
    (string-append
       "Https://Felleisen.org/"
       "matthias/"
       "HtDP2e/Files/machine-configuration.xml"))

(define PREFIX "https://www.marketwatch.com/investing/stock/")
(define SIZE 22) ; font size 
 
(define-struct data [price delta])
; A StockWorld is a structure: (make-data String String)
; interpretation: a stock price and its change in price
 
; String -> StockWorld
; retrieves the stock price of co and its change every 15s
(define (stock-alert co)
  (local ((define url (string-append PREFIX co))
          ; [StockWorld -> StockWorld]
          ; takes an unused StockWorld __w and returns a new Stockworld
          ; with data from url
          (define (retrieve-stock-data __w)
            (local ((define x (read-xexpr/web url)))
              (make-data (get x "price")
                         (get x "priceChange"))))
          ; StockWorld -> Image
          ; renders stock data as an image
          (define (render-stock-data w)
            (local (; [StockWorld String -> String] -> Image
                    ; calls selector sel on StockWorld w and returns text image of given color
                    (define (word sel col)
                      (text (sel w) SIZE col)))
              (overlay (beside (word data-price 'black)
                               (text "  " SIZE 'white)
                               (word data-delta 'red))
                       (rectangle 300 35 'solid 'white)))))
    (big-bang (retrieve-stock-data 'no-use)
      [on-tick retrieve-stock-data 15]
      [to-draw render-stock-data])))

; Xexpr.v3 String -> String
; retrieves the value of the "content" attribute 
; from a 'meta element that has attribute "name"
; with value s
(check-expect
 (get '(meta ((content "+1") (name "F"))) "F")
 "+1")
(check-error
 (get '(meta ((content "+1") (itemprop "F"))) "F")
 "not found")
(check-error
 (get '(meta ((content "+1") (name "G"))) "F")
 "not found")
(check-error
 (get '(action ((content "+1") (name "F"))) "F")
 "not found")
(define (get x s)
  (local ((define result (get-xexpr x s)))
    (if (string? result)
        result
        (error "not found"))))

; Xexpr.v3 String -> [Maybe String]
; retrieves the value of the "content" attribute 
; from a 'meta element that has attribute "name"
; with value s
(check-expect
 (get-xexpr '(meta ((content "+1") (name "F"))) "F")
 "+1")
(check-expect
 (get-xexpr '(meta ((content "+1") (itemprop "F"))) "F")
#false)
(check-expect
 (get-xexpr '(meta ((content "+1") (name "G"))) "F")
 #false)
(check-expect
 (get-xexpr '(action ((content "+1") (name "F"))) "F")
 #false)
(check-expect
 (get-xexpr mw "price")
 "$12.75")
(check-expect
 (get-xexpr mw "priceChange")
 "-0.07")
(check-expect
 (get-xexpr mw "bingBong")
 #false)
(define (get-xexpr x s)
  (cond
    [(and (cons? x) (not (empty? x)))
     (local ((define name (xexpr-name x))
             (define attrs (xexpr-attr x))
             (define content (xexpr-content x))
             (define (get-xexpr* lox s)
               (cond
                 [(empty? lox) #false]
                 [(string? (get-xexpr (first lox) s)) (get-xexpr (first lox) s)]
                 [else (get-xexpr* (rest lox) s)])))
       (if (and (symbol=? 'meta name)
                (equal? s (find-attr attrs 'name)))
           (find-attr attrs 'content)
           (get-xexpr* content s)))]
    [else #false]))

; An Xexpr.v3 is one of:
;  – Symbol
;  – String
;  – Number
;  – (cons Symbol (cons Attribute*.v3 [List-of Xexpr.v3]))
;  – (cons Symbol [List-of Xexpr.v3])
; 
; An Attribute*.v3 is a [List-of Attribute.v3].
;   
; An Attribute.v3 is a list of two items:
;   (list Symbol String)

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

(define mw (read-xexpr "./fordmarketwatch.html"))

; guidance sought here:
; https://gitlab.com/cs-study/htdp/-/blob/main/04-Intertwined-Data/22-Project-The-Commerce-of-XML/Exercise-386.rkt