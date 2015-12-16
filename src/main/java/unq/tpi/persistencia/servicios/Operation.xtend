package unq.tpi.persistencia.servicios

public interface Operation<T> {
	def T execute()
}