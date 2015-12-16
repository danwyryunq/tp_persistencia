package unq.tpi.persistencia.daos

import unq.tpi.persistencia.daos.DAO
import tridentePersistente.tp_persistencia.RentAuto.sistema.Usuario

class UsuarioDAO extends DAO<Usuario, String> {
		
	new (){
		super(Usuario, String, "nombreDeUsuario")
	}
}