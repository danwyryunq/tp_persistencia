package unq.tpi.persistencia.daos;

import org.hibernate.SessionFactory;
import org.hibernate.Transaction;
import org.hibernate.cfg.Configuration;
import org.hibernate.classic.Session;

import unq.tpi.persistencia.servicios.Operation;

import org.eclipse.xtext.xbase.lib.Functions.Function0


public class HibernateSessionManager implements ISessionManager{
	
	private static SessionFactory sessionFactory;
	private static ThreadLocal<Session> tlSession = new ThreadLocal<Session>();
	
	def synchronized static SessionFactory getSessionFactory() {
		if (sessionFactory == null) {
			val Configuration cfg = new Configuration();
			cfg.configure();

			sessionFactory = cfg.buildSessionFactory();
		}

		return sessionFactory;
	}
	
	override  <T> T runInSession(Function0<T> cmd){
		var SessionFactory sessionFactory = HibernateSessionManager.getSessionFactory();
		var Transaction transaction = null;
		var T result = null;
		var Session session = null;
		
		try {
			session = sessionFactory.openSession();
			transaction = session.beginTransaction();

			tlSession.set(session);
			
			result = cmd.apply();

			session.flush();
			transaction.commit();
		} catch (Exception e) {
			if (transaction != null)
				transaction.rollback();
			throw new RuntimeException(e);
		} finally {
			if (session != null)
				session.close();
			tlSession.set(null);
		}
		
		return result;
	}

	def static Session getSession() {
		return tlSession.get();
	}
	
	def static truncate(){
		sessionFactory = null
	}

}
