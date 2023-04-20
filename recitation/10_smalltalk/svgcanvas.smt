; Overwrite printing behavior for arrays of coordinates
; (but actually for all arrays, so dangerous! Is there a better way?)
(SequenceableCollection addSelector:withMethod: 'print
  (compiled-method ()
    (self do: [block (elem)
                (elem print)
                (space print)])))

(CoordPair addSelector:withMethod: 'print
  (compiled-method ()
    ((self x) print)
    (', print)
    ((self y) print)))

(class SVGCanvas
  [subclass-of Object]
  (method startDrawing ()
    ('(<svg viewBox="-5 -5 11 10"
       width="300px" height="300px"
       transform="scale(1 -1)">) print)
       (newline print))

  (method stopDrawing ()
    ('</svg> println))

  (method drawPolygon: (coord-list)  (self leftAsExercise))
  (method drawEllipseAt:width:height: (center w h))

)
