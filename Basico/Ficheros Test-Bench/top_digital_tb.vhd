--------------------------------------------------------------------------------
-- TEST BENCH DEL FICHERO TOP DIGITAL
--
-- Bloque de pruebas de top_digital
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
 
ENTITY top_digital_tb IS
END top_digital_tb;
 
ARCHITECTURE behavior OF top_digital_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT top_digital
    PORT(
         clk : IN  std_logic;
         Puls : IN  std_logic_vector(3 downto 0);
         SW : IN  std_logic_vector(5 downto 0);
         Rst : IN  std_logic;
         Disp : OUT  std_logic_vector(3 downto 0);
         Seg7 : OUT  std_logic_vector(6 downto 0);
         DOUT : IN  std_logic;
         CS0 : OUT  std_logic;
         CS1 : OUT  std_logic;
         DIN : OUT  std_logic;
         SCLK : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal Puls : std_logic_vector(3 downto 0) := (others => '0');
   signal SW : std_logic_vector(5 downto 0) := (others => '0');
   signal Rst : std_logic := '0';
   signal DOUT : std_logic := '0';

 	--Outputs
   signal Disp : std_logic_vector(3 downto 0);
   signal Seg7 : std_logic_vector(6 downto 0);
   signal CS0 : std_logic;
   signal CS1 : std_logic;
   signal DIN : std_logic;
   signal SCLK : std_logic;

   -- Reloj de periodo 20 ns
   constant clk_period : time := 20 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: top_digital PORT MAP (
          clk => clk,
          Puls => Puls,
          SW => SW,
          Rst => Rst,
          Disp => Disp,
          Seg7 => Seg7,
          DOUT => DOUT,
          CS0 => CS0,
          CS1 => CS1,
          DIN => DIN,
          SCLK => SCLK
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
		Rst<='1';	--Reset inicial e inicialización
		Puls<= "0000";
		SW <= "000000";
		Dout <= '1';
      wait for 100 ns;	
		Rst<='0';
		wait for 125 us; --Toma primera muestra
		wait for 16 us; --Envío petición
		DOUT <= '0';	--Recepción del dato "000011110000"
		wait for 10 us;
		DOUT <= '1';
		wait for 8 us;
		DOUT <= '0';
		wait for 10 us;
		wait for clk_period; --Actúa encriptador (b = sw)
		wait for 32 us; --Actúa control_DAC
		Puls <= "0001"; --Se incrementa en uno el código
		wait for 44980 ns; --Se toma la siguiente muestra
		wait for 125*800 us; --Se esperan 125 periodos de muestreo
		Puls <= "0000";
		wait for 16 us; --Envío petición
		DOUT <= '0';	--Recepción del dato "000000011100"
		wait for 16 us;
		DOUT <= '1';
		wait for 6 us;
		DOUT <= '0';
		wait for 6 us;
		wait for clk_period; --Actúa encriptador (b distinto de sw)
		wait for 32 us; --Actúa control_DAC


      wait;
   end process;

END;
