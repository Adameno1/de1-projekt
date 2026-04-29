library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity display_driver is
    Port (
        clk         : in  STD_LOGIC;
        rst         : in  STD_LOGIC;
        data        : in  STD_LOGIC_VECTOR(15 downto 0);
        digit_index : in  STD_LOGIC_VECTOR(1 downto 0);
        seg         : out STD_LOGIC_VECTOR(6 downto 0);
        anode       : out STD_LOGIC_VECTOR(7 downto 0)
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

    component bin2seg is
        port (
            bin : in  std_logic_vector(3 downto 0);
            seg : out std_logic_vector(6 downto 0)
        );
    end component;

    signal sig_en      : std_logic;
    signal sig_digit   : unsigned(1 downto 0) := (others => '0');
    signal sig_bin     : std_logic_vector(3 downto 0);
    signal seg_decoded : std_logic_vector(6 downto 0);

    signal blink_cnt   : unsigned(25 downto 0) := (others => '0');
    signal blink       : std_logic := '0';

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


    process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                blink_cnt <= (others => '0');
                blink     <= '0';
            else
                blink_cnt <= blink_cnt + 1;
                blink     <= blink_cnt(25);
            end if;
        end if;
    end process;

  
    with std_logic_vector(sig_digit) select
        sig_bin <= data(3 downto 0)    when "00",
                   data(7 downto 4)    when "01",
                   data(11 downto 8)   when "10",
                   data(15 downto 12)  when "11",
                   "0000"              when others;

   
    decoder_0 : bin2seg
        port map (
            bin => sig_bin,
            seg => seg_decoded
        );

    
    process(sig_digit, digit_index, blink, seg_decoded)
    begin
        if std_logic_vector(sig_digit) = digit_index then
            if blink = '1' then
                seg <= "1111111";   -- selected digit off
            else
                seg <= seg_decoded; -- selected digit on
            end if;
        else
            seg <= seg_decoded;     -- other digits stay visible
        end if;
    end process;

    -- Active-low anode selection
    process(sig_digit)
    begin
        case std_logic_vector(sig_digit) is
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