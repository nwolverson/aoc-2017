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
(define (steps x y n c target)
  (if (< c target)
      (let ([res (step x y n (- target c))])
            (steps (car res) (cadr res) (caddr res) (+ c (caddr res)) target))

      (+ (abs x) (abs y))))

(define (ans1 target) (steps 0 0 0 1 target))