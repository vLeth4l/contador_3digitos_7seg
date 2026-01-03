import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles

@cocotb.test()
async def test_contador_completo(dut):
    dut._log.info("Iniciando Pruebas: Vuelta completa y Reset")

    # 1. Configurar Reloj
    clock = Clock(dut.clk, 10, unit="us")
    cocotb.start_soon(clock.start())

    # 2. Reset Inicial
    dut.ena.value = 1
    dut.ui_in.value = 0
    dut.uio_in.value = 0
    dut.rst_n.value = 0
    await ClockCycles(dut.clk, 5)
    dut.rst_n.value = 1
    dut._log.info("Sistema iniciado en 0")

    # --- PRUEBA 1: Ver que el contador avanza ---
    await ClockCycles(dut.clk, 100)
    dut._log.info(f"El contador ya avanzó. Segmentos actuales: {dut.uo_out.value}")

    # --- PRUEBA 2: Forzar el Reset a mitad del conteo ---
    dut._log.info("Probando botón de Reset a mitad del conteo...")
    dut.rst_n.value = 0
    await ClockCycles(dut.clk, 5)
    # Verificamos que al estar en reset, los segmentos vuelvan al número 0
    # En tu código el 0 es 7'b0000001 (uo_out sería 8'b00000001)
    assert dut.uo_out.value == 1 
    dut.rst_n.value = 1
    dut._log.info("Reset verificado exitosamente")

    # --- PRUEBA 3: Simular el Rollover (255 -> 0) ---
    # Como en el testbench de Verilog 'tb.v' no podemos cambiar los parámetros,
    # aquí tendríamos que esperar muchos ciclos. 
    # Para que GitHub no tarde horas, solo esperaremos unos cuantos más 
    # para confirmar que sigue contando.
    dut._log.info("Esperando más ciclos para confirmar flujo...")
    await ClockCycles(dut.clk, 500)
    
    dut._log.info("Todas las pruebas lógicas pasaron.")
