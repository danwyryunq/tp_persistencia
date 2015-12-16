package unq.tpi.persistencia.daos

import Mongo.Collection
import Mongo.SistemDB
import amigos.AmigosService
import java.sql.Date
import java.util.List
import org.mongojack.DBQuery
import org.mongojack.DBQuery.Query
import tridentePersistente.tp_persistencia.RentAuto.sistema.Auto
import tridentePersistente.tp_persistencia.RentAuto.sistema.Calificacion
import tridentePersistente.tp_persistencia.RentAuto.sistema.Categoria
import tridentePersistente.tp_persistencia.RentAuto.sistema.Reserva
import tridentePersistente.tp_persistencia.RentAuto.sistema.TipoCalificacion
import tridentePersistente.tp_persistencia.RentAuto.sistema.Ubicacion
import tridentePersistente.tp_persistencia.RentAuto.sistema.Usuario
import tridentePersistente.tp_persistencia.RentAuto.sistema.Visibilidad

class Servicios
{
	ISessionManager hibernateSessionManager = new HibernateSessionManager() ; 
	Collection<Calificacion> homeCalificacion = SistemDB.instance().collection(Calificacion)
	AmigosService amigosService = new AmigosService()
	
	def	guardarUsuario(Usuario usuario1) {
		hibernateSessionManager.runInSession([
			new UsuarioDAO().save(usuario1)
			null 
		])
	}
	
	def dameUsuario(String nombreDeUsuario) {
		hibernateSessionManager.runInSession([
				new UsuarioDAO().get(nombreDeUsuario)
		])
	}
	
	def calificarAuto(Usuario usuario,Auto auto,TipoCalificacion tipoCal,String comentario,Visibilidad visibilidad)
	{
		var calificacion = new Calificacion(usuario, auto, tipoCal, comentario, visibilidad)
		homeCalificacion.insert(calificacion)
		
	}
	
	/// devuelve el perfil publico
	def usuarioPidePerfilDe(Usuario solicitante, Usuario delPerfil)
	{
		var query = DBQuery.is("usuario", delPerfil.nombreDeUsuario)
		
		if (solicitante.nombreDeUsuario != delPerfil.nombreDeUsuario)
		{ 
			var Query queryVis 
			if (tieneDeAmigoA(solicitante, delPerfil) )  
			{
				queryVis = DBQuery.in("visibilidad", Visibilidad.SOLOAMIGOS, Visibilidad.PUBLICO) 			
			} else 
			{
				queryVis = DBQuery.is("visibilidad", Visibilidad.PUBLICO)
			}
			query = query.and(queryVis)
		}
		
		homeCalificacion.mongoCollection.find( query )
	}
	
	def amigarse(Usuario usuario1,Usuario usuario2)
	{
		amigosService.amigarse(usuario1,usuario2)
	}
	
	def crearNodo(Usuario usuario1)
	{
		amigosService.crearNodo(usuario1)
	}
	
	def tieneDeAmigoA(Usuario solicitante,Usuario delPerfil)
	{
		var amigos = amigosService.amigos(delPerfil)
		amigos.exists[ it.nombreDeUsuario == solicitante.nombreDeUsuario ] 
	}
		
	def altaAuto(Auto auto) {
		new CassandraServices().altaAuto(
			auto,
			[	hibernateSessionManager.runInSession [new AutoDAO().save(auto); null]	]
		)
	}
		
	def dameAuto(String patente) {
		hibernateSessionManager.runInSession([
			new AutoDAO().get(patente)
	])}
		
	def guardarReserva(Reserva reserva) {
		hibernateSessionManager.runInSession([
			new ReservaDAO().save(reserva)
			null 
		])
	} 
		
	def dameReserva(Integer numeroReserva) {
		hibernateSessionManager.runInSession([
			new ReservaDAO().get(numeroReserva)
		])
	} 
		
	def List<Auto> autosEnUbicacion(Ubicacion ubicacion,Date dia) {
 		hibernateSessionManager.runInSession([
			new AutoDAO().dameTodosEnUbicacion(ubicacion,dia)
		])
	}
	
	/*
	 * Como administrador quiero que la información de disponibilidad de los autos se guarde de forma cacheada por día y ubicación, 
	 * o sea para cada día que autos estan disponibles. 
	 */
	 
	 	
	def List<Auto> autosPosiblesEn(Ubicacion origen,Ubicacion destino,Date inicio,Date fin,Categoria categoria) {
		
		new CassandraServices()
			.autosPosiblesEn(
				origen, destino, inicio, fin, categoria,
				[	hibernateSessionManager.runInSession [new AutoDAO().autosPosiblesEn( origen, destino, inicio, fin, categoria )]	]
			)
		
	}
	 
	def hacerReserva(Integer numeroSolicitud,Ubicacion origen,Ubicacion destino,Date inicio,Date fin,Auto auto,Usuario usuario) {
		new CassandraServices().hacerReserva(
			numeroSolicitud,origen,destino,inicio,fin,auto,usuario,
			[ hibernateSessionManager.runInSession [guardarReserva( new Reserva(numeroSolicitud,origen,destino,inicio,fin,auto,usuario) )	] ]
		)
	}
}	
