package unq.tpi.persistencia.daos

import org.eclipse.xtend.lib.annotations.Accessors
import java.io.Serializable

@Accessors
abstract class  DAO<T,PK extends Serializable> {
	
	var Class<T> clase
	var Class<PK> tipoPK
	var String nombreDeClase
	var String nombreDeIdentificador
	
	new(Class<T> c, Class<PK> pk, String nombreDelIdentificador){
		this.clase = c
		this.tipoPK = pk
		this.nombreDeClase = c.getName
		this.nombreDeIdentificador = nombreDelIdentificador
	}
	
	def T get(PK pk){
		HibernateSessionManager.getSession()
			.createQuery(this.getQuery)
			.setParameter("identificador", pk)
			.uniqueResult as T
	}
	
	protected def String getQuery(){
		"FROM "+nombreDeClase+" WHERE "+nombreDeIdentificador+"= :identificador"
	}
	
	
	def save(T t) {
		println("llego aca")
		HibernateSessionManager.getSession().saveOrUpdate(t);
	}
	
}