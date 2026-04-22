library ieee;
use ieee.std_logic_1164.all;

entity code_compare is
    port (
        clk        : in  std_logic;
        rst        : in  std_logic;
        compare_en : in  std_logic;
        d0         : in  std_logic_vector(3 downto 0);
        d1         : in  std_logic_vector(3 downto 0);
        d2         : in  std_logic_vector(3 downto 0);
        d3         : in  std_logic_vector(3 downto 0);
        code_ok    : out std_logic;
        code_err   : out std_logic
    );
end code_compare;

architecture Behavioral of code_compare is
    constant C0 : std_logic_vector(3 downto 0) := "0010"; -- 2
    constant C1 : std_logic_vector(3 downto 0) := "0101"; -- 5
    constant C2 : std_logic_vector(3 downto 0) := "1000"; -- 8
    constant C3 : std_logic_vector(3 downto 0) := "0000"; -- 0

    signal ok_i  : std_logic := '0';
    signal err_i : std_logic := '0';
begin

    process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                ok_i  <= '0';
                err_i <= '0';

            elsif compare_en = '1' then
                if (d0 = C0) and (d1 = C1) and (d2 = C2) and (d3 = C3) then
                    ok_i  <= '1';
                    err_i <= '0';
                else
                    ok_i  <= '0';
                    err_i <= '1';
                end if;
            end if;
        end if;
    end process;

    code_ok  <= ok_i;
    code_err <= err_i;

end Behavioral;