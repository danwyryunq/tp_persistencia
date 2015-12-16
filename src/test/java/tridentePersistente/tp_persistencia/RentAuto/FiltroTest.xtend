package tridentePersistente.tp_persistencia.RentAuto

import org.junit.Assert
import org.junit.Test
import tridentePersistente.tp_persistencia.RentAuto.sistema.filtros.FiltroAnd
import tridentePersistente.tp_persistencia.RentAuto.sistema.filtros.FiltroFechaFin
import tridentePersistente.tp_persistencia.RentAuto.sistema.filtros.FiltroFechaInicio
import tridentePersistente.tp_persistencia.RentAuto.sistema.filtros.FiltroNot
import tridentePersistente.tp_persistencia.RentAuto.sistema.filtros.FiltroOr
import tridentePersistente.tp_persistencia.RentAuto.sistema.filtros.FiltroOrigen

class FiltroTest {
		
	@Test
	def testFiltros(){
		var FiltroAnd and = new FiltroAnd
		and.agregarTodos(#[(new FiltroOr).agregarTodos(#[new FiltroOrigen, new FiltroFechaInicio]), 
						   (new FiltroOr).agregarTodos(#[new FiltroFechaFin, new FiltroNot(new FiltroOrigen), new FiltroFechaInicio])
		])
		
		System.out.println(and.query)
		Assert.assertTrue(true)
	}
}