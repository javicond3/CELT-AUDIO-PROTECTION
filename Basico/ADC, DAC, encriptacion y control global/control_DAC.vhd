----------------------------------------------------------------------------------
-- BLOQUE DE CONTROL DEL DAC 
--
-- Se encarga de gestionar la comunicaci�n con el DAC
-- generando y enviando las se�ales que necesita para
-- realizar la conversi�n: 2 bytes de control + datos.
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity control_DAC is
    Port ( clk : in  STD_LOGIC;	--Reloj de la FPGA
           Rst : in  STD_LOGIC;	--Se�al de Reset
           start_DAC : in  STD_LOGIC; --Pone a funcionar el bloque
           end_DAC : out  STD_LOGIC; --Indica que el bloque ha terminado su funci�n
           valor_DAC : in  STD_LOGIC_VECTOR (11 downto 0);	--Bits de datos que se enviar�n al DAC
           CS1 : out  STD_LOGIC;	--Chip Select (habilitaci�n del DAC)
           SCLK : buffer  STD_LOGIC;	--Reloj SCLK (T = 2us) para sincronizar la comunicaci�n
           DIN : out  STD_LOGIC);	--Salida de bits en serie hacia el DAC
end control_DAC;

architecture Behavioral of control_DAC is

--Declaraci�n de se�ales necesarias

signal st : std_logic_vector(1 downto 0) := "00";	--Indicador del estado del bloque
signal en_cnt : std_logic := '0';	--Habilitaci�n el contador de 1 us
signal fin_de_cuenta : std_logic := '0';	--Salida del contador de 1 us (activa durante un flanco, cada 1us)
signal bit_DIN : std_logic_vector(3 downto 0) := "0000";	--Cuenta los bits enviados
signal dato_DAC : std_logic_vector(15 downto 0) := "0000000000000000";  --Almacenamiento del dato que se va a enviar al DAC
signal contador : std_logic_vector(5 downto 0) := "000000";	--Valor del contador de 1 us

begin


process (clk, Rst) 	--contador 1 us
		begin
			if (clk'event and clk='1') then
				fin_de_cuenta <= '0'; 	--Pone la se�al de salida a 0 en cada flanco de subida
				contador <= contador + '1'; 
				if (contador >= 50) then 	--El reloj de la FPGA tiene T = 20ns
					fin_de_cuenta <= '1'; 	--Cuando transcurra 1 us habr�n pasado 50 periodos
					contador <= "000000";	--Al transcurrir 1 us se activa la salida y se reinicia el contador
				end if;
			end if;
			if(Rst = '1' or en_cnt = '0') then	--Inicializaci�n de se�ales
				contador <= "000000";				--Si reset o cuenta deshabilitada
				fin_de_cuenta <= '0';
			end if;
		end process;
		
		process(clk, Rst)		--Generaci�n de la se�al SCLK (periodo de 2 us)
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
			en_cnt <= '0';
			bit_DIN <= "0000";
			dato_DAC <= "0000000000000000";
		elsif (clk'event and clk = '1') then
			case st is
				when "00" => 	--Reposo (Estado 00)
					end_DAC <= '0';	--Inicializar se�ales
					en_cnt <= '0';
					bit_DIN <= "0000";
					dato_DAC <= "000"&valor_DAC&'0';
					if (start_DAC = '1') then
						st <= "01";
					end if;
				when "01" => --Env�o de los 2 bytes de control y datos (Estado 01)
					en_cnt <= '1';
					if(fin_de_cuenta = '1' and SCLK = '1') then  --Flancos de bajada
						dato_DAC <= dato_DAC(14 downto 0)&'0'; --Desplaza los bits a enviar
						bit_DIN <= bit_DIN + "01";
						if(bit_DIN >= "1111") then --Se han enviado los 2 bytes completos
							st <= "11";
							bit_DIN <= (others => '0');
						end if;
					end if;
				when "11" => --Fin de env�o de datos(Estado 11)
					st <= "00";	--Regresa al estado 00
					end_DAC <= '1';	--Indica que ha terminado el env�o
				when others =>	--Si algo fallase, vuelve al estado inicial
					st <= "00";			
			end case;
		end if;
	end process;
	
	CS1 <= not en_cnt; 	--Activaci�n o no del DAC (chip select activo en estado 01 y 11)
	DIN <= dato_DAC(15);	--Asignaci�n de la salida serie
								--al bit m�s significativo del dato a enviar
	
end Behavioral;

