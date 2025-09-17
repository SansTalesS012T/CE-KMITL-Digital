----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:19:24 09/17/2025 
-- Design Name: 
-- Module Name:    sevenSegmentController - Behavioral 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity sevenSegmentController is
	port(
		clk_in		:	in		std_logic;
		num_in		:	in		std_logic_vector(7 downto 0);
		bits_out		:	out	std_logic_vector(6 downto 0);
		common_out	:	out	std_logic_vector(3 downto 0)
	);
end sevenSegmentController;

architecture Behavioral of sevenSegmentController is
	function hex_to_7segment (bits :  std_logic_vector (3 downto 0)) return std_logic_vector is
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
	
	signal commoning	:	std_logic	:=	'0';
	
begin

	process(clk_in)
	begin
		if(rising_edge(clk_in)) then
			commoning <= not commoning;
		end if;
	end process;
	
	process(commoning)
	begin
		if(commoning = '0') then
			common_out	<=	(0 => '0', others => '1');
		else
			common_out	<=	(1 => '0', others => '1');
		end if;
	end process;
	
	process(commoning)
	begin
		if(commoning = '0') then
			bits_out		<=	hex_to_7segment(num_in(3 downto 0));
		else
			bits_out		<=	hex_to_7segment(num_in(7 downto 4));
		end if;
	end process;
end Behavioral;

