-- Testbench automatically generated online
-- at https://vhdl.lapinoo.net
-- Generation date : Wed, 06 May 2026 17:06:13 GMT
-- Request id : cfwk-fed377c2-69fb75050c985

library ieee;
use ieee.std_logic_1164.all;

entity tb_display_driver is
end tb_display_driver;

architecture tb of tb_display_driver is

    component display_driver
        port (
            clk          : in  std_logic;
            rst          : in  std_logic;
            data         : in  std_logic_vector(15 downto 0);
            digit_index  : in  std_logic_vector(1 downto 0);
            blink_enable : in  std_logic;
            seg          : out std_logic_vector(6 downto 0);
            anode        : out std_logic_vector(7 downto 0)
        );
    end component;

    signal clk          : std_logic := '0';
    signal rst          : std_logic := '0';
    signal data         : std_logic_vector(15 downto 0) := (others => '0');
    signal digit_index  : std_logic_vector(1 downto 0) := (others => '0');
    signal blink_enable : std_logic := '0';
    signal seg          : std_logic_vector(6 downto 0);
    signal anode        : std_logic_vector(7 downto 0);

    constant TbPeriod : time := 10 ns;
    signal TbClock    : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    dut : display_driver
        port map (
            clk          => clk,
            rst          => rst,
            data         => data,
            digit_index  => digit_index,
            blink_enable => blink_enable,
            seg          => seg,
            anode        => anode
        );

    -- Clock generation
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';
    clk <= TbClock;

    stimuli : process
    begin
        --------------------------------------------------------------------
        -- Initial values
        --------------------------------------------------------------------
        rst          <= '0';
        data         <= x"0000";
        digit_index  <= "00";
        blink_enable <= '0';

        wait for 20 ns;

        --------------------------------------------------------------------
        -- Reset
        --------------------------------------------------------------------
        rst <= '1';
        wait for 50 ns;
        rst <= '0';
        wait for 50 ns;

        --------------------------------------------------------------------
        -- Display value 2580 without blinking
        -- data = d3 & d2 & d1 & d0
        -- d0 = 2, d1 = 5, d2 = 8, d3 = 0
        --------------------------------------------------------------------
        data <= x"0852";
        digit_index <= "00";
        blink_enable <= '0';

        wait for 2 ms;

        --------------------------------------------------------------------
        -- Blink first digit d0
        --------------------------------------------------------------------
        digit_index <= "00";
        blink_enable <= '1';

        wait for 2 ms;

        --------------------------------------------------------------------
        -- Blink second digit d1
        --------------------------------------------------------------------
        digit_index <= "01";

        wait for 2 ms;

        --------------------------------------------------------------------
        -- Blink third digit d2
        --------------------------------------------------------------------
        digit_index <= "10";

        wait for 2 ms;

        --------------------------------------------------------------------
        -- Blink fourth digit d3
        --------------------------------------------------------------------
        digit_index <= "11";

        wait for 2 ms;

        --------------------------------------------------------------------
        -- Disable blinking again
        --------------------------------------------------------------------
        blink_enable <= '0';

        wait for 1 ms;

        --------------------------------------------------------------------
        -- Change displayed value to 1234
        -- d0 = 1, d1 = 2, d2 = 3, d3 = 4
        --------------------------------------------------------------------
        data <= x"4321";
        digit_index <= "00";
        blink_enable <= '1';

        wait for 2 ms;

        --------------------------------------------------------------------
        -- End simulation
        --------------------------------------------------------------------
        TbSimEnded <= '1';
        wait;
    end process;

end tb;

configuration cfg_tb_display_driver of tb_display_driver is
    for tb
    end for;
end cfg_tb_display_driver;
