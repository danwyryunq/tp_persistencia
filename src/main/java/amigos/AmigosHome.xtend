package amigos


import org.eclipse.xtend.lib.annotations.Accessors
import org.neo4j.graphdb.Direction
import org.neo4j.graphdb.DynamicLabel
import org.neo4j.graphdb.GraphDatabaseService
import org.neo4j.graphdb.Node
import org.neo4j.graphdb.RelationshipType
import tridentePersistente.tp_persistencia.RentAuto.sistema.Usuario
import java.util.Date
import tridentePersistente.tp_persistencia.RentAuto.sistema.Mensaje

@Accessors
class AmigosHome {
	GraphDatabaseService graph

	new() { 
		this.graph = Neo4JSessionManager.getGraphDb()
	}

	def usuarioLabel() {
		DynamicLabel.label("Usuario")
	}
	
	def mensajeLabel(){
		DynamicLabel.label("Mensaje")
	}

	def eliminarNodo(Usuario usuario) {
		val nodo = getNodo(usuario)
		nodo.relationships.forEach[delete]
		nodo.delete
	}
	
	def eliminarNodo(Mensaje mensaje) {
		val nodo = getNodo(mensaje)
		nodo.relationships.forEach[delete]
		nodo.delete
	}
	
	

	def getNodo(Usuario usuario) {
		graph.findNodes(usuarioLabel, "nombreDeUsuario", usuario.nombreDeUsuario).head
	}

	def getNodo(Mensaje mensaje) {
		graph.findNodes(mensajeLabel, "cuerpo", mensaje.cuerpo).head
	}

	def crearNodo(Usuario usuario) {
		val node = graph.createNode(usuarioLabel)
		node.setProperty("nombreDeUsuario", usuario.nombreDeUsuario)
		node
	}

	def crearNodo(Mensaje mensaje) {
		val node = graph.createNode(usuarioLabel)
		node.setProperty("cuerpo", mensaje.cuerpo)
		node
	}
	

	def crearUsuario(Node nodo) {
		new Usuario => [
			nombreDeUsuario = nodo.getProperty("nombreDeUsuario") as String
		]
	}

	def crearMensaje(Node nodo) {
		new Mensaje => [
			cuerpo = nodo.getProperty("cuerpo") as String
		]
	}
	

	def amigoDe(Usuario usuarioSolicitud, Usuario usuarioConfirmante) {
		val usuario1Node = getNodo(usuarioSolicitud)
		val usuario2Node = getNodo(usuarioConfirmante)
		usuario1Node.createRelationshipTo(usuario2Node, TipoDeRelaciones.AMIGO)
		usuario2Node.createRelationshipTo(usuario1Node, TipoDeRelaciones.AMIGO)
	}


	def enviarMensaje(Usuario envia,Usuario recibe, Mensaje mensaje) {
		val usuario1Node = getNodo(envia)
		val usuario2Node = getNodo(recibe)
		val mensajeNode = crearNodo(mensaje)

		usuario1Node.createRelationshipTo(mensajeNode,TipoDeRelaciones.ENVIA)
		usuario2Node.createRelationshipTo(mensajeNode,TipoDeRelaciones.RECIBE)		
	}


	def amigos(Usuario usuario) {
		amigos(getNodo(usuario))
	}

	def amigos(Node nodo) {
		nodosRelacionados(nodo, TipoDeRelaciones.AMIGO, Direction.OUTGOING)
	}

	protected def nodosRelacionados(Node nodo, RelationshipType tipo, Direction direccion) {
		nodo.getRelationships(tipo, direccion).map[it.getOtherNode(nodo)]
	}


	def amigosDe(Usuario usuario) {
		amigos(usuario).map[crearUsuario].<Usuario>toList
	}

	def amigosRecursivosDe(Usuario usuario) {
		val amigos = amigos(usuario).map[amigos].flatten
		amigos.map[crearUsuario].<Usuario>toList
	}
	
	def mensajesEnviadosPor(Usuario usuario) 
	{
		nodosRelacionados(getNodo(usuario), TipoDeRelaciones.ENVIA, Direction.OUTGOING).map[println(it); crearMensaje].<Mensaje>toList
	}
	
	def mensajesRecibidosPor(Usuario usuario) 
	{
		nodosRelacionados(getNodo(usuario), TipoDeRelaciones.RECIBE, Direction.OUTGOING).map[ println(it); crearMensaje].<Mensaje>toList
	}
}