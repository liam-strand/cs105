(class Creature
    [subclass-of Object]
    [ivars alive]

    ;; public
    (class-method new () ((super new) init))
    
    (method alive? () alive)

    (method kill () 
        (set alive false) 
        self)

    (method canEat: (aCreature)
        (alive and: {(self aliveEats: aCreature)}))

    ;; private
    (method init () 
        (set alive true) 
        self)

    (method aliveEats: (aCreature)
        (self subclassResponsibility))

    (method eatenByChicken? () (self subclassResponsibility))
    (method eatenByFlyTrap? () (self subclassResponsibility))
    (method eatenByFly?     () (self subclassResponsibility))
)

(class Chicken
    [subclass-of Creature]
    
    ;; private
    (method aliveEats: (aCreature)
        (aCreature eatenByChicken?))

    (method eatenByChicken? () false)
    (method eatenByFlyTrap? () false)
    (method eatenByFly?     () (alive not)))

(class Fly
    [subclass-of Creature]

    ;; private
    (method aliveEats: (aCreature)
        (aCreature eatenByFly?))

    (method eatenByChicken? () alive)
    (method eatenByFlyTrap? () true)
    (method eatenByFly?     () false))

(class FlyTrap
    [subclass-of Creature]

    ;; private
    (method aliveEats: (aCreature)
        (aCreature eatenByFlyTrap?))

    (method eatenByChicken? () true)
    (method eatenByFlyTrap? () false)
    (method eatenByFly?     () false))


(val aChicken      (Chicken new))
(val aDeadChicken ((Chicken new)  kill)) 
(val aFly          (Fly new)) 
(val aDeadFly     ((Fly new)      kill)) 
(val aFlyTrap      (FlyTrap new))
(val aDeadFlyTrap ((FlyTrap new)  kill))

(check-assert ((aChicken canEat: aChicken)     not))
(check-assert ((aChicken canEat: aDeadChicken) not))
(check-assert  (aChicken canEat: aFly))
(check-assert ((aChicken canEat: aDeadFly)     not))
(check-assert  (aChicken canEat: aFlyTrap))
(check-assert  (aChicken canEat: aDeadFlyTrap))

(check-assert ((aFly canEat: aChicken)      not))
(check-assert  (aFly canEat: aDeadChicken))
(check-assert ((aFly canEat: aFlyTrap)      not))
(check-assert ((aFly canEat: aDeadFlyTrap)  not))
(check-assert ((aFly canEat: aFly)          not))
(check-assert ((aFly canEat: aDeadFly)      not))

(check-assert ((aFlyTrap canEat: aChicken)     not))
(check-assert ((aFlyTrap canEat: aDeadChicken) not))
(check-assert ((aFlyTrap canEat: aFlyTrap)     not))
(check-assert ((aFlyTrap canEat: aDeadFlyTrap) not))
(check-assert  (aFlyTrap canEat: aFly))
(check-assert  (aFlyTrap canEat: aDeadFly))

