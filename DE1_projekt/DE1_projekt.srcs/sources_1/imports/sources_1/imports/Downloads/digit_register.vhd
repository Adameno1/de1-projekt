library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity digit_registers is
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
end digit_registers;

architecture Behavioral of digit_registers is
    signal r0, r1, r2, r3 : std_logic_vector(3 downto 0) := (others => '0');
begin

    process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                r0 <= (others => '0');
                r1 <= (others => '0');
                r2 <= (others => '0');
                r3 <= (others => '0');
            elsif store_en = '1' then
                case digit_index is
                    when "00" => r0 <= digit_in;
                    when "01" => r1 <= digit_in;
                    when "10" => r2 <= digit_in;
                    when "11" => r3 <= digit_in;
                    when others => null;
                end case;
            end if;
        end if;
    end process;

    d0 <= r0;
    d1 <= r1;
    d2 <= r2;
    d3 <= r3;

end Behavioral;
