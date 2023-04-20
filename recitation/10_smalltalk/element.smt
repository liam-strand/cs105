(class Element
    [subclass-of Object]
    [ivars tag attrs]
    (class-method new: (n) ((self new) init: n))

    (method init: (someN)
        (set tag someN)
        (set attrs (Dictionary new))
        self)
    
    (method print ()
        ('< print)
        (tag print)
        (attrs associationsDo: 
            [block (a)
                (space print)
                ((a key) print)
                ('= print)
                ('" print)
                ((a value) print)
                ('" print)
            ])
        ('/> print)
        ())

    (method attribute:put: (k v)
        (attrs at:put: k v)
        self)
)
