library IEEE;
use work.MyModule.all;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity CountSeq is
	generic(
        max_n       :   integer :=  4;
		max_bit		:	integer	:=	4;
        start       :   integer :=  0
	);
	port(
		clk_in, clr	:	in		std_logic;
        seq         :   in      integer_vector(0 to max_n - 1);
		TC			:	out		std_logic;
		num			:	out		std_logic_vector(max_bit - 1 downto 0)
	);
end CountSeq;

architecture Behavioral of CountSeq is	
	signal counting	:	integer	:= start;
begin
	process(clk_in, clr, counting, seq)
	begin
		if(clr = '1') then
			counting	<=	0;
		elsif(rising_edge(clk_in)) then
			if(counting = max_n - 1) then
				counting    <=  0;
				TC			<=	'1';
			else
				counting	<=	counting + 1;
				TC			<=	'0';
			end if;
		end if;
		num <= std_logic_vector(to_unsigned(seq(counting), num'length));
	end process;
end Behavioral;