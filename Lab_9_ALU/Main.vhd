----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:16:04 09/17/2025 
-- Design Name: 
-- Module Name:    Main - Behavioral 
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

entity Main is
	port(
		clk_in			:	in		std_logic;
		butt1				:	in		std_logic;
		A, B				:	in		std_logic_vector(7 downto 0);
		segment_bits	:	out	std_logic_vector(6 downto 0);
		common			:	out	std_logic_vector(3 downto 0);
		command_led		:	out	std_logic_vector(1 downto 0)
	);
end Main;

architecture Behavioral of Main is
	component sevenSegmentController is
		port(
			clk_in		:	in		std_logic;
			num_in		:	in		std_logic_vector(7 downto 0);
			bits_out		:	out	std_logic_vector(6 downto 0);
			common_out	:	out	std_logic_vector(3 downto 0)
		);
	end component;
	
	component ModN is
		generic(
			maxN			:	integer	:=	16;
			maxBit		:	integer	:=	4
		);
		port(
			clk_in, clr	:	in		std_logic;
			TC				:	out	std_logic;
			num			:	out	std_logic_vector(maxBit - 1 downto 0)
		);
	end component;
	
	component ALU is
		port(
			A, B			:	in		std_logic_vector(7 downto 0);
			command		:	in		std_logic_vector(1 downto 0);
			C				:	out	std_logic_vector(7 downto 0)
		);
	end component;
	
	signal tc1			:	std_logic	:=	'0';
	signal c1			:	std_logic_vector(7 downto 0);
	signal command		:	std_logic_vector(1 downto 0)	:=	"00";
	
begin
	modn1: ModN generic map(
		maxN		=>	4,
		maxBit	=>	2
	) port map(
		clk_in	=>	butt1,
		clr		=>	'0',
		TC			=>	open,
		num		=>	command
	);
	command_led <=	command;
	
	modn2: ModN generic map(
		maxN		=>	8,
		maxBit	=>	3
	) port map(
		clk_in	=>	clk_in,
		clr		=>	'0',
		TC			=>	tc1,
		num		=>	open
	);
	
	ALU1: ALU port map(
		A 			=> A,
		B 			=> B,
		command	=>	command,
		C			=>	c1
	);
	
	seging: sevenSegmentController port map(
		clk_in		=>	tc1,
		num_in		=>	c1,
		bits_out		=>	segment_bits,
		common_out	=>	common
	);
	
end Behavioral;

