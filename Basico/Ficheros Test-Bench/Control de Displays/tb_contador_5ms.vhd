--------------------------------------------------------------------------------
-- TEST BENCH DE CONTROL DE CONTADOR 5 MS
--
-- Bloque de pruebas del contador de 5 ms
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
 
ENTITY tb_contador_5ms IS
END tb_contador_5ms;
 
ARCHITECTURE behavior OF tb_contador_5ms IS 
 
 
    COMPONENT contador_5ms
    PORT(
         clk : IN  std_logic;
         cnt_5ms : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';

 	--Outputs
   signal cnt_5ms : std_logic;

   -- Reloj de periodo 20 ns
   constant clk_period : time := 20 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: contador_5ms PORT MAP (
          clk => clk,
          cnt_5ms => cnt_5ms
        );

   -- Generación de la señal de reloj
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
			--Basta con esperar, y comprobar que cada 5 ms se activa la salida
      wait;
   end process;

END;
