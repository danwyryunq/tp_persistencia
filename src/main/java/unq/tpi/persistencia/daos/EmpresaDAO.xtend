package unq.tpi.persistencia.daos

import tridentePersistente.tp_persistencia.RentAuto.sistema.Empresa

class EmpresaDAO extends DAO<Empresa, String> {
	
	new(){
		super(Empresa, String, "cuit")
	}
}