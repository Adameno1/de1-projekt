library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Riadiaci modul celého zámku
-- Určuje, kedy sa má číslica uložiť a kedy sa má kód porovnať
entity safe_fsm is
    port (
        clk         : in  std_logic; -- hlavný clock
        rst         : in  std_logic; -- reset systému
        btn_store   : in  std_logic; -- impulz z tlačidla na uloženie číslice
        btn_compare : in  std_logic; -- impulz z tlačidla na porovnanie kódu

        store_en    : out std_logic; -- povolí zápis číslice do registra
        compare_en  : out std_logic; -- spustí porovnanie kódu
        digit_index : out std_logic_vector(1 downto 0) -- aktuálna pozícia číslice
    );
end safe_fsm;

architecture Behavioral of safe_fsm is

    -- Pozícia aktuálne zadávanej číslice
    -- 00 = prvá číslica, 01 = druhá, 10 = tretia, 11 = štvrtá
    signal pos : unsigned(1 downto 0) := (others => '0');

    -- Interné signály pre výstupy
    signal store_en_i   : std_logic := '0';
    signal compare_en_i : std_logic := '0';

begin

    process(clk)
    begin
        if rising_edge(clk) then

            -- Reset nastaví systém na začiatok
            if rst = '1' then
                pos          <= (others => '0');
                store_en_i   <= '0';
                compare_en_i <= '0';

            else
                -- compare_en je iba krátky impulz, preto sa defaultne nulí
                compare_en_i <= '0';

                -- Ak bol v predchádzajúcom takte vytvorený store impulz,
                -- teraz ho vypneme a posunieme sa na ďalšiu číslicu
                if store_en_i = '1' then
                    store_en_i <= '0';

                    -- Index ide maximálne po hodnotu 3
                    if pos < "11" then
                        pos <= pos + 1;
                    end if;

                -- Po stlačení tlačidla store vytvoríme impulz store_en
                elsif btn_store = '1' then
                    store_en_i <= '1';

                -- Po stlačení compare vytvoríme impulz compare_en
                elsif btn_compare = '1' then
                    compare_en_i <= '1';
                end if;
            end if;
        end if;
    end process;

    -- Výstupy modulu
    store_en    <= store_en_i;
    compare_en  <= compare_en_i;
    digit_index <= std_logic_vector(pos);

end Behavioral;