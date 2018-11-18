----------------------------------------------------------------------------------
-- CONTADOR DE TIEMPO
--  
-- Este bloque se encarga de contar el tiempo
-- basándose en un contador de segundos, y haciendo uso
-- de él, saca a la salida el tiempo (minutos y segundos)
-- en binario que ha transcurrido desde que se inicia.
----------------------------------------------------------------------------------
library IEEE;       --Librerias                    
use IEEE.STD_LOGIC_1164.ALL; 
use IEEE.STD_LOGIC_ARITH.ALL; 
use IEEE.STD_LOGIC_UNSIGNED.ALL; 


entity contador_tiempo is
    Port ( clk : in STD_LOGIC;	--Reloj de la FPGA
			  rst : in  STD_LOGIC;	--Señal de Reset
           segundos : out  STD_LOGIC_VECTOR (5 downto 0);	--Segundos (binario)
           minutos : out  STD_LOGIC_VECTOR (5 downto 0));	--Minutos (binario)
end contador_tiempo;

architecture Behavioral of contador_tiempo is

--Declaración del componente contador_1s

Component contador_1s is
Port(clk : in  STD_LOGIC;  
           rst_cnt : in  STD_LOGIC; 
           cnt_1s : out  STD_LOGIC); 	
end component;

--Declaración de señales

signal cont_1s : STD_LOGIC := '0';	--Señal para contar seungods
signal seg : STD_LOGIC_VECTOR(5 downto 0) := "000000";	--Señal para contar segundos
signal min : STD_LOGIC_VECTOR(5 downto 0) := "000000";	--Señal para contar minutos

begin

	process (clk)
	begin
		if(clk'event and clk = '1') then
			if (cont_1s = '1') then	--Cada vez que pasa un segundo
				seg <= seg + 1; --Se incrementa el contador de segundos
				if (seg = 59) then
					seg <= "000000"; --Cada 60 segundos se suma un minuto
					min <= min + 1;
					if (min = 59) then
						min <= "000000";	--Si llega al tope (1 hora) se reinicia.
					end if;
				end if;
			end if;
		end if;
		if (rst = '1') then --Si hay un reset, inicializa todo
			seg <= "000000";
			min <= "000000";
		end if;
	end process;
	
	U1: contador_1s port map(clk, rst, cont_1s);
	segundos <= seg; --Asignación de señales
	minutos <= min;
				
end Behavioral;

