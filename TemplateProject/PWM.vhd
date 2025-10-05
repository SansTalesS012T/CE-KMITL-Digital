library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity pwm is
    generic(
        duty_cycle  :   integer := 70   
    );
    port(
        clk, rst    :   in  std_logic;
        pwm_out     :   out std_logic
    );
end pwm;

architecture behave of pwm is
    signal cnt  :   std_logic_vector(7 downto 0);
begin 
    process(clk, rst)
    begin 
        if(rst = '1') then
            cnt <= (others => '0');
        elsif rising_edge(clk) then
            if(cnt < 99) then
                cnt <= cnt + 1;
            else
                cnt <= (others => '0');
            end if;
        end if;
    end process;
    pwm_out <= '1' when cnt < duty_cycle else '0';
end behave;