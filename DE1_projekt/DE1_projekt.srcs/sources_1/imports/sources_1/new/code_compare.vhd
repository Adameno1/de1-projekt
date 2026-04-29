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

    -- Správny kód: 2 5 8 0
    constant C0 : std_logic_vector(3 downto 0) := "0010"; -- 2
    constant C1 : std_logic_vector(3 downto 0) := "0101"; -- 5
    constant C2 : std_logic_vector(3 downto 0) := "1000"; -- 8
    constant C3 : std_logic_vector(3 downto 0) := "0000"; -- 0

    -- Interné registre (držia výsledok)
    signal ok_reg  : std_logic := '0';
    signal err_reg : std_logic := '0';

begin

    process(clk)
    begin
        if rising_edge(clk) then

            -- RESET
            if rst = '1' then
                ok_reg  <= '0';
                err_reg <= '0';

            -- POROVNANIE
            elsif compare_en = '1' then

                -- správny kód
                if (d0 = C0) and (d1 = C1) and (d2 = C2) and (d3 = C3) then
                    ok_reg  <= '1';
                    err_reg <= '0';

                -- nesprávny kód
                else
                    ok_reg  <= '0';
                    err_reg <= '1';
                end if;

            end if;

        end if;
    end process;

    -- Výstupy
    code_ok  <= ok_reg;
    code_err <= err_reg;

end Behavioral;