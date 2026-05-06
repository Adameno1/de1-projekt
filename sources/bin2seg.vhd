-------------------------------------------------
--! @brief Binary to 7-segment decoder (common anode, 1 digit)
--! @version 1.5
--! @copyright (c) 2018-2026 Tomas Fryza, MIT license
--!
--! This design decodes a 4-bit binary input into control
--! signals for a 7-segment common-anode display. It
--! supports hexadecimal characters:
--!
--!   0, 1, 2, 3, 4, 5, 6, 7, 8, 9, A, b, C, d, E, F
--
-- Notes:
-- - Common anode: segment ON = 0, OFF = 1
-- - No decimal point is implemented
-- - Purely combinational (no clock)
-------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity bin2seg is
    port (
        bin : in  std_logic_vector(3 downto 0);
        seg : out std_logic_vector(6 downto 0)
    );
end entity bin2seg;

architecture Behavioral of bin2seg is
begin

    process(bin)
    begin
        case bin is
            when x"0" => seg <= "1000000"; -- 0
            when x"1" => seg <= "1111001"; -- 1
            when x"2" => seg <= "0100100"; -- 2
            when x"3" => seg <= "0110000"; -- 3
            when x"4" => seg <= "0011001"; -- 4
            when x"5" => seg <= "0010010"; -- 5
            when x"6" => seg <= "0000010"; -- 6
            when x"7" => seg <= "1111000"; -- 7
            when x"8" => seg <= "0000000"; -- 8
            when x"9" => seg <= "0010000"; -- 9
            when x"A" => seg <= "0001000"; -- A
            when x"b" => seg <= "0000011"; -- b
            when x"C" => seg <= "1000110"; -- C
            when x"d" => seg <= "0100001"; -- d
            when x"E" => seg <= "0000110"; -- E
            when x"F" => seg <= "0001110"; -- F
            when others => seg <= "1111111"; -- off
        end case;
    end process;

end Behavioral;
