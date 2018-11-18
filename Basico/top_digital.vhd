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
    Port ( clk : in  STD_LOGIC;	--Reloj de la FPGA
           Puls : in  STD_LOGIC_VECTOR (3 downto 0);	--Pulsadores
           SW : in  STD_LOGIC_VECTOR (5 downto 0);	--Switches
           Rst : in  STD_LOGIC; --Señal de Reset (SW 7)
           Disp : out  STD_LOGIC_VECTOR (3 downto 0);	--Activación de displays
           Seg7 : out  STD_LOGIC_VECTOR (6 downto 0);	--7 Segmentos del display activo
           DOUT : in  STD_LOGIC;	--Salida serie del ADC/DAC
           CS0 : out  STD_LOGIC;	--Chip Select para activar ADC
           CS1 : out  STD_LOGIC;	--Chip Select para activar DAC
           DIN : out  STD_LOGIC;	--Entrada serie del ADC/DAC
           SCLK : out  STD_LOGIC);	--Señal SCLK del ADC/DAC
end top_digital;

architecture Behavioral of top_digital is

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
           valor_DAC : out  STD_LOGIC_VECTOR (11 downto 0));
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

--Declaración de señales intermedias

signal b : STD_LOGIC_VECTOR (5 downto 0);
signal sADC : STD_LOGIC_VECTOR (11 downto 0);
signal sDAC : STD_LOGIC_VECTOR (11 downto 0);
signal start_ADC,start_DAC,start_random,end_random,end_ADC,end_DAC,SCLK1,SCLK2,DIN1,DIN2 : STD_LOGIC;
signal global_st : STD_LOGIC_VECTOR(1 downto 0);


begin

--Interconexión de bloques

U1 : control_pulsadores port map(clk,Rst,Puls(0),Puls(1),Puls(2),Puls(3),b);
U2 : control_displays port map(b,clk,Disp(0),Disp(1),Disp(2),Disp(3),Seg7);
U3 : control_ADC port map(clk,Rst,start_ADC,end_ADC,CS0,SCLK1,DIN1,DOUT,sADC);
U4 : pseudo_random port map(clk,Rst,start_random,end_random,SW,b,sADC,sDAC);
U5 : control_DAC port map(clk,Rst,start_DAC,end_DAC,sDAC,CS1,SCLK2,DIN2);
U6 : control_global port map(clk,Rst,start_ADC,start_random,start_DAC,end_ADC,end_random,end_DAC,global_st);

process(clk)	--Elección de las señales SCLK y DIN
	begin			--Depende de si opera el DAC o el ADC
	case global_st is
		when "01" => SCLK <= SCLK1; DIN <= DIN1;
		when "10" => SCLK <= SCLK2; DIN <= DIN2;
		when others => SCLK <= '0'; DIN <= '0';
	end case;
end process;

end Behavioral;

