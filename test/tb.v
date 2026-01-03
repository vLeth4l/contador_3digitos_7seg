`default_nettype none
`timescale 1ns / 1ps

/* Este testbench instancia el módulo y crea los cables necesarios
   para que cocotb (Python) pueda controlar las señales del chip.
*/
module tb ();

  // Generación del archivo de ondas para depuración
  initial begin
    $dumpfile("tb.fst");
    $dumpvars(0, tb);
    #1;
  end

  // Declaración de señales para conectar al chip
  reg clk;
  reg rst_n;
  reg ena;
  reg [7:0] ui_in;
  reg [7:0] uio_in;
  wire [7:0] uo_out;
  wire [7:0] uio_out;
  wire [7:0] uio_oe;

`ifdef GL_TEST
  wire VPWR = 1'b1;
  wire VGND = 1'b0;
`endif

  // --- INSTANCIACIÓN DE TU PROYECTO ---
  // Se reemplaza tt_um_example por tu nombre de módulo único
  tt_um_contador_3digitos_7seg user_project (

`ifdef GL_TEST
      .VPWR(VPWR),
      .VGND(VGND),
`endif

      .ui_in  (ui_in),    // Entradas dedicadas
      .uo_out (uo_out),   // Salidas dedicadas (Segmentos)
      .uio_in (uio_in),   // Entradas de los pines E/S
      .uio_out(uio_out),  // Salidas de los pines E/S (Dígitos)
      .uio_oe (uio_oe),   // Control de dirección de los pines E/S
      .ena    (ena),      // Habilitación del diseño
      .clk    (clk),      // Reloj
      .rst_n  (rst_n)     // Reset (activo en bajo)
  );

endmodule
