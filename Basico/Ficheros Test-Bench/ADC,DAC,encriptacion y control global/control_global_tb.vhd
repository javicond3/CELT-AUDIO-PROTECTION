--------------------------------------------------------------------------------
-- TEST BENCH DE CONTROL GLOBAL
--
-- Bloque de pruebas de control_global
--------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

 
 
ENTITY control_global_tb IS
END control_global_tb;
 
ARCHITECTURE behavior OF control_global_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT control_global
    PORT(
         clk : IN  std_logic;
         Rst : IN  std_logic;
         start_ADC : OUT  std_logic;
         start_random : OUT  std_logic;
         start_DAC : OUT  std_logic;
         end_ADC : IN  std_logic;
         end_random : IN  std_logic;
         end_DAC : IN  std_logic;
         global_st : OUT  std_logic_vector(1 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal Rst : std_logic := '0';
   signal end_ADC : std_logic := '0';
   signal end_random : std_logic := '0';
   signal end_DAC : std_logic := '0';

 	--Outputs
   signal start_ADC : std_logic;
   signal start_random : std_logic;
   signal start_DAC : std_logic;
   signal global_st : std_logic_vector(1 downto 0);

   -- Reloj de periodo 20 ns
   constant clk_period : time := 20 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: control_global PORT MAP (
          clk => clk,
          Rst => Rst,
          start_ADC => start_ADC,
          start_random => start_random,
          start_DAC => start_DAC,
          end_ADC => end_ADC,
          end_random => end_random,
          end_DAC => end_DAC,
          global_st => global_st
        );

   -- Generación de la señal de reloj
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- Simulación
   stim_proc: process
   begin		
      Rst<='1';	--Reset inicial
		wait for 100 ns;
		Rst <= '0';
      wait for 125 us;	--Espera para tomar una muestra
								--ADC funcionando
      wait for 48 us;
		end_ADC <= '1';	--Termina de funcionar el ADC
		wait for clk_period;
		end_ADC <= '0';
		wait for clk_period; --Empieza a funcionar la encriptación
		end_random <='1';	--Termina de funcionar la encriptación
		wait for clk_period;	--Empieza a funcionar el DAC
		end_random <='0';
		wait for 32 us;
		end_DAC<='1'; 	--Termina de funcionar el DAC
		wait for clk_period;
		end_DAC<='0';

      wait;
   end process;

END;
