--------------------------------------------------------------------------------
-- TEST BENCH DE CONTROL DEL ADC
--
-- Bloque de pruebas de control_ADC
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
ENTITY tb_control_ADC IS
END tb_control_ADC;
 
ARCHITECTURE behavior OF tb_control_ADC IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT control_ADC
    PORT(
         clk : IN  std_logic;
         Rst : IN  std_logic;
         start_ADC : IN  std_logic;
         DOUT : IN  std_logic;
         end_ADC : OUT  std_logic;
         SCLK : BUFFER  std_logic;
         CS0 : OUT  std_logic;
         DIN : OUT  std_logic;
         valor_ADC : OUT  std_logic_vector(11 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal Rst : std_logic := '0';
   signal start_ADC : std_logic := '0';
   signal DOUT : std_logic := '0';

 	--Outputs
   signal end_ADC : std_logic;
   signal SCLK : std_logic;
   signal CS0 : std_logic;
   signal DIN : std_logic;
   signal valor_ADC : std_logic_vector(11 downto 0);

   -- Clock period definitions
   constant clk_period : time := 20 ns;
  
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: control_ADC PORT MAP (
          clk => clk,
          Rst => Rst,
          start_ADC => start_ADC,
          DOUT => DOUT,
          end_ADC => end_ADC,
          SCLK => SCLK,
          CS0 => CS0,
          DIN => DIN,
          valor_ADC => valor_ADC
        );


   -- reset signal generation
   rst <= '1', '0' after 500 ns;

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 
  
   -- start_adc signal generation (8 kHz)
   s_start_adc_process :process
   begin
		start_adc <= '0';
		wait for 125 us;
		start_adc <= '1';
		wait for 20 ns;
		start_adc <= '0';
   end process;


   -- DOUT generation (ADC response)
   DOUT_response: process
	  variable adc_value : std_logic_vector(11 downto 0);
	  variable dout_value : std_logic_vector(15 downto 0);
   begin		
		dout <= '0';
      wait for 1 ns;

      -- PRIMER DATO ADC
      wait until CS0'event and CS0 = '0';
		adc_value := x"f0f";   							-- VALOR: "1111 0000 1111"
		dout_value := '0' & adc_value & "000";    -- construye la trama de 16 bits 
      for i in 0 to 7 loop
  		  dout <= '0';
        wait until SCLK'event and SCLK = '0';   -- espera la peticion
		end loop;
      for i in 15 downto 0 loop
		  dout <= dout_value(i);
        wait until SCLK'event and SCLK = '0';   -- entrega 1 bit
		end loop;

      -- SEGUNDO DATO ADC
      wait until CS0'event and CS0 = '0';
		adc_value := x"335";   						   -- VALOR: "0011 0011 0101"
		dout_value := '0' & adc_value & "000";    -- construye la trama
      for i in 0 to 7 loop
  		  dout <= '0';
        wait until SCLK'event and SCLK = '0';   -- espera la peticion
		end loop;
      for i in 15 downto 0 loop
		  dout <= dout_value(i);
        wait until SCLK'event and SCLK = '0';   -- entrega 1 bit
		end loop;

      -- TERCER DATO ADC
      wait until CS0'event and CS0 = '0';
		adc_value := x"b5d";   							-- VALOR: "1011 0101 1101"
		dout_value := '0' & adc_value & "000";    -- construye la trama
      for i in 0 to 7 loop
  		  dout <= '0';
        wait until SCLK'event and SCLK = '0';   -- espera la peticion
		end loop;
      for i in 15 downto 0 loop
		  dout <= dout_value(i);
        wait until SCLK'event and SCLK = '0';   -- entrega 1 bit
		end loop;

		dout<='0';
		wait for 50 us;
		
      wait;
   end process;


END;
