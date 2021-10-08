;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname exercise409) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(define-struct db [schema content])
; A DB is a structure: (make-db Schema Content)
 
; A Schema is a [List-of Spec]
; A Spec is a [List Label Predicate]
; A Label is a String
; A Predicate is a [Any -> Boolean]
 
; A (piece of) Content is a [List-of Row]
; A Row is a [List-of Cell]
; A Cell is Any
; constraint cells do not contain functions 
 
; integrity constraint In (make-db sch con), 
; for every row in con,
; (I1) its length is the same as sch's, and
; (I2) its ith Cell satisfies the ith Predicate in sch

(define school-schema
  `(("Name"    ,string?)
    ("Age"     ,integer?)
    ("Present" ,boolean?)))

(define school-content
  `(("Alice" 35 #true)
    ("Bob"   25 #false)
    ("Carol" 30 #true)
    ("Dave"  32 #false)))

(define school-db
  (make-db school-schema
           school-content))

(define presence-schema
  `(("Present"     ,boolean?)
    ("Description" ,string?)))

(define presence-content
  `((#true  "presence")
    (#false "absence")))

(define presence-db
  (make-db presence-schema
           presence-content))

(define bad-db
  (make-db presence-schema
           school-content))

; DB -> Boolean
; do all rows in db satisfy (I1) and (I2)
(check-expect (integrity-check school-db) #true)
(check-expect (integrity-check presence-db) #true)
(check-expect (integrity-check bad-db) #false)
(define (integrity-check db)
  (local ((define schema  (db-schema db))
          (define content (db-content db))
          (define width   (length schema))
          ; Row -> Boolean 
          ; does row satisfy (I1) and (I2) 
          (define (row-integrity-check row)
            (and (= (length row) width)
                 (andmap (lambda (s c) [(second s) c])
                         schema
                         row))))
    (andmap row-integrity-check content)))

(define projected-content
  `(("Alice" #true)
    ("Bob"   #false)
    ("Carol" #true)
    ("Dave"  #false)))
 
(define projected-schema
  `(("Name" ,string?) ("Present" ,boolean?)))
 
(define projected-db
  (make-db projected-schema projected-content))

; DB [List-of Label] -> DB
; retains a column from db if its label is in labels
(check-expect
  (db-content (project school-db '("Name" "Present")))
  projected-content)
(define (project db labels)
  (local ((define schema  (db-schema db))
          (define content (db-content db))
 
          ; Spec -> Boolean
          ; does this column belong to the new schema
          (define (keep? c)
            (member? (first c) labels))
 
          ; Row -> Row 
          ; retains those columns whose name is in labels
          (define (row-project row)
            (foldr (lambda (cell m c) (if m (cons cell c) c))
                   '()
                   row
                   mask))
          (define mask (map keep? schema)))
    (make-db (filter keep? schema)
             (map row-project content))))

; DB [List-of Label] Predicate -> [List-of Row]
; returns rows that satisfy p that are found in columns named in labels
(check-expect (select school-db '("Name" "Present") (lambda (row) (not (false? (third row)))))
              '(("Alice" #true) ("Carol" #true)))
(check-expect (select school-db '("Name" "Present") (lambda (row) (false? (third row))))
              '(("Bob" #false) ("Dave" #false)))
(check-expect (select school-db '("Name" "Age") (lambda (row) (> (second row) 30)))
              '(("Alice" 35) ("Dave" 32)))
(check-expect (select school-db '("Name" "Age") (lambda (row) (> (second row) 50)))
              '())
(define (select db labels p)
  (local ((define schema  (db-schema db))
          (define content (db-content db))
    
          ; Spec -> Boolean
          ; does this column belong to the projection of the labels
          (define (keep? c)
            (member? (first c) labels))

          (define mask (map keep? schema))
 
          ; Row -> Row 
          ; retains those columns whose name is in labels
          (define (row-project row)
            (foldr (lambda (cell m c) (if m (cons cell c) c))
                   '()
                   row
                   mask)))
    (map row-project (filter p content))))

; DB [List-of Label] -> DB
; produces a database like db with columns reordered according to lol
(check-expect (map first (db-schema (reorder school-db '("Present" "Age" "Name"))))
              '("Present" "Age" "Name"))
(check-expect (db-content (reorder school-db '("Present" "Age" "Name")))
              `((#true  35 "Alice")
                (#false 25 "Bob")
                (#true  30 "Carol")
                (#false 32 "Dave")))
(check-error (reorder school-db '("Present" "Age" "Name" "Dogs")) "Column not found")
(check-error (reorder school-db '("Present" "Age")) "Labels must match existing schema")
; solution adapted from:
; https://gitlab.com/cs-study/htdp/-/blob/main/04-Intertwined-Data/23-Simultaneous-Processing/Exercise-409.rkt
(define (reorder db lol)
  (local ((define schema (db-schema db))
          (define content (db-content db))

          ; with input `(("Name" ,string?) ("Age" ,integer?) ("Present" ,boolean?))
          ; and `("Present" "Age" "Name")
          ; produces `(2 1 0)
          (define indexes
            (local ((define (get-index schema label)
                      (cond
                        [(empty? schema) (error "Column not found")]
                        [else
                         (if (string=? (first (first schema)) label)
                             0
                             (add1 (get-index (rest schema) label)))])))
              (map (lambda (label) (get-index schema label)) lol)))
          
          ; input '("Alice" 35 #true) produces '(#true 35 "Alice")
          (define (reorder-row r)
            (map (lambda (i) (list-ref r i)) indexes)))

    (cond
      [(not (= (length schema) (length lol)))
       (error "Labels must match existing schema")]
      [else
       (make-db (map (lambda (i) (list-ref schema i)) indexes) ; reorders schema using computed indexes
                (map reorder-row content))])))

; bears repeating: the solution found at this link is worthy of study and is a good example of
; the design recipe at work
; https://gitlab.com/cs-study/htdp/-/blob/main/04-Intertwined-Data/23-Simultaneous-Processing/Exercise-409.rkt