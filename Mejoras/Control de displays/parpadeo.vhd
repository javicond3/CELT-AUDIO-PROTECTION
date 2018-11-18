----------------------------------------------------------------------------------
-- BLOQUE DE PARPADEO
--  
-- Este bloque genera un pulso cuadrado de periodo 2 segundos
-- de forma que cuando vale 1 se encenderán los displays
-- que muestran el código, y cuando valga 0 se apagarán.
-- El resultado es que parpadean cada segundo.
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity parpadeo is
    Port ( clk : in  STD_LOGIC;	--Reloj de la FPGA
           Rst : in  STD_LOGIC;	--Señal de Reset
           encendido : out  STD_LOGIC);	--Señal cuadrada de salida
end parpadeo;

architecture Behavioral of parpadeo is

signal flag : STD_LOGIC := '0';													--Valor de encendido usado en el process
signal contador : STD_LOGIC_VECTOR (25 downto 0) := (others => '0');	--Contador

begin

process(clk,rst)
begin
	if (clk'event and clk = '1') then
		contador <= contador + 1; --En cada flanco de subida aumenta el contador
		if (contador = 50000000	) then	--Cada segundo (50e6 cuentas) conmuta la salida flag
			flag <= not flag;	--Reinicia la cuenta
			contador <= (others => '0');
		end if;
	end if;
	if(Rst = '1') then	--Si se activa el Reset, se reinicia la cuenta			
		flag <= '0';
		contador <= (others => '0');
	end if;
end process;

encendido <= flag;	--Asignación de la salida


end Behavioral;

