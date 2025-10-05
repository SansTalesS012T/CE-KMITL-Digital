library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity CountForwardBackward is
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
end CountForwardBackward;

architecture behave of CountForwardBackward is
    signal count      :     integer     :=  start_value;
    signal mode       :     integer     :=  1;
    signal tc_s, tc_e :     std_logic;
begin
    process(clk_in, set_start, set_end)
    begin
        if(set_start = '1') then
            count   <=  0;
            mode    <=  1;
        elsif(set_end  = '1') then
            count   <=  max_n - 1;
            mode    <=  -1;
        end if;

        if(count = 0) then
            tc_s    <=  '1';
            mode    <=  1;
        elsif(count = max_n - 1) then
            tc_e    <=  '1';
            mode    <=  -1;
        else
            tc_s    <=  '0';
            tc_e    <=  '0';
        end if;

        if(rising_edge(clk_in)) then
            count   <=  count + mode;
        end if;
        
        tc_start    <=  tc_s;
        tc_end      <=  tc_e;
        num_out     <=  std_logic_vector(to_unsigned(count, num_out'length));
    end process;
end behave;