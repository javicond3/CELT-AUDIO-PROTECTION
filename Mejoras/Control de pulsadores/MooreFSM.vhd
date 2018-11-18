----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:48:25 10/17/2016 
-- Design Name: 
-- Module Name:    MooreFSM - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;   -- Librerias
use IEEE.STD_LOGIC_1164.ALL; 
use IEEE.STD_LOGIC_ARITH.ALL; 
use IEEE.STD_LOGIC_UNSIGNED.ALL; 

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity MooreFSM is  		--Entidad
    Port ( clk : in STD_LOGIC; --Reloj de la FPGA
			  Up0 : in  STD_LOGIC; --Aumentar en 1
           Down0 : in  STD_LOGIC; --Disminuir en 1
           Up1 : in  STD_LOGIC; --Aumentar en 10
           Down1 : in  STD_LOGIC; --Disminuir en 10
           Rst : in  STD_LOGIC; --Reset
           cnt_100ms : in  STD_LOGIC; 
           rst_b : out  STD_LOGIC; 
           rst_cnt : out  STD_LOGIC;
           en_cnt : out  STD_LOGIC;
           en_b : out  STD_LOGIC;
           sel : out  STD_LOGIC_VECTOR (1 downto 0));
end MooreFSM;

architecture Behavioral of MooreFSM is

type clase_estado is (st_Reset, st_Main, st_Up0a, st_Up0b, st_Down0a, st_Down0b, st_Up1a, st_Up1b, st_Down1a, st_Down1b);
signal estado_actual: clase_estado := st_Reset;
signal estado_siguiente: clase_estado := st_Main;

begin

--State memory
process(clk)
	begin
		if(clk = '1' and clk'event) then
			estado_actual <= estado_siguiente;
		end if;
end process;

--Next-state logic
process(estado_actual,Rst,Up0,Up1,Down0,Down1,cnt_100ms)
	begin
		case estado_actual is
			when st_Reset =>
				estado_siguiente <= st_Main;
			when st_Main =>
				if (Up0 = '1') then
					estado_siguiente <= st_Up0a;
				elsif(Down0 = '1') then
					estado_siguiente <= st_Down0a;
				elsif(Up1 = '1') then
					estado_siguiente <= st_Up1a;
				elsif(Down1 = '1') then
					estado_siguiente <= st_Down1a;
				elsif(Rst = '1') then
					estado_siguiente <= st_Reset;
				else
					estado_siguiente <= st_Main;
				end if;
			when st_Up0a =>
				if (cnt_100ms = '0') then
					estado_siguiente <= st_Up0a;
				else
					estado_siguiente <= st_Up0b;
				end if;
			when st_Up0b =>
				estado_siguiente <= st_Main;
			when st_Down0a =>
				if (cnt_100ms = '0') then
					estado_siguiente <= st_Down0a;
				else
					estado_siguiente <= st_Down0b;
				end if;
			when st_Down0b =>
				estado_siguiente <= st_Main;
			when st_Up1a =>
				if (cnt_100ms = '0') then
					estado_siguiente <= st_Up1a;
				else
					estado_siguiente <= st_Up1b;
				end if;
			when st_Up1b =>
				estado_siguiente <= st_Main;
			when st_Down1a =>
				if (cnt_100ms = '0') then
					estado_siguiente <= st_Down1a;
				else
					estado_siguiente <= st_Down1b;
				end if;
			when st_Down1b =>
				estado_siguiente <= st_Main;
			when others =>
				estado_siguiente <= st_Main;
		end case;
end process;

--Output logic
process(estado_actual)
	begin
		case estado_actual is
			when st_Reset =>
				rst_b <= '1';
				rst_cnt <= '1';
				en_cnt <= '0';
				en_b <= '0';
				sel <= "00";
			when st_Main =>
				rst_b <= '0';
				rst_cnt <= '1';
				en_cnt <= '0';
				en_b <= '0';
				sel <= "00";
			when st_Up0a =>
				rst_cnt <= '0';
				en_cnt <= '1';
				en_b <= '0';
				sel <= "00";
				rst_b <= '0';
			when st_Up0b =>
				rst_b <= '0';
				rst_cnt <= '1';
				en_cnt <= '0';
				en_b <= '1';
				sel <= "00";
			when st_Down0a =>
				rst_cnt <= '0';
				en_cnt <= '1';
				en_b <= '0';
				sel <= "00";
				rst_b <= '0';
			when st_Down0b =>
				rst_b <= '0';
				rst_cnt <= '1';
				en_cnt <= '0';
				en_b <= '1';
				sel <= "01";
			when st_Up1a=>
				rst_cnt <= '0';
				en_cnt <= '1';
				en_b <= '0';
				sel <= "00";
				rst_b <= '0';
			when st_Up1b =>
				rst_b <= '0';
				rst_cnt <= '1';
				en_cnt <= '0';
				en_b <= '1';
				sel <= "10";
			when st_Down1a =>
				rst_cnt <= '0';
				en_cnt <= '1';
				en_b <= '0';
				sel <= "00";
				rst_b <= '0';
			when st_Down1b =>
				rst_b <= '0';
				rst_cnt <= '1';
				en_cnt <= '0';
				en_b <= '1';
				sel <= "11";
		end case;
	end process;
	
end Behavioral;

