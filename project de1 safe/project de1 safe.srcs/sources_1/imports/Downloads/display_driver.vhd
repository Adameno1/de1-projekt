library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity display_driver is
    Port (
        clk   : in  STD_LOGIC;
        rst   : in  STD_LOGIC;
        data  : in  STD_LOGIC_VECTOR(15 downto 0);
        seg   : out STD_LOGIC_VECTOR(6 downto 0);
        anode : out STD_LOGIC_VECTOR(7 downto 0)
    );
end display_driver;

architecture Behavioral of display_driver is

    component clk_en is
        generic ( G_MAX : positive );
        port (
            clk : in  std_logic;
            rst : in  std_logic;
            ce  : out std_logic
        );
    end component;

    component counter is
        generic ( G_BITS : positive );
        port (
            clk : in  std_logic;
            rst : in  std_logic;
            en  : in  std_logic;
            cnt : out std_logic_vector(G_BITS - 1 downto 0)
        );
    end component;

    component bin2seg is
        port (
            bin : in  std_logic_vector(3 downto 0);
            seg : out std_logic_vector(6 downto 0)
        );
    end component;

    signal sig_en    : std_logic;
    signal sig_digit : std_logic_vector(1 downto 0);
    signal sig_bin   : std_logic_vector(3 downto 0);

begin

    clock_0 : clk_en
        generic map (
            G_MAX => 80000
        )
        port map (
            clk => clk,
            rst => rst,
            ce  => sig_en
        );

    counter_0 : counter
        generic map (
            G_BITS => 2
        )
        port map (
            clk => clk,
            rst => rst,
            en  => sig_en,
            cnt => sig_digit
        );

    with sig_digit select
        sig_bin <= data(3 downto 0)    when "00",
                   data(7 downto 4)    when "01",
                   data(11 downto 8)   when "10",
                   data(15 downto 12)  when "11",
                   "0000"              when others;

    decoder_0 : bin2seg
        port map (
            bin => sig_bin,
            seg => seg
        );

    process(sig_digit)
    begin
        case sig_digit is
            when "00" =>
                anode <= "11111110";
            when "01" =>
                anode <= "11111101";
            when "10" =>
                anode <= "11111011";
            when "11" =>
                anode <= "11110111";
            when others =>
                anode <= "11111111";
        end case;
    end process;

end Behavioral;