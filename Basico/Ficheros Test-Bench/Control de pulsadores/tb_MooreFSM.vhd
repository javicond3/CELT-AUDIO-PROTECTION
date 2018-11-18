--------------------------------------------------------------------------------
-- TEST BENCH DE MOORE-FSM
--
-- Bloque de pruebas del autómata de Moore
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
 
ENTITY tb_MooreFSM IS
END tb_MooreFSM;
 
ARCHITECTURE behavior OF tb_MooreFSM IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT MooreFSM
    PORT(
         clk : IN  std_logic;
         Up0 : IN  std_logic;
         Down0 : IN  std_logic;
         Up1 : IN  std_logic;
         Down1 : IN  std_logic;
         Rst : IN  std_logic;
         cnt_100ms : IN  std_logic;
         rst_b : OUT  std_logic;
         rst_cnt : OUT  std_logic;
         en_cnt : OUT  std_logic;
         en_b : OUT  std_logic;
         sel : OUT  std_logic_vector(1 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal Up0 : std_logic := '0';
   signal Down0 : std_logic := '0';
   signal Up1 : std_logic := '0';
   signal Down1 : std_logic := '0';
   signal Rst : std_logic := '0';
   signal cnt_100ms : std_logic := '0';

 	--Outputs
   signal rst_b : std_logic;
   signal rst_cnt : std_logic;
   signal en_cnt : std_logic;
   signal en_b : std_logic;
   signal sel : std_logic_vector(1 downto 0);

   -- Reloj de periodo 20 ns
   constant clk_period : time := 20 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: MooreFSM PORT MAP (
          clk => clk,
          Up0 => Up0,
          Down0 => Down0,
          Up1 => Up1,
          Down1 => Down1,
          Rst => Rst,
          cnt_100ms => cnt_100ms,
          rst_b => rst_b,
          rst_cnt => rst_cnt,
          en_cnt => en_cnt,
          en_b => en_b,
          sel => sel
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
      Rst <= '1';	--Reset inicial
      wait for 100 ns;	
		Rst <= '0';	
		cnt_100ms <= '0';
		Up0 <= '1'; --Se pulsa para incrementar 1
      wait for 100 ms;
		Up0 <= '0';
		cnt_100ms <= '1'; --El contador habrá contado ya 100 ms
		wait for 20 ns;	
		cnt_100ms <= '0';	--Se desactiva el flag del contador
		wait for 100 ns;
		Up1 <= '1'; --Se pulsa para incrementar 10
		wait for 100 ms;
		Up1 <= '0';
		cnt_100ms <= '1'; --El contador habrá contado ya 100 ms
		wait for 20 ns;	
		cnt_100ms <= '0';	--Se desactiva el flag del contador
		wait for 100 ns;
		Down1 <= '1'; --Se pulsa para decrementar 10
		wait for 100 ms;
		Down1 <= '0';
		cnt_100ms <= '1'; --El contador habrá contado ya 100 ms
		wait for 20 ns;	
		cnt_100ms <= '0';	--Se desactiva el flag del contador
		wait for 100 ns;
		Down0 <= '1'; --Se pulsa para decrementar 1
		wait for 100 ms;
		Down0 <= '0';
		cnt_100ms <= '1'; --El contador habrá contado ya 100 ms
		wait for 20 ns;	
		cnt_100ms <= '0';	--Se desactiva el flag del contador
		wait for 100 ns;
		Rst <= '1';	--Se resetea el sistema
		wait for 100 ns;
		Rst <= '0';

      wait;
   end process;

END;
