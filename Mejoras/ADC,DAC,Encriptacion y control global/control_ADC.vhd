----------------------------------------------------------------------------------
-- BLOQUE DE CONTROL DEL ADC
-- 
-- Bloque encargado de gestionar la comunicaci�n con el ADC.
-- Se encarga de enviar en primer lugar el byte de petici�n
-- para configurar el modo de funcionamiento del ADC.
-- Una vez realizado el env�o recibir� el valor digital
-- de la muestra anal�gica procesada por el ADC.
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity control_ADC is
    Port ( clk : in  STD_LOGIC;	--Reloj de la FPGA
           Rst : in  STD_LOGIC;	--Se�al de Reset (SW-7)
           start_ADC : in  STD_LOGIC;	--Pone a funcionar el bloque
           end_ADC : out  STD_LOGIC; --Indica que el bloque ha terminado de realizar su funci�n							
           CS0 : out  STD_LOGIC;	--Chip Select (habilitaci�n del ADC)
           SCLK : buffer  STD_LOGIC; --Reloj SCLK (T = 2us) para sincronizar el env�o y la recepci�n.
           DIN : out  STD_LOGIC;	--Salida de datos serie hacia el ADC
           DOUT : in  STD_LOGIC;	--Recepci�n de datos en serie desde el ADC
           valor_ADC : out  STD_LOGIC_VECTOR (11 downto 0)); --Valor binario completo recibido desde el ADC
end control_ADC;

architecture Behavioral of control_ADC is

--Declaraci�n de se�ales

signal st : std_logic_vector(1 downto 0) := "00";	--Indicador del estado en que se encuentra el bloque
signal byte_peticion_ADC : std_logic_vector(7 downto 0) := "00000000"; --Byte de petici�n
signal en_cnt : std_logic := '0';	--Habilitaci�n del contador de 1 us
signal fin_de_cuenta : std_logic := '0';	--Salida del contador de 1 us (activa durante un flanco, cada 1us)
signal bit_DIN : std_logic_vector(3 downto 0) := "0000";	--Cuenta los bits enviados/recibidos
signal dato_ADC : std_logic_vector(15 downto 0) := "0000000000000000";	--Almacena el dato recibido en serie por el ADC
signal contador : std_logic_vector(5 downto 0) := "000000";	--Valor del contador de 1 us

begin

	process (clk, Rst) 			--contador 1 us
		begin
			if (clk'event and clk='1') then
				fin_de_cuenta <= '0';	--Pone la se�al de salida a 0 en cada flanco de subida
				contador <= contador + '1'; 
				if (contador >= 50) then	--El reloj de la FPGA tiene T = 20ns
					fin_de_cuenta <= '1';	--Cuando transcurra 1 us habr�n pasado 50 periodos
					contador <= "000000";	--Al transcurrir 1 us se activa la salida y se reinicia el contador
				end if;
			end if;
			if(Rst = '1' or en_cnt = '0') then	--Inicializaci�n de se�ales si Reset o cuenta deshabilitada
				contador <= "000000";
				fin_de_cuenta <= '0';
			end if;
		end process;
		
		process(clk, Rst)	--Generaci�n de la se�al SCLK (periodo de 2 us)
			begin
				if (clk'event and clk = '1') then
					if(fin_de_cuenta = '1') then	--Al activarse fin_de_cuenta
						SCLK <= not SCLK;	--habr� pasado medio periodo de SCLK
					end if;
				end if;
				if (Rst = '1') then	--Inicializaci�n de SCLK si hay Reset
					SCLK <= '0';
				end if;
		end process;

	process(Rst,clk)
	begin
		if(Rst = '1') then	--Inicializar todas las se�ales si hay un reset
			st <= "00";
			byte_peticion_ADC <= "00000000";
			en_cnt <= '0';
			bit_DIN <= "0000";
			dato_ADC <= "0000000000000000";
		elsif (clk'event and clk = '1') then
			case st is
				when "00" => 	--Reposo (Estado 00)									
					end_ADC <= '0';	--Inicializar se�ales
					en_cnt <= '0';		--Contador inhabilitado
					bit_DIN <= "0000";
					dato_ADC <= "0000000000000000";
					byte_peticion_ADC <= "10010111";
					if (start_ADC = '1') then	--Esperar hasta que se active start_ADC
						st <= "01";
					end if;
				when "01" => 	--Entrega de la petici�n (Estado 01)
					en_cnt <= '1';		--Habilita el contador
					if(fin_de_cuenta = '1' and SCLK = '1') then 	--Flanco de bajada
						byte_peticion_ADC <= byte_peticion_ADC(6 downto 0)&'0';  --Desplaza petici�n
						bit_DIN <= bit_DIN + "01";
						if(bit_DIN >= "0111") then 	--Se ha enviado la petici�n completa
							st <= "10";
							bit_DIN <= (others => '0');
						end if;
					end if;
				when "10" => 	--Recepci�n de los datos serie (Estado 10)
					en_cnt <= '1';
					if(fin_de_cuenta = '1' and SCLK = '0') then	--Flanco de subida de SCLK
						dato_ADC <= dato_ADC(14 downto 0) & DOUT; --Recepci�n serie
					end if;
					if(fin_de_cuenta = '1' and SCLK = '1') then 	--Flanco de bajada de SCLK
						bit_DIN <= bit_DIN + "01";
						if (bit_DIN = "1111") then --Espera a recibir el dato completo
							st <= "11";
							bit_DIN <= (others => '0');
						end if;
					end if;
				when "11" =>	--Fin de env�o y recepci�n (Estado 11)
					st <= "00";	--Vuelve al estado inicial
					valor_ADC <= dato_ADC(14 downto 3);	--Coge los bits de informaci�n (12 bits) recibidos en serie
					end_ADC <= '1';	--Indica que ha terminado de operar
				when others =>
					st <= "00";	--Si algo fallase, vuelve al estado inicial
			end case;
		end if;
	end process;
	
	DIN <= byte_peticion_ADC(7); 	--Coge el bit mas significativo de la peticion
	CS0 <= not en_cnt; --Activaci�n o no del ADC (chip select activo en los estados 01,10 y 11)

end Behavioral;

