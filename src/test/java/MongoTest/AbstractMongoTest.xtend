package MongoTest

import Mongo.Collection
import Mongo.SistemDB
import amigos.AmigosService
import java.util.Date
import org.junit.After
import org.junit.Assert
import org.junit.Before
import org.junit.Test
import org.mongojack.DBQuery
import tridentePersistente.tp_persistencia.RentAuto.sistema.Auto
import tridentePersistente.tp_persistencia.RentAuto.sistema.Calificacion
import tridentePersistente.tp_persistencia.RentAuto.sistema.TipoCalificacion
import tridentePersistente.tp_persistencia.RentAuto.sistema.Turismo
import tridentePersistente.tp_persistencia.RentAuto.sistema.Ubicacion
import tridentePersistente.tp_persistencia.RentAuto.sistema.Usuario
import tridentePersistente.tp_persistencia.RentAuto.sistema.Visibilidad
import unq.tpi.persistencia.daos.CassandraManager
import unq.tpi.persistencia.daos.HibernateSessionManager
import unq.tpi.persistencia.daos.Servicios

class AbstractMongoTest {
	protected Collection<Calificacion> homeCalificaciones ; 
	protected Usuario usuario = new Usuario("miguel", "del sel", "miguelito", "m@gmail.com", new Date(), "sarlanga")
	protected Usuario usuario2 = new Usuario("miguel", "del sel", "miguelito2", "m2@gmail.com", new Date(), "sarlanga")
	protected Usuario usuario3 = new Usuario("miguel", "del sel", "miguelito3", "m3@gmail.com", new Date(), "sarlanga")

	protected Servicios servicios = new Servicios()
	protected var Auto auto = new Auto
	protected var Auto otroAuto = new Auto
	protected var Calificacion calificacionOriginal

	protected AmigosService service = new AmigosService
	var CassandraManager cassandra = new CassandraManager()

	@Before
	def void setup()
	{
		try {
			finalizeCassandra  /// borro las tablas "por las dudas"
		} catch (Exception e) {}
		initializeCassandra
		
		homeCalificaciones = SistemDB.instance().collection(Calificacion)

		servicios.guardarUsuario(usuario)
		servicios.guardarUsuario(usuario2)
		servicios.guardarUsuario(usuario3)

		service.crearNodo(usuario)
		service.crearNodo(usuario2)
		service.crearNodo(usuario3)
		servicios.amigarse(usuario,usuario2)
		servicios.amigarse(usuario2,usuario)

		auto = new Auto('fiat', 'tipo', 1999, 'AAB123', new Turismo, 12.4, new Ubicacion("ranelagh"))
		servicios.altaAuto(auto)

		otroAuto = new Auto('fiat', 'tipo', 1999, 'AAB124', new Turismo, 12.4, new Ubicacion("ranelagh"))
		servicios.altaAuto(auto)

		servicios.calificarAuto(usuario, 
						auto, 
						TipoCalificacion.MALO, 
						"El auto es una porquería, y no digo otra cosa porque hay niños presentes", 
						Visibilidad.PUBLICO	)

		servicios.calificarAuto(usuario, 
				auto, 
				TipoCalificacion.BUENO, 
				"El auto anda bien", 
				Visibilidad.SOLOAMIGOS)
		
		servicios.calificarAuto(usuario, 
				auto, 
				TipoCalificacion.MALO, 
				"El auto es una porquería", 
				Visibilidad.PRIVADO	)
		
	}

	@After
	def void after(){
		HibernateSessionManager.truncate		
		service.eliminarNodo(usuario)
		service.eliminarNodo(usuario2)
//		service.eliminarNodo(usuario3)
		homeCalificaciones.mongoCollection.drop

		
	}

	def void initializeCassandra() { 
		cassandra.session.execute("CREATE KEYSPACE cache WITH replication = { 'class' : 'SimpleStrategy', 'replication_factor' : 1 }")
		cassandra.session.execute("CREATE TABLE cache.autosPosiblesEn (id text  PRIMARY KEY, value text);");		
	}

	def finalizeCassandra() {
		cassandra.session.execute("DROP KEYSPACE cache")
	}
}