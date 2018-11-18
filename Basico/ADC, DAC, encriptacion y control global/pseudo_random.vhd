----------------------------------------------------------------------------------
-- BLOQUE DE ENCRIPTACI�N DE LA SE�AL 
--  
-- Se encarga de comprobar si el c�digo introducido en los pulsadores
-- es igual que el c�digo fijado en los switches o no.
-- Si son iguales, la salida ser� la se�al de entrada generada por el ADC.
-- Si no coinciden, la salida del bloque ser� una se�al pseudo-aleatoria,
-- generada por un registro de desplazamiento con realimentaci�n lineal (LFSR).
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity pseudo_random is
    Port ( clk : in  STD_LOGIC;	--Reloj de la FPGA
           Rst : in  STD_LOGIC;	--Se�al de Reset
           start_random : in  STD_LOGIC;	--Indica el inicio de operaci�n del bloque
           end_random : out  STD_LOGIC;	--Indica el fin de operaci�n del bloque
           sw : in  STD_LOGIC_VECTOR (5 downto 0);	--Valor binario procedente de los switches
           b : in  STD_LOGIC_VECTOR (5 downto 0);	--Valor binario procedente de los pulsadores
           valor_ADC : in  STD_LOGIC_VECTOR (11 downto 0);	--Valor de entrada al bloque (generado por el ADC)
           valor_DAC : out  STD_LOGIC_VECTOR (11 downto 0));--Valor de salida del bloque (se entregar� al DAC)
end pseudo_random;

architecture Behavioral of pseudo_random is

--Declaraci�n de se�ales

signal lfsr : std_logic_vector(15 downto 0) := "1101000111100101";	--Se�al pseudo-aleatoria
signal bitAleatorio : std_logic := '0';	--Bit salida del circuito de puertas XOR del lfsr


begin
	
	process(clk, Rst) --Generaci�n se�al pseudo-aleatoria
	begin
		if (clk'event and clk = '1') then
			bitAleatorio <= ((lfsr(15) xor lfsr(13)) xor lfsr(12)) xor lfsr(10);	--Bit a introducir en el lfsr
			lfsr <= lfsr(14 downto 0)&bitAleatorio; --Desplaza los 14 bits menos significativos
			if (Rst = '1') then		--Inicializaci�n de lfsr tras reset
				lfsr <= "1101000111100101";	--(No es necesario, se usa para pruebas)
			end if;
		end if;
	end process;
	
	process(Rst,clk) 		--Asignaci�n de la salida
	begin
		if (clk'event and clk = '1') then
			end_random <='0';
			if(start_random = '1') then	--Comprueba si los valores de pulsadores y switches coinciden
				if (b=sw) then	--Si coinciden, la salida ser� el valor procedente del ADC
					valor_DAC <= valor_ADC + "100000000000";  --Suma 0x800 = 2048 = 0b100000000000
				else	--Si no, la salida ser� la se�al pseudo-aleatoria del lfsr
					valor_DAC <= lfsr(11 downto 0);
				end if;
				end_random <= '1';	--Indica que ha terminado de realizar su funci�n
			end if;
		end if;
		if (Rst = '1') then	--Si hay un Reset, indica que no ha terminado de funcionar (prevenci�n)
			end_random <= '0';
		end if;
	end process;
	
end Behavioral;

