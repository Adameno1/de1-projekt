library ieee;
use ieee.std_logic_1164.all;

-- Hlavný/top-level modul celého projektu
entity top_safe is
    port (
        -- Hlavný clock z FPGA dosky
        CLK100MHZ : in  std_logic;

        -- Tlačidlá
        BTNC      : in  std_logic; -- uloženie aktuálnej číslice
        BTNR      : in  std_logic; -- porovnanie zadaného kódu
        BTNU      : in  std_logic; -- reset systému

        -- Prepínače na zadávanie 4-bitovej číslice
        SW        : in  std_logic_vector(3 downto 0);

        -- RGB LED výstupy
        LED16_G   : out std_logic; -- zelená LED = správny kód
        LED16_R   : out std_logic; -- červená LED = zlý kód

        -- Výstupy pre 7-segmentový displej
        AN        : out std_logic_vector(7 downto 0);
        SEG       : out std_logic_vector(6 downto 0);
        DP        : out std_logic;
        RELAY     : out std_logic
    );
end top_safe;

architecture Behavioral of top_safe is

    -- Debounce modul čistí signál z mechanického tlačidla
    component debounce
        port (
            clk       : in  std_logic;
            rst       : in  std_logic;
            btn_in    : in  std_logic;
            btn_state : out std_logic;
            btn_press : out std_logic
        );
    end component;

    -- FSM riadi postup zadávania a porovnávania kódu
    component safe_fsm
        port (
            clk         : in  std_logic;
            rst         : in  std_logic;
            btn_store   : in  std_logic;
            btn_compare : in  std_logic;
            store_en    : out std_logic;
            compare_en  : out std_logic;
            digit_index : out std_logic_vector(1 downto 0)
        );
    end component;

    -- Register modul ukladá štyri zadané číslice
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

    -- Modul na porovnanie zadaného kódu so správnym kódom
    component code_compare
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
    end component;

    -- Modul na ovládanie 7-segmentového displeja
    component display_driver
        port (
            clk          : in  std_logic;
            rst          : in  std_logic;
            data         : in  std_logic_vector(15 downto 0);
            digit_index  : in  std_logic_vector(1 downto 0);
            blink_enable : in  std_logic;
            seg          : out std_logic_vector(6 downto 0);
            anode        : out std_logic_vector(7 downto 0)
        );
    end component;

    -- Signály po debounce tlačidiel
    signal btnc_state_s   : std_logic;
    signal btnc_press_s   : std_logic;
    signal btnr_state_s   : std_logic;
    signal btnr_press_s   : std_logic;

    -- Riadiace signály z FSM
    signal store_en_s     : std_logic;
    signal compare_en_s   : std_logic;
    signal digit_index_s  : std_logic_vector(1 downto 0);

    -- Uložené číslice kódu
    signal d0_s           : std_logic_vector(3 downto 0);
    signal d1_s           : std_logic_vector(3 downto 0);
    signal d2_s           : std_logic_vector(3 downto 0);
    signal d3_s           : std_logic_vector(3 downto 0);

    -- Výsledok porovnania
    signal code_ok_s      : std_logic;
    signal code_err_s     : std_logic;

    -- 16-bitový signál pre displej
    signal display_data_s : std_logic_vector(15 downto 0);

    -- Povolenie blikania aktuálnej číslice
    signal blink_enable_s : std_logic;

begin

    -- Debounce pre tlačidlo BTNC
    -- Z mechanického tlačidla vytvorí čistý impulz btnc_press_s
    u_db_store : debounce
        port map (
            clk       => CLK100MHZ,
            rst       => BTNU,
            btn_in    => BTNC,
            btn_state => btnc_state_s,
            btn_press => btnc_press_s
        );

    -- Debounce pre tlačidlo BTNR
    -- Používa sa na spustenie porovnania kódu
    u_db_compare : debounce
        port map (
            clk       => CLK100MHZ,
            rst       => BTNU,
            btn_in    => BTNR,
            btn_state => btnr_state_s,
            btn_press => btnr_press_s
        );

    -- Riadiaci modul
    -- Určuje, kedy ukladať číslicu a kedy porovnať kód
    u_fsm : safe_fsm
        port map (
            clk         => CLK100MHZ,
            rst         => BTNU,
            btn_store   => btnc_press_s,
            btn_compare => btnr_press_s,
            store_en    => store_en_s,
            compare_en  => compare_en_s,
            digit_index => digit_index_s
        );

    -- Register číslic
    -- Hodnota zo SW sa uloží do d0/d1/d2/d3 podľa digit_index_s
    u_regs : digit_registers
        port map (
            clk         => CLK100MHZ,
            rst         => BTNU,
            store_en    => store_en_s,
            digit_index => digit_index_s,
            digit_in    => SW,
            d0          => d0_s,
            d1          => d1_s,
            d2          => d2_s,
            d3          => d3_s
        );

    -- Porovnanie kódu
    -- Pri compare_en_s porovná uložené číslice so správnym kódom
    u_cmp : code_compare
        port map (
            clk        => CLK100MHZ,
            rst        => BTNU,
            compare_en => compare_en_s,
            d0         => d0_s,
            d1         => d1_s,
            d2         => d2_s,
            d3         => d3_s,
            code_ok    => code_ok_s,
            code_err   => code_err_s
        );

    -- Spojenie štyroch 4-bitových číslic do jedného 16-bitového signálu
    -- Tento signál ide do display_driver
    display_data_s <= d3_s & d2_s & d1_s & d0_s;

    -- Blikanie je povolené iba počas zadávania
    -- Keď je výsledok OK alebo ERROR, blikanie sa vypne
    blink_enable_s <= not (code_ok_s or code_err_s);

    -- Ovládanie 7-segmentového displeja
    -- Zobrazuje uložené číslice a bliká aktuálna pozícia
    u_disp : display_driver
        port map (
            clk          => CLK100MHZ,
            rst          => BTNU,
            data         => display_data_s,
            digit_index  => digit_index_s,
            blink_enable => blink_enable_s,
            seg          => SEG,
            anode        => AN
        );
        
        
        RELAY <= not code_ok_s;
    -- Výstup na RGB LED
    LED16_G <= code_ok_s;   -- zelená = správny kód
    LED16_R <= code_err_s;  -- červená = zlý kód
    -- Desatinnú bodku nepoužívame, preto je vypnutá
    DP <= '1';

end Behavioral;
