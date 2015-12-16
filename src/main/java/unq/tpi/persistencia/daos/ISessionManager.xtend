package unq.tpi.persistencia.daos

import org.eclipse.xtext.xbase.lib.Functions.Function0

interface ISessionManager {
	public def <T> T runInSession(Function0<T> command);
}