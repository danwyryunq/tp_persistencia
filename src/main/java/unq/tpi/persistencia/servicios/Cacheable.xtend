package unq.tpi.persistencia.servicios

import com.google.gson.Gson
import com.google.gson.GsonBuilder
import com.google.gson.reflect.TypeToken
import java.util.List
import org.eclipse.xtend.lib.annotations.Accessors
import tridentePersistente.tp_persistencia.RentAuto.sistema.Auto
import unq.tpi.persistencia.adapters.HibernateProxyTypeAdapter
import com.google.gson.ExclusionStrategy
import com.google.gson.FieldAttributes

abstract public class Cacheable<T> {
	@Accessors var String pk ;
	@Accessors var String id;
	@Accessors var String tableName;
	@Accessors var ()=>T fetchFromOrigin ;

	public def String pkCondition() {
		'''«pk» = '«id»' '''
	}

	abstract def String jsonValue(T t)

	abstract def T fromJson(String string) ;

}

public class AnnotationExclusionStrategy implements ExclusionStrategy {
	override shouldSkipClass(Class<?> arg0) {
		return false
	}

	override shouldSkipField(FieldAttributes field) {
		 return field.getAnnotation(Exclude) != null;
	}

}


public class ListAutoCacheable extends Cacheable<List<Auto>> {
			
	override fromJson(String string) {
		var gson = new Gson();
		var type = new TypeToken<List<Auto>>(){}.getType();
		gson.fromJson(string, type) as List<Auto>
	}
	
	override jsonValue(List<Auto> value) {
		var GsonBuilder b = new GsonBuilder();
		 b.registerTypeAdapterFactory(HibernateProxyTypeAdapter.FACTORY);
		b.exclusionStrategies = new AnnotationExclusionStrategy
		var gson = b.create();
		gson.toJson(value)
	}
}