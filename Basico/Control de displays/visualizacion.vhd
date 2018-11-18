----------------------------------------------------------------------------------
-- VISUALIZACI�N 
--
--	Este m�dulo se encarga de gestionar la visualizaci�n
-- en displays de los valores introducidos.
-- Con un multiplexor, cuya se�al de control var�a cada 5 ms,
-- se elige qu� display est� activo en cada momento
-- y qu� valor BCD le corresponde mostrar a dicho display.
-- Finalmente, usando un m�dulo auxiliar, se pasa el valor
-- BCD a 7 segmentos y se saca a la salida.
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity visualizacion is
    Port ( clk : in  STD_LOGIC;	--Reloj de la FPGA
           cnt_5ms : in  STD_LOGIC;	--Salida del contador de 5 ms
           digito0 : in  STD_LOGIC_VECTOR (3 downto 0);	--BCD del Digito0
           digito1 : in  STD_LOGIC_VECTOR (3 downto 0);	--BCD del Digito1
           digito2 : in  STD_LOGIC_VECTOR (3 downto 0);	--BCD del Digito2
           digito3 : in  STD_LOGIC_VECTOR (3 downto 0);	--BCD del Digito3
           Disp0 : out  STD_LOGIC;	--Activaci�n Display0
           Disp1 : out  STD_LOGIC;	--Activaci�n Display1
           Disp2 : out  STD_LOGIC;	--Activaci�n Display2
           Disp3 : out  STD_LOGIC;	--Activaci�n Display3
           Seg7 : out  STD_LOGIC_VECTOR (6 downto 0));	--7 Segmentos del display activo
end visualizacion;

architecture Behavioral of visualizacion is

--Declaraci�n del decodificador a 7 segmentos

component decod7s
	 port ( DIN : in STD_LOGIC_VECTOR (3 downto 0); -- entrada de datos
			  S7SEG : out STD_LOGIC_VECTOR (0 to 6)); -- salidas 7seg (abcdefg)
end component;

signal sel : STD_LOGIC_VECTOR(1 downto 0) := "00"; --Se�al de control del MUX
signal digitoBCD : STD_LOGIC_VECTOR(3 downto 0) := "0000"; --Digito BCD del disp activo

begin

--Multiplexor para activar un display distinto cada 5 ms
--Tambi�n selecciona el d�gito BCD asociado al display

process (sel, digito0, digito1, digito2, digito3)
begin
	digitoBCD <= digito0; -- asignaci�n por defecto
	Disp0 <= '1'; Disp1 <= '1'; Disp2 <= '1'; Disp3 <= '1'; 
	case sel is
		when "00" => Disp0 <= '0'; Disp1 <= '1'; Disp2 <= '1'; Disp3 <= '1'; digitoBCD <= digito0;
		when "01" => Disp0 <= '1'; Disp1 <= '0'; Disp2 <= '1';Disp3 <= '1'; digitoBCD <= digito1;
		when "10" => Disp0 <= '1'; Disp1 <= '1'; Disp2 <= '0'; Disp3 <= '1'; digitoBCD <= digito2;
		when "11" => Disp0 <= '1'; Disp1 <= '1'; Disp2 <= '1'; Disp3 <= '0'; digitoBCD <= digito3;
		when others => Disp0 <= '1';
	end case;
end process; 

process (clk)	--Cambio de la se�al de control cada 5 ms
begin
 if clk'event and clk='1' then
	if(cnt_5ms = '1') then
		sel <= sel + 1;
	end if;
 end if;
end process; 

U1 : decod7s port map(digitoBCD,Seg7); --Conversi�n de BCD a 7segmentos

end Behavioral;

