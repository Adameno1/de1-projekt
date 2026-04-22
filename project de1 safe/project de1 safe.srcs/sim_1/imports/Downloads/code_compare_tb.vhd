library ieee;
use ieee.std_logic_1164.all;

entity tb_code_compare is
end tb_code_compare;

architecture tb of tb_code_compare is

    component code_compare
        port (
            compare_en : in  std_logic;
            d0         : in  std_logic_vector(3 downto 0);
            d1         : in  std_logic_vector(3 downto 0);
            d2         : in  std_logic_vector(3 downto 0);
            d3         : in  std_logic_vector(3 downto 0);
            code_ok    : out std_logic;
            code_err   : out std_logic
        );
    end component;

    signal compare_en : std_logic := '0';
    signal d0         : std_logic_vector(3 downto 0) := (others => '0');
    signal d1         : std_logic_vector(3 downto 0) := (others => '0');
    signal d2         : std_logic_vector(3 downto 0) := (others => '0');
    signal d3         : std_logic_vector(3 downto 0) := (others => '0');
    signal code_ok    : std_logic;
    signal code_err   : std_logic;

begin

    dut : code_compare
        port map (
            compare_en => compare_en,
            d0         => d0,
            d1         => d1,
            d2         => d2,
            d3         => d3,
            code_ok    => code_ok,
            code_err   => code_err
        );

    stimuli : process
    begin
        -- inicializácia
        compare_en <= '0';
        d0 <= "0000";
        d1 <= "0000";
        d2 <= "0000";
        d3 <= "0000";
        wait for 20 ns;

        -- spravny kod: 2 5 8 0
        d0 <= "0010";
        d1 <= "0101";
        d2 <= "1000";
        d3 <= "0000";
        compare_en <= '1';
        wait for 20 ns;

        -- vypnut compare
        compare_en <= '0';
        wait for 20 ns;

        -- nespravny kod: 2 5 9 0
        d0 <= "0010";
        d1 <= "0101";
        d2 <= "1001";
        d3 <= "0000";
        compare_en <= '1';
        wait for 20 ns;

        -- vypnut compare
        compare_en <= '0';
        wait for 20 ns;

        -- dalsi nespravny kod: 1 2 3 4
        d0 <= "0001";
        d1 <= "0010";
        d2 <= "0011";
        d3 <= "0100";
        compare_en <= '1';
        wait for 20 ns;

        -- koniec simulacie
        compare_en <= '0';
        wait;
    end process;

end tb;

configuration cfg_tb_code_compare of tb_code_compare is
    for tb
    end for;
end cfg_tb_code_compare;