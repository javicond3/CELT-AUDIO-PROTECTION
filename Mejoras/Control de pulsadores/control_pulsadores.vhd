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
    Port ( clk : in  STD_LOGIC;										--Reloj de la FPGA (T = 20ns)
           Rst : in  STD_LOGIC;										--Señal de Reset
           Up0 : in  STD_LOGIC;										--Incrementar una unidad 
           Down0 : in  STD_LOGIC;									--Decrementar una unidad
           Up1 : in  STD_LOGIC;										--Incrementar 10 unidades
           Down1 : in  STD_LOGIC;									--Decrementar 10 unidades
           b : out  STD_LOGIC_VECTOR (5 downto 0);				--Código,en binario, generado por el usuario
			  filas : in STD_LOGIC_VECTOR (3 downto 0);			--Filas teclado matricial
			  columnas : out STD_LOGIC_VECTOR (3 downto 0);		--Columnas teclado matricial
			  SW6 : in STD_LOGIC);										--Seleccion teclado-pulsadores
end control_pulsadores;

architecture Behavioral of control_pulsadores is

component contador_100ms is 								--Declaración de componentes
    Port ( clk : in  STD_LOGIC; 
           rst_cnt : in  STD_LOGIC; 
           en_cnt : in  STD_LOGIC;  
           cnt_100ms : out  STD_LOGIC); 
end component;

component contador_50ms is			
    Port ( clk : in  STD_LOGIC;  
           rst_cnt : in  STD_LOGIC; 
           en_cnt : in  STD_LOGIC; 
           cnt_50ms : out  STD_LOGIC); 
end component;

component MooreFSM_mejora is  
    Port ( clk : in STD_LOGIC; 
			  Up0 : in  STD_LOGIC; 
           Down0 : in  STD_LOGIC; 
           Rst : in  STD_LOGIC; 
           cnt_100ms : in  STD_LOGIC; 
			  cnt_50ms : in  STD_LOGIC; 
           rst_b : out  STD_LOGIC; 
           rst_cnt_100 : out  STD_LOGIC;
           en_cnt_100 : out  STD_LOGIC;
			  rst_cnt_50 : out  STD_LOGIC;
           en_cnt_50 : out  STD_LOGIC;
           en_b : out  STD_LOGIC;
           sel : out  STD_LOGIC_VECTOR (1 downto 0));
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

component top_teclado is
    Port ( clk : in STD_LOGIC;
			  Rst : in STD_LOGIC;
			  fila0 : in  STD_LOGIC;
           fila1 : in  STD_LOGIC;
           fila2 : in  STD_LOGIC;
           fila3 : in  STD_LOGIC;
           col0 : out  STD_LOGIC;
           col1 : out  STD_LOGIC;
           col2 : out  STD_LOGIC;
           col3 : out  STD_LOGIC;
           Up0 : out  STD_LOGIC;
           Down0 : out  STD_LOGIC;
           Up1 : out  STD_LOGIC;
           Down1 : out  STD_LOGIC);
end component;
						--Declaración de señales intermedias
						
signal s_rst_cnt_50, s_en_cnt_50, s_cnt_50ms : STD_LOGIC;
signal s_rst_cnt_100_1, s_en_cnt_100_1, s_cnt_100ms_1, s_rst_cnt_100_2, s_en_cnt_100_2, s_cnt_100ms_2 : STD_LOGIC;
signal s_sel,s_sel1,s_sel2 : STD_LOGIC_VECTOR(1 downto 0);
signal t_Up0,t_Down0,t_Up1,t_Down1 : STD_LOGIC;
signal s_en_b,s_en_b1,s_en_b2,s_rst_b1,s_rst_b2,s_rst_b : STD_LOGIC;



begin
						--Interconexión de bloques

U1 : MooreFSM_mejora port map(clk,Up0,Down0,Rst,s_cnt_100ms_1,s_cnt_50ms,s_rst_b1,s_rst_cnt_100_1,s_en_cnt_100_1,s_rst_cnt_50,s_en_cnt_50,s_en_b1,s_sel1);
U2 : contador_100ms port map (clk,s_rst_cnt_100_1,s_en_cnt_100_1,s_cnt_100ms_1);
U3 : contador_50ms port map (clk,s_rst_cnt_50,s_en_cnt_50,s_cnt_50ms); 
U4 : top_teclado port map(clk,Rst,filas(0),filas(1),filas(2),filas(3),columnas(0),columnas(1),columnas(2),columnas(3),t_Up0,t_Down0,t_Up1,t_Down1);
U5 : contador_100ms port map (clk,s_rst_cnt_100_2,s_en_cnt_100_2,s_cnt_100ms_2);
U6 : MooreFSM port map(clk,t_Up0,t_Down0,t_Up1,t_Down1,Rst,s_cnt_100ms_2,s_rst_b2,s_rst_cnt_100_2,s_en_cnt_100_2,s_en_b2,s_sel2);
U7 : Reg_b port map (clk,s_rst_b,s_en_b,s_sel,b);

process(clk)	--Selección entre teclado matricial o pulsadores (en función del switch sw6)
	begin
		if(SW6 = '1') then
			s_sel <= s_sel2;
			s_en_b <= s_en_b2;
			s_rst_b <= s_rst_b2;
		else
			s_sel <= s_sel1;
			s_en_b <= s_en_b1;
			s_rst_b <= s_rst_b1;
		end if;
end process;

end Behavioral;

