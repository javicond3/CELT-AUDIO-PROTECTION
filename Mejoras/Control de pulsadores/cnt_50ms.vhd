----------------------------------------------------------------------------------
-- CONTADOR DE 50ms
--
-- Se trata de un simple contador de 50 ms que cada
-- 100ms activa la señal cnt_50ms durante un ciclo de reloj.
-- Necesario para controlar el tiempo entre pulsaciones sucesivas
-- En el autómata de Moore
-- Este contador está implementado como parte de una mejora.
----------------------------------------------------------------------------------
library IEEE;       --Librerias                    
use IEEE.STD_LOGIC_1164.ALL; 
use IEEE.STD_LOGIC_ARITH.ALL; 
use IEEE.STD_LOGIC_UNSIGNED.ALL; 


entity contador_50ms is			
    Port ( clk : in  STD_LOGIC;  --Reloj de la FPGA
           rst_cnt : in  STD_LOGIC; --Entrada reset para el contador
           en_cnt : in  STD_LOGIC; --Entrada para habilitar el contador
           cnt_50ms : out  STD_LOGIC); --Salida del contador
end contador_50ms;

architecture Behavioral of contador_50ms is

signal contador : STD_LOGIC_VECTOR(21 downto 0) := "0000000000000000000000"; --señal que lleva la cuenta

begin

		process (clk) 	--Process para contar 50 ms
		begin
			if (clk'event and clk='1') then
				cnt_50ms <= '0'; 	--Pone la señal de salida a 0 en cada flanco de subida
				if en_cnt = '1' then		--para que sólo esté activa durante un ciclo de clk.
					contador <= contador + '1'; 	--Si enable está activa, el contador se incrementa
				end if;
				if (contador >= 2500000) then 	--El reloj de la FPGA tiene T = 20ns
					cnt_50ms <= '1'; 	--Cuando transcurran 50 ms habrán pasado 2.5e6 periodos
					contador <= (others => '0');	--Al transcurrir 50 ms se activa la salida y se reinicia el contador
				end if;
				if (rst_cnt = '1') then --Si está activa la entrada rst_cnt (reset)
					cnt_50ms <= '0';	--Se pone la salida a 0
					contador <= (others => '0');	--y se reinicia el contador	
				end if;
			end if;
		end process;
end Behavioral;

