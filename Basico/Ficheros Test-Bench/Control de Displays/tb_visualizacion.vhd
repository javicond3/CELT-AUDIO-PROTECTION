--------------------------------------------------------------------------------
-- TEST BENCH DE CONTROL DE VISUALIZACIÓN
--
-- Bloque de pruebas de visualizacion
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
 
ENTITY tb_visualizacion IS
END tb_visualizacion;
 
ARCHITECTURE behavior OF tb_visualizacion IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT visualizacion
    PORT(
         clk : IN  std_logic;
         cnt_5ms : IN  std_logic;
         digito0 : IN  std_logic_vector(3 downto 0);
         digito1 : IN  std_logic_vector(3 downto 0);
         digito2 : IN  std_logic_vector(3 downto 0);
         digito3 : IN  std_logic_vector(3 downto 0);
         Disp0 : OUT  std_logic;
         Disp1 : OUT  std_logic;
         Disp2 : OUT  std_logic;
         Disp3 : OUT  std_logic;
         Seg7 : OUT  std_logic_vector(6 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal cnt_5ms : std_logic := '0';
   signal digito0 : std_logic_vector(3 downto 0) := (others => '0');
   signal digito1 : std_logic_vector(3 downto 0) := (others => '0');
   signal digito2 : std_logic_vector(3 downto 0) := (others => '0');
   signal digito3 : std_logic_vector(3 downto 0) := (others => '0');

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
   uut: visualizacion PORT MAP (
          clk => clk,
          cnt_5ms => cnt_5ms,
          digito0 => digito0,
          digito1 => digito1,
          digito2 => digito2,
          digito3 => digito3,
          Disp0 => Disp0,
          Disp1 => Disp1,
          Disp2 => Disp2,
          Disp3 => Disp3,
          Seg7 => Seg7
        );

   -- Generación de la señal de reloj
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
	
	-- Generación de la señal cnt_5ms
   contador_process :process
   begin
		cnt_5ms <= '0';
		wait for 5 ms;
		cnt_5ms <= '1';
		wait for clk_period;
   end process;
 

   -- Simulación
   stim_proc: process
   begin		
      Digito0 <= "0000";	--Fijamos los BCD a 0
		Digito1 <= "0000";
		Digito2 <= "0000";
		Digito3 <= "0000";
      wait for 20 ms;
		Digito2 <= "0001";	--Valor  10 en BCD
		Digito3 <= "0000";
		wait for 100 ms;
		Digito2 <= "0000";	--Valor  9 en BCD
		Digito3 <= "1001";
		wait for 100 ms;
		Digito2 <= "0010";	--Valor  24 en BCD
		Digito3 <= "0100";
		wait for 100 ms;
		Digito2 <= "0000";	--Valor 0 en BCD
		Digito3 <= "0000";
 

      wait;
   end process;

END;
