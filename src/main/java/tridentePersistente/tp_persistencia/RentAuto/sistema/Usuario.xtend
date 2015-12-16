package tridentePersistente.tp_persistencia.RentAuto.sistema

import java.util.ArrayList
import java.util.Date
import java.util.List
import org.eclipse.xtend.lib.annotations.Accessors

@Accessors class Usuario implements IUsuario {
	
	Integer id
	String nombre
	String apellido
	String nombreDeUsuario
	String contrasenha
	String email
	Date fechaDeNacimiento
	List<Reserva> reservas= #[]
	List<Calificacion> calificaciones = new ArrayList(); 
	
	new(){}
	
	new(String unNombre, String unApellido, String unNombreDeUsuario, String unEmail, Date unaFechaDeNacimiento,String contrasenha){
		this.nombre = unNombre
		this.apellido = unApellido
		this.nombreDeUsuario = unNombreDeUsuario
		this.email = unEmail
		this.fechaDeNacimiento = unaFechaDeNacimiento
		this.contrasenha = contrasenha
	}
	
	override agregarReserva(Reserva unaReserva) {
		reservas.add(unaReserva)
	}
		
	static def String getName(){
		"Usuario"
	}	
}