package tridentePersistente.tp_persistencia.RentAuto.sistema

import java.util.Date
import org.eclipse.xtend.lib.annotations.Accessors

@Accessors

class Mensaje {
	var Usuario origen
	var Usuario destino
	var Date fecha
	var String cuerpo
	
	new (Usuario origen, Usuario destino, String cuerpo) {
		this.origen = origen
		this.destino = destino 
		fecha = new Date
		this.cuerpo = cuerpo
	}
	
	new() {
		
	}
	
}