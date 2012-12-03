(define-syntax
 cond-expand
 (syntax-rules
  (and or not else compile-to-c mobile android)
  ((cond-expand) (syntax-error "Unfulfilled cond-expand"))
  ((cond-expand (else body ...)) (begin body ...))
  ((cond-expand ((and) body ...) more-clauses ...) (begin body ...))
  ((cond-expand ((and req1 req2 ...) body ...) more-clauses ...)
   (cond-expand
    (req1 (cond-expand ((and req2 ...) body ...) more-clauses ...))
    more-clauses
    ...))
  ((cond-expand ((or) body ...) more-clauses ...)
   (cond-expand more-clauses ...))
  ((cond-expand ((or req1 req2 ...) body ...) more-clauses ...)
   (cond-expand
    (req1 (begin body ...))
    (else (cond-expand ((or req2 ...) body ...) more-clauses ...))))
  ((cond-expand ((not req) body ...) more-clauses ...)
   (cond-expand (req (cond-expand more-clauses ...)) (else body ...)))
  ((cond-expand (compile-to-c body ...) more-clauses ...) (begin body ...))
  ((cond-expand (mobile body ...) more-clauses ...) (begin body ...))
  ((cond-expand (android body ...) more-clauses ...) (begin body ...))
  ((cond-expand (feature-id body ...) more-clauses ...)
   (cond-expand more-clauses ...))))
(include "/data/projects/simon-says/src/main.scm")
