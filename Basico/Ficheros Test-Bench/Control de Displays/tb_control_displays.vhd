--------------------------------------------------------------------------------
-- TEST BENCH DE CONTROL DE DISPLAYS
--
-- Bloque de pruebas del control displays
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
 
ENTITY tb_control_displays IS
END tb_control_displays;
 
ARCHITECTURE behavior OF tb_control_displays IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT control_displays
    PORT(
         f : IN  std_logic_vector(5 downto 0);
         clk : IN  std_logic;
         Disp0 : OUT  std_logic;
         Disp1 : OUT  std_logic;
         Disp2 : OUT  std_logic;
         Disp3 : OUT  std_logic;
         Seg7 : OUT  std_logic_vector(6 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal f : std_logic_vector(5 downto 0) := (others => '0');
   signal clk : std_logic := '0';

 	--Outputs
   signal Disp0 : std_logic;
   signal Disp1 : std_logic;
   signal Disp2 : std_logic;
   signal Disp3 : std_logic;
   signal Seg7 : std_logic_vector(6 downto 0);

   -- Reloj de periodo 20 ns
   constant clk_period : time := 20 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: control_displays PORT MAP (
          f => f,
          clk => clk,
          Disp0 => Disp0,
          Disp1 => Disp1,
          Disp2 => Disp2,
          Disp3 => Disp3,
          Seg7 => Seg7
        );

   -- Generación del reloj
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
		f <= "000000";	--valor inicial 0
      wait for 100 ms;	
		f <= "001010"; --Incremento en 10
		wait for 100 ms;
		f <= "001001";	--Decremento en 1
		wait for 100 ms;
		f <= "000000";	--Hago un reset en pulsadores

      wait;
   end process;

END;
