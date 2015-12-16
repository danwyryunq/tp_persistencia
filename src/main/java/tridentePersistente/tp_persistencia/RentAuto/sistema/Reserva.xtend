package tridentePersistente.tp_persistencia.RentAuto.sistema

import java.util.Date
import org.eclipse.xtend.lib.annotations.Accessors
import org.joda.time.DateTime
import org.joda.time.Days
import static tridentePersistente.tp_persistencia.RentAuto.sistema.DateExtensions.*
@Accessors
class Reserva {
	Integer id
	Integer numeroSolicitud
	Ubicacion origen
	Ubicacion destino
	Date inicio
	Date fin
	Auto auto
	Usuario usuario
	
	new() {
	}
	
	new(int i, Ubicacion ubicacion, Ubicacion ubicacion2,Date inicio,Date fin, Auto auto, Usuario usuario) {
		this.numeroSolicitud = i
		this.origen = ubicacion
		this.destino = ubicacion2
		this.inicio = inicio
		this.fin = fin
		this.auto = auto
		this.usuario = usuario
	}

	def costo() {
		val cantidadDeDias = Days.daysBetween(new DateTime(inicio), new DateTime(fin)).days
		return cantidadDeDias * auto.costoTotal;
	}
	
	def void validar(){
		val ubicacionInicial = auto.ubicacionParaDia(inicio)
		
		if(ubicacionInicial != origen)
			throw new ReservaException("El auto no tiene la ubicación de origen buscada")
		
		if(!auto.estaLibre(inicio, fin))
			throw new ReservaException("El auto no esta libre en el periodo pedido")
	}
	
	def isActiva(){
		inicio <= hoy && hoy <= fin
	}
	
	def seSuperpone(Date desde, Date hasta){
		if(inicio <= desde && desde <= fin )
			return true
		if(inicio <= hasta && hasta <= fin )
			return true
		if(desde <= inicio && fin <= hasta)
			return true
			
		return false	
	}
	
	def costoPorDia(){
		return 0
	}
	
	def reservar(){
		this.auto.agregarReserva(this)
		this.usuario.agregarReserva(this)
	}
	
	static def String getName(){
		"Reserva"
	}
}


@Accessors 
class ReservaEmpresarial extends Reserva{
	Empresa empresa
	String nombreContacto
	String cargoContacto
	
	new(){}
	
	override reservar(){
		super.reservar()
		this.empresa.agregarReserva(this)
	}
}

class ReservaException extends RuntimeException{
	new(String msg){
		super(msg)
	}
}
