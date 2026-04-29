library ieee;
use ieee.std_logic_1164.all;

entity top_safe is
    port (
        CLK100MHZ : in  std_logic;
        BTNC      : in  std_logic;
        BTNR      : in  std_logic;
        BTNU      : in  std_logic;
        SW        : in  std_logic_vector(3 downto 0);
        LED16_G   : out std_logic;
        LED16_R   : out std_logic;
        AN        : out std_logic_vector(7 downto 0);
        SEG       : out std_logic_vector(6 downto 0);
        DP        : out std_logic
    );
end top_safe;

architecture Behavioral of top_safe is

    component debounce
        port (
            clk       : in  std_logic;
            rst       : in  std_logic;
            btn_in    : in  std_logic;
            btn_state : out std_logic;
            btn_press : out std_logic
        );
    end component;

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

    component display_driver
        port (
            clk         : in  std_logic;
            rst         : in  std_logic;
            data        : in  std_logic_vector(15 downto 0);
            digit_index : in  std_logic_vector(1 downto 0);
            seg         : out std_logic_vector(6 downto 0);
            anode       : out std_logic_vector(7 downto 0)
        );
    end component;

    signal btnc_state_s   : std_logic;
    signal btnc_press_s   : std_logic;
    signal btnr_state_s   : std_logic;
    signal btnr_press_s   : std_logic;

    signal store_en_s     : std_logic;
    signal compare_en_s   : std_logic;
    signal digit_index_s  : std_logic_vector(1 downto 0);

    signal d0_s           : std_logic_vector(3 downto 0);
    signal d1_s           : std_logic_vector(3 downto 0);
    signal d2_s           : std_logic_vector(3 downto 0);
    signal d3_s           : std_logic_vector(3 downto 0);

    signal code_ok_s      : std_logic;
    signal code_err_s     : std_logic;

    signal display_data_s : std_logic_vector(15 downto 0);

begin

    u_db_store : debounce
        port map (
            clk       => CLK100MHZ,
            rst       => BTNU,
            btn_in    => BTNC,
            btn_state => btnc_state_s,
            btn_press => btnc_press_s
        );

    u_db_compare : debounce
        port map (
            clk       => CLK100MHZ,
            rst       => BTNU,
            btn_in    => BTNR,
            btn_state => btnr_state_s,
            btn_press => btnr_press_s
        );

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

    display_data_s <= d3_s & d2_s & d1_s & d0_s;

    u_disp : display_driver
        port map (
            clk         => CLK100MHZ,
            rst         => BTNU,
            data        => display_data_s,
            digit_index => digit_index_s,
            seg         => SEG,
            anode       => AN
        );

   LED16_G <= code_ok_s;
   LED16_R <= code_err_s;

    DP <= '1';

end Behavioral;