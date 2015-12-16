package AmigosTest


import org.junit.After
import org.junit.Assert
import org.junit.Before
import org.junit.Test
import tridentePersistente.tp_persistencia.RentAuto.sistema.Usuario
import amigos.AmigosService

class AmigosServiceTest {
	
	Usuario usuario1
	Usuario usuario2
	Usuario usuario3
	Usuario usuario4
	AmigosService service
	
	@Before
	def void setup(){
		usuario1 = new Usuario => [
			nombreDeUsuario = "usuario1" 
			nombre = "Nombreusuario1"
			apellido = "Apellidousuario1"
		]
		
		usuario2 = new Usuario => [
			nombreDeUsuario = "usuario2" 
			nombre = "Nombreusuario2"
			apellido = "Apellidousuario2"
		]
		
		usuario3 = new Usuario => [
			nombreDeUsuario = "usuario3" 
			nombre = "Nombreusuario3"
			apellido = "Apellidousuario3"
		]
		
		usuario4 = new Usuario => [
			nombreDeUsuario = "usuario4" 
			nombre = "Nombreusuario4"
			apellido = "Apellidousuario4"
		]
		
		service = new AmigosService
		service.crearNodo(usuario1)
		service.crearNodo(usuario2)
		service.crearNodo(usuario3)
		service.crearNodo(usuario4)
		service.amigarse(usuario1, usuario2)
		service.amigarse(usuario2, usuario3)
		service.amigarse(usuario1, usuario4)
		service.amigarse(usuario4, usuario2)
	}
	
	@Test
	def void testEsAmigo(){
		val amigos = service.amigos(usuario2)
		Assert.assertEquals(3, amigos.length)
		Assert.assertEquals(amigos.map[it.nombreDeUsuario].sort, #[usuario1,usuario3,usuario4].map[it.nombreDeUsuario].sort)
	}
	
	@Test
	def void testAmigar(){
		var amigos = service.amigos(usuario3)
		Assert.assertEquals(1, amigos.length)
		
		service.amigarse(usuario3,usuario1)
		
		amigos = service.amigos(usuario3)
		Assert.assertEquals(2, amigos.length)
	}
	
	@Test
	def void testPersonasConectadas(){
		var amigosDeAmigos = service.amigosDeAmigos(usuario3)
		Assert.assertEquals(3, amigosDeAmigos.length)
	}
	
	@Test
	def void testMensajesEnviados() 
	{
		
		val mensaje = "Querés ser mi ameo, gato?"
		service.enviarMensaje(usuario1,usuario2,mensaje);
		Assert.assertTrue( service.mensajesEnviadosPor(usuario1).map[cuerpo].contains(mensaje) )
		Assert.assertTrue( service.mensajesRecibidosPor(usuario2).map[cuerpo].contains(mensaje) )
	}
	
	@After
	def void after(){
		service.eliminarNodo(usuario1)
		service.eliminarNodo(usuario2)
		service.eliminarNodo(usuario3)
		service.eliminarNodo(usuario4)
	}
}