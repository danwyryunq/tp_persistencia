package unq.tpi.persistencia.daos

import tridentePersistente.tp_persistencia.RentAuto.sistema.Reserva

class ReservaDAO extends DAO<Reserva, Integer> {
		
	new (){
		super(Reserva, Integer, "numeroSolicitud")
	}
	
}