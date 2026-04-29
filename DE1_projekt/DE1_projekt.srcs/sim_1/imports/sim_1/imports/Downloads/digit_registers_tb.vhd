library ieee;
use ieee.std_logic_1164.all;

entity tb_digit_registers is
end tb_digit_registers;

architecture tb of tb_digit_registers is

    component digit_registers
        port (
            clk         : in  std_logic;
            rst         : in  std_logic;
            store_en    : in  std_logic;
            digit_index : in  std_logic_vector(1 downto 0);
            digit_in    : in  std_logic_vector(3 downto 0);
            d0          : out std_logic_vector(3 downto 0);
            d1          : out std_logic_vector(3 downto 0);
            d2          : out std_logic_vector(3 downto 0);
            d3          : out std_logic_vector(3 downto 0)
        );
    end component;

    signal clk         : std_logic := '0';
    signal rst         : std_logic := '0';
    signal store_en    : std_logic := '0';
    signal digit_index : std_logic_vector(1 downto 0) := (others => '0');
    signal digit_in    : std_logic_vector(3 downto 0) := (others => '0');
    signal d0          : std_logic_vector(3 downto 0);
    signal d1          : std_logic_vector(3 downto 0);
    signal d2          : std_logic_vector(3 downto 0);
    signal d3          : std_logic_vector(3 downto 0);

    constant TbPeriod  : time := 10 ns;
    signal TbClock     : std_logic := '0';
    signal TbSimEnded  : std_logic := '0';

begin

    dut : digit_registers
        port map (
            clk         => clk,
            rst         => rst,
            store_en    => store_en,
            digit_index => digit_index,
            digit_in    => digit_in,
            d0          => d0,
            d1          => d1,
            d2          => d2,
            d3          => d3
        );

    -- Clock generation
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';
    clk <= TbClock;

    stimuli : process
    begin
        -- inicializácia
        rst         <= '0';
        store_en    <= '0';
        digit_index <= "00";
        digit_in    <= "0000";

        -- reset
        rst <= '1';
        wait for 3 * TbPeriod;
        rst <= '0';
        wait for 2 * TbPeriod;

        -- zapis d0 = 2
        digit_index <= "00";
        digit_in    <= "0010";
        store_en    <= '1';
        wait for TbPeriod;
        store_en    <= '0';
        wait for 2 * TbPeriod;

        -- zapis d1 = 5
        digit_index <= "01";
        digit_in    <= "0101";
        store_en    <= '1';
        wait for TbPeriod;
        store_en    <= '0';
        wait for 2 * TbPeriod;

        -- zapis d2 = 8
        digit_index <= "10";
        digit_in    <= "1000";
        store_en    <= '1';
        wait for TbPeriod;
        store_en    <= '0';
        wait for 2 * TbPeriod;

        -- zapis d3 = 0
        digit_index <= "11";
        digit_in    <= "0000";
        store_en    <= '1';
        wait for TbPeriod;
        store_en    <= '0';
        wait for 4 * TbPeriod;

        -- ukončenie simulácie
        TbSimEnded <= '1';
        wait;
    end process;

end tb;

configuration cfg_tb_digit_registers of tb_digit_registers is
    for tb
    end for;
end cfg_tb_digit_registers;