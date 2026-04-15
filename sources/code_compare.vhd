library ieee;
use ieee.std_logic_1164.all;

entity code_compare is
    port (
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
begin

    process(compare_en, d0, d1, d2, d3)
    begin
        code_ok  <= '0';
        code_err <= '0';

        if compare_en = '1' then
            if (d0 = C0) and (d1 = C1) and (d2 = C2) and (d3 = C3) then
                code_ok <= '1';
                code_err <= '0';
            else
                code_ok <= '0';
                code_err <= '1';
            end if;
        end if;
    end process;

end Behavioral;