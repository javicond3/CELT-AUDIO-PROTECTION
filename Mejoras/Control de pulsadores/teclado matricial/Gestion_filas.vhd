----------------------------------------------------------------------------------
-- BLOQUE DE GESTIÓN DE FILAS
-- 
-- Bloque para gestionar las filas del teclado
-- Si se detecta una pulsación, se activa la salida
-- pulsada y se indica qué fila se ha pulsado.
----------------------------------------------------------------------------------
library IEEE;                         
use IEEE.STD_LOGIC_1164.ALL; 
use IEEE.STD_LOGIC_ARITH.ALL; 
use IEEE.STD_LOGIC_UNSIGNED.ALL; 


entity Gestion_filas is
    Port ( clk : in  STD_LOGIC;	--Reloj de la FPGA
           Rst : in  STD_LOGIC;	--Señal de Reset
           fila0 : in  STD_LOGIC;	--Pulsación en fila 0
           fila1 : in  STD_LOGIC;	--Pulsación en fila 1
           fila2 : in  STD_LOGIC;	--Pulsación en fila 2
           fila3 : in  STD_LOGIC;	--Pulsación en fila 3
           pulsada : out  STD_LOGIC; 	--Indica si hay una tecla pulsada
           fila_pulsada : out  STD_LOGIC_VECTOR(1 downto 0));--Indica en qué fila está la tecla pulsada
end Gestion_filas;

architecture Behavioral of Gestion_filas is

begin

	process (clk,Rst)			
	begin
		if(Rst = '1') then
			pulsada <= '0';				--Valores por defecto
			fila_pulsada <= "00";
		elsif (clk'event and clk = '1') then
			if(fila0 = '1') then	--Se ha pulsado tecla en la fila0
				pulsada <= '1';
				fila_pulsada <= "00";
			elsif(fila1 = '1') then	--Se ha pulsado tecla en la fila1
				pulsada <= '1';
				fila_pulsada <= "01";
			elsif(fila2 = '1') then	--Se ha pulsado tecla en la fila2
				pulsada <= '1';
				fila_pulsada <= "10";
			elsif(fila3 = '1') then	--Se ha pulsado tecla en la fila3
				pulsada <= '1';
				fila_pulsada <= "11";--Si se pulsan varias a la vez: la más prioritaria es la 0.
			else
				pulsada <= '0';	--Nada pulsado => valores por defecto
				fila_pulsada <= "00";
			end if;
			
			
		end if;
	end process;


end Behavioral;

