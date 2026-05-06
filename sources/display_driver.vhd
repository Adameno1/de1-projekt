library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Modul na ovládanie 7-segmentového displeja
-- Zobrazuje 4 číslice a bliká aktuálna pozícia počas zadávania
entity display_driver is
    Port (
        clk          : in  STD_LOGIC; -- hlavný clock
        rst          : in  STD_LOGIC; -- reset
        data         : in  STD_LOGIC_VECTOR(15 downto 0); -- 4 číslice (4×4 bity)
        digit_index  : in  STD_LOGIC_VECTOR(1 downto 0); -- ktorá číslica má blikať
        blink_enable : in  STD_LOGIC; -- povolenie blikania

        seg          : out STD_LOGIC_VECTOR(6 downto 0); -- segmenty a-g
        anode        : out STD_LOGIC_VECTOR(7 downto 0)  -- výber číslice
    );
end display_driver;

architecture Behavioral of display_driver is

    -- Generátor pomalšieho enable signálu (multiplexovanie)
    component clk_en is
        generic ( G_MAX : positive );
        port (
            clk : in  std_logic;
            rst : in  std_logic;
            ce  : out std_logic
        );
    end component;

    -- Prevod 4-bit čísla na 7-seg
    component bin2seg is
        port (
            bin : in  std_logic_vector(3 downto 0);
            seg : out std_logic_vector(6 downto 0)
        );
    end component;

    -- Enable pre multiplexovanie
    signal sig_en      : std_logic;

    -- Ktorá číslica sa práve zobrazuje (0-3)
    signal sig_digit   : unsigned(1 downto 0) := (others => '0');

    -- Vybraná 4-bitová číslica
    signal sig_bin     : std_logic_vector(3 downto 0);

    -- Dekódovaný výstup na segmenty
    signal seg_decoded : std_logic_vector(6 downto 0);

    -- Signály pre blikanie
    signal blink_cnt   : unsigned(25 downto 0) := (others => '0');
    signal blink       : std_logic := '0';

begin

    -- Generovanie pomalšieho enable signálu
    clock_0 : clk_en
        generic map (
            G_MAX => 80000
        )
        port map (
            clk => clk,
            rst => rst,
            ce  => sig_en
        );

    -- Multiplexovanie číslic (prepínanie medzi d0-d3)
    process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                sig_digit <= (others => '0');
            elsif sig_en = '1' then
                sig_digit <= sig_digit + 1;
            end if;
        end if;
    end process;

    -- Generátor blikania (pomalý toggle signál)
    process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                blink_cnt <= (others => '0');
                blink     <= '0';
            else
                blink_cnt <= blink_cnt + 1;
                blink     <= blink_cnt(25); -- pomalé prepínanie
            end if;
        end if;
    end process;

    -- Výber aktuálnej číslice zo vstupu data
    with std_logic_vector(sig_digit) select
        sig_bin <= data(3 downto 0)    when "00", -- d0
                   data(7 downto 4)    when "01", -- d1
                   data(11 downto 8)   when "10", -- d2
                   data(15 downto 12)  when "11", -- d3
                   "0000"              when others;

    -- Prevod čísla na segmenty
    decoder_0 : bin2seg
        port map (
            bin => sig_bin,
            seg => seg_decoded
        );

    -- Riadenie blikania aktuálnej číslice
    process(sig_digit, digit_index, blink, blink_enable, seg_decoded)
    begin
        -- Ak je zapnuté blikanie a toto je aktuálna číslica
        if blink_enable = '1' and std_logic_vector(sig_digit) = digit_index then
            if blink = '1' then
                seg <= "1111111";      -- vypnutá (neviditeľná)
            else
                seg <= seg_decoded;    -- zapnutá
            end if;
        else
            -- ostatné číslice svietia stále
            seg <= seg_decoded;
        end if;
    end process;

    -- Výber aktívnej anódy (ktorá číslica svieti)
    process(sig_digit)
    begin
        case std_logic_vector(sig_digit) is
            when "00" =>
                anode <= "11111110"; -- prvá číslica
            when "01" =>
                anode <= "11111101"; -- druhá číslica
            when "10" =>
                anode <= "11111011"; -- tretia číslica
            when "11" =>
                anode <= "11110111"; -- štvrtá číslica
            when others =>
                anode <= "11111111"; -- všetko vypnuté
        end case;
    end process;

end Behavioral;
