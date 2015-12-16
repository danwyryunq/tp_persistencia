package MongoTest

import org.junit.Assert
import org.junit.Test
import org.mongojack.DBQuery
import tridentePersistente.tp_persistencia.RentAuto.sistema.Calificacion
import tridentePersistente.tp_persistencia.RentAuto.sistema.TipoCalificacion
import tridentePersistente.tp_persistencia.RentAuto.sistema.Visibilidad

class ServiciosConMongoTest extends AbstractMongoTest {
	
	@Test
	def testInsertarCalificacion() 
	{
		
		calificacionOriginal = new Calificacion(usuario, auto, TipoCalificacion.MALO, 
						"El auto es una porquería, y no digo otra cosa porque hay niños presentes", 
						Visibilidad.PUBLICO		)
		
		val query = DBQuery.is("auto", "AAB123")
		val calificaciones = homeCalificaciones.getMongoCollection().find(query)
		// val calificaciones = homeCalificaciones.getMongoCollection().find
		val calificacionEnBase = calificaciones.next

		Assert.assertEquals(calificacionEnBase.usuario, calificacionOriginal.usuario)
		Assert.assertEquals(calificacionEnBase.auto, calificacionOriginal.auto)
		Assert.assertEquals(calificacionEnBase.visibilidad, calificacionOriginal.visibilidad)
		Assert.assertEquals(calificacionEnBase.calificacion, calificacionOriginal.calificacion)
		Assert.assertEquals(calificacionEnBase.comentario, calificacionOriginal.comentario)		
	}	
	
	@Test
	def testVerCalificaciones()
	{	
		val comentariosVisibles = servicios.usuarioPidePerfilDe(usuario2, usuario)
		println(comentariosVisibles.size.toString)
		val comentariosNoVisibles = servicios.usuarioPidePerfilDe(usuario3, usuario)
		println(comentariosNoVisibles.size.toString)
 
		Assert.assertEquals(comentariosVisibles.size, 2)
		Assert.assertEquals(comentariosNoVisibles.size, 1)
	}
	
	
}