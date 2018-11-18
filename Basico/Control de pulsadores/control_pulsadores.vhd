----------------------------------------------------------------------------------
-- BLOQUE DE CONTROL DE PULSADORES
-- 
-- Este bloque es la "caja negra" que se encarga 
-- de gestionar el funcionamiento de los pulsadores
-- 
----------------------------------------------------------------------------------
library IEEE;       --Librerias                    
use IEEE.STD_LOGIC_1164.ALL; 
use IEEE.STD_LOGIC_ARITH.ALL; 
use IEEE.STD_LOGIC_UNSIGNED.ALL; 



entity control_pulsadores is
    Port ( clk : in  STD_LOGIC;								--Reloj de la FPGA
           Rst : in  STD_LOGIC;								--Señal de Reset
           Up0 : in  STD_LOGIC;								--Incrementar una unidad
           Down0 : in  STD_LOGIC;							--Decrementar una unidad
           Up1 : in  STD_LOGIC;								--Incrementar 10 unidades
           Down1 : in  STD_LOGIC;							--Decrementar 10 unidades
           b : out  STD_LOGIC_VECTOR (5 downto 0));	--Valor binario del código de pulsadores
end control_pulsadores;

architecture Behavioral of control_pulsadores is

component contador_100ms is 				--Declaración de componentes
    Port ( clk : in  STD_LOGIC; 
           rst_cnt : in  STD_LOGIC; 
           en_cnt : in  STD_LOGIC;  
           cnt_100ms : out  STD_LOGIC); 
end component;

component MooreFSM is 
    Port ( clk : in STD_LOGIC; 
			  Up0 : in  STD_LOGIC;
           Down0 : in  STD_LOGIC; 
           Up1 : in  STD_LOGIC; 
           Down1 : in  STD_LOGIC; 
           Rst : in  STD_LOGIC; 
           cnt_100ms : in  STD_LOGIC; 
           rst_b : out  STD_LOGIC; 
           rst_cnt : out  STD_LOGIC;
           en_cnt : out  STD_LOGIC;
           en_b : out  STD_LOGIC;
           sel : out  STD_LOGIC_VECTOR (1 downto 0));
end component;

component Reg_b is 
    Port ( clk : in  STD_LOGIC; 								
           rst_b : in  STD_LOGIC; 						
           en_b : in  STD_LOGIC;								
           sel : in  STD_LOGIC_VECTOR (1 downto 0);								
           b : out  STD_LOGIC_VECTOR (5 downto 0));	
end component;

--Declaración de señales intermedias

signal s_rst_cnt, s_en_cnt, s_cnt_100ms,s_en_b,s_rst_b : STD_LOGIC;
signal s_sel : STD_LOGIC_VECTOR(1 downto 0);

begin

--Conexionado de módulos internos

U1 : MooreFSM port map(clk,Up0,Down0,Up1,Down1,Rst,s_cnt_100ms,s_rst_b,s_rst_cnt,s_en_cnt,s_en_b,s_sel);
U2 : contador_100ms port map (clk,s_rst_cnt,s_en_cnt,s_cnt_100ms);
U3 : Reg_b port map (clk,s_rst_b,s_en_b,s_sel,b);

end Behavioral;

