--------------------------------------------------------------------------------
-- TEST BENCH DEL BLOQUE DE ENCRIPTACIÓN
--
-- Bloque de pruebas de pseudo_random
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
 
ENTITY pseudo_random_tb IS
END pseudo_random_tb;
 
ARCHITECTURE behavior OF pseudo_random_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT pseudo_random
    PORT(
         clk : IN  std_logic;
         Rst : IN  std_logic;
         start_random : IN  std_logic;
         end_random : OUT  std_logic;
         sw : IN  std_logic_vector(5 downto 0);
         b : IN  std_logic_vector(5 downto 0);
         valor_ADC : IN  std_logic_vector(11 downto 0);
         valor_DAC : OUT  std_logic_vector(11 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal Rst : std_logic := '0';
   signal start_random : std_logic := '0';
   signal sw : std_logic_vector(5 downto 0) := (others => '0');
   signal b : std_logic_vector(5 downto 0) := (others => '0');
   signal valor_ADC : std_logic_vector(11 downto 0) := (others => '0');

 	--Outputs
   signal end_random : std_logic;
   signal valor_DAC : std_logic_vector(11 downto 0);

   -- Reloj de periodo 20 ns
   constant clk_period : time := 20 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: pseudo_random PORT MAP (
          clk => clk,
          Rst => Rst,
          start_random => start_random,
          end_random => end_random,
          sw => sw,
          b => b,
          valor_ADC => valor_ADC,
          valor_DAC => valor_DAC
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
      Rst <= '1';	--Reset inicial
		wait for 100 ns;
		Rst <= '0';
		valor_ADC <= "000011110000";	--Se fijan las señales de entrada
		sw <= "100100";	--Coinciden sw y b
		b <= "100100";	--debe ocurrir que valor_DAC = valor_ADC + 0x800
		wait for 190 ns;
		start_random <= '1';	--Comienza a operar el encriptador
      wait for clk_period;
		start_random <= '0';	--Termina de operar el encriptador
		sw <= "101100";
		b <= "100100";	--En este caso no coinciden b y sw
		wait for 100 ns;	--Valor_DAC debe ser la señal pseudoaleatoria
		start_random <= '1';	--Comienza a operar el encriptador
		wait for clk_period;
		start_random <= '0';	--Termina de operar el encriptador

      wait;
   end process;

END;
