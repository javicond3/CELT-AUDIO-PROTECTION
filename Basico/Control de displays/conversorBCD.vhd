----------------------------------------------------------------------------------
-- CONVERSOR BCD
-- 
-- Recibe el valor binario del c�digo de los pulsadores
-- y saca a la salida 2 d�gitos BCD correspondientes
-- a las decenas y unidades de dicho valor.
-- Hace uso de conversorBCD_unit, que convierte 
-- un valor binario de 6 bits en 2 d�gitos BCD de 4 bits
-- cada uno.
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity conversorBCD is
    Port ( clk : in  STD_LOGIC;	--Reloj de la FPGA
           b : in  STD_LOGIC_VECTOR (5 downto 0);	--Valor de los pulsadores en binario
           D0 : out  STD_LOGIC_VECTOR (3 downto 0);	--Digito0 en BCD
           D1 : out  STD_LOGIC_VECTOR (3 downto 0);	--Digito1 en BCD
           D2 : out  STD_LOGIC_VECTOR (3 downto 0);	--Digito2 en BCD
           D3 : out  STD_LOGIC_VECTOR (3 downto 0));	--Digito3 en BCD
end conversorBCD;


architecture Behavioral of conversorBCD is

--Declaraci�n del componente conversorBCD_unit

component conversorBCD_unit
Port ( data_in : in STD_LOGIC_VECTOR (5 downto 0); 
 data_out : out STD_LOGIC_VECTOR (3 downto 0); 
 digito : out STD_LOGIC_VECTOR (3 downto 0) ); 
end component;

--Se�ales necesarias para los registros

signal unidades : STD_LOGIC_VECTOR(3 downto 0) := "0000";
signal decenas : STD_LOGIC_VECTOR(3 downto 0) := "0000";
signal entrada : STD_LOGIC_VECTOR(5 downto 0) := "000000" ;

begin

	process(clk)	--Registro para mantener estables las se�ales
	begin
		if(clk' event and clk = '1') then
			entrada<= b;		--Asigna entradas a se�ales
			D2 <= decenas;		--Asigna se�ales a salidas
			D3 <= unidades;
		end if;
	end process;


U1 : conversorBCD_unit port map(entrada,unidades,decenas);	--Conversi�n binario-BCD
D0 <= "0000"; 	--Dos d�gitos sin uso definido
D1 <= "0000";	--Se ponene a 0


end Behavioral;

