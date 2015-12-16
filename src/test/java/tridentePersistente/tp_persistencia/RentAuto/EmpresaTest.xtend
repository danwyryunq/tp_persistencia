package tridentePersistente.tp_persistencia.RentAuto

import org.junit.Test
import tridentePersistente.tp_persistencia.RentAuto.sistema.ReservaEmpresarial
import tridentePersistente.tp_persistencia.RentAuto.sistema.ReservaException
import static tridentePersistente.tp_persistencia.RentAuto.sistema.DateExtensions.*


import static org.junit.Assert.*

class EmpresaTest extends AbstractTest{
	@Test
	def void reservaOk(){
		new ReservaEmpresarial => [
			origen = retiro
			destino = aeroparque
			inicio = nuevaFecha(2015,03,01)
			fin = nuevaFecha(2015,03,05)
			it.auto = this.auto
			it.usuario = usuarioEmpresa
			it.empresa = empresa 
			reservar()
		]
		assertEquals(1, empresa.reservas.size)
	}

	@Test(expected=ReservaException)
	def void reservaUsuarioInvalido(){
		new ReservaEmpresarial => [
			origen = retiro
			destino = aeroparque
			inicio = nuevaFecha(2015,03,01)
			fin = nuevaFecha(2015,03,05)
			it.auto = this.auto
			it.usuario = usuarioPrueba
			it.empresa = empresa 
			reservar()
		]
		fail()
	}

}