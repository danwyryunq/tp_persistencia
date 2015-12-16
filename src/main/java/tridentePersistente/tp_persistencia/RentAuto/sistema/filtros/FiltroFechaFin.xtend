package tridentePersistente.tp_persistencia.RentAuto.sistema.filtros

import tridentePersistente.tp_persistencia.RentAuto.sistema.filtros.FiltroSimple

class FiltroFechaFin extends FiltroSimple {
	
	override query() {
		"fin = :fin"
	}
	
}