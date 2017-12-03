#lang racket
(define (step x y n-full lim)
  (let ([n (min n-full lim)]
        [n1 (min (+ n-full 1) lim)])
    (cond 
      [(and (> x 0) (> y 0))
       (list (- x n1) y n1)]
      [(> x 0)
       (list x (+ y n) n)
       ]
      [(and (<= x 0) (<= y 0))
       (list (+ x n1) x n1)]
      [else
       (list x (- y n) n)
       ])))
(define (pos x y n c target)
  (if (< c target)
      (let ([res (step x y n (- target c))])
        (pos (car res) (cadr res) (caddr res) (+ c (caddr res)) target))
      (cons x y)))
(define (pos1 target) (pos 0 0 0 1 target))

(define (ans1 target)
  (let ([res (pos 0 0 0 1 target)])
    (+ (abs (car res)) (abs (cdr res)))))

(define (add-pairs p1 p2)
  (cons (+ (car p1) (car p2))
        (+ (cdr p1) (cdr p2))))
(define (square-value grid pos)
  (let ([adj '((1 . 0) (1 . 1) (0 . 1) (-1 . 1) (-1 . 0) (-1 . -1) (0 . -1) (1 . -1))])
    (foldl + 0 (map (lambda (p)
                      (hash-ref grid (add-pairs pos p) 0))
                    adj))))

(define (ans2-step grid n target)
  (let ([val (square-value grid (pos1 n))])
    (if (> val target)
        val
        (begin
          (hash-set! grid (pos1 n) val)
          (ans2-step grid (+ n 1) target)))))

(define (ans2 target)
  (let ([grid (make-hash '((( 0 . 0 ) . 1)))])
    (ans2-step grid 2 target)))