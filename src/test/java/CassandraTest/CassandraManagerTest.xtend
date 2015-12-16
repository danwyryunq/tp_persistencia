package CassandraTest

import com.google.gson.Gson
import com.google.gson.reflect.TypeToken
import java.util.ArrayList
import java.util.List
import org.junit.After
import org.junit.Before
import org.junit.Test
import tridentePersistente.tp_persistencia.RentAuto.sistema.Auto
import tridentePersistente.tp_persistencia.RentAuto.sistema.Reserva
import tridentePersistente.tp_persistencia.RentAuto.sistema.Turismo
import tridentePersistente.tp_persistencia.RentAuto.sistema.Ubicacion
import tridentePersistente.tp_persistencia.RentAuto.sistema.Usuario
import unq.tpi.persistencia.daos.CassandraManager
import unq.tpi.persistencia.servicios.Cacheable
import unq.tpi.persistencia.servicios.ListAutoCacheable

import static org.junit.Assert.*
import java.util.Date

class CassandraManagerTest {
	
	var CassandraManager cassandra = new CassandraManager()
	var Ubicacion ranelagh
	var Ubicacion quilmes
	var Ubicacion bera
	var Auto a
	var Auto b
	var Auto c
	var Turismo turismo1
	var Reserva reserva
	var Usuario usuario
	var Cacheable cacheable 
	
	var List<Auto> lista = new ArrayList<Auto>();  
	

	def void initializeCassandra() { 
		cassandra.session.execute("CREATE KEYSPACE cache WITH replication = { 'class' : 'SimpleStrategy', 'replication_factor' : 1 }")
		cassandra.session.execute("CREATE TABLE cache.autos (id text PRIMARY KEY, value text);");		
	}

	def finalizeCassandra() {
		cassandra.session.execute("DROP KEYSPACE cache")
	}


	@Before
	def void setup(){
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
		a.reservas = #[new Reserva(1, quilmes, bera, new Date(115, 3 ,  5 ), new Date(115,  3,  8), a, usuario)]
		
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
		
		lista.add(a);
		lista.add(b) ; 
		lista.add(c);
		
		cacheable = new ListAutoCacheable() ;
	}
	
	@After
	def void tearDown() { 
		finalizeCassandra  /// borro las tablas "por las dudas"
	}	
	
	@Test
	def void testSave(){
		cacheable.tableName = "cache.autos"
		cacheable.pk = "id"
		cacheable.id = "1uasdf-asd-asdfasd";

		cassandra.save(cacheable ,lista)
    }   

	@Test
	def void testGet(){
		cacheable.tableName = "cache.autos"
		cacheable.pk = "id"
		cacheable.id = "1uasdf-asd-asdfasd";
		
		cassandra.<List<Auto>>save(cacheable , lista )
		
		var List<Auto> l = cassandra.<List<Auto>>get(cacheable)  
		
		
		assertTrue(l.exists[ it.patente == a.patente ]);  
	}

	@Test
	def void testRunInCache(){
		cacheable.tableName = "cache.autos"
		cacheable.pk = "id"
		cacheable.id = "1uasdf-asd-asdfasd";
		cacheable.fetchFromOrigin = [ null as List<Auto> ]
		
		cassandra.<List<Auto>>runInCache(cacheable )
		
		var l = cassandra.<List<Auto>>get(cacheable) as List<Auto>
		
		assertTrue(l == null);    
	}
}

