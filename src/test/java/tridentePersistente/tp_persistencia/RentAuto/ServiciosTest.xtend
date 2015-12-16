package tridentePersistente.tp_persistencia.RentAuto

import java.sql.Date
import org.junit.After
import org.junit.Assert
import org.junit.Before
import org.junit.Test
import tridentePersistente.tp_persistencia.RentAuto.sistema.Auto
import tridentePersistente.tp_persistencia.RentAuto.sistema.Reserva
import tridentePersistente.tp_persistencia.RentAuto.sistema.Turismo
import tridentePersistente.tp_persistencia.RentAuto.sistema.Ubicacion
import tridentePersistente.tp_persistencia.RentAuto.sistema.Usuario
import unq.tpi.persistencia.daos.CassandraManager
import unq.tpi.persistencia.daos.HibernateSessionManager
import unq.tpi.persistencia.daos.Servicios

class ServiciosTest {
	var Servicios servicios = new Servicios()
	var Ubicacion ranelagh
	var Ubicacion quilmes
	var Ubicacion bera
	var Auto a
	var Auto b
	var Auto c
	var Turismo turismo1
	var Reserva reserva
	var Usuario usuario

	protected CassandraManager sessionManagerC = new CassandraManager()

	def void initializeCassandra() { 
		
		sessionManagerC.session.execute("CREATE KEYSPACE cache WITH replication = { 'class' : 'SimpleStrategy', 'replication_factor' : 1 }")

		sessionManagerC.session.execute("CREATE TABLE cache.autosPosiblesEn (id text  PRIMARY KEY, value text);");		

	}

	def finalizeCassandra() {
		sessionManagerC.session.execute("DROP KEYSPACE cache")
	}

	@Before
	def void setUp() {
		try {
			finalizeCassandra  /// borro las tablas "por las dudas"
		} catch (Exception e) {}
		initializeCassandra
		ranelagh = new Ubicacion()
		quilmes = new Ubicacion()
		bera = new Ubicacion()
		ranelagh.nombre = "Ranelagh"
		quilmes.nombre = "Quilmes"
		bera.nombre = "Bera"
		a = new Auto
		b = new Auto
		c = new Auto

		turismo1 = new Turismo()

		a.marca = "marca1"
		a.modelo = "modelo1"
		a.anho = 1999
		a.patente = "AABB123"
		a.costoBase = 12.4
		a.categoria = turismo1
		a.ubicacionInicial = ranelagh
		
		b.marca = "marca1"
		b.modelo = "modelo1"
		b.anho = 1999
		b.patente = "HOLAB123"
		b.costoBase = 12.4
		b.categoria = turismo1
		b.ubicacionInicial = bera
		
		c.marca = "marca1"
		c.modelo = "modelo1"
		c.anho = 1999
		c.patente = "JOSE435"
		c.costoBase = 12.4
		c.categoria = turismo1
		c.ubicacionInicial = quilmes
		
		
		servicios.altaAuto(a)
		servicios.altaAuto(b)
		servicios.altaAuto(c)

		usuario = new Usuario("nombre", "apellido", "nombreDEusser", "email", new Date(7), "contrasenha")

		reserva = new Reserva(1, quilmes, bera, new Date(115, 3 ,  5 ), new Date(115,  3,  8), a, usuario)


//		servicios.hacerReserva(2,ranelagh,ranelagh,new Date(4,3,5),new Date(2,4,7),a,usuario)
	
	}
	
	@After
	def void after(){
		HibernateSessionManager.truncate
		finalizeCassandra
	}

	@Test
	def testAutosEnUbicacion() {
		servicios.hacerReserva(2,quilmes,bera,new Date(115,3,5),new Date(115,3,8),a,usuario)		

		val resultado = servicios.autosEnUbicacion(bera,new Date(115,9,7))
		println(resultado)
		
		Assert.assertTrue(resultado.map[ patente ].contains(a.patente) )
		Assert.assertTrue(resultado.map[ patente ].contains(b.patente) )
		Assert.assertFalse(resultado.map[ patente ].contains(c.patente) )
		
	}

	@Test
	def testHacerReserva() {
		servicios.hacerReserva(1,quilmes,ranelagh,new Date(3/5/5),new Date(5/8/5),a,usuario)		
		Assert.assertEquals(reserva.auto.patente,servicios.dameReserva(1).auto.patente)
		
	}

	@Test
	def void testAutosPosiblesEn() {
		Assert.assertEquals(1,
			servicios.autosPosiblesEn(quilmes, ranelagh, new Date(115, 5 , 5), new Date(115, 8 , 5), turismo1).size)
		
		
		servicios.hacerReserva(1,quilmes,ranelagh,new Date(115,5,5),new Date(115,8,9),a,usuario)
		Assert.assertEquals(1,
			servicios.autosPosiblesEn(quilmes, ranelagh, new Date(113, 6 , 5), new Date(115, 9 , 5), turismo1).size)
		
	
		servicios.hacerReserva(12,quilmes,ranelagh,new Date(113,4,6),new Date(115,9,6),c,usuario)
		Assert.assertEquals(0,
			servicios.autosPosiblesEn(quilmes, ranelagh, new Date(113, 4 , 6), new Date(115, 9 , 6), turismo1).size)
		
				
		servicios.hacerReserva(13,quilmes,ranelagh,new Date(116,4,6),new Date(116,9,6),c,usuario)
		Assert.assertEquals(0,
			servicios.autosPosiblesEn(quilmes, ranelagh, new Date(116, 4 , 6), new Date(116, 9 , 6), turismo1).size)
		
		
			
	}

}
