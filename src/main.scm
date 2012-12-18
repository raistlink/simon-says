(define points 0)
(define highscore 0)
(define playerinput '())
(define playerinput2 '())
(define computeraux2 '())

(define (my-log text)
  (SDL_LogInfo SDL_LOG_CATEGORY_APPLICATION text))

(define (fill-random nlist)
  (let loop ((rest nlist))
    (if (null? rest)
        (cons (random-integer 4) '())
        (cons (car rest)
              (loop (cdr rest))))))

(define game-state 'start-screen)
(define magic-state 'nothing)
(define (main)
  ((fusion:create-simple-gl-cairo '(width: 1280 height: 752))
   (let ((posx 80.0) 
         (count 35)
         (computer '())
         (computeraux '())
         (statecounter 0)
         (round 1)
         (flabbergasting #f))
     (lambda (cr)
       ;;(SDL_LogInfo SDL_LOG_CATEGORY_APPLICATION (object->string (SDL_GL_Extension_Supported "GL_EXT_texture_format_BGRA8888")))
       (let ((test-func (lambda () (my-log "test func!!!!!")))
             (paint-rectangles
              (lambda (rectangle value)
                (if (eq? rectangle topleft)
                    (cairo_set_source_rgba cr 1.0 0.0 0.0 1.0)
                    (cairo_set_source_rgba cr 0.5 0.0 0.0 1.0)))))
         (case game-state
           ((start-screen)
            (if (> points highscore)
                (set! highscore points))
            (cairo_select_font_face cr "Purisa" CAIRO_FONT_SLANT_NORMAL CAIRO_FONT_WEIGHT_BOLD)
            (cairo_set_source_rgba cr 0.0 0.0 1.0 0.01)
            (cairo_set_font_size cr 200.0)
            (cairo_move_to cr 80.0 250.0)
            (cairo_show_text cr "EUFRASIO")
            (cairo_select_font_face cr "Purisa" CAIRO_FONT_SLANT_NORMAL CAIRO_FONT_WEIGHT_BOLD)
            (cairo_set_source_rgba cr 0.0 1.0 1.0 0.01)
            (cairo_set_font_size cr 200.0)
            (cairo_move_to cr 350.0 650.0)
            (cairo_show_text cr "DICE")
            (cairo_select_font_face cr "Purisa" CAIRO_FONT_SLANT_NORMAL CAIRO_FONT_WEIGHT_BOLD)
            (cairo_set_source_rgba cr 0.0 0.0 0.0 0.01)
            (cairo_set_font_size cr 40.0)
            (cairo_move_to cr 500.0 400.0)
            (cairo_show_text cr "RELOADED")
            (cairo_set_source_rgba cr 1.0 0.0 1.0 0.007)
            (cairo_rectangle cr 0.0 0.0 1280.0 752.0)
            (cairo_fill cr)
            (cairo_select_font_face cr "Purisa" CAIRO_FONT_SLANT_NORMAL CAIRO_FONT_WEIGHT_BOLD)
            (cairo_set_source_rgba cr 0.0 0.0 0.0 0.01)
            (cairo_set_font_size cr 30.0)
            (cairo_move_to cr 50.0 650.0)
            (cairo_show_text cr "Highscore:")
            (cairo_select_font_face cr "Purisa" CAIRO_FONT_SLANT_NORMAL CAIRO_FONT_WEIGHT_BOLD)
            (cairo_set_source_rgba cr 0.0 0.0 0.0 0.01)
            (cairo_set_font_size cr 30.0)
            (cairo_move_to cr 230.0 650.0)
            (cairo_show_text cr (number->string highscore))
            (cairo_select_font_face cr "Purisa" CAIRO_FONT_SLANT_NORMAL CAIRO_FONT_WEIGHT_BOLD)
            (cairo_set_source_rgba cr 0.0 0.0 0.0 0.01)
            (cairo_set_font_size cr 30.0)
            (cairo_move_to cr 50.0 600.0)
            (cairo_show_text cr "Score:")
            (cairo_select_font_face cr "Purisa" CAIRO_FONT_SLANT_NORMAL CAIRO_FONT_WEIGHT_BOLD)
            (cairo_set_source_rgba cr 0.0 0.0 0.0 0.01)
            (cairo_set_font_size cr 30.0)
            (cairo_move_to cr 160.0 600.0)
            (cairo_show_text cr (number->string points)))
           (else
            (when (eq? game-state 'computer-phase) 
                  (when (eq? count 25)
                        (set! flabbergasting #f)
                        (set! magic-state 'nothing))
                  (if (eq? count 35)
                      (begin (set! computer (fill-random computer))
                             (set! count 0)
                             (if (= (car computer) 0)
                                 (set! magic-state 'topleft))
                             (if (= (car computer) 1)
                                 (set! magic-state 'topright))
                             (if (= (car computer) 2)
                                 (set! magic-state 'bottomleft))
                             (if (= (car computer) 3)
                                 (set! magic-state 'bottomright))
                             (set! computeraux (append computeraux (cons (car computer) '())))
                             (set! computer (cdr computer))
                             (set! statecounter (+ statecounter 1))))
                  (set! count (+ count 1)))
            (when (> statecounter round)
                  (set! game-state 'player-phase)
                  (set! computeraux2 computeraux)
                  (set! statecounter 0)
                  (set! magic-state 'nothing)
                  (set! count 35))
            (when (= (length playerinput) round)
                  (if (every = playerinput computeraux)
                      (begin (set! flabbergasting #t)
                             (set! points (+ points (* 10 round)))
                             (set! playerinput '())
                             (set! computer computeraux)
                             (set! computeraux '())
                             (set! game-state 'computer-phase)
                             (set! round (+ round 1)))
                      (set! game-state 'failure)))
           
            (if (eq? magic-state 'topleft)  
                (cairo_set_source_rgba cr 1.0 0.0 0.0 1.0)
                (cairo_set_source_rgba cr 0.5 0.0 0.0 1.0))
            (cairo_rectangle cr 0.0 0.0 640.0 376.0)
            (cairo_fill cr)
            (if (eq? magic-state 'topright)
                (cairo_set_source_rgba cr 0.0 1.0 0.0 1.0)
                (cairo_set_source_rgba cr 0.0 0.5 0.0 1.0))
            (cairo_rectangle cr 640.0 0.0 1280.0 376.0)
            (cairo_fill cr)
            (if (eq? magic-state 'bottomleft)
                (cairo_set_source_rgba cr 0.0 0.0 1.0 1.0)
                (cairo_set_source_rgba cr 0.0 0.0 0.5 1.0))
            (cairo_rectangle cr 0.0 376.0 640.0 752.0)
            (cairo_fill cr)
            (if (eq? magic-state 'bottomright)
                (cairo_set_source_rgba cr 1.0 1.0 0.0 1.0)
                (cairo_set_source_rgba cr 0.5 0.5 0.0 1.0))
            (cairo_rectangle cr 640.0 376.0 1280.0 752.0)
            (cairo_fill cr)
            (cairo_select_font_face cr "Purisa" CAIRO_FONT_SLANT_NORMAL CAIRO_FONT_WEIGHT_BOLD)
            (cairo_set_source_rgba cr 0.0 0.0 0.0 0.8)
            (cairo_set_font_size cr 16.0)
            (cairo_move_to cr 1115.0 40.0)
            (cairo_show_text cr "POINTS: ")
            (cairo_fill cr)
            (cairo_select_font_face cr "Purisa" CAIRO_FONT_SLANT_NORMAL CAIRO_FONT_WEIGHT_BOLD)
            (cairo_set_source_rgba cr 0.0 0.0 0.0 0.8)
            (cairo_set_font_size cr 16.0)
            (cairo_move_to cr 1200.0 40.0)
            (cairo_show_text cr (number->string points))
            (cairo_fill cr)
            (cairo_select_font_face cr "Purisa" CAIRO_FONT_SLANT_NORMAL CAIRO_FONT_WEIGHT_BOLD)
            (cairo_set_source_rgba cr 0.0 0.0 0.0 0.8)
            (cairo_set_font_size cr 16.0)
            (cairo_move_to cr 1115.0 60.0)
            (cairo_show_text cr "Ronda")
            (cairo_fill cr)
            (cairo_select_font_face cr "Purisa" CAIRO_FONT_SLANT_NORMAL CAIRO_FONT_WEIGHT_BOLD)
            (cairo_set_source_rgba cr 0.0 0.0 0.0 0.8)
            (cairo_set_font_size cr 16.0)
            (cairo_move_to cr 1200.0 60.0)
            (cairo_show_text cr (number->string round))
            (cairo_fill cr)
            (when (eq? flabbergasting #t)
                  (cairo_select_font_face cr "Purisa" CAIRO_FONT_SLANT_NORMAL CAIRO_FONT_WEIGHT_BOLD)
                  (cairo_set_source_rgba cr 1.0 0.0 1.0 0.8)
                  (cairo_set_font_size cr 80.0)
                  (cairo_move_to cr 400.0 410.0)
                  (cairo_show_text cr "Maravilloso")
                  (cairo_fill cr))
            (if (eq? game-state 'failure)
                (begin 
                  (cairo_set_source_rgba cr 1.0 0.0 0.0 1.0)
                  (cairo_rectangle cr 0.0 0.0 1280.0 752.0)
                  (cairo_fill cr)
                  (set! round 1)
                  (set! computer '())
                  (set! computeraux '())
                  (set! playerinput '())
                  (set! game-state 'start-screen))
                'draw)))
         'draw)))

   (lambda (event)
     (let ((type (SDL_Event-type event)))
       (cond
        ((= type SDL_MOUSEBUTTONDOWN)
         (let* ((button (SDL_Event-button event))
                (x (SDL_MouseButtonEvent-x button))
                (y (SDL_MouseButtonEvent-y button)))
           (SDL_LogInfo SDL_LOG_CATEGORY_APPLICATION (number->string x))
           (if (eq? game-state 'player-phase)
               (cond ((< x 640)
                      (if (< y 376)
                          (set! magic-state 'topleft)
                          (set! magic-state 'bottomleft)))
                     ((> x 640)
                      (if (< y 376)
                          (set! magic-state 'topright)
                          (set! magic-state 'bottomright)))))))
        ((= type SDL_MOUSEBUTTONUP)
         (let ((button (SDL_Event-button event)))
           (if (eq? game-state 'player-phase)
               (case magic-state
                 ((topleft)
                  (set! magic-state 'nothing)
                  (set! playerinput (append playerinput '(0))) 
                  (set! playerinput2 0)
                  (if (eq? (car computeraux2) playerinput2)
                      (set! computeraux2 (cdr computeraux2))
                      (set! game-state 'failure)))
                 ((topright)
                  (set! magic-state 'nothing)
                  (set! magic-state 'nothing)
                  (set! playerinput (append playerinput '(1)))
                  (set! playerinput2 1)
                  (if (eq? (car computeraux2) playerinput2)
                      (set! computeraux2 (cdr computeraux2))
                      (set! game-state 'failure)))
                 ((bottomleft)
                  (set! magic-state 'nothing)
                  (set! playerinput (append playerinput '(2)))
                  (set! playerinput2 2)
                  (if (eq? (car computeraux2) playerinput2)
                      (set! computeraux2 (cdr computeraux2))
                      (set! game-state 'failure)))
                 ((bottomright)
                  (set! magic-state 'nothing)
                  (set! playerinput (append playerinput '(3)))
                  (set! playerinput2 3)
                  (if (eq? (car computeraux2) playerinput2)
                      (set! computeraux2 (cdr computeraux2))
                      (set! game-state 'failure)))))
           (if (eq? game-state 'start-screen)
               (set! game-state 'computer-phase)
               (set! score 0))))
        ((= type SDL_KEYDOWN)
         (let* ((kevt (SDL_Event-key event))
                (key (SDL_Keysym-sym (SDL_KeyboardEvent-keysym kevt))))
           (if (eq? game-state 'player-phase)
               (cond ((= key SDLK_q)
                      (set! magic-state 'topleft))
                     ((= key SDLK_w)
                      (set! magic-state 'topright))
                     ((= key SDLK_a)
                      (set! magic-state 'bottomleft))
                     ((= key SDLK_s)
                      (set! magic-state 'bottomright))
                     (else
                      (SDL_LogInfo SDL_LOG_CATEGORY_APPLICATION (string-append "Key: " (number->string key))))))
           (if (= key SDLK_ESCAPE)
               'exit)))
        ((= type SDL_KEYUP)
         (let* ((kevt (SDL_Event-key event))
                (key (SDL_Keysym-sym (SDL_KeyboardEvent-keysym kevt))))
           (if (eq? game-state 'player-phase)
               (cond ((= key SDLK_q)
                      (set! magic-state 'nothing)
                      (set! playerinput (append playerinput '(0))) 
                      (set! playerinput2 0)
                      (if (eq? (car computeraux2) playerinput2)
                          (set! computeraux2 (cdr computeraux2))
                          (set! game-state 'failure))
                      (pp playerinput))
                     ((= key SDLK_w)
                      (set! magic-state 'nothing)
                      (set! playerinput (append playerinput '(1)))
                      (set! playerinput2 1)
                      (if (eq? (car computeraux2) playerinput2)
                          (set! computeraux2 (cdr computeraux2))
                          (set! game-state 'failure))
                      (pp playerinput))
                     ((= key SDLK_a)
                      (set! magic-state 'nothing)
                      (set! playerinput (append playerinput '(2)))
                      (set! playerinput2 2)
                      (if (eq? (car computeraux2) playerinput2)
                          (set! computeraux2 (cdr computeraux2))
                          (set! game-state 'failure))
                      (pp playerinput))
                     ((= key SDLK_s)
                      (set! magic-state 'nothing)
                      (set! playerinput (append playerinput '(3)))
                      (set! playerinput2 3)
                      (if (eq? (car computeraux2) playerinput2)
                          (set! computeraux2 (cdr computeraux2))
                          (set! game-state 'failure))
                      (pp playerinput))))
           (if (= key SDLK_SPACE)
            (begin (set! game-state 'computer-phase)
                   (set! points 0)))))
        ((= type SDL_FINGERDOWN)
         (SDL_LogInfo SDL_LOG_CATEGORY_APPLICATION "Finger down!"))
        ((= type SDL_WINDOWEVENT)
         'handle-window-events)
        ((= type SDL_QUIT)
         'exit))))))
