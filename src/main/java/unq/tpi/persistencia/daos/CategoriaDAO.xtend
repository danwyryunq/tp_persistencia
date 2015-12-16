package unq.tpi.persistencia.daos

import tridentePersistente.tp_persistencia.RentAuto.sistema.Categoria

class CategoriaDAO extends DAO<Categoria, String>{
	
	new() {
		super(Categoria, String, "nombre")
	}
}