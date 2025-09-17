----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:13:01 09/17/2025 
-- Design Name: 
-- Module Name:    ALU - Behavioral 
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
use IEEE.numeric_std.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ALU is
	port(
		A, B		:	in		std_logic_vector(7 downto 0);
		command	:	in		std_logic_vector(1 downto 0);
		C			:	out	std_logic_vector(7 downto 0)
	);
end ALU;

architecture Behavioral of ALU is
	function twoCompli(num_in	:	std_logic_vector(7 downto 0)) return std_logic_vector is
		variable	num_out	:	std_logic_vector(7 downto 0);
		variable tempNum	:	signed(7 downto 0);
	begin
		tempNum	:=	(not signed(num_in)) + 1;
		num_out	:=	std_logic_vector(tempNum);
		return num_out;
	end function;
	
	signal tempA, tempB	:	signed(7 downto 0);
begin
	process(command, A, B) 
	begin
		if(command = "00") then 	-- Add
			C	<=	std_logic_vector(signed(A) + signed(B));
		elsif(command = "01") then	-- Sub
			C	<=	std_logic_vector(signed(A) + signed(twoCompli(B)));
		elsif(command = "10") then -- Xor
			C	<=	A xor B;
		elsif(command = "11") then -- SHL
			C 	<=	A(6 downto 0) & '0';
		end if;
	end process;

end Behavioral;

