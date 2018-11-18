----------------------------------------------------------------------------------
-- CONVERSOR BCD_UNIT
-- 
-- Conversor auxiliar utilizado en el bloque conversor BCD
-- A partir de una entrada binaria de 6 bits obtiene
-- a la salida dos dígitos BCD.
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity conversorBCD_unit is
	Port ( data_in : in STD_LOGIC_VECTOR (5 downto 0); -- numero binario de entrada
			 data_out : out STD_LOGIC_VECTOR (3 downto 0); -- numero binario de salida
			 digito : out STD_LOGIC_VECTOR (3 downto 0) ); -- digito BCD de salida
end conversorBCD_unit;

architecture behavior of conversorBCD_unit is

begin

process (data_in)
 VARIABLE resto : STD_LOGIC_VECTOR (5 downto 0);
begin
 digito <= (others => '0'); resto := data_in; -- VALORES POR DEFECTO

 if data_in >= conv_std_logic_vector(10, 6) then
	digito <= "0001"; resto := data_in - conv_std_logic_vector(10, 6); -- resto = data_in - 10
 end if;
 if data_in >= conv_std_logic_vector(20, 6) then
	digito <= "0010"; resto := data_in - conv_std_logic_vector(20, 6); -- resto = data_in - 20
 end if;
 if data_in >= conv_std_logic_vector(30, 6) then
	digito <= "0011"; resto := data_in - conv_std_logic_vector(30, 6); -- resto = data_in - 30
 end if;
 if data_in >= conv_std_logic_vector(40, 6) then
	digito <= "0100"; resto := data_in - conv_std_logic_vector(40, 6); -- resto = data_in - 40
 end if;
 if data_in >= conv_std_logic_vector(50, 6) then
	digito <= "0101"; resto := data_in - conv_std_logic_vector(50, 6); -- resto = data_in - 50
 end if;
 if data_in >= conv_std_logic_vector(60, 6) then
	digito <= "0110"; resto := data_in - conv_std_logic_vector(60, 6); -- resto = data_in - 60
 end if;
 data_out <= resto(3 downto 0); -- Asignacion de salida
end process;
end behavior; 