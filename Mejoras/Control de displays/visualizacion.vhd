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
			  Rst : in STD_LOGIC;	--Se�al de Reset
           cnt_5ms : in  STD_LOGIC;	--Salida del contador de 5 ms
			  muestra_password : in STD_LOGIC;	--Activaci�n de los displays que muestran el c�digo (mejora)
           digito0 : in  STD_LOGIC_VECTOR (3 downto 0); --Valor BCD de las decenas de los switches
           digito1 : in  STD_LOGIC_VECTOR (3 downto 0);	--Valor BCD de las unidades de los switches
           digito2 : in  STD_LOGIC_VECTOR (3 downto 0);	--Valor BCD de las decenas de los pulsadores
           digito3 : in  STD_LOGIC_VECTOR (3 downto 0);	--Valor BCD de las unidades de los pulsadores
           Disp0 : out  STD_LOGIC;	--Activaci�n del display0 (activa a nivel bajo)
           Disp1 : out  STD_LOGIC;	--Activaci�n del display1 (activa a nivel bajo)
           Disp2 : out  STD_LOGIC;	--Activaci�n del display2 (activa a nivel bajo)
           Disp3 : out  STD_LOGIC;	--Activaci�n del display3 (activa a nivel bajo)
           Seg7 : out  STD_LOGIC_VECTOR (6 downto 0);		--Valor del d�gito BCD activo en cada momento en 7 segmentos
			  activa_tiempo : in STD_LOGIC);	--Activa la muestra de tiempo
																			
end visualizacion;

architecture Behavioral of visualizacion is

component decod7s												--Componente que pasa de BCD a 7 segmentos
	 port ( DIN : in STD_LOGIC_VECTOR (3 downto 0); 
			  S7SEG : out STD_LOGIC_VECTOR (0 to 6)); 
end component;

signal sel : STD_LOGIC_VECTOR(1 downto 0) := "00"; 			--Se�al de control del multiplexor
signal digitoBCD : STD_LOGIC_VECTOR(3 downto 0) := "0000";	--Se�al con el d�gito BCD correspondiente al display activo

begin

--Multiplexor para activar un display distinto cada 5 ms
--Tambi�n selecciona el d�gito BCD asociado al display

process (sel, digito0, digito1, digito2, digito3)			
begin
	digitoBCD <= digito0; 		--Asignaciones por defecto
	Disp0 <= '1'; Disp1 <= '1'; Disp2 <= '1'; Disp3 <= '1'; 
	case sel is																
		when "00" => Disp0 <= '0'; Disp1 <= '1'; Disp2 <= '1'; Disp3 <= '1'; digitoBCD <= digito0;
		when "01" => Disp0 <= '1'; Disp1 <= '0'; Disp2 <= '1';Disp3 <= '1'; digitoBCD <= digito1;
		when "10" => Disp0 <= '1'; Disp1 <= '1'; Disp2 <= '0'; Disp3 <= '1'; digitoBCD <= digito2;
		when "11" => Disp0 <= '1'; Disp1 <= '1'; Disp2 <= '1'; Disp3 <= '0'; digitoBCD <= digito3;
		when others => Disp0 <= '1';
	end case;
	if(muestra_password = '0' and Rst = '0' and activa_tiempo = '0') then			--Si est� desactivada muestra_password
		Disp0 <= '1';								--Se apagan los displays que muestran el c�digo de los switches
		Disp1 <= '1';
	elsif (Rst = '1') then						--Si est� activo el Reset	
		Disp3 <= '1';								--Displays muestran "OFF"
	end if;
	
end process; 

process (clk)										--Incremento de la se�al de control "sel" cada 5 ms
begin
 if clk'event and clk='1' then
	if(cnt_5ms = '1') then
		sel <= sel + 1;
	end if;
 end if;
end process; 

U1 : decod7s port map(digitoBCD,Seg7);		--Conversi�n de BCD a 7 segmentos

end Behavioral;

