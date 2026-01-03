/*`default_nettype none

module tt_um_example (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // always 1 when the design is powered, so you can ignore it
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

  // All output pins must be assigned. If not used, assign to 0.
  assign uo_out  = ui_in + uio_in;  // Example: ou_out is the sum of ui_in and uio_in
  assign uio_out = 0;
  assign uio_oe  = 0;

  // List all unused inputs to prevent warnings
  wire _unused = &{ena, clk, rst_n, 1'b0};

endmodule*/

/*
 * Copyright (c) 2024 Ivan Rodriguez
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

module tt_um_contador_3digitos_7seg (
    input  wire [7:0] ui_in,    // Entradas dedicadas
    output wire [7:0] uo_out,   // Salidas dedicadas (Segmentos)
    input  wire [7:0] uio_in,   // Pines E/S - Entrada
    output wire [7:0] uio_out,  // Pines E/S - Salida (Dígitos)
    output wire [7:0] uio_oe,   // Pines E/S - Habilitación de salida
    input  wire       ena,      // Habilitación del diseño (siempre 1)
    input  wire       clk,      // Reloj principal
    input  wire       rst_n     // Reset (activo en bajo)
);

  // --- 1. DECLARACIÓN DE CABLES INTERNOS ---
  // Estos cables sirven para conectar mi contador con los pines del chip
  wire [6:0] segmentos;
  wire [2:0] digitos;

  // --- 2. INSTANCIACIÓN DEL MÓDULO (Lógica original) ---
  // Aquí mando a llamar al contador que ya fabriqué
  contador_3digitos_7seg contador_3digitos_7seg_Unit (
    .clk(clk),
    .rst_n(rst_n),
    .seg(segmentos),
    .dig(digitos)
  );

  // --- 3. CONEXIONES DE SALIDA (Asignaciones) ---
  
  // Conecto los 7 segmentos a los primeros pines de uo_out
  // El bit 7 lo mando a 0 porque no lo uso
  assign uo_out = {1'b0, segmentos};

  // Conecto los 3 dígitos a los pines de uio_out
  // Los otros 5 bits se quedan en 0
  assign uio_out = {5'b00000, digitos};

  // --- 4. CONFIGURACIÓN DE PINES BIDIRECCIONALES ---
  // Como dice el profe, hay que decirle cuáles pines de I/O son salidas.
  // Pongo en '1' los primeros 3 bits para que funcionen los dígitos.
  assign uio_oe = 8'b0000_0111;

  // --- 5. MANEJO DE ENTRADAS NO USADAS ---
  // Para evitar los "warnings" que menciona el profe en el video,
  // juntamos todas las señales que no usamos.
  wire _unused = &{ena, ui_in, uio_in, 1'b0};

endmodule
