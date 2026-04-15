-- Testbench automatically generated online
-- at https://vhdl.lapinoo.net
-- Generation date : Wed, 15 Apr 2026 16:27:32 GMT
-- Request id : cfwk-fed377c2-69dfbc74459ed

library ieee;
use ieee.std_logic_1164.all;

entity tb_digit_registers is
end tb_digit_registers;

architecture tb of tb_digit_registers is

    component digit_registers
        port (clk         : in std_logic;
              rst         : in std_logic;
              store_en    : in std_logic;
              digit_index : in std_logic_vector (1 downto 0);
              digit_in    : in std_logic_vector (3 downto 0);
              d0          : out std_logic_vector (3 downto 0);
              d1          : out std_logic_vector (3 downto 0);
              d2          : out std_logic_vector (3 downto 0);
              d3          : out std_logic_vector (3 downto 0));
    end component;

    signal clk         : std_logic;
    signal rst         : std_logic;
    signal store_en    : std_logic;
    signal digit_index : std_logic_vector (1 downto 0);
    signal digit_in    : std_logic_vector (3 downto 0);
    signal d0          : std_logic_vector (3 downto 0);
    signal d1          : std_logic_vector (3 downto 0);
    signal d2          : std_logic_vector (3 downto 0);
    signal d3          : std_logic_vector (3 downto 0);

    constant TbPeriod : time := 1000 ns; -- ***EDIT*** Put right period here
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    dut : digit_registers
    port map (clk         => clk,
              rst         => rst,
              store_en    => store_en,
              digit_index => digit_index,
              digit_in    => digit_in,
              d0          => d0,
              d1          => d1,
              d2          => d2,
              d3          => d3);

    -- Clock generation
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';

    -- ***EDIT*** Check that clk is really your main clock signal
    clk <= TbClock;

    stimuli : process
    begin
        -- ***EDIT*** Adapt initialization as needed
        store_en <= '0';
        digit_index <= (others => '0');
        digit_in <= (others => '0');

        -- Reset generation
        -- ***EDIT*** Check that rst is really your reset signal
        rst <= '1';
        wait for 100 ns;
        rst <= '0';
        wait for 100 ns;

        -- ***EDIT*** Add stimuli here
        wait for 100 * TbPeriod;

        -- Stop the clock and hence terminate the simulation
        TbSimEnded <= '1';
        wait;
    end process;

end tb;

-- Configuration block below is required by some simulators. Usually no need to edit.

configuration cfg_tb_digit_registers of tb_digit_registers is
    for tb
    end for;
end cfg_tb_digit_registers;