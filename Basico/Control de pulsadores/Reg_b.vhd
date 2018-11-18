----------------------------------------------------------------------------------
-- REGISTRO REG_B QUE ALMACENA EL C�DIGO INTRODUCIDO POR LOS PULSADORES
--	 
-- Este registro se encarga de guardar y actualizar el 
-- valor binario del c�digo introducido por el usuario 
-- mediante los pulsadores. Para ello, recibe desde el
-- aut�mata de Moore la operaci�n a realizar a trav�s de
-- la se�al Sel.
----------------------------------------------------------------------------------


library IEEE;                      
use IEEE.STD_LOGIC_1164.ALL; 
use IEEE.STD_LOGIC_ARITH.ALL; 
use IEEE.STD_LOGIC_UNSIGNED.ALL; 

entity Reg_b is
    Port ( clk : in  STD_LOGIC; 								--Reloj de la FPGA
           rst_b : in  STD_LOGIC; 							--Se�al de reset
           en_b : in  STD_LOGIC;								--Se�al de enable
           sel : in  STD_LOGIC_VECTOR (1 downto 0);	--Se�al que elige la operaci�n a realizar
           b : out  STD_LOGIC_VECTOR (5 downto 0));	--Salida en binario del c�digo del usuario
end Reg_b;

architecture Behavioral of Reg_b is

signal s_Reg_b : STD_LOGIC_VECTOR(5 downto 0) := "000000"; --Se�al auxiliar para el process

begin

	process(rst_b,clk)
	begin
		if(rst_b = '1') then
			s_Reg_b <= "000000"; 								--Asignaci�n del valor por defecto
		elsif (clk'event and clk = '1') then
			if (en_b = '1') then
				if((sel = "00") and (s_Reg_b < 63)) then 	--Menor que 63
					s_Reg_b <= s_Reg_b + "01";					--Incremento +1 de la se�al
				end if;
				if ((sel = "01") and (s_Reg_b > 0)) then 	--Mayor que 0
					s_Reg_b <= s_Reg_b - "01";					--Decremento -1 de la se�al
				end if;
				if ((sel = "10") and (s_Reg_b < 54)) then --Menor que 54
					s_Reg_b <= s_Reg_b + "01010";				--Incremento +10 de la se�al
				end if;											
				if ((sel = "11") and (s_Reg_b > 9)) then --Mayor que 9
					s_Reg_b <= s_Reg_b - "01010"; 		  --Decremento -10 de la se�al
				end if;
			end if;
		end if;
	end process;
	
	b <= s_Reg_b;
	
end Behavioral;

