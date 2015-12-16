package tridentePersistente.tp_persistencia.RentAuto.sistema.filtros

import tridentePersistente.tp_persistencia.RentAuto.sistema.filtros.FiltroSimple

class FiltroFechaInicio extends FiltroSimple {
	
	override query() {
		"inicio = :inicio"
	}
	
}