----------------------------------------------------------------------------------
-- CONVERSOR BCD
-- 
-- Recibe los valores binarios del valor introducido
-- y del código, y saca a la salida 2 dígitos BCD
-- para cada valor (4 dígitos BCD en total).
-- Hace uso de conversorBCD_unit, que convierte 
-- un valor binario de 6 bits en 2 dígitos BCD de 4 bits
-- cada uno
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity conversorBCD is
    Port ( clk : in  STD_LOGIC;								--Reloj de la FPGA
			  Rst : in STD_LOGIC;								--Señal de Reset
           b : in  STD_LOGIC_VECTOR (5 downto 0);		--Valor introducido mediante pulsadores (binario)
			  sw : in STD_LOGIC_VECTOR (5 downto 0);		--Código generado con los switches (binario)
           D0 : out  STD_LOGIC_VECTOR (3 downto 0);	--BCD de las decenas de los switches
           D1 : out  STD_LOGIC_VECTOR (3 downto 0);	--BCD de las unidades de los switches
           D2 : out  STD_LOGIC_VECTOR (3 downto 0);	--BCD de las decenas de los pulsadores
           D3 : out  STD_LOGIC_VECTOR (3 downto 0);	--BCD de las unidades de los pulsadores
			  segundos : in STD_LOGIC_VECTOR(5 downto 0);--Valor binario del tiempo (seg) que lleva activado
			  minutos : in STD_LOGIC_VECTOR(5 downto 0);	--Valor binario del tiempo (min) que lleva activado
			  activa_tiempo : in STD_LOGIC);					--Pulsador que muestra el tiempo		
end conversorBCD;


architecture Behavioral of conversorBCD is

component conversorBCD_unit											--Declaración de conversorBCD_unit
Port ( data_in : in STD_LOGIC_VECTOR (5 downto 0); 
 data_out : out STD_LOGIC_VECTOR (3 downto 0); 
 digito : out STD_LOGIC_VECTOR (3 downto 0) ); 
end component;

signal b_unidades : STD_LOGIC_VECTOR(3 downto 0) := "0000";		--Declaración de señales necesarias
signal b_decenas : STD_LOGIC_VECTOR(3 downto 0) := "0000";		--Se hace uso de ellas en los registros
signal b_entrada : STD_LOGIC_VECTOR(5 downto 0) := "000000" ;	
signal sw_unidades : STD_LOGIC_VECTOR(3 downto 0) := "0000";
signal sw_decenas : STD_LOGIC_VECTOR(3 downto 0) := "0000";
signal sw_entrada : STD_LOGIC_VECTOR(5 downto 0) := "000000" ;
signal segundos_unidades : STD_LOGIC_VECTOR(3 downto 0) := "0000";
signal segundos_decenas : STD_LOGIC_VECTOR(3 downto 0) := "0000";
signal segundos_entrada : STD_LOGIC_VECTOR(5 downto 0) := "000000";
signal minutos_unidades : STD_LOGIC_VECTOR(3 downto 0) := "0000";
signal minutos_decenas : STD_LOGIC_VECTOR(3 downto 0) := "0000";
signal minutos_entrada : STD_LOGIC_VECTOR(5 downto 0) := "000000" ;
begin

	process(clk)									--Registros para mantener estables las entradas y salidas
	begin												
		if(clk' event and clk = '1') then
			if (activa_tiempo = '0') then	
				b_entrada<= b;
				D2 <= b_decenas;
				D3 <= b_unidades;
				sw_entrada<= sw;
				D0 <= sw_decenas;
				D1 <= sw_unidades;
			else
				segundos_entrada<= segundos;
				D2 <= segundos_decenas;
				D3 <= segundos_unidades;
				minutos_entrada<= minutos;
				D0 <= minutos_decenas;
				D1 <= minutos_unidades;
			end if;
			if (Rst = '1') then					--En Reset muestra off
				D0 <= "0000";
				D1 <= "1111";
				D2 <= "1111";
				D3 <= "0000";
			end if;
		end if;
	end process;

U1 : conversorBCD_unit port map(b_entrada,b_unidades,b_decenas);									--Obtención dígitos BCD de los pulsadores
U2 : conversorBCD_unit port map(sw_entrada,sw_unidades,sw_decenas);								--Obtención dígitos BCD de los switches
U3 : conversorBCD_unit port map(segundos_entrada,segundos_unidades,segundos_decenas);		--Obtención dígitos BCD de los segundos
U4 : conversorBCD_unit port map(minutos_entrada,minutos_unidades,minutos_decenas);			--Obtención dígitos BCD de los minutos
end Behavioral;

