#lang racket

; Step to a corner (or as near as we can get) given the last step size, giving the new coordinates and updated step size
(define (step x y n-full lim)
  (let ([n (min n-full lim)]
        [n1 (min (+ n-full 1) lim)])
    (cond 
      [(and (> x 0) (> y 0))
       (list (- x n1) y n1)]
      [(> x 0)
       (list x (+ y n) n)]
      [(<= y 0)
       (list (+ x n1) x n1)]
      [else
       (list x (- y n) n)])))

; What is the grid position of the target-th number (starting at 1)
(define (pos target)
  (define (pos1 x y n c)
    (if (< c target)
        (match (step x y n (- target c))
          [(list x1 y1 n1) (pos1 x1 y1 n1 (+ c n1))])
        (cons x y)))
  (pos1 0 0 0 1))

; Answer 1: Manhattan distance of the target-th number
(define (answer-1 target)
  (match (pos target)
    [(cons x y) (+ (abs x) (abs y))]))

; Pointwise addition
(define (add-pairs p1 p2)
  (match* (p1 p2)
    [((cons x1 y1) (cons x2 y2))
     (cons (+ x1 x2) (+ y1 y2))]))

; Value of a square is the sum of the pre-existing adjacent squares
(define (square-value grid pos)
  (let ([adj '((1 . 0) (1 . 1) (0 . 1) (-1 . 1) (-1 . 0) (-1 . -1) (0 . -1) (1 . -1))])
    (foldl + 0 (map (lambda (p)
                      (hash-ref grid (add-pairs pos p) 0))
                    adj))))

; Answer 2: Walk as per answer 1 accumulating square values on a grid
(define (answer-2 target)
  (define (ans2-step grid n target)
    (let ([val (square-value grid (pos n))])
      (if (> val target)
          val
          (ans2-step (hash-set grid (pos n) val) (+ n 1) target))))
  (ans2-step (make-immutable-hash '((( 0 . 0 ) . 1)))
             2 target))