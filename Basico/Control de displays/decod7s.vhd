----------------------------------------------------------------------------------
-- DECODIFICADOR BCD A 7 SEGMENTOS
-- 
-- Módulo auxiliar para la conversión de binario
-- a 7 segmentos
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity decod7s is
		port ( DIN : in STD_LOGIC_VECTOR (3 downto 0); -- entrada de datos
				 S7SEG : out STD_LOGIC_VECTOR (6 downto 0)); -- salidas 7seg (abcdefg)
end decod7s;
architecture a_decod7s of decod7s is
begin
 with DIN select S7SEG <=	--Asignación de 7 segmentos
	"1000000" when "0000",
	"1111001" when "0001",
	"0100100" when "0010",
	"0110000" when "0011",
	"0011001" when "0100",
	"0010010" when "0101",
	"0000010" when "0110",
	"1111000" when "0111",
	"0000000" when "1000",
	"0011000" when "1001",
	"1111111" when others;
end a_decod7s; 

