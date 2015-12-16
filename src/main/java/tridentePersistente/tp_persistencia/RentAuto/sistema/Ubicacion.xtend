package tridentePersistente.tp_persistencia.RentAuto.sistema

import com.google.gson.annotations.Expose
import java.util.List
import org.eclipse.xtend.lib.annotations.Accessors

@Accessors 
class Ubicacion {
	@Accessors Integer id
	String nombre
	
	new() {
	}
	
	new(String nombre){
		this.nombre = nombre
	}
	
	static def String getName(){
		"Ubicacion"
	}
}

@Accessors 
class UbicacionVirtual extends Ubicacion{
	@Expose(serialize = false , deserialize = true)
	List<Ubicacion> ubicaciones = newArrayList
	
	new(){
		
	}
	
	new(List<Ubicacion> ubicaciones){
		this.ubicaciones = ubicaciones
	}
	
	
}
