package tridentePersistente.tp_persistencia.RentAuto.sistema

import java.util.Date
import java.util.List
import org.eclipse.xtend.lib.annotations.Accessors
import unq.tpi.persistencia.servicios.Exclude

@Accessors 
class Auto {
	Integer id
	String marca
	String modelo
	Integer anho
	String patente
	Double costoBase
	Ubicacion ubicacionInicial
	Categoria categoria
	
	//Debe estar ordenado
	@Exclude	
	@Accessors  List<Reserva> reservas = newArrayList()
	
	new() {
	}

	new(String marca, String modelo, Integer anio, String patente, Categoria categoria, Double costoBase, Ubicacion ubicacionInicial){
		this.marca = marca
		this.modelo = modelo
		this.anho = anio
		this.patente = patente
		this.costoBase = costoBase
		this.categoria = categoria
		this.ubicacionInicial = ubicacionInicial
	}

	def getReservas() { 
		reservas 
	}
	
	def getUbicacion(){
		this.ubicacionParaDia(new Date());
	}
	
	def ubicacionParaDia(Date unDia){
		val encontrado = reservas.findLast[ it.fin <= unDia ]
		if(encontrado != null){
			return encontrado.destino
		}else{
			return ubicacionInicial
		}
	}
	
	def Boolean estaLibre(Date desde, Date hasta){
		reservas.forall[ !seSuperpone(desde,hasta) ]
	}
	
	def agregarReserva(Reserva reserva){
		reserva.validar
		reservas.add(reserva)
		reservas.sortInplaceBy[inicio]
	}
	
	def costoTotal(){
		return categoria.calcularCosto(this)
	}
	
	static def String getName(){
		"Auto"
	}
	
//	public def getCategoria() { categoria }
//	public def setCategoria(Categoria categoria) {
//		// al desserializarse un objeto de tipo categoria no se convierte automáticamente a su subtipo
//		switch categoria.getClassName() {
//			case "Turismo": 
//				this.categoria = Turismo.cast(categoria)
//			case "Familiar": 
//				this.categoria = Familiar.cast(categoria)
//			case "Deportivo" : 
//				this.categoria = Deportivo.cast(categoria)
//			case "TodoTerreno" : 
//				this.categoria = TodoTerreno.cast(categoria)
//			default: 
//				this.categoria = categoria
//		}
//		
//	}
}
