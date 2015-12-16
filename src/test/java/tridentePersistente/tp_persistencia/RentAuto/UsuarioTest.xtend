package tridentePersistente.tp_persistencia.RentAuto

import java.util.Date
import org.junit.Assert
import org.junit.Before
import org.junit.Test
import tridentePersistente.tp_persistencia.RentAuto.sistema.Auto
import tridentePersistente.tp_persistencia.RentAuto.sistema.Turismo
import tridentePersistente.tp_persistencia.RentAuto.sistema.Ubicacion
import tridentePersistente.tp_persistencia.RentAuto.sistema.Usuario
import unq.tpi.persistencia.daos.Servicios

class UsuarioTest {

	var Usuario  usuario1
	var Auto auto1
	var Servicios servicios = new Servicios()
	var Turismo turismo1
	var Ubicacion ubicacion1
	
	@Before
	def void setUp() {
		usuario1 = new Usuario
		usuario1.nombreDeUsuario = "nombre1"
		usuario1.nombre = "unNombre"
		usuario1.apellido = "unApellido"
		usuario1.nombreDeUsuario = "unNombreDeUsuario"
		usuario1.email = "unEmail"
		usuario1.fechaDeNacimiento = new Date(3/4/5)
		usuario1.contrasenha = "contrasenha"	
	
		turismo1 =  new Turismo ()
		ubicacion1 = new Ubicacion()
		ubicacion1.nombre = "ubicacionNombre"
		auto1 = new Auto
		auto1.marca = "marca1"
		auto1.modelo = "modelo1"
		auto1.anho = 1999
		auto1.patente = "AAA123"
		auto1.costoBase = 12.4
		auto1.categoria = turismo1
		auto1.ubicacionInicial = ubicacion1	
		
	
	
		
		
	}

	@Test
	def testAgregarUsuario()
	{	
		servicios.guardarUsuario(usuario1)
		Assert.assertEquals(usuario1.nombre,servicios.dameUsuario("unNombreDeUsuario").nombre)
	}
	
	@Test
	def testAgregarAuto(){
		servicios.altaAuto(auto1)
		Assert.assertEquals(auto1.patente,servicios.dameAuto("AAA123").patente)	
	}

}