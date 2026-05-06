-- Testbench automatically generated online
-- at https://vhdl.lapinoo.net
-- Generation date : Wed, 15 Apr 2026 16:28:59 GMT
-- Request id : cfwk-fed377c2-69dfbccb962a4

library ieee;
use ieee.std_logic_1164.all;

entity tb_safe_fsm is
end tb_safe_fsm;

architecture tb of tb_safe_fsm is

    component safe_fsm
        port (
            clk         : in  std_logic;
            rst         : in  std_logic;
            btn_store   : in  std_logic;
            btn_compare : in  std_logic;
            store_en    : out std_logic;
            compare_en  : out std_logic;
            digit_index : out std_logic_vector(1 downto 0)
        );
    end component;

    signal clk         : std_logic := '0';
    signal rst         : std_logic := '0';
    signal btn_store   : std_logic := '0';
    signal btn_compare : std_logic := '0';
    signal store_en    : std_logic;
    signal compare_en  : std_logic;
    signal digit_index : std_logic_vector(1 downto 0);

    constant TbPeriod : time := 10 ns;
    signal TbClock    : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    dut : safe_fsm
        port map (
            clk         => clk,
            rst         => rst,
            btn_store   => btn_store,
            btn_compare => btn_compare,
            store_en    => store_en,
            compare_en  => compare_en,
            digit_index => digit_index
        );

    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';
    clk <= TbClock;

    stimuli : process
    begin
        rst <= '0';
        btn_store <= '0';
        btn_compare <= '0';

        -- reset
        rst <= '1';
        wait for 30 ns;
        rst <= '0';
        wait for 20 ns;

        -- 1. store
        btn_store <= '1';
        wait for 10 ns;
        btn_store <= '0';
        wait for 20 ns;

        -- 2. store
        btn_store <= '1';
        wait for 10 ns;
        btn_store <= '0';
        wait for 20 ns;

        -- 3. store
        btn_store <= '1';
        wait for 10 ns;
        btn_store <= '0';
        wait for 20 ns;

        -- 4. store
        btn_store <= '1';
        wait for 10 ns;
        btn_store <= '0';
        wait for 20 ns;

        -- compare
        btn_compare <= '1';
        wait for 10 ns;
        btn_compare <= '0';
        wait for 20 ns;

        TbSimEnded <= '1';
        wait;
    end process;

end tb;

configuration cfg_tb_safe_fsm of tb_safe_fsm is
    for tb
    end for;
end cfg_tb_safe_fsm;
