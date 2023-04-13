(use /comp/105/build-prove-compare/examples/usmalltalk/shapes.smt)
(use element.smt)
(use svgcanvas.smt) 
(val c (Circle new))
(val s (Square new))
(s adjustPoint:to: 'West (c location: 'East))
(class Triangle
   [subclass-of Shape] 
   ;; no additional representation
   (method drawOn: (canvas)
      (canvas drawPolygon: (self locations: '(North Southwest Southeast))))
)
(val t ((Triangle new) adjustPoint:to: 'Southwest (s location: 'East)))
(val pic (Picture empty))
(pic add: c)
(pic add: s)
(pic add: t)
(val canvas (SVGCanvas new))
'-------------------
(begin (pic renderUsing: canvas)
 '-------------------)
