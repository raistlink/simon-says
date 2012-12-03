(define (main)
  ((fusion:create-simple-gl-cairo '(width: 1280 height: 752))
   (let ((posx 80.0))
     (lambda (cr)
       ;;(SDL_LogInfo SDL_LOG_CATEGORY_APPLICATION (object->string (SDL_GL_Extension_Supported "GL_EXT_texture_format_BGRA8888")))
       (cairo_set_source_rgba cr 1.0 0.0 1.0 1.0)
       (cairo_rectangle cr 0.0 0.0 640.0 376.0)
       (cairo_fill cr)
       (cairo_set_source_rgba cr 1.0 1.0 1.0 1.0)
       (cairo_rectangle cr 0.0 0.0 500.0 500.0)
       (cairo_fill cr)
       (cairo_set_source_rgba cr 1.0 1.0 1.0 1.0)
       (cairo_rectangle cr 0.0 0.0 500.0 500.0)
       (cairo_fill cr)
       (cairo_set_source_rgba cr 1.0 1.0 1.0 1.0)
       (cairo_rectangle cr 0.0 0.0 500.0 500.0)
       (cairo_fill cr)
       (cairo_arc cr posx 80.0 150.0 0.0 6.28)
       (cairo_set_source_rgba cr 0.0 0.0 1.0 1.0)
       (cairo_fill cr)
       (cairo_select_font_face cr "Sans" CAIRO_FONT_SLANT_NORMAL CAIRO_FONT_WEIGHT_BOLD)
       (cairo_set_source_rgba cr 0.0 0.0 0.0 0.8)
       (cairo_set_font_size cr 16.0)
       (cairo_move_to cr 40.0 40.0)
       (cairo_show_text cr "Example App")
       (cairo_fill cr)
       (set! posx (+ 1.0 posx))))
   (lambda (event)
     (let ((type (SDL_Event-type event)))
       (cond
        ((= type SDL_KEYDOWN)
         (let* ((kevt (SDL_Event-key event))
                (key (SDL_Keysym-sym (SDL_KeyboardEvent-keysym kevt))))
           (cond ((= key SDLK_ESCAPE)
                  'exit)
                 (else
                  (SDL_LogInfo SDL_LOG_CATEGORY_APPLICATION (string-append "Key: " (number->string key)))))))
        ((= type SDL_MOUSEBUTTONDOWN)
         (SDL_LogInfo SDL_LOG_CATEGORY_APPLICATION "Mouse button down!"))
        ((= type SDL_FINGERDOWN)
         (SDL_LogInfo SDL_LOG_CATEGORY_APPLICATION "Finger down!"))
        ((= type SDL_WINDOWEVENT)
         'handle-window-events)
        ((= type SDL_QUIT)
         'exit))))))
