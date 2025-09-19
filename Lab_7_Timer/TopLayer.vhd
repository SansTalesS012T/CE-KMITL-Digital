library ieee;
use ieee.std_logic_1164.all;

entity TopLayer is
    port(
        stopButton, resetButton, clkIn      :   in      std_logic;  
        ledDot                              :   out     std_logic;
        segmentBit  	                    :	out	    std_logic_vector(6 downto 0);
		common			                    :	out 	std_logic_vector(3 downto 0)
    );
end TopLayer;

architecture behave of TopLayer is
    component sevenSegmentController is
        generic(
            num_amount	:	integer	:=	1
        );
        port(
            clk_in		:	in	std_logic;
            num_in		:	in	std_logic_vector(((4*num_amount) - 1) downto 0);
            bits_out	:	out	std_logic_vector(6 downto 0);
            common_out	:	out	std_logic_vector(3 downto 0)
        );
    end component;
    
    component ModN is
        generic(
            maxN		:	integer	:=	16;
            maxBit		:	integer	:=	4
        );
        port(
            clk_in, clr	:	in		std_logic;
            TC			:	out		std_logic;
            num			:	out		std_logic_vector(maxBit - 1 downto 0)
        );
    end component;

    type intArray is array (integer range <>) of integer;

    constant maxNArray                  :   intArray(0 to 3) := (10, 6, 10, 10);

    signal timeRunning, segmentFreq     :   std_logic   :=  '1';
    signal dotTC                        :   std_logic   :=  '0';
    signal dotRunning                   :   std_logic_vector(0 downto 0)    := "0";  
    signal timeNumber                   :   std_logic_vector(15 downto 0);
    signal tcVector                     :   std_logic_vector(4 downto 0)    := "00000";
    signal commonControl                :   std_logic_vector(3 downto 0);
begin
    process (stopButton)
    begin
        if(rising_edge(stopButton)) then
            timeRunning <= not timeRunning;
        end if;
    end process;

    process
    begin
        if(commonControl(2) = '0') then
            ledDot  <=  dotRunning(0);
        else
            ledDot  <=  '0';
        end if;
    end process;

    clock1Hz: ModN
        generic map(
            maxN    =>  20000000,
            maxBit  =>  25
        )
        port map(
            clk_in  =>  clkIn and timeRunning,
            clr     =>  resetButton and not timeRunning,
            TC      =>  tcVector(0),
            num     =>  open
        );

    tempClock1: ModN
        generic map(
            maxN    =>  10000000,
            maxBit  =>  25
        )
        port map(
            clk_in  =>  clkIn and timeRunning,
            clr     =>  resetButton and not timeRunning,
            TC      =>  dotTC,
            num     =>  open
        );

    tempClock2: ModN
        generic map(
            maxN    =>  2,
            maxBit  =>  1
        )
        port map(
            clk_in  =>  dotTC,
            clr     =>  resetButton and not timeRunning,
            TC      =>  open,
            num     =>  dotRunning
        );

    genModNBlock: for i in 0 to 3 generate
            digit: ModN
                generic map(
                    maxN    =>  maxNArray(i),
                    maxBit  =>  4
                ) port map(
                    clk_in  =>  tcVector(i),
                    clr     =>  resetButton and not timeRunning,
                    TC      =>  tcVector(i + 1),
                    num     =>  timeNumber(4*i + 3 downto 4*i)
                );
    end generate;

    -- digit1: ModN 
    --     generic map(
    --         maxN    =>  10,
    --         maxBit  =>  4
    --     ) port map(
    --         clk_in  =>  tcVector(0),
    --         clr     =>  resetButton and not timeRunning,
    --         TC      =>  tcVector(1),
    --         num     =>  timeNumber(3 downto 0)
    --     );

    -- digit2: ModN
    --     generic map(
    --         maxN    =>  6,
    --         maxBit  =>  4
    --     ) port map(
    --         clk_in  =>  tcVector(1),
    --         clr     =>  resetButton and not timeRunning,
    --         TC      =>  tcVector(2),
    --         num     =>  timeNumber(7 downto 4)
    --     );

    -- digit3: ModN
    --     generic map(
    --         maxN    =>  10,
    --         maxBit  =>  4
    --     ) port map(
    --         clk_in  =>  tcVector(2),
    --         clr     =>  resetButton and not timeRunning,
    --         TC      =>  tcVector(3),
    --         num     =>  timeNumber(11 downto 8)
    --     );
    
    -- digit4: ModN
    --     generic map(
    --         maxN    =>  10,
    --         maxBit  =>  4
    --     ) port map(
    --         clk_in  =>  tcVector(3),
    --         clr     =>  resetButton and not timeRunning,
    --         TC      =>  open,
    --         num     =>  timeNumber(15 downto 12)
    --     );

    forSegmentFreq: ModN
        generic map(
            maxN    =>  8,
            maxBit  =>  3
        ) port map(
            clk_in  =>  clkIn,
            clr     =>  '0',
            TC      =>  segmentFreq,
            num     =>  open
        );

    segmentManage: sevenSegmentController
        generic map(
            num_amount  =>  4
        ) port map(
            clk_in      =>  segmentFreq,
            num_in      =>  timeNumber,
            bits_out    =>  segmentBit,
            common_out  =>  commonControl
        );
    common <= commonControl;
end behave;