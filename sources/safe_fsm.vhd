----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/15/2026 06:26:50 PM
-- Design Name: 
-- Module Name: safe_fsm - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

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
    signal pos : unsigned(1 downto 0) := (others => '0');
begin

    process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                pos <= (others => '0');
                store_en <= '0';
                compare_en <= '0';
            else
                store_en <= '0';
                compare_en <= '0';

                if btn_store = '1' then
                    store_en <= '1';
                    if pos < 3 then
                        pos <= pos + 1;
                    end if;
                end if;

                if btn_compare = '1' then
                    compare_en <= '1';
                end if;
            end if;
        end if;
    end process;

    digit_index <= std_logic_vector(pos);

end Behavioral;