----------------------------------------------------------------------------------
-- CONTADOR DE 5 MS
-- 
-- Reloj que activa cada 5 ms una se�al y la mantiene activa 
-- durante un ciclo de clk.
-- Se usa para cambiar  cada 5 ms la se�al de control de un 
-- multiplexor en el bloque "visualizaci�n".
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity contador_5ms is							
    Port ( clk : in  STD_LOGIC;				--Reloj de la FPGA
           cnt_5ms : out  STD_LOGIC);		--Salida del contador (activada cada 5 ms)
end contador_5ms;

architecture Behavioral of contador_5ms is

--Se�al que lleva la cuenta

signal contador : STD_LOGIC_VECTOR(21 downto 0) := "0000000000000000000000"; 

begin
	CONT: process (CLK)									--Activa la se�al cnt_5ms cada 5 ms
		begin													--La deja activa solo durante un ciclo de reloj
			if (CLK'event and CLK='1') then
				cnt_5ms <= '0';							--Pone a 0 la se�al de salida cnt_5ms
				contador <= contador +1; 				--incremento del contador en cada ciclo de reloj
				if (contador>=250000) then				--En 250000 ciclos pasan 5ms
				contador <= (others => '0');
				cnt_5ms <= '1';  							--Genera un pulso al cabo de 5ms
				end if;										
			end if;
		end process;
	
end Behavioral;

