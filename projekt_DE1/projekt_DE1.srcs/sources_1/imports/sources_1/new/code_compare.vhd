library ieee;
use ieee.std_logic_1164.all;

-- Modul na porovnanie zadaného kódu so správnym kódom
entity code_compare is
    port (
        clk        : in  std_logic; -- hlavný clock
        rst        : in  std_logic; -- reset výsledku

        compare_en : in  std_logic; -- impulz na spustenie porovnania

        d0         : in  std_logic_vector(3 downto 0); -- prvá číslica
        d1         : in  std_logic_vector(3 downto 0); -- druhá číslica
        d2         : in  std_logic_vector(3 downto 0); -- tretia číslica
        d3         : in  std_logic_vector(3 downto 0); -- štvrtá číslica

        code_ok    : out std_logic; -- správny kód
        code_err   : out std_logic  -- nesprávny kód
    );
end code_compare;

architecture Behavioral of code_compare is

    -- Správny kód je 2580
    constant C0 : std_logic_vector(3 downto 0) := "0010"; -- 2
    constant C1 : std_logic_vector(3 downto 0) := "0101"; -- 5
    constant C2 : std_logic_vector(3 downto 0) := "1000"; -- 8
    constant C3 : std_logic_vector(3 downto 0) := "0000"; -- 0

    -- Registre držia výsledok porovnania
    signal ok_reg  : std_logic := '0';
    signal err_reg : std_logic := '0';

begin

    process(clk)
    begin
        if rising_edge(clk) then

            -- Reset vypne oba výsledkové signály
            if rst = '1' then
                ok_reg  <= '0';
                err_reg <= '0';

            -- Porovnanie sa vykoná iba pri compare_en
            elsif compare_en = '1' then

                -- Ak všetky číslice sedia, nastaví sa OK
                if (d0 = C0) and (d1 = C1) and (d2 = C2) and (d3 = C3) then
                    ok_reg  <= '1';
                    err_reg <= '0';

                -- Ak aspoň jedna číslica nesedí, nastaví sa ERROR
                else
                    ok_reg  <= '0';
                    err_reg <= '1';
                end if;
            end if;
        end if;
    end process;

    -- Výstupy držia posledný výsledok až do resetu alebo ďalšieho porovnania
    code_ok  <= ok_reg;
    code_err <= err_reg;

end Behavioral;