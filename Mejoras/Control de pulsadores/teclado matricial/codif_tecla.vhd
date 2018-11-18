----------------------------------------------------------------------------------
-- BLOQUE DE CODIFICACIÓN DE TECLA
-- 
-- Recibe la tecla pulsada y si es válida o no.
-- En función de la tecla, y de si es válida,
-- modifica el valor del código introducido por el usuario
----------------------------------------------------------------------------------
library IEEE;                         
use IEEE.STD_LOGIC_1164.ALL; 
use IEEE.STD_LOGIC_ARITH.ALL; 
use IEEE.STD_LOGIC_UNSIGNED.ALL; 


entity codif_tecla is
    Port ( tecla : in  STD_LOGIC_VECTOR (3 downto 0);	--Tecla pulsada
           valida : in  STD_LOGIC;	--Tecla válida o no
           Up0 : out  STD_LOGIC;	--Incrementar en 1 el código
           Down0 : out  STD_LOGIC;	--Disminuir en 1 el código
           Up1 : out  STD_LOGIC;	--Incrementar en 10 el código
           Down1 : out  STD_LOGIC);	--Disminuir en 10 el código
end codif_tecla;

architecture Behavioral of codif_tecla is

begin

	process(tecla,valida)
	begin
		Up0 <= '0';
		Up1 <= '0';
		Down0 <= '0';
		Down1 <= '0';
		if(valida = '1') then
			if (tecla = "0010") then	--Si tecla "2" suma 1
				Up0 <= '1';
			elsif (tecla = "0100") then	--Si tecla "4" suma 10
				Up1 <= '1';
			elsif (tecla = "0110") then	--Si tecla"6" resta 1
				Down0 <= '1';
			elsif (tecla = "1000") then	--Si tecla "8" resta 10
				Down1 <= '1';
			else
				Up0 <= '0';
				Up1 <= '0';
				Down0 <= '0';
				Down1 <= '0';
			end if;
		end if;
	end process;

end Behavioral;

