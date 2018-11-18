----------------------------------------------------------------------------------
-- DIGITAL 1 - TOP PARA PULSADORES Y DISPLAYS
-- 
-- Fichero de interconexión de los módulos de control de displays
-- y control de pulsadores
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity digital1 is
    Port ( clk : in  STD_LOGIC;	--Reloj de la FPGA
           Rst : in  STD_LOGIC;	--Señal de Reset
           Up0 : in  STD_LOGIC;	--Incrementar 1 el código
           Down0 : in  STD_LOGIC;	--Decrementar 1 el código
           Up1 : in  STD_LOGIC;	--Incrementar 10 el código
           Down1 : in  STD_LOGIC;	--Decrementar 10 el código
           Disp0 : out  STD_LOGIC;	--Activación Display0
           Disp1 : out  STD_LOGIC;	--Activación Display1
           Disp2 : out  STD_LOGIC;	--Activación Display2
           Disp3 : out  STD_LOGIC;	--Activación Display3
           Seg7 : out  STD_LOGIC_VECTOR (6 downto 0));	--7 Segmentos Display activo
end digital1;

architecture Behavioral of digital1 is

--Declaración de componentes

component control_pulsadores is 
    Port ( clk : in  STD_LOGIC;
           Rst : in  STD_LOGIC;
           Up0 : in  STD_LOGIC;
           Down0 : in  STD_LOGIC;
           Up1 : in  STD_LOGIC;
           Down1 : in  STD_LOGIC;
           b : out  STD_LOGIC_VECTOR (5 downto 0));
end component;

component control_displays is 
    Port ( f : in  STD_LOGIC_VECTOR (5 downto 0);
           clk : in  STD_LOGIC;
           Disp0 : out  STD_LOGIC;
           Disp1 : out  STD_LOGIC;
           Disp2 : out  STD_LOGIC;
           Disp3 : out  STD_LOGIC;
           Seg7 : out  STD_LOGIC_VECTOR (6 downto 0));
end component;

--Declaración de señales intermedias

signal b : STD_LOGIC_VECTOR (5 downto 0);

begin

--Interconexión de bloques

U1 : control_pulsadores port map(clk,Rst,Up0,Down0,Up1,Down1,b);
U2 : control_displays port map(b,clk,Disp0,Disp1,Disp2,Disp3,Seg7);

end Behavioral;

