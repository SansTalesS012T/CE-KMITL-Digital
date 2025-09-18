library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity sevenSegmentController is
	generic(
		num_amount	:	integer	:=	1
	);
	port(
		clk_in		:	in	std_logic;
		num_in		:	in	std_logic_vector(((4*num_amount) - 1) downto 0);
		bits_out	:	out	std_logic_vector(6 downto 0);
		common_out	:	out	std_logic_vector(3 downto 0)
	);
end sevenSegmentController;

architecture Behavioral of sevenSegmentController is
	function hex_to_7segment (bits :  std_logic_vector (3 downto 0)	:=	"1010") return std_logic_vector is
		variable segments: std_logic_vector (6 downto 0); 
	begin
		case bits is 
			when "0000" => segments := "1111110";
			when "0001" => segments := "0110000";
			when "0010" => segments := "1101101";
			when "0011" => segments := "1111001";
			when "0100" => segments := "0110011";
			when "0101" => segments := "1011011";
			when "0110" => segments := "1011111";
			when "0111" => segments := "1110000";
			when "1000" => segments := "1111111";
			when "1001" => segments := "1111011";
			when "1010" => segments := "1110111";
			when "1011" => segments := "0011111";
			when "1100" => segments := "1001110";
			when "1101" => segments := "0111101";
			when "1110" => segments := "1001111";
			when "1111" => segments := "1000111";
			when others => segments := "0000000";
		end case;

		return segments;
	end function;
	
	signal commoning : integer := 0;
	
begin

	process(clk_in)
	begin
		if(rising_edge(clk_in)) then
			if(commoning = num_amount - 1) then
				commoning <= 0;
			else
				commoning <= commoning + 1;
			end if;
		end if;
	end process;
	
	process(commoning)
	begin
		common_out				<=	(others => '1');
		common_out(commoning) 	<=	'0';
		bits_out				<=	hex_to_7segment(num_in(((4*commoning) + 3) downto (4*commoning)));
	end process;
end Behavioral;
