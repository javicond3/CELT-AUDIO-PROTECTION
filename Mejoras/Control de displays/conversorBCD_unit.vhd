----------------------------------------------------------------------------------
-- CONVERSORBCD_UNIT
--
-- Se trata de un conversor cuya entrada es siempre
-- un valor binario de 6 bits, y su salida son dos
-- valores BCD correspondientes a las decenas y unidades
-- en BCD del valor binario que se tiene a la entrada.
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity conversorBCD_unit is
	Port ( data_in : in STD_LOGIC_VECTOR (5 downto 0);   --valor binario de entrada
			 data_out : out STD_LOGIC_VECTOR (3 downto 0); --unidades en BCD
			 digito : out STD_LOGIC_VECTOR (3 downto 0) ); --decenas en BCD
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