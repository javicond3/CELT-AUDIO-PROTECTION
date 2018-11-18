--------------------------------------------------------------------------------
-- TEST BENCH DEL REGISTRO REG_B
--
-- Bloque de pruebas del registro que contiene el valor "b"
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 

ENTITY tb_Reg_b IS
END tb_Reg_b;
 
ARCHITECTURE behavior OF tb_Reg_b IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT Reg_b
    PORT(
         clk : IN  std_logic;
         rst_b : IN  std_logic;
         en_b : IN  std_logic;
         sel : IN  std_logic_vector(1 downto 0);
         b : OUT  std_logic_vector(5 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal rst_b : std_logic := '0';
   signal en_b : std_logic := '0';
   signal sel : std_logic_vector(1 downto 0) := (others => '0');

 	--Outputs
   signal b : std_logic_vector(5 downto 0);

   -- Reloj de periodo 20 ns
   constant clk_period : time := 20 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: Reg_b PORT MAP (
          clk => clk,
          rst_b => rst_b,
          en_b => en_b,
          sel => sel,
          b => b
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
      rst_b <= '1'; --Reset inicial
      wait for 100 ns;	
		rst_b <= '0';
		en_b <= '0';
		sel <= "00";
		wait for 100 ms;
		en_b <= '1';	--Incremento de 1 en b
		wait for clk_period;
		en_b <= '0';
		wait for 100 ms;
		sel <= "10";	--Incremento de 10 en b
		en_b <= '1';
		wait for clk_period;
		en_b <= '0';
		sel <= "00";
		wait for 50 ms;
		rst_b <= '1';	--Activación del Reset
		wait for 500 ns;
		rst_b <= '0';
		
      wait;
   end process;

END;
