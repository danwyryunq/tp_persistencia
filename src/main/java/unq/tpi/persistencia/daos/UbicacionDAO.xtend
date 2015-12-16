package unq.tpi.persistencia.daos


import tridentePersistente.tp_persistencia.RentAuto.sistema.Ubicacion

class UbicacionDAO extends DAO<Ubicacion, Integer> {
		
	new (){
		super(Ubicacion, Integer, "nombre")
	}	
}

