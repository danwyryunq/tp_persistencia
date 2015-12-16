package amigos

import tridentePersistente.tp_persistencia.RentAuto.sistema.Mensaje
import tridentePersistente.tp_persistencia.RentAuto.sistema.Usuario
import unq.tpi.persistencia.daos.ISessionManager

class AmigosService {

	ISessionManager neo4JSessionManager = new Neo4JSessionManager ; 
	def home() { 
		new AmigosHome()
	}

	def eliminarNodo(Usuario persona) {
		neo4JSessionManager.runInSession[home().eliminarNodo(persona); null]
	}
	
	def eliminarNodo(Mensaje mensaje) {
		neo4JSessionManager.runInSession[home().eliminarNodo(mensaje); null]
	}
	
	def getNodo(Usuario persona) {
		neo4JSessionManager.runInSession[home().getNodo(persona)]
	}
	
	def getNodo(Mensaje mensaje) {
		neo4JSessionManager.runInSession[home().getNodo(mensaje)]
	}
	
	def crearNodo(Usuario persona) {
		neo4JSessionManager.runInSession[home().crearNodo(persona); null]
	}

	def crearNodo(Mensaje mensaje) {
		neo4JSessionManager.runInSession[home().crearNodo(mensaje); null]
	}
	
	
	def amigos(Usuario ameo) {
		neo4JSessionManager.runInSession[home().amigosDe(ameo)]
	}

	def amigosDeAmigos(Usuario ameo) {
		neo4JSessionManager.runInSession[home().amigosRecursivosDe(ameo)]
	}
	
	def amigarse(Usuario ameo1, Usuario ameo2) {
		neo4JSessionManager.runInSession[ home().amigoDe(ameo1, ameo2)]
	}
	
	def enviarMensaje(Usuario remitente, Usuario destinatario, String cuerpo) {
		val msg = new Mensaje(remitente, destinatario, cuerpo)
		neo4JSessionManager.runInSession [ home().enviarMensaje(remitente, destinatario, msg) ]
	}
	
	def mensajesEnviadosPor(Usuario usuario) {
		neo4JSessionManager.runInSession [ home().mensajesEnviadosPor(usuario) ]
	}
	
	def mensajesRecibidosPor(Usuario usuario) {
		neo4JSessionManager.runInSession [ home().mensajesRecibidosPor(usuario) ]
	}
	
}