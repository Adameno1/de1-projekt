library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity safe_fsm is
    port (
        clk         : in  std_logic;
        rst         : in  std_logic;
        btn_store   : in  std_logic;
        btn_compare : in  std_logic;
        store_en    : out std_logic;
        compare_en  : out std_logic;
        digit_index : out std_logic_vector(1 downto 0)
    );
end safe_fsm;

architecture Behavioral of safe_fsm is
    signal pos            : unsigned(1 downto 0) := (others => '0');
    signal store_en_i     : std_logic := '0';
    signal compare_en_i   : std_logic := '0';
begin

    process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                pos          <= (others => '0');
                store_en_i   <= '0';
                compare_en_i <= '0';

            else
                -- default
                compare_en_i <= '0';

                -- if previous cycle generated store pulse,
                -- now move to next position
                if store_en_i = '1' then
                    store_en_i <= '0';
                    if pos < "11" then
                        pos <= pos + 1;
                    end if;

                elsif btn_store = '1' then
                    -- generate one-cycle store pulse
                    store_en_i <= '1';

                elsif btn_compare = '1' then
                    compare_en_i <= '1';
                end if;
            end if;
        end if;
    end process;

    store_en    <= store_en_i;
    compare_en  <= compare_en_i;
    digit_index <= std_logic_vector(pos);

end Behavioral;