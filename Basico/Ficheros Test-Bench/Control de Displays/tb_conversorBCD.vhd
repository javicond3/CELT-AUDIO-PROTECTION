--------------------------------------------------------------------------------
-- TEST BENCH DE CONTROL DE CONVERSOR BCD
--
-- Bloque de pruebas del conversor binario-BCD
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
 
ENTITY tb_conversorBCD IS
END tb_conversorBCD;
 
ARCHITECTURE behavior OF tb_conversorBCD IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT conversorBCD
    PORT(
         clk : IN  std_logic;
         b : IN  std_logic_vector(5 downto 0);
         D0 : OUT  std_logic_vector(3 downto 0);
         D1 : OUT  std_logic_vector(3 downto 0);
         D2 : OUT  std_logic_vector(3 downto 0);
         D3 : OUT  std_logic_vector(3 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal b : std_logic_vector(5 downto 0) := (others => '0');

 	--Outputs
   signal D0 : std_logic_vector(3 downto 0);
   signal D1 : std_logic_vector(3 downto 0);
   signal D2 : std_logic_vector(3 downto 0);
   signal D3 : std_logic_vector(3 downto 0);

   -- Reloj de periodo 20 ns
   constant clk_period : time := 20 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: conversorBCD PORT MAP (
          clk => clk,
          b => b,
          D0 => D0,
          D1 => D1,
          D2 => D2,
          D3 => D3
        );

   -- Generación del reloj
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
      b <= "000000";	--Inicializamos el valor binario a 0
      wait for 20 ms;	
		b <= "001010"; --Fijamos a 10
		wait for 20 ms;
		b <= "100000"; --Fijamos a 32
		wait for 20 ms;
		b <= "110011"; --fijamos a 51
		wait for 20 ms;
		b <= "000000"; --Volvemos al valor 0
      wait;
   end process;

END;
