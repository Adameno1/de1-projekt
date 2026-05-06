library ieee;
use ieee.std_logic_1164.all;

entity tb_code_compare is
end tb_code_compare;

architecture tb of tb_code_compare is

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

    signal clk        : std_logic := '0';
    signal rst        : std_logic := '0';
    signal compare_en : std_logic := '0';

    signal d0         : std_logic_vector(3 downto 0) := "0000";
    signal d1         : std_logic_vector(3 downto 0) := "0000";
    signal d2         : std_logic_vector(3 downto 0) := "0000";
    signal d3         : std_logic_vector(3 downto 0) := "0000";

    signal code_ok    : std_logic;
    signal code_err   : std_logic;

    constant TbPeriod : time := 10 ns;
    signal TbSimEnded : std_logic := '0';

begin

    dut : code_compare
        port map (
            clk        => clk,
            rst        => rst,
            compare_en => compare_en,
            d0         => d0,
            d1         => d1,
            d2         => d2,
            d3         => d3,
            code_ok    => code_ok,
            code_err   => code_err
        );

    clk <= not clk after TbPeriod / 2 when TbSimEnded /= '1' else '0';

    stimuli : process
    begin
   
        rst        <= '0';
        compare_en <= '0';
        d0 <= "0000";
        d1 <= "0000";
        d2 <= "0000";
        d3 <= "0000";

        wait for 20 ns;

  
        rst <= '1';
        wait for 30 ns;
        rst <= '0';
        wait for 30 ns;

 
        d0 <= "0010"; -- 2
        d1 <= "0101"; -- 5
        d2 <= "1000"; -- 8
        d3 <= "0000"; -- 0

        wait for 20 ns;

        compare_en <= '1';
        wait for TbPeriod;
        compare_en <= '0';

   
        wait for 300 ns;

 
        d0 <= "0010"; -- 2
        d1 <= "0101"; -- 5
        d2 <= "1001"; -- 9
        d3 <= "0000"; -- 0

        wait for 20 ns;

        compare_en <= '1';
        wait for TbPeriod;
        compare_en <= '0';

      
        wait for 300 ns;

     
        rst <= '1';
        wait for 30 ns;
        rst <= '0';

        wait for 100 ns;

        TbSimEnded <= '1';
        wait;
    end process;

end tb;

configuration cfg_tb_code_compare of tb_code_compare is
    for tb
    end for;
end cfg_tb_code_compare;
