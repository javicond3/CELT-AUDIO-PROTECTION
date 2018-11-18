----------------------------------------------------------------------------------
-- BLOQUE DE PULSACIÓN DE TECLA
--
-- Recibe la columna y la fila activa en cada momento
-- y si se ha pulsado alguna tecla (pulsación)
-- A la salida saca a qué tecla se corresponde
-- Y si la tecla es válida (2,4,6 u 8)
----------------------------------------------------------------------------------
library IEEE;                         
use IEEE.STD_LOGIC_1164.ALL; 
use IEEE.STD_LOGIC_ARITH.ALL; 
use IEEE.STD_LOGIC_UNSIGNED.ALL; 


entity tecla_pulsada is
    Port ( columna : in  STD_LOGIC_VECTOR (1 downto 0);	--Columna activa
           fila : in  STD_LOGIC_VECTOR (1 downto 0);	--Fila activa
           pulsacion : in  STD_LOGIC;	--Tecla pulsada o no
           tecla : out  STD_LOGIC_VECTOR (3 downto 0);	--Tecla activada
           valida : out  STD_LOGIC);	--Tecla válida o no
end tecla_pulsada;

architecture Behavioral of tecla_pulsada is

begin

process(fila,columna,pulsacion)	--Elección de tecla
begin
	if(pulsacion = '1') then	--Si hay tecla pulsada, selecciona la tecla
		if(fila = "00") then
			case columna is																
				when "00" => valida <= '0'; tecla <= "0001";		--Tecla 1
				when "01" => valida <= '1'; tecla <= "0010";		--Tecla 2
				when "10" => valida <= '0'; tecla <= "0011";		--Tecla 3
				when "11" => valida <= '0'; tecla <= "1100";		--Tecla C
				when others => valida <= '0';
			end case;
		elsif(fila = "01") then
			case columna is																
				when "00" => valida <= '1'; tecla <= "0100";		--Tecla 4
				when "01" => valida <= '0'; tecla <= "0101";		--Tecla 5
				when "10" => valida <= '1'; tecla <= "0110";		--Tecla 6
				when "11" => valida <= '0'; tecla <= "1101";		--Tecla D
				when others => valida <= '0';
			end case;
		elsif(fila = "10") then
			case columna is																
				when "00" => valida <= '0'; tecla <= "0111";		--Tecla 7
				when "01" => valida <= '1'; tecla <= "1000";		--Tecla 8
				when "10" => valida <= '0'; tecla <= "1001";		--Tecla 9
				when "11" => valida <= '0'; tecla <= "1110";		--Tecla E
				when others => valida <= '0';
			end case;
		elsif(fila = "11") then
			case columna is																
				when "00" => valida <= '0'; tecla <= "1010";		--Tecla A
				when "01" => valida <= '0'; tecla <= "0000";		--Tecla 0
				when "10" => valida <= '0'; tecla <= "1011";		--Tecla B
				when "11" => valida <= '0'; tecla <= "1111";		--Tecla F
				when others => valida <= '0';
			end case;
		else 
			valida <= '0';
			tecla <= "0000";
		end if;
	else 
		valida <= '0';
		tecla <= "0000";
	end if;
end process;


end Behavioral;

