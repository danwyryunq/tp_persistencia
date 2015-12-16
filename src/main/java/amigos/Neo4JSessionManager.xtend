package amigos

import org.neo4j.graphdb.factory.GraphDatabaseFactory
import org.neo4j.graphdb.GraphDatabaseService
import org.eclipse.xtext.xbase.lib.Functions.Function1
import org.eclipse.xtext.xbase.lib.Functions.Function0
import unq.tpi.persistencia.daos.ISessionManager

class Neo4JSessionManager  implements ISessionManager {

	static private GraphDatabaseService _amigos

	static synchronized def GraphDatabaseService getGraphDb() {
		if (_amigos == null) {
			_amigos = new GraphDatabaseFactory()
				.newEmbeddedDatabaseBuilder("./target/neo4j")
				.newGraphDatabase();
				registerShutDownHook
		}
		_amigos
	}

	
	override <T> T runInSession(Function0<T> command){
		val tx = getGraphDb.beginTx
		try{
			val t = command.apply()
			tx.success
			t
		}catch(Exception e){
			tx.failure
			throw e
		}finally{
			tx.close
		}
	}

	
	static def <T> T run(Function1<GraphDatabaseService, T> command){
		val tx = getGraphDb.beginTx
		try{
			val t = command.apply(getGraphDb)
			tx.success
			t
		}catch(Exception e){
			tx.failure
			throw e
		}finally{
			tx.close
		}
	}
	
	static def registerShutDownHook() {
    	Runtime.runtime.addShutdownHook(new Thread([|
    		graphDb.shutdown
    	]))
  	}
}
