----------------------------------------------------------------------------------
-- BLOQUE DE CONTROL GLOBAL
-- 
-- Este bloque se encarga de gestionar en qué momento
-- tiene que estar activo cada uno de los bloques
-- que dependen de él (ADC, DAC y encriptación)
-- Como la frecuencia de muestreo es 8 kHz, 
-- el primer bloque se debe iniciar una vez cada 125 us.
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity control_global is
    Port ( clk : in  STD_LOGIC;											--Reloj de la FPGA
           Rst : in  STD_LOGIC;											--Señal de Reset
           start_ADC : out  STD_LOGIC;									--Indica si ADC debe empezar a funcionar
           start_random : out  STD_LOGIC;								--Indica si el encriptador debe empezar a funcionar
           start_DAC : out  STD_LOGIC;									--Indica si el DAC debe empezar a funcionar
           end_ADC : in  STD_LOGIC;										--El ADC indica que ha terminado su función
           end_random : in  STD_LOGIC;									--El encriptador indica que ha terminado su función
           end_DAC : in  STD_LOGIC;										--El DAC indica que ha terminado su función
           global_st : out  STD_LOGIC_VECTOR (1 downto 0));		--Variable de estado. Indica qué bloque está funcionando
end control_global;

architecture Behavioral of control_global is

signal st : std_logic_vector(1 downto 0) := "00";							--Valor de global_st
signal fin_de_cuenta : std_logic := '0';										--Salida del contador de 125 us
signal contador : std_logic_vector(12 downto 0) := "0000000000000";	--Valor del contador de 125 us

begin

	process (clk,Rst) 		--contador 125 us
		begin
			if (clk'event and clk='1') then
				fin_de_cuenta <= '0'; 				--Pone la señal de salida a 0 en cada flanco de subida
				contador <= contador + '1'; 		--Si enable está activa, el contador se incrementa
				if (contador >= 6250) then 		--El reloj de la FPGA tiene T = 20ns
					fin_de_cuenta <= '1'; 			--Cuando transcurra 125 us habrán pasado 6250 periodos
					contador <= (others => '0');	--Al transcurrir 125 us se activa la salida y se reinicia el contador
				end if;
			end if;
			if(Rst = '1') then						--Si hay un reset reinicia la cuenta y pone a 0 la salida
				contador <= (others => '0');
				fin_de_cuenta <= '0';
			end if;
		end process;
	
	process(clk, Rst)
	begin
		if(Rst = '1') then
				start_ADC <= '0';								--Cuando hay un reset, inicializa todas las señales
				start_random <= '0';
				start_DAC <= '0';	
				st <= "00";
		elsif (clk'event and clk = '1') then
			case st is
				when "00" => 		--Esperando nuevo procesamiento (Estado 00)
				start_ADC <= '0';
				start_random <= '0';
				start_DAC <= '0';
				if(fin_de_cuenta = '1') then		--Tras 125us empezará a funcionar el control del ADC
						start_ADC <= '1';
						st <= "01";
					end if;
				when "01" => 		--Captura de datos ADC (Estado 01)
					start_ADC <= '0';
					if(end_ADC = '1') then			--Cuando termina el control del ADC, comienza a funcionar el encriptador
						start_random <= '1';
						st <= "11";
					end if;
				when "11" => 		--Procesamiento de datos en bloque de encriptación (Estado 11)
					start_random <= '0';
					if(end_random = '1') then		--Cuando termina el encriptador, se envían los datos al ADC
						start_DAC <= '1';
						st <= "10";
					end if;
				when "10" => 		--Enviando datos al DAC (Estado 10)
				start_DAC <= '0';
					if(end_DAC = '1') then			--Cuando termina el control del DAC, se vuelve al estado 00
						st <= "00";
					end if;
				when others =>		--Si ocurre algo inesperado se vuelve al estado de reposo 00
					st <= "00";
			end case;
		end if;
	end process;

	global_st <= st;		--Asignación de la salida global_st
end Behavioral;

