package tridentePersistente.tp_persistencia.RentAuto.sistema.filtros

import tridentePersistente.tp_persistencia.RentAuto.sistema.filtros.Filtro

class FiltroNot extends Filtro {
	
	var Filtro filtro
	
	new(Filtro unFiltro){
		filtro = unFiltro
	}
	
	override query() {
		"not " + filtro.query
	}
	
}