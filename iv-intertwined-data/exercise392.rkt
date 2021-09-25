;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname exercise392) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(define-struct branch [left right])
 
; A TOS is one of:
; – Symbol
; – (make-branch TOS TOS)
; interpretation: a tree of symbols
; examples
(define tree0 'a)
(define tree1 (make-branch 'a 'b))
(define tree2 (make-branch
               (make-branch 'a 'b)
               (make-branch 'c 'd)))
(define tree3 (make-branch
               (make-branch
                (make-branch 'a 'b)
                (make-branch 'c 'd))
               (make-branch
                (make-branch 'e 'f)
                (make-branch 'g 'h))))
 
; A Direction is one of:
; – 'left
; – 'right
 
; A list of Directions is also called a path. 
; examples
(define path0 '())
(define path1 (list 'left))
(define path2 (list 'left 'right))
(define path3 (list 'left 'right 'left))


; TOS [List-of Direction] -> TOS
; produces the tree that results from following path
; produces error when given a symbol and a non-empty path
(check-expect (tree-pick tree0 path0) 'a)
(check-expect (tree-pick tree3 path0) tree3)
(check-error (tree-pick tree0 path1) "path exceeds tree depth")
(check-expect (tree-pick tree1 path1) 'a)
(check-expect (tree-pick tree2 path2) 'b)
(check-expect (tree-pick tree3 path3) 'c)
(check-expect (tree-pick tree3 path2) (make-branch 'c 'd))
(check-error (tree-pick tree1 path3) "path exceeds tree depth")
(define (tree-pick tree path)
  (cond
    [(empty? path) tree]
    [(symbol? tree) (error "path exceeds tree depth")]
    [else
     (tree-pick
      (if (symbol=? 'left (first path))
          (branch-left tree)
          (branch-right tree))
      (rest path))]))