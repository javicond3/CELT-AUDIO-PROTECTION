----------------------------------------------------------------------------------
-- FICHERO TOP DEL TECLADO MATRICIAL
--
-- Fichero de interconexiones de los submódulos
-- que controlan el teclado matricial
----------------------------------------------------------------------------------
library IEEE;                         
use IEEE.STD_LOGIC_1164.ALL; 
use IEEE.STD_LOGIC_ARITH.ALL; 
use IEEE.STD_LOGIC_UNSIGNED.ALL; 

entity top_teclado is
    Port ( clk : in STD_LOGIC;	--Reloj de la FPGA
			  Rst : in STD_LOGIC;	--Señal de Reset
			  fila0 : in  STD_LOGIC;	--Entradas de filas del teclado
           fila1 : in  STD_LOGIC;
           fila2 : in  STD_LOGIC;
           fila3 : in  STD_LOGIC;
           col0 : out  STD_LOGIC;	--Salidas para excitación de columnas
           col1 : out  STD_LOGIC;
           col2 : out  STD_LOGIC;
           col3 : out  STD_LOGIC;
           Up0 : out  STD_LOGIC;	--Incrementar 1 el codigo de usuario
           Down0 : out  STD_LOGIC;	--Decrementar 1 el código de usuario
           Up1 : out  STD_LOGIC;	--Incrementar 10 el código de usuario
           Down1 : out  STD_LOGIC);	--Decrementar 10 el código de usuario
end top_teclado;

architecture Behavioral of top_teclado is

--Declaración de componentes

component Gestin_columnas is
    Port ( clk : in  STD_LOGIC;
           Rst : in  STD_LOGIC;
           Col0 : out  STD_LOGIC;
           Col1 : out  STD_LOGIC;
           Col2 : out  STD_LOGIC;
           Col3 : out  STD_LOGIC;
			  col_activa: out STD_LOGIC_VECTOR(1 downto 0));
end component;

component Gestion_filas is
    Port ( clk : in  STD_LOGIC;
           Rst : in  STD_LOGIC;
           fila0 : in  STD_LOGIC;
           fila1 : in  STD_LOGIC;
           fila2 : in  STD_LOGIC;
           fila3 : in  STD_LOGIC;
           pulsada : out  STD_LOGIC; 		
           fila_pulsada : out  STD_LOGIC_VECTOR(1 downto 0));
end component;

component tecla_pulsada is
    Port ( columna : in  STD_LOGIC_VECTOR (1 downto 0);
           fila : in  STD_LOGIC_VECTOR (1 downto 0);
           pulsacion : in  STD_LOGIC;
           tecla : out  STD_LOGIC_VECTOR (3 downto 0);
           valida : out  STD_LOGIC);
end component;

component codif_tecla is
    Port ( tecla : in  STD_LOGIC_VECTOR (3 downto 0);	
           valida : in  STD_LOGIC;	
           Up0 : out  STD_LOGIC;								
           Down0 : out  STD_LOGIC;							
           Up1 : out  STD_LOGIC;								
           Down1 : out  STD_LOGIC);							
end component;

--Declaración de señales intermedias

signal tecla : STD_LOGIC_VECTOR (3 downto 0);
signal col_activa : STD_LOGIC_VECTOR (1 downto 0);
signal fila_pulsada : STD_LOGIC_VECTOR (1 downto 0);
signal valida,pulsada : STD_LOGIC;

begin

--Interconexiones

U1 : gestin_columnas port map(clk,Rst,col0,col1,col2,col3,col_activa);
U2 : gestion_filas port map(clk,Rst,fila0,fila1,fila2,fila3,pulsada,fila_pulsada);
U3 : tecla_pulsada port map(col_activa,fila_pulsada,pulsada,tecla,valida);
U4 : codif_tecla port map(tecla,valida,Up0,Down0,Up1,Down1);
end Behavioral;

