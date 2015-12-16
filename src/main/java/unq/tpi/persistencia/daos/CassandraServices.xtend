package unq.tpi.persistencia.daos

import java.text.SimpleDateFormat
import java.util.Date
import java.util.List
import org.eclipse.xtext.xbase.lib.Functions.Function0
import tridentePersistente.tp_persistencia.RentAuto.sistema.Auto
import tridentePersistente.tp_persistencia.RentAuto.sistema.Categoria
import tridentePersistente.tp_persistencia.RentAuto.sistema.Ubicacion
import tridentePersistente.tp_persistencia.RentAuto.sistema.Usuario
import unq.tpi.persistencia.servicios.ListAutoCacheable

class CassandraServices {
	CassandraManager cassandra = new CassandraManager ; 

	new () { }
	
	def String dateForKey(Date fecha) 
	{ 
		val SimpleDateFormat format = new SimpleDateFormat("yyyyMMdd")
		format.format(fecha)
	}

	def String uuidAutosPosiblesEn(Ubicacion origen,Ubicacion destino,Date inicio,Date fin,Categoria categoria) {
		 '''«origen.id»_«destino.id»_«dateForKey(inicio)»_«dateForKey(fin)»_«categoria.id»'''
		
	}

	def List<Auto> autosPosiblesEn(Ubicacion origen,Ubicacion destino,Date inicio,Date fin,Categoria categoria, ()=>List<Auto> bloque) {		
		var uuid = uuidAutosPosiblesEn(origen,destino,inicio,fin,categoria)

		var ListAutoCacheable c = new ListAutoCacheable()
		c.tableName = 'cache.autosPosiblesEn'
		c.pk = 'id'
		c.id = uuid
		c.fetchFromOrigin = bloque

		cassandra.<List<Auto>>runInCache(c)
	}
	
	
	def hacerReserva(Integer numeroSolicitud,Ubicacion origen,Ubicacion destino,Date inicio,Date fin,Auto auto,Usuario usuario, Function0 bloque) {
		var uuid = uuidAutosPosiblesEn(origen,destino,inicio,fin,auto.categoria)
		
		var ListAutoCacheable c = new ListAutoCacheable()
		c.tableName = 'cache.autosPosiblesEn'
		c.pk = 'id'
		c.id = uuid

		bloque.apply 
		cassandra.delete(c)
		
	}

	def altaAuto(Auto auto, Function0 bloque) {
		cassandra.delete('cache.autosPosiblesEn')
		bloque.apply 
		null
	}


}