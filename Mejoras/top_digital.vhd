----------------------------------------------------------------------------------
-- FICHERO TOP (GLOBAL)
--
-- Este bloque es la "caja negra" del sistema
-- Se encarga de interconectar todos los bloques
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;



entity top_digital is
    Port ( clk : in  STD_LOGIC;										--Reloj de la FPGA
           Puls : in  STD_LOGIC_VECTOR (3 downto 0);			--Pulsadores
           SW : in  STD_LOGIC_VECTOR (5 downto 0);				--Switches que controlan el c�digo (SW0-SW5)
			  SW6 : in STD_LOGIC; 										--Swtich que elige teclado matricial o pulsadores (SW 6)
           Rst : in  STD_LOGIC; 										--Switch para el reset (SW7)
           Disp : out  STD_LOGIC_VECTOR (3 downto 0);			--Indicador de qu� display est� encendido
           Seg7 : out  STD_LOGIC_VECTOR (6 downto 0);			--7 segmentos a mostrar en el display activo
           DOUT : in  STD_LOGIC;										--Recepci�n serie desde el ADC
           CS0 : out  STD_LOGIC;										--Chip select 0 (activaci�n de ADC)
           CS1 : out  STD_LOGIC;										--Chip select 1 (activaci�n del DAC)
           DIN : out  STD_LOGIC;										--Env�o serie al ADC/DAC
           SCLK : out  STD_LOGIC;									--Se�al de reloj SCLK usada con el ADC/DAC
			  LEDS : out STD_LOGIC_VECTOR (7 downto 0); 			--Se�ales de activaci�n de leds
			  filas : in STD_LOGIC_VECTOR (3 downto 0);			--Filas teclado matricial
			  columnas : out STD_LOGIC_VECTOR (3 downto 0));	--Columnas teclado matricial
end top_digital;

architecture Behavioral of top_digital is

--Declaraci�n de componentes
									
component control_pulsadores is 			
    Port ( clk : in  STD_LOGIC;
           Rst : in  STD_LOGIC;
           Up0 : in  STD_LOGIC;
           Down0 : in  STD_LOGIC;
           Up1 : in  STD_LOGIC;
           Down1 : in  STD_LOGIC;
           b : out  STD_LOGIC_VECTOR (5 downto 0);
			  filas : in STD_LOGIC_VECTOR (3 downto 0);
			  columnas : out STD_LOGIC_VECTOR (3 downto 0);		
			  SW6 : in STD_LOGIC);										
end component;

component control_displays is 
    Port ( f : in  STD_LOGIC_VECTOR (5 downto 0);
			  Rst : in STD_LOGIC;
			  sw : in  STD_LOGIC_VECTOR (5 downto 0);
           clk : in  STD_LOGIC;
           Disp0 : out  STD_LOGIC;
           Disp1 : out  STD_LOGIC;
           Disp2 : out  STD_LOGIC;
           Disp3 : out  STD_LOGIC;
           Seg7 : out  STD_LOGIC_VECTOR (6 downto 0);
			  pulsador : in STD_LOGIC);
end component;

component control_ADC is
    Port ( clk : in  STD_LOGIC;
           Rst : in  STD_LOGIC;
           start_ADC : in  STD_LOGIC;
           end_ADC : out  STD_LOGIC;
           CS0 : out  STD_LOGIC;
           SCLK : buffer  STD_LOGIC;
           DIN : out  STD_LOGIC;
           DOUT : in  STD_LOGIC;
           valor_ADC : out  STD_LOGIC_VECTOR (11 downto 0));
end component;

component pseudo_random is
    Port ( clk : in  STD_LOGIC;
           Rst : in  STD_LOGIC;
           start_random : in  STD_LOGIC;
           end_random : out  STD_LOGIC;
           sw : in  STD_LOGIC_VECTOR (5 downto 0);
           b : in  STD_LOGIC_VECTOR (5 downto 0);
           valor_ADC : in  STD_LOGIC_VECTOR (11 downto 0);
           valor_DAC : out  STD_LOGIC_VECTOR (11 downto 0);
			  mute : in STD_LOGIC);
end component;

component control_DAC is
    Port ( clk : in  STD_LOGIC;
           Rst : in  STD_LOGIC;
           start_DAC : in  STD_LOGIC;
           end_DAC : out  STD_LOGIC;
           valor_DAC : in  STD_LOGIC_VECTOR (11 downto 0);
           CS1 : out  STD_LOGIC;
           SCLK : buffer  STD_LOGIC;
           DIN : out  STD_LOGIC);
end component;

component control_global is
    Port ( clk : in  STD_LOGIC;
           Rst : in  STD_LOGIC;
           start_ADC : out  STD_LOGIC;
           start_random : out  STD_LOGIC;
           start_DAC : out  STD_LOGIC;
           end_ADC : in  STD_LOGIC;
           end_random : in  STD_LOGIC;
           end_DAC : in  STD_LOGIC;
           global_st : out  STD_LOGIC_VECTOR (1 downto 0));
end component;

component control_teclado is
    Port ( clk : in  STD_LOGIC;
           Rst : in  STD_LOGIC;
			  fila0 : in  STD_LOGIC;
           fila1 : in  STD_LOGIC;
           fila2 : in  STD_LOGIC;
           fila3 : in  STD_LOGIC;
           col0 : out  STD_LOGIC;
           col1 : out  STD_LOGIC;
           col2 : out  STD_LOGIC;
           col3 : out  STD_LOGIC;
           b : out  STD_LOGIC_VECTOR (5 downto 0));
end component;
															
signal b : STD_LOGIC_VECTOR (5 downto 0);			--Declaraci�n de se�ales intermedias
signal sADC : STD_LOGIC_VECTOR (11 downto 0);
signal sDAC : STD_LOGIC_VECTOR (11 downto 0);
signal start_ADC,start_DAC,start_random,end_random,end_ADC,end_DAC,SCLK1,SCLK2,DIN1,DIN2 : STD_LOGIC;
signal global_st : STD_LOGIC_VECTOR(1 downto 0);


begin
			--Interconexi�n de bloques
	
U1 : control_pulsadores port map(clk,Rst,Puls(0),Puls(1),Puls(2),Puls(3),b,filas,columnas,SW6);
U2 : control_displays port map(b,Rst,SW,clk,Disp(0),Disp(1),Disp(2),Disp(3),Seg7,Puls(3));
U3 : control_ADC port map(clk,Rst,start_ADC,end_ADC,CS0,SCLK1,DIN1,DOUT,sADC);
U4 : pseudo_random port map(clk,Rst,start_random,end_random,SW,b,sADC,sDAC,Puls(2));
U5 : control_DAC port map(clk,Rst,start_DAC,end_DAC,sDAC,CS1,SCLK2,DIN2);
U6 : control_global port map(clk,Rst,start_ADC,start_random,start_DAC,end_ADC,end_random,end_DAC,global_st);

process(clk)	--Decisi�n de las salidas DIN y SCLK, en funci�n de si opera el DAC o el ADC
	begin
	case global_st is
		when "01" => SCLK <= SCLK1; DIN <= DIN1;
		when "10" => SCLK <= SCLK2; DIN <= DIN2;
		when others => SCLK <= '0'; DIN <= '0';
	end case;
end process;

LEDS (5 downto 0) <= SW;
LEDS(6) <= SW6;
LEDS (7) <= Rst;

end Behavioral;

