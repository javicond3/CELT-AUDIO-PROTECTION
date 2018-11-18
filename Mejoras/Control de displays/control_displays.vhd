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
			  Rst : in STD_LOGIC;	--Señal de reset
			  sw: in  STD_LOGIC_VECTOR (5 downto 0);	--Contraseña (procedente de switches)
           clk : in  STD_LOGIC;	--Reloj de la FPGA
           Disp0 : out  STD_LOGIC;	--Activación Display0
           Disp1 : out  STD_LOGIC;	--Activación Display1
           Disp2 : out  STD_LOGIC;	--Activación Display2
           Disp3 : out  STD_LOGIC;	--Activación Display3
           Seg7 : out  STD_LOGIC_VECTOR (6 downto 0);	--7 Segmentos del Display activo
			  pulsador : in STD_LOGIC);	--Pulsador para mostrar tiempo
end control_displays;

architecture Behavioral of control_displays is

--Declaración de componentes

component contador_5ms					
	 Port ( clk : in  STD_LOGIC;
           cnt_5ms : out  STD_LOGIC);
end component;

component conversorBCD
	 Port ( clk : in  STD_LOGIC;
			  Rst: in STD_LOGIC;
           b : in  STD_LOGIC_VECTOR (5 downto 0);
			  sw: in  STD_LOGIC_VECTOR (5 downto 0);
           D0 : out  STD_LOGIC_VECTOR (3 downto 0);
           D1 : out  STD_LOGIC_VECTOR (3 downto 0);
           D2 : out  STD_LOGIC_VECTOR (3 downto 0);
           D3 : out  STD_LOGIC_VECTOR (3 downto 0);
			  segundos : in STD_LOGIC_VECTOR(5 downto 0);
			  minutos : in STD_LOGIC_VECTOR(5 downto 0);
			  activa_tiempo : in STD_LOGIC);
end component;

component visualizacion
	 Port ( clk : in  STD_LOGIC;
			  Rst: in STD_LOGIC;
           cnt_5ms : in  STD_LOGIC;
			  muestra_password : in STD_LOGIC;
           digito0 : in  STD_LOGIC_VECTOR (3 downto 0);
           digito1 : in  STD_LOGIC_VECTOR (3 downto 0);
           digito2 : in  STD_LOGIC_VECTOR (3 downto 0);
           digito3 : in  STD_LOGIC_VECTOR (3 downto 0);
           Disp0 : out  STD_LOGIC;
           Disp1 : out  STD_LOGIC;
           Disp2 : out  STD_LOGIC;
           Disp3 : out  STD_LOGIC;
           Seg7 : out  STD_LOGIC_VECTOR (6 downto 0);
			  activa_tiempo : in STD_LOGIC);
end component;

component parpadeo is
    Port ( clk : in  STD_LOGIC;				
           Rst : in  STD_LOGIC;				
           encendido : out  STD_LOGIC);
end component;

component contador_tiempo is
    Port ( clk : in STD_LOGIC;
			  rst : in  STD_LOGIC;
           segundos : out  STD_LOGIC_VECTOR (5 downto 0);
           minutos : out  STD_LOGIC_VECTOR (5 downto 0));
end component;
		
--Declaración de señales intermedias

signal digito0 : STD_LOGIC_VECTOR(3 downto 0);	
signal digito1 : STD_LOGIC_VECTOR(3 downto 0);
signal digito2 : STD_LOGIC_VECTOR(3 downto 0);
signal digito3 : STD_LOGIC_VECTOR(3 downto 0);
signal cnt_5ms : STD_LOGIC;
signal muestra_password : STD_LOGIC;
signal segundos,minutos : STD_LOGIC_VECTOR (5 downto 0);

begin

--Interconexiones

U1: contador_tiempo port map(clk,Rst,segundos,minutos);
U2: conversorBCD port map(clk,Rst,f,sw,digito0,digito1,digito2,digito3,segundos,minutos,pulsador);
U3: contador_5ms port map(clk,cnt_5ms);
U4: parpadeo port map(clk,rst,muestra_password);
U5: visualizacion port map(clk,Rst,cnt_5ms,muestra_password,digito0,digito1,digito2,digito3,Disp0,Disp1,Disp2,Disp3,Seg7,pulsador);


end Behavioral;

