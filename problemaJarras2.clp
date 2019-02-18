(deftemplate estado
	(slot jarra6)
	(slot jarra8)
	(slot padre)
	(slot nivel)
	(slot nodo)
	(slot s-accion)
)

(deffacts BHInicial
	(estado (jarra6 0)(jarra8 0)(nivel 1)(s-accion "Inicio"))
)

(defrule meta-alcanzada
	?e <- (estado(jarra6 2)(jarra8 0))
	=>
	(printout t "META ALCANZADA" crlf)
	(assert(obtener-padre ?e))
	(assert (camino))
)
;------------------------------------------------------------------------
(defrule contruye-camino
	?e <- (estado (padre ?padre) (s-accion ?accion))
	?r <- (obtener-padre ?e)
	?c <- (camino $?caminoactual)
	=>
	(assert (camino ?accion ?caminoactual))
	(assert (obtener-padre ?padre))
	(retract ?c)
	(retract ?r)
)
;------------------------------------------------------------------------
(defrule terminado
	?rec <- (obtener-padre nil)
	?lista <- (camino $?caminocompleto)
	=>
	(printout t "Solucion:" ?caminocompleto crlf)
	(retract ?rec ?lista)
	(halt)
)
;------------------------------------------------------------------------
(defrule regla_inicial
	(initial-fact)
	=>
	(assert (nodo 1))
)
;------------------------------------------------------------------------
(defrule llenar-jarra6
	?e <- (estado(jarra6 ?litrosj6)(jarra8 ?litrosj8)(nivel ?level))
	?n <- (nodo ?node)
	(not(estado (jarra6 6)(jarra8 ?litrosj8)))
	(test(and(numberp ?litrosj6)(< ?litrosj6 6)))
	=>
	(assert (estado (jarra6 6)(jarra8 ?litrosj8)(nivel (+ ?node 1))(padre ?e)(s-accion "Llenar jarra 6 completamente")))
	(retract ?n)
	(assert (nodo (+ ?node 1)))
	(printout t "JARRA 6: llenada totalmente" crlf)
)
;------------------------------------------------------------------------
(defrule llenar-jarra8
	?e <- (estado(jarra6 ?litrosj6)(jarra8 ?litrosj8)(nivel ?level))
	?n <- (nodo ?node)
	(not(estado (jarra6 ?litrosj6)(jarra8 8)))
	(test(and(numberp ?litrosj8)(< ?litrosj8 8)))
	=>
	(assert (estado (jarra6 ?litrosj6)(jarra8 8)(nivel (+ ?node 1))(padre ?e)(s-accion "Llenar jarra 8 completamente")))
	(retract ?n)
	(assert (nodo (+ ?node 1)))
	(printout t "JARRA 8: llenada totalmente" crlf)
)
;------------------------------------------------------------------------
(defrule llenar-j6-con-parte-j8
	?e <- (estado (jarra6 ?litrosj6)(jarra8 ?litrosj8)(nivel ?level))
	?n <- (nodo ?node)
	(not (estado (jarra6 6) (jarra8 =(- ?litrosj8 (- 6 ?litrosj6)))))
	(test(and(< ?litrosj6 6)(> (+ ?litrosj8 ?litrosj6) 6)(> ?litrosj8 0)))
	=>
	(assert (estado (jarra6 6)(jarra8 =(- ?litrosj8 (- 6 ?litrosj6))) (nivel (+ ?node 1))(padre ?e)(s-accion "Llenar jarra 6 con parte de jarra 8")))
	(retract ?n)
	(assert (nodo (+ ?node 1)))
	(printout t "JARRA 6: llenada con parte de JARRA 8" crlf)
)
;------------------------------------------------------------------------
(defrule llenar-j8-con-parte-j6
	?e <- (estado (jarra6 ?litrosj6)(jarra8 ?litrosj8)(nivel ?level))
	?n <- (nodo ?node)
	(not (estado (jarra6 =(- ?litrosj6 (- 8 ?litrosj8))) (jarra8 8)))
	(test(and(> ?litrosj6 0)(> (+ ?litrosj8 ?litrosj6) 8)(< ?litrosj8 8)))
	=>
	(assert (estado (jarra6 =(- ?litrosj6 (- 8 ?litrosj8))) (jarra8 8) (nivel (+ ?node 1))(padre ?e)(s-accion "Llenar jarra 8 con parte de jarra 6")))
	(retract ?n)
	(assert (nodo (+ ?node 1)))
	(printout t "JARRA 8: llenada con parte de JARRA 6" crlf)
)
;------------------------------------------------------------------------
(defrule vaciar-jarra6
	?e <- (estado (jarra6 ?litrosj6)(jarra8 ?litrosj8)(nivel ?level))
	?n <- (nodo ?node)
	(not (estado (jarra6 0)(jarra8 ?litrosj8)))
	(test(> ?litrosj6 0))
	=>
	(assert (estado (jarra6 0)(jarra8 ?litrosj8)(nivel (+ ?node 1))(padre ?e)(s-accion "Jarra 6 vaciada totalmente")))
	(retract ?n)
	(assert (nodo (+ ?node 1)))
	(printout t "JARRA 6: vaciada" crlf)

)
;------------------------------------------------------------------------
(defrule vaciar-jarra8
	?e <- (estado (jarra6 ?litrosj6)(jarra8 ?litrosj8)(nivel ?level))
	?n <- (nodo ?node)
	(not (estado (jarra8 0)(jarra6 ?litrosj6)))
	(test(> ?litrosj8 0))
	=>
	(assert (estado (jarra6 ?litrosj6)(jarra8 0)(nivel (+ ?node 1))(padre ?e)(s-accion "Jarra 8 vaciada totalmente")))
	(retract ?n)
	(assert (nodo (+ ?node 1)))
	(printout t "JARRA 8: vaciada" crlf)
)
;------------------------------------------------------------------------
(defrule vaciar-j6-en-j8
	?e <- (estado (jarra6 ?litrosj6)(jarra8 ?litrosj8)(nivel ?level))
	?n <- (nodo ?node)
	(not (estado (jarra6 0)(jarra8 =(+ ?litrosj8 ?litrosj6))))
	(test(and(> ?litrosj6 0)(<= (+ ?litrosj8 ?litrosj6) 8)))
	=>
	(assert (estado (jarra6 0)(jarra8 =(+ ?litrosj8 ?litrosj6)) (nivel (+ ?node 1))(padre ?e)(s-accion "Vaciar jarra 6 en jarra 8")))
	(retract ?n)
	(assert (nodo (+ ?node 1)))
	(printout t "JARRA 6 vaciada en JARRA 8" crlf)
)
;------------------------------------------------------------------------
(defrule vaciar-j8-en-j6
	?e <- (estado (jarra6 ?litrosj6)(jarra8 ?litrosj8)(nivel ?level))
	?n <- (nodo ?node)
	(not (estado (jarra8 0)(jarra6 6)))
	(test(and(> ?litrosj8 0)(<= (+ ?litrosj8 ?litrosj6) 6)))
	=>
	(assert (estado (jarra6 =(+ ?litrosj8 ?litrosj6)) (jarra8 0) (nivel (+ ?node 1))(padre ?e)(s-accion "Vaciar jarra 8 en jarra 6")))
	(retract ?n)
	(assert (nodo (+ ?node 1)))
	(printout t "JARRA 8 vaciada en JARRA 6" crlf)
)
;------------------------------------------------------------------------