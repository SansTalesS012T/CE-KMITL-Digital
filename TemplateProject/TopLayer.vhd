library IEEE;
use work.MyModule.all;
use IEEE.STD_LOGIC_1164.ALL;

entity testing2 is
	port( 
		clk_in		:	in		std_logic;
		segment_bit	:	out	    std_logic_vector(6 downto 0);
		common		:	out		std_logic_vector(3 downto 0)
	);
end testing2;

architecture Behavioral of testing2 is
	signal moded8, moded20M	: 	std_logic;
	-- signal seq				:	integer_vector(0 to 9) 			:= (7, 9, 1, 5, 0, 2, 4, 3, 8, 6);
	signal tempNum			:	std_logic_vector(3 downto 0)	:=	"0000";
begin
	mod8: ModN
		generic map(
			max_n	=>	8,
			max_bit	=>	3
		) port map(
			clk_in	=>	clk_in,
			clr		=>	'0',
			TC		=>	moded8,
			num		=>	open
		);

	mod20M: ModN
		generic map(
			max_n	=>	20000000,
			max_bit	=>	27
		) port map(
			clk_in	=>	clk_in,
			clr		=>	'0',
			TC		=>	moded20M,
			num		=>	open
		);
    
	segmentControl:	sevenSegmentController
		generic map(
			max_digit	=>	4,
			use_digit	=>	1
		) port map(
			clk_in		=>	moded8,
			num_in		=>	tempNum,
			bits_out	=>	segment_bit,	
			common_out	=>	common
		);
end Behavioral;