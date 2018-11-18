----------------------------------------------------------------------------------
-- CONTADOR DE 1 SEGUNDO
--
-- Contador que activa la salida cada vez que transcurre
-- un segundo. Se utiliza como módulo auxiliar para el
-- contador de tiempo.
----------------------------------------------------------------------------------
library IEEE;       --Librerias                    
use IEEE.STD_LOGIC_1164.ALL; 
use IEEE.STD_LOGIC_ARITH.ALL; 
use IEEE.STD_LOGIC_UNSIGNED.ALL; 


entity contador_1s is
  Port ( clk : in  STD_LOGIC;  --Reloj de la FPGA
           rst_cnt : in  STD_LOGIC; --Señal de reset
           cnt_1s : out  STD_LOGIC); --Salida del contador
end contador_1s;

architecture Behavioral of contador_1s is

--Declaración de señales

signal contador : STD_LOGIC_VECTOR(25 downto 0) := "00000000000000000000000000"; --señal que guarda la cuenta


begin

		process (clk) 	--Proceso que cuenta
		begin
			if (clk'event and clk='1') then
				cnt_1s <= '0'; --Pone la señal de salida a 0 en cada flanco de subida
				contador <= contador + '1'; --El contador se incrementa
				if (contador >= 50000000) then --El reloj de la FPGA tiene T = 20ns
					cnt_1s <= '1'; --Cuando transcurran 1s habrán pasado 5e7 periodos
					contador <= (others => '0');	--Al transcurrir 1s se activa la salida y se reinicia el contador
				end if;
				if (rst_cnt = '1') then --Si está activa la entrada rst_cnt (reset)
					cnt_1s <= '0';	--Se pone la salida a 0
					contador <= (others => '0');	--y se reinicia el contador	
				end if;
			end if;
		end process;

end Behavioral;

