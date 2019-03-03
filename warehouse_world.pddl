(define (domain warehouse)
	(:requirements :typing)
	(:types robot pallette - bigobject
        	location shipment order saleitem)

  	(:predicates
    	(ships ?s - shipment ?o - order)
    	(orders ?o - order ?si - saleitem)
    	(unstarted ?s - shipment)
    	(started ?s - shipment)
    	(complete ?s - shipment)
    	(includes ?s - shipment ?si - saleitem)

    	(free ?r - robot)
    	(has ?r - robot ?p - pallette)

    	(packing-location ?l - location)
    	(packing-at ?s - shipment ?l - location)
    	(available ?l - location)
    	(connected ?l - location ?l - location)
    	(at ?bo - bigobject ?l - location)
    	(no-robot ?l - location)
    	(no-pallette ?l - location)

    	(contains ?p - pallette ?si - saleitem)
  )

   (:action startShipment
      :parameters (?s - shipment ?o - order ?l - location)
      :precondition (and (unstarted ?s) (not (complete ?s)) (ships ?s ?o) (available ?l) (packing-location ?l))
      :effect (and (started ?s) (packing-at ?s ?l) (not (unstarted ?s)) (not (available ?l)))
   )

	(:action robotMove
      :parameters (?la - location ?lb - location ?r - robot)
      :precondition (and(no-robot ?lb)(at ?r ?la)(connected ?la ?lb))
      :effect (and (not(no-robot ?lb))(no-robot ?la)(at ?r ?lb)(not(at ?r ?la)))
   )

   (:action robotMoveWithPallette
      :parameters (?la - location ?lb - location ?r - robot ?p - pallette)
      :precondition (and (at ?r ?la)(at ?p ?la)(no-robot ?lb)(no-pallette ?lb)(connected ?la ?lb))
      :effect (and (at ?r ?lb)(at ?p ?lb)(not(no-robot ?lb))(not(no-pallette ?lb))(not(at ?r ?la))(not(at ?p ?la)))
   )

    (:action moveItemFromPalletteToShipment
      :parameters (?l - location ?s - shipment ?sa - saleitem ?p - pallette ?o - order)
      :precondition (and (started ?s)(at ?p ?l)(packing-location ?l)(orders ?o ?sa)(ships ?s ?o)(packing-at ?s ?l)(not(complete ?s)))
      :effect (and (includes ?s ?sa)(not(contains ?p ?sa))(started ?s)(not(unstarted ?s)))
   )

   (:action completeShipment
      :parameters (?l - location ?s - shipment ?o - order)
      :precondition (and (ships ?s ?o)(packing-at ?s ?l)(started ?s))
      :effect (and (not(packing-at ?s ?l))(not (ships ?s ?o))(not(started ?s))(available ?l)(complete ?s))
   )

)
