package tridentePersistente.tp_persistencia.RentAuto.sistema

import java.util.List

interface IUsuario {
	def void agregarReserva(Reserva unaReserva)
	def List<Reserva> getReservas()
}