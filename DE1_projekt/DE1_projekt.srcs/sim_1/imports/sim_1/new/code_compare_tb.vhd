-- Testbench automatically generated online
-- at https://vhdl.lapinoo.net
-- Generation date : Wed, 15 Apr 2026 16:59:17 GMT
-- Request id : cfwk-fed377c2-69dfc3e53f727

library ieee;
use ieee.std_logic_1164.all;

entity tb_code_compare is
end tb_code_compare;

architecture Behavioral of tb_code_compare is

    component code_compare is
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
    signal d0, d1, d2, d3 : std_logic_vector(3 downto 0) := (others => '0');
    signal code_ok, code_err : std_logic;

begin

    uut: code_compare
        port map (
            compare_en => compare_en,
            d0 => d0,
            d1 => d1,
            d2 => d2,
            d3 => d3,
            code_ok => code_ok,
            code_err => code_err
        );

    process
    begin
        -- dobry kod
        d0 <= "0010";
        d1 <= "0101";
        d2 <= "1000";
        d3 <= "0000";
        compare_en <= '1';
        wait for 20 ns;

        -- zly kod
        d0 <= "0010";
        d1 <= "0101";
        d2 <= "1001";
        d3 <= "0000";
        wait for 20 ns;

        compare_en <= '0';
        wait;
    end process;

end Behavioral;