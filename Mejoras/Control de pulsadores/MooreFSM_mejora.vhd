----------------------------------------------------------------------------------
-- AUTÓMATA DE MOORE PARA CONTROLAR LOS PULSADORES (MEJORA)
--
-- Se trata de una máquina de estados que gestiona a la vez
-- los contadores de 100ms y 50 ms (este último como mejora) 
-- y controla el valor b del registro Reg_b, que se corresponderá
-- con el valor seleccionado por el usuario a través de los
-- pulsadores, y codificado en binario.
----------------------------------------------------------------------------------

library IEEE;   
use IEEE.STD_LOGIC_1164.ALL; 
use IEEE.STD_LOGIC_ARITH.ALL; 
use IEEE.STD_LOGIC_UNSIGNED.ALL; 


entity MooreFSM_mejora is  		
    Port ( clk : in STD_LOGIC; 	--Reloj de la FPGA
			  Up0 : in  STD_LOGIC; 	--Aumentar en 1
           Down0 : in  STD_LOGIC; --Disminuir en 1
           Rst : in  STD_LOGIC; --Reset
           cnt_100ms : in  STD_LOGIC; --Fin de la cuenta de 100ms
			  cnt_50ms : in  STD_LOGIC; --Fin de la cuenta de 50ms (mejora)
           rst_b : out  STD_LOGIC; 	--Reset del registro Reg_b
           rst_cnt_100 : out  STD_LOGIC;	--Reset del contador de 100ms
           en_cnt_100 : out  STD_LOGIC;	--Enable del contador de 100ms
			  rst_cnt_50 : out  STD_LOGIC; --Reset del contador de 50 ms
           en_cnt_50 : out  STD_LOGIC;	--Enable del contador de 50ms
           en_b : out  STD_LOGIC; --Enable del registro Reg_b
           sel : out  STD_LOGIC_VECTOR (1 downto 0)); --Controla la modificación de b en el registro
end MooreFSM_mejora;

architecture Behavioral of MooreFSM_mejora is

--Declaración de señales

type clase_estado is (st_Reset, st_Main, st_Up0a, st_Up0b, st_Up0c,st_Up0d,st_Down0a, st_Down0b,st_Down0c,st_Down0d);
signal estado_actual: clase_estado := st_Reset;
signal estado_siguiente: clase_estado := st_Main;

begin

--State memory 
process(clk) 					-- Se actualiza el estado del autómata en cada ciclo de clk
	begin
		if(clk = '1' and clk'event) then
			estado_actual <= estado_siguiente;
		end if;
end process;

--Next-state logic 
process(estado_actual,Rst,Up0,Down0,cnt_100ms,cnt_50ms)
	begin
		case estado_actual is
			when st_Reset =>		--Estado al que se va tras pulsar el Reset
				estado_siguiente <= st_Main;
			when st_Main => 	--Si se pulsa algún pulsador, se salta a otro estado
				if (Up0 = '1') then 			--Depende de qué pulsador se toque
					estado_siguiente <= st_Up0a;
				elsif(Down0 = '1') then
					estado_siguiente <= st_Down0a;
				elsif(Rst = '1') then
					estado_siguiente <= st_Reset;
				else
					estado_siguiente <= st_Main;
				end if;
			when st_Up0a =>	--Estados del pulsador que incrementa en uno
				if (cnt_100ms = '0') then
					estado_siguiente <= st_Up0a;
				else
					estado_siguiente <= st_Up0b;
				end if;
			when st_Up0b =>
				if (Up0 = '0') then
					estado_siguiente <= st_Main;
				else
					estado_siguiente <= st_Up0c;
				end if;
			when st_Up0c =>
				if (cnt_50ms = '0') then
					estado_siguiente <= st_Up0c;
				else
					estado_siguiente <= st_Up0d;
				end if;
			when st_Up0d =>
				estado_siguiente <= st_Up0b;
			when st_Down0a =>	--Estados del pulsador que decrementa en uno
				if (cnt_100ms = '0') then
					estado_siguiente <= st_Down0a;
				else
					estado_siguiente <= st_Down0b;
				end if;
			when st_Down0b =>
				if (Down0 = '0') then
					estado_siguiente <= st_Main;
				else
					estado_siguiente <= st_Down0c;
				end if;
			when st_Down0c =>
				if (cnt_50ms = '0') then
					estado_siguiente <= st_Down0c;
				else
					estado_siguiente <= st_Down0d;
				end if;
			when st_Down0d =>
				estado_siguiente <= st_Down0b;
			when others =>
				estado_siguiente <= st_Main;
		end case;
end process;

--Output logic 				
process(estado_actual)	-- Actualiza las salidas del automáta en función del estado en que esté
	begin
		case estado_actual is
			when st_Reset =>
				rst_b <= '1';
				rst_cnt_100 <= '1';
				en_cnt_100 <= '0';
				rst_cnt_50 <= '1';
				en_cnt_50 <= '0';
				en_b <= '0';
				sel <= "00";
			when st_Main =>
				rst_b <= '0';
				rst_cnt_100 <= '1';
				en_cnt_100 <= '0';
				rst_cnt_50 <= '1';
				en_cnt_50 <= '0';
				en_b <= '0';
				sel <= "00";
			when st_Up0a =>
				rst_cnt_100 <= '0';
				en_cnt_100 <= '1';
				rst_cnt_50 <= '1';
				en_cnt_50 <= '0';
				en_b <= '0';
				sel <= "00";
				rst_b <= '0';
			when st_Up0b =>
				rst_b <= '0';
				rst_cnt_100 <= '1';
				en_cnt_100 <= '0';
				rst_cnt_50 <= '1';
				en_cnt_50 <= '0';
				en_b <= '1';
				sel <= "00";
			when st_Up0c =>
				rst_cnt_50 <= '0';
				en_cnt_50 <= '1';
				rst_cnt_100 <= '1';
				en_cnt_100 <= '0';
				en_b <= '0';
				sel <= "00";
				rst_b <= '0';
			when st_Up0d =>
				rst_b <= '0';
				rst_cnt_100 <= '1';
				en_cnt_100 <= '0';
				rst_cnt_50 <= '1';
				en_cnt_50 <= '0';
				en_b <= '1';
				sel <= "00";
			when st_Down0a =>
				rst_cnt_100 <= '0';
				en_cnt_100 <= '1';
				rst_cnt_50 <= '1';
				en_cnt_50 <= '0';
				en_b <= '0';
				sel <= "00";
				rst_b <= '0';
			when st_Down0b =>
				rst_b <= '0';
				rst_cnt_100 <= '1';
				en_cnt_100 <= '0';
				rst_cnt_50 <= '1';
				en_cnt_50 <= '0';
				en_b <= '1';
				sel <= "01";
			when st_Down0c =>
				rst_cnt_50 <= '0';
				en_cnt_50 <= '1';
				rst_cnt_100 <= '1';
				en_cnt_100 <= '0';
				en_b <= '0';
				sel <= "01";
				rst_b <= '0';
			when st_Down0d =>
				rst_b <= '0';
				rst_cnt_100 <= '1';
				en_cnt_100 <= '0';
				rst_cnt_50 <= '1';
				en_cnt_50 <= '0';
				en_b <= '1';
				sel <= "01";
		end case;
	end process;
	
end Behavioral;

