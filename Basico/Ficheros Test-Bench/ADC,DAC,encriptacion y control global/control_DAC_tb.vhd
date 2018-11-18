--------------------------------------------------------------------------------
-- TEST BENCH DE CONTROL DEL DAC
--
-- Bloque de pruebas de control_DAC
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
 
ENTITY control_DAC_tb IS
END control_DAC_tb;
 
ARCHITECTURE behavior OF control_DAC_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT control_DAC
    PORT(
         clk : IN  std_logic;
         Rst : IN  std_logic;
         start_DAC : IN  std_logic;
         end_DAC : OUT  std_logic;
         valor_DAC : IN  std_logic_vector(11 downto 0);
         CS1 : OUT  std_logic;
         SCLK : BUFFER  std_logic;
         DIN : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal Rst : std_logic := '0';
   signal start_DAC : std_logic := '0';
   signal valor_DAC : std_logic_vector(11 downto 0) := (others => '0');

 	--Outputs
   signal end_DAC : std_logic;
   signal CS1 : std_logic;
   signal SCLK : std_logic;
   signal DIN : std_logic;

   -- Reloj de periodo 20 ns
   constant clk_period : time := 20 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: control_DAC PORT MAP (
          clk => clk,
          Rst => Rst,
          start_DAC => start_DAC,
          end_DAC => end_DAC,
          valor_DAC => valor_DAC,
          CS1 => CS1,
          SCLK => SCLK,
          DIN => DIN
        );

	-- reset inicial
   rst <= '1', '0' after 500 ns;

   -- Generación de la señal de reloj
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 
  
   -- Generación de la señal start_dac cada 125us (8 kHz)
   s_start_dac_process :process
   begin
		start_dac <= '0';
		wait for 125 us;
		start_dac <= '1';
		wait for 20 ns;
		start_dac <= '0';
   end process;
	
	
 

   -- Simulación
   stim_proc: process
   begin		
      
		wait for 125 us;
		valor_DAC <= "110011001111"; --Envía este valor al DAC
		wait for 125 us; --Siguiente valor
		valor_DAC <= "111100001111"; --Envía este otro valor al DAC
		wait for 125 us; --Siguiente valor
		valor_DAC <= "101010100101"; --Envía este otro valor al DAC
      wait;
   end process;

END;
