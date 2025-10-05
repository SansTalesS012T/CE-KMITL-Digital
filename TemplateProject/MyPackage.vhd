library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;

package MyModule is
    type integer_vector is array (integer range <>) of integer;

    function Fibo(index: integer) return integer;

    component SevenSegmentController is
        generic(
            max_digit		:	integer	:=	1;
            use_digit		:	integer	:=	1
        );
        port(
            clk_in			:	in	std_logic;
            num_in			:	in	std_logic_vector(((4*use_digit) - 1) downto 0);
            bits_out		:	out	std_logic_vector(6 downto 0);
            common_out		:	out	std_logic_vector(max_digit - 1 downto 0)
        );
    end component;

    component ModN is
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
    end component;

    component CountForwardBackward is
        generic(
            max_n                           :   integer     :=  4;
            max_bit                         :   integer     :=  2;
            start_value                     :   integer     :=  0
        );
        port(
            clk_in, set_start, set_end      :   in      std_logic;
            tc_start, tc_end                :   out     std_logic;
            num_out                         :   out     std_logic_vector(max_bit - 1 downto 0)
        );
    end component;

    component CountSeq is
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
    end component;

    component BinaryToBCD is
        generic(
            N   : positive := 8
        );
        port(
            clk, reset                      :   in  std_logic;
            binary_in                       :   in  std_logic_vector(N - 1 downto 0);
            bcd0, bcd1, bcd2, bcd3, bcd4    :   out std_logic_vector(3 downto 0)
        );
    end component ;

end package MyModule;

package body MyModule is
    function Fibo(index : integer) return integer is
        variable a      :   integer := 0;
        variable b      :   integer := 1;
        variable res    :   integer;
        variable i      :   integer := 1;
    begin
        if(index = 0 or index = 1) then
            return index;
        end if;
        while(i < index) loop
            res :=  a + b;
            a   :=  b;
            b   :=  res;
            i   :=  i + 1;
        end loop;
        return res;
    end function Fibo;
end package body MyModule;