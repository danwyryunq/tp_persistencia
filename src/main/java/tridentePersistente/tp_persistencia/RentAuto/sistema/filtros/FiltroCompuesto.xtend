package tridentePersistente.tp_persistencia.RentAuto.sistema.filtros

import java.util.ArrayList
import java.util.List

abstract class FiltroCompuesto extends Filtro {	
	
	protected var List<Filtro> filtros = new ArrayList<Filtro>
	protected var String conector
	
	override query(){
		var List<String> queries = filtros.map[query]
		queries.join(" "+conector+" ")
	}
	
	def Filtro agregar(Filtro unFiltro){
		filtros.add(unFiltro)
		this
	}
	
	def Filtro remove(Filtro unFiltro){
		filtros.remove(unFiltro)
		this
	}
	
	def Filtro agregarTodos(List<? extends Filtro> muchosFiltros){
		filtros.addAll(muchosFiltros)
		this
	}
}