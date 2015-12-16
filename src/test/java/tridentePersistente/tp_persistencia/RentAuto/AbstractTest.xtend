package tridentePersistente.tp_persistencia.RentAuto

import org.junit.Before
import tridentePersistente.tp_persistencia.RentAuto.sistema.Auto
import tridentePersistente.tp_persistencia.RentAuto.sistema.Categoria
import tridentePersistente.tp_persistencia.RentAuto.sistema.Empresa
import tridentePersistente.tp_persistencia.RentAuto.sistema.Familiar
import tridentePersistente.tp_persistencia.RentAuto.sistema.Ubicacion
import tridentePersistente.tp_persistencia.RentAuto.sistema.Usuario
import unq.tpi.persistencia.daos.CassandraManager

import static org.mockito.Mockito.*
import org.junit.After

class AbstractTest {
	protected Auto auto
	protected Categoria categoriaFamiliar
	protected Ubicacion retiro
	protected Ubicacion aeroparque
	protected Usuario usuarioPrueba
	protected Usuario usuarioEmpresa
	protected Empresa empresa
	protected CassandraManager sessionManagerC = new CassandraManager();

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

		categoriaFamiliar = new Familiar
		retiro = new Ubicacion("Retiro")
		aeroparque = new Ubicacion("Aeroparque")
		auto = new Auto("Peugeot", "505", 1990, "XXX123", categoriaFamiliar, 100D, retiro)

		usuarioPrueba = mock(Usuario)
		usuarioEmpresa = mock(Usuario)
		
		empresa = new Empresa => [
			cuit = "30-11223344-90"
			nombreEmpresa = "Empresa Fantasmita"
			cantidadMaximaDeReservasActivas = 2
			valorMaximoPorDia = 1000D
		]
		
		empresa.usuarios.add(usuarioEmpresa)
	}
	
	@After
	def void tearDown() {
		
		finalizeCassandra
		
	}
}
