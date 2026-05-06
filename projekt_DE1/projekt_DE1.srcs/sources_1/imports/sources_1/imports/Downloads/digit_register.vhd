library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Modul na uloženie štyroch číslic kódu
entity digit_registers is
    port (
        clk         : in  std_logic; -- hlavný clock
        rst         : in  std_logic; -- reset registrov

        store_en    : in  std_logic; -- povolenie zápisu
        digit_index : in  std_logic_vector(1 downto 0); -- výber registra
        digit_in    : in  std_logic_vector(3 downto 0); -- číslica zo switchov

        d0          : out std_logic_vector(3 downto 0); -- prvá číslica
        d1          : out std_logic_vector(3 downto 0); -- druhá číslica
        d2          : out std_logic_vector(3 downto 0); -- tretia číslica
        d3          : out std_logic_vector(3 downto 0)  -- štvrtá číslica
    );
end digit_registers;

architecture Behavioral of digit_registers is

    -- Interné registre pre jednotlivé číslice
    signal r0, r1, r2, r3 : std_logic_vector(3 downto 0) := (others => '0');

begin

    process(clk)
    begin
        if rising_edge(clk) then

            -- Reset vymaže všetky uložené číslice
            if rst = '1' then
                r0 <= (others => '0');
                r1 <= (others => '0');
                r2 <= (others => '0');
                r3 <= (others => '0');

            -- Ak je store_en aktívny, uloží sa digit_in do vybraného registra
            elsif store_en = '1' then
                case digit_index is
                    when "00" => r0 <= digit_in; -- uloženie prvej číslice
                    when "01" => r1 <= digit_in; -- uloženie druhej číslice
                    when "10" => r2 <= digit_in; -- uloženie tretej číslice
                    when "11" => r3 <= digit_in; -- uloženie štvrtej číslice
                    when others => null;
                end case;
            end if;
        end if;
    end process;

    -- Výstupy registrov
    d0 <= r0;
    d1 <= r1;
    d2 <= r2;
    d3 <= r3;

end Behavioral;