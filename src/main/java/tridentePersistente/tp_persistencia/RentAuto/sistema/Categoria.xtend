package tridentePersistente.tp_persistencia.RentAuto.sistema

import org.eclipse.xtend.lib.annotations.Accessors

class Categoria {
	@Accessors Integer id
	@Accessors protected String nombre	
	public new () {
		
	}
	def Double calcularCosto(Auto auto) {}
	public def String getClassName() { nombre }
	static def String getName(){
		"Categoria"
	}
}


class Turismo extends Categoria{
	new () { nombre = "Turismo" }
	static def getName() {
		
	}

	override calcularCosto(Auto auto) {
		if(auto.anho > 2000){
			return auto.costoBase * 1.10			
		}else{
			return auto.costoBase - 200
		}
	}
}

class Familiar extends Categoria{
	new () { nombre = "Familiar" }	
	
	override calcularCosto(Auto auto) {
		return auto.costoBase + 200
	}
}

class Deportivo extends Categoria{
	new () { nombre = "Deportivo" }
	override calcularCosto(Auto auto) {
		if(auto.anho > 2000){
			return auto.costoBase * 1.30			
		}else{
			return auto.costoBase * 1.20
		}
	}
}

class TodoTerreno extends Categoria{
	new () { nombre = "TodoTerreno" }
	override calcularCosto(Auto auto) {
		auto.costoBase * 1.10
	}
}