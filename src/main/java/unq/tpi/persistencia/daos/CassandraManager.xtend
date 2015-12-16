package unq.tpi.persistencia.daos

import com.datastax.driver.core.Cluster
import org.eclipse.xtend.lib.annotations.Accessors
import unq.tpi.persistencia.servicios.Cacheable

@Accessors 
class CassandraManager {
	
	private static val ip = "localhost"
	private static val cluster = Cluster.builder.addContactPoint(ip).build
	public static val session = cluster.connect()
	
	public new(  ){
	}
	    
	def getSession()
	{	session		}
	
	
	def <T> save(Cacheable cacheable,T value)
	{
		session.execute('''insert into «cacheable.getTableName()»  (id,value) VALUES ('«cacheable.getId()»','«cacheable.jsonValue(value)»')''')
	}
	
	def <T> T get(Cacheable cacheable)
	{
		
		var T resultado = null 
		var rs = session.execute('''select value from «cacheable.getTableName()» where id ='«cacheable.getId()»' ''')
		var iterador = rs.iterator()
		
		if (iterador.hasNext()){
    		var String value = iterador.next().getObject("value") as String 
    		resultado = cacheable.fromJson(value) as T
   		} 
   
		resultado as T
	}

	
	def delete(Cacheable cacheable)
	{
		session.execute('''delete from «cacheable.getTableName()» where id='«cacheable.getId()»' ''');
	}

	def delete(String nameTable)
	{
		session.execute('''truncate «nameTable»''');
	}

	def <T> T runInCache(Cacheable cacheable) {
		var resultado = <T> get(cacheable) as T
		if (null == resultado) 
		{
			resultado = cacheable.fetchFromOrigin.apply as T
			save(	cacheable,	resultado	)
		}
		resultado
	}
	

}