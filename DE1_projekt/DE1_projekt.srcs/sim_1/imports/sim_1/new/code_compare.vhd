----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/15/2026 06:49:11 PM
-- Design Name: 
-- Module Name: code_compare - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity code_compare is
    Port ( compare_en : in STD_LOGIC;
           d0 : in STD_LOGIC;
           d1 : in STD_LOGIC;
           d2 : in STD_LOGIC;
           d3 : in STD_LOGIC;
           code_ok : out STD_LOGIC;
           code_err : out STD_LOGIC);
end code_compare;

architecture Behavioral of code_compare is

begin


end Behavioral;
