----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    08:59:02 09/17/2025 
-- Design Name: 
-- Module Name:    ModN - Behavioral 
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
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
-- use IEEE.MATH_REAL.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ModN is
	generic(
		maxN			:	integer	:=	16;
		maxBit		:	integer	:=	4
	);
	port(
		clk_in, clr	:	in		std_logic;
		TC				:	out	std_logic;
		num			:	out	std_logic_vector(maxBit - 1 downto 0)
	);
end ModN;

architecture Behavioral of ModN is	
	signal counting	:	integer	:=	0;
begin
	process
	begin
		if(clr = '1') then
			counting	<=	0;
		elsif(rising_edge(clk_in)) then
			if(counting = maxN - 1) then
				counting <= 0;
				TC			<=	'1';
			else
				counting	<=	counting + 1;
				TC			<=	'0';
			end if;
		end if;
		num <= std_logic_vector(to_unsigned(counting, num'length));
	end process;
end Behavioral;