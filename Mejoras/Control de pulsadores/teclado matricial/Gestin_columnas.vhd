----------------------------------------------------------------------------------
-- BLOQUE DE GESTIÓN DE COLUMNAS
-- 
--	Este bloque se encarga de excitar una columna cada 25 ms
-- Y de enviar al bloque de tecla_pulsada la columna excitada
-- para que pueda descifrar que tecla se ha pulsado
----------------------------------------------------------------------------------
library IEEE;                         
use IEEE.STD_LOGIC_1164.ALL; 
use IEEE.STD_LOGIC_ARITH.ALL; 
use IEEE.STD_LOGIC_UNSIGNED.ALL; 


entity Gestin_columnas is
    Port ( clk : in  STD_LOGIC;	--Reloj de la FPGA
           Rst : in  STD_LOGIC;	--Señal de reset
           Col0 : out  STD_LOGIC;	--Excitación columna 0
           Col1 : out  STD_LOGIC;	--Excitación columna 1
           Col2 : out  STD_LOGIC;	--Excitación columna 2
           Col3 : out  STD_LOGIC;	--Excitación columna 3
			  col_activa: out STD_LOGIC_VECTOR(1 downto 0));	--Columna activada
end Gestin_columnas;

architecture Behavioral of Gestin_columnas is

--Señales necesarias

signal contador : STD_LOGIC_VECTOR(23 downto 0) := (others => '0');	--Contador 
signal columna : STD_LOGIC_VECTOR(1 downto 0) := "00";	--Columna excitada

begin

process (clk,rst) --Cambio de columna a excitar cada 25ms
		begin
			if (clk'event and clk='1') then				
				contador <= contador + '1';
				if (contador >= 1250000) then --El reloj de la FPGA tiene T = 20ns
					columna <= columna + 1;	--Cuando transcurran 25 ms habrán pasado 1.255e6 periodos
					contador <= (others => '0');	--Al transcurrir 25 ms se cambia de columna
				end if;
				if (rst = '1') then 	--Si está activa la entrada reset
					columna <= "00";	--Se pone la salida a 0
					contador <= (others => '0');	--y se reinicia el contador	
				end if;
			end if;
		end process;

	process(columna)		--Activa una columna distinta cada 25 ms
	begin
		col0 <= '0'; col1 <= '0'; col2 <= '0'; col3 <= '0'; 
		case columna is																
		when "00" => col0 <= '1';	--Activa 1ª columna
		when "01" => col1 <= '1';	--Activa 2ª columna
		when "10" => col2 <= '1';	--Activa 3ª columna
		when "11" => col3 <= '1';	--Activa 4ª columna
		when others => col0 <= '1';
	end case;
	end process;

	col_activa <= columna;	--Asinación de salidas
	
end Behavioral;

