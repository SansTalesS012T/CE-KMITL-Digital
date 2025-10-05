library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity ModN is
	generic(
		max_n		:	integer	:=	16;
		max_bit		:	integer	:=	4;
		start		:	integer	:=	0
	);
	port(
		clk_in, clr	:	in		std_logic;
		TC			:	out		std_logic;
		num			:	out		std_logic_vector(max_bit - 1 downto 0)
	);
end ModN;

architecture Behavioral of ModN is	
	signal counting	:	integer	:= start;
begin
	process(clk_in, clr, counting)
	begin
		if(clr = '1') then
			counting	<=	0;
		elsif(rising_edge(clk_in)) then
			if(counting = max_n - 1) then
				counting 	<= 	0;
				TC			<=	'1';
			else
				counting	<=	counting + 1;
				TC			<=	'0';
			end if;
		end if;
		num <= std_logic_vector(to_unsigned(counting, num'length));
	end process;
end Behavioral;