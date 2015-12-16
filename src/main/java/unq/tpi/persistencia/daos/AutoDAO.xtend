package unq.tpi.persistencia.daos

import java.util.List
import tridentePersistente.tp_persistencia.RentAuto.sistema.Auto
import tridentePersistente.tp_persistencia.RentAuto.sistema.Ubicacion
import java.util.Date
import tridentePersistente.tp_persistencia.RentAuto.sistema.Categoria

class AutoDAO extends DAO<Auto, String> {
		
	new (){
		super(Auto, String, "patente")
	}
		
	def List<Auto> dameTodosEnUbicacion(Ubicacion ubicacion,Date dia) {
		return  HibernateSessionManager.getSession().createQuery("
			from Auto as auto
		 	left join fetch auto.reservas as reserva 
			where 
			auto.ubicacionInicial = :ubicacion or (
			reserva is not null and (reserva.inicio < :diaReserva or reserva.fin > :diaReserva 
			and (reserva.destino = :ubicacion) ))
		")

		.setParameter("ubicacion", ubicacion)
		.setParameter("diaReserva" , dia)
		.list()
	}
	
	
	def List<Auto> autosPosiblesEn(Ubicacion origen,Ubicacion destino,Date inicio,Date fin,Categoria categoria)
	{
			/*return  SessionManager.getSession()
			 
				autos que no tengan reserva entre fecha de inicio y fecha de fin 
				* interseccion
				autos que cuyo ultima reserva tenga como destino :origen
				* interseccion
				autos tengan categoria :cat
				* interseccion
				autos cuya primera reserva despues de la fecha de :fin tenga cmo origen :destino
			 * 
			*/
			
		return  HibernateSessionManager.getSession().createQuery("
			from Auto as auto
		 	left join fetch auto.reservas as reservas 
			where 
			auto.categoria = :categoria and (
			( 
				reservas.id is null	and auto.ubicacionInicial = :origen	
			) or ( 
				auto in (
					select fRes.auto
					from Reserva as fRes
					where 		fRes.destino = :origen
							and fRes.fin = (
								select max(fRes2.fin) as reserva_id 
								from Reserva as fRes2 
								where 	fRes2.fin < :diaInicioReserva
									and fRes2.auto = fRes.auto
							)
				)
				and (
					auto in (
						select fRes.auto
						from Reserva as fRes
						where 		fRes.origen = :destino
								and fRes.inicio = (
									select min(fRes2.inicio)  
									from Reserva as fRes2 
									where 	fRes2.inicio > :diaFinReserva
										and fRes2.auto = fRes.auto
								)
					) or auto not in (
						select fRes.auto from Reserva as fRes where inicio > :diaFinReserva
					)
				)
				and auto not in (
					select fRes3.auto
					from Reserva as fRes3 
					where 		:diaInicioReserva between fRes3.inicio and fRes3.fin 	
							or  :diaFinReserva between fRes3.inicio and fRes3.fin
				)
			)
		)")
		.setParameter("categoria",categoria )
		.setParameter("origen", origen)
		.setParameter("diaInicioReserva" ,inicio)
		.setParameter("destino", destino)
		.setParameter("diaFinReserva" ,fin)
		
		
		.list
			
			
	}
}
	
	
		
	
	
	
	
