## How it works

Este proyecto es un contador digital de 8 bits que visualiza valores del **0 al 255** en tres displays de 7 segmentos utilizando multiplexación.

El sistema consta de tres etapas principales:
1.  **Divisor de Frecuencia:** Reduce el reloj maestro de 50 MHz para obtener una velocidad de conteo de 4 Hz y una frecuencia de multiplexación de 1 kHz para evitar el parpadeo en los displays.
2.  **Lógica Binario a BCD:** Utiliza el algoritmo "Double Dabble" (Shift-and-Add-3) para convertir el valor binario del contador (8 bits) en dígitos individuales para unidades, decenas y centenas.
3.  **Multiplexor de Salida:** Alterna rápidamente entre los tres dígitos, activando los segmentos correspondientes (`uo_out`) y seleccionando el ánodo/cátodo común a través de los pines bidireccionales (`uio_out`).

## How to test

Para probar el contador, sigue estos pasos:
1.  **Reset:** Al iniciar, mantén el pin `rst_n` en bajo (0) momentáneamente para inicializar el contador en cero. Luego, cámbialo a alto (1).
2.  **Conteo:** El contador comenzará a incrementar automáticamente a una tasa de 4 Hz. Observarás cómo los números avanzan de 0 a 255.
3.  **Rollover:** Una vez que el contador llegue a 255, se reiniciará automáticamente a 0 en el siguiente pulso.
4.  **Verificación de Reset:** En cualquier momento del conteo, puedes poner `rst_n` en bajo y confirmar que el display regresa instantáneamente a "000".

## External hardware

Para visualizar el proyecto físicamente, se requiere:
* **Display de 7 segmentos (3 dígitos):** Ya sea de cátodo o ánodo común.
* **Resistencias de limitación de corriente:** (220-330 ohms) para cada uno de los 7 segmentos.
* **Transistores (Opcional):** Dependiendo de la corriente del display, para los pines de selección de dígito (`uio[0:2]`).
* **Conexiones:**
    * `uo_out[0:6]` -> Segmentos A hasta G.
    * `uio_out[0:2]` -> Pines de selección de dígito (Unidades, Decenas, Centenas).
