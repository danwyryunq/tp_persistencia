package tridentePersistente.tp_persistencia.RentAuto.sistema

import org.eclipse.xtend.lib.annotations.Accessors
import org.mongojack.ObjectId
import com.fasterxml.jackson.annotation.JsonProperty

@Accessors 
public class Calificacion {
	@ObjectId
	@JsonProperty("_id")	
	String id
	String auto
	String usuario
	Visibilidad visibilidad
	TipoCalificacion calificacion
	String comentario 
	
	new () 
	{

	}
	
	new(Usuario usuario,Auto auto,TipoCalificacion tipoCal,String comentario,Visibilidad visibilidad)
	{
		this.usuario = usuario.nombreDeUsuario
		this.auto = auto.patente
		this.calificacion = tipoCal
		this.comentario = comentario
		this.visibilidad = visibilidad
	}
}


enum Visibilidad {
	PRIVADO,
	PUBLICO,
	SOLOAMIGOS
}

enum TipoCalificacion{
	EXCELENTE,
	BUENO,
	REGULAR,
	MALO
}