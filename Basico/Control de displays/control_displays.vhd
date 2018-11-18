----------------------------------------------------------------------------------
-- CONTROL DE DISPLAYS
-- 
-- Este bloque se encarga, en su conjunto, de la gestión
-- de información suministrada por los displays.
-- Este módulo en concreto realiza las interconexiones
-- entre los submódulos que controlan los displays.
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity control_displays is
    Port ( f : in  STD_LOGIC_VECTOR (5 downto 0);	--Código de los pulsadores
           clk : in  STD_LOGIC;	--Reloj de la FPGA
           Disp0 : out  STD_LOGIC;	--Activación Display0
           Disp1 : out  STD_LOGIC;	--Activación Display1
           Disp2 : out  STD_LOGIC;	--Activación Display2
           Disp3 : out  STD_LOGIC;	--Activación Display3
           Seg7 : out  STD_LOGIC_VECTOR (6 downto 0));	--7 Segmentos del display activo
end control_displays;

architecture Behavioral of control_displays is

--Declaración de componentes

component contador_5ms
	 Port ( clk : in  STD_LOGIC;
           cnt_5ms : out  STD_LOGIC);
end component;

component conversorBCD
	 Port ( clk : in  STD_LOGIC;
           b : in  STD_LOGIC_VECTOR (5 downto 0);
           D0 : out  STD_LOGIC_VECTOR (3 downto 0);
           D1 : out  STD_LOGIC_VECTOR (3 downto 0);
           D2 : out  STD_LOGIC_VECTOR (3 downto 0);
           D3 : out  STD_LOGIC_VECTOR (3 downto 0));
end component;

component visualizacion
	 Port ( clk : in  STD_LOGIC;
           cnt_5ms : in  STD_LOGIC;
           digito0 : in  STD_LOGIC_VECTOR (3 downto 0);
           digito1 : in  STD_LOGIC_VECTOR (3 downto 0);
           digito2 : in  STD_LOGIC_VECTOR (3 downto 0);
           digito3 : in  STD_LOGIC_VECTOR (3 downto 0);
           Disp0 : out  STD_LOGIC;
           Disp1 : out  STD_LOGIC;
           Disp2 : out  STD_LOGIC;
           Disp3 : out  STD_LOGIC;
           Seg7 : out  STD_LOGIC_VECTOR (6 downto 0));
end component;

--Declaración de señales intermedias

signal digito0 : STD_LOGIC_VECTOR(3 downto 0);
signal digito1 : STD_LOGIC_VECTOR(3 downto 0);
signal digito2 : STD_LOGIC_VECTOR(3 downto 0);
signal digito3 : STD_LOGIC_VECTOR(3 downto 0);
signal cnt_5ms : STD_LOGIC;

begin

--Interconexiones


U1: conversorBCD port map(clk,f,digito0,digito1,digito2,digito3);
U2: contador_5ms port map(clk,cnt_5ms);
U3: visualizacion port map(clk,cnt_5ms,digito0,digito1,digito2,digito3,Disp0,Disp1,Disp2,Disp3,Seg7);


end Behavioral;

