----------------------------------------------------------------------------------
-- CONTADOR DE 100ms
--
-- Se trata de un simple contador de 100ms que cada
-- 100ms activa la señal cnt_100ms durante un ciclo de reloj.
-- Necesario para controlar el tiempo entre pulsaciones sucesivas
-- En el autómata de Moore
----------------------------------------------------------------------------------


library IEEE;                         
use IEEE.STD_LOGIC_1164.ALL; 
use IEEE.STD_LOGIC_ARITH.ALL; 
use IEEE.STD_LOGIC_UNSIGNED.ALL; 

entity contador_100ms is			
    Port ( clk : in  STD_LOGIC;  			--Reloj de la FPGA
           rst_cnt : in  STD_LOGIC; 		--Entrada reset para el contador
           en_cnt : in  STD_LOGIC;  		--Entrada para habilitar el contador
           cnt_100ms : out  STD_LOGIC); 	--Salida del contador
end contador_100ms;

architecture Behavioral of contador_100ms is

signal contador : STD_LOGIC_VECTOR(22 downto 0) := "00000000000000000000000"; --señal que guarda la cuenta
--BBBBB = 22 Porque son necesarios 23 bits para poder contar hasta 5.000.000

begin

		process (clk) 									--Proceso que cuenta
		begin
			if (clk'event and clk='1') then
				cnt_100ms <= '0'; 					--Pone la señal de salida a 0 en cada flanco de subida
				if en_cnt = '1' then					--para que solo esté activa durante un ciclo de clk
					contador <= contador + '1'; 	--Si enable está activa, el contador se incrementa
				end if;
				if (contador >= 5000000) then 	--El reloj de la FPGA tiene T = 20ns
					cnt_100ms <= '1'; 				--Cuando transcurran 100 ms habrán pasado 5e6 periodos
					contador <= (others => '0');	--Al transcurrir 100 ms se activa la salida y se reinicia el contador
				end if;
				if (rst_cnt = '1') then 			--Si está activa la entrada rst_cnt (reset)
					cnt_100ms <= '0';					--Se pone la salida a 0
					contador <= (others => '0');	--y se reinicia el contador	
				end if;
			end if;
		end process;
end Behavioral;

