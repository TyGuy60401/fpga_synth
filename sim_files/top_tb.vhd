----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/30/2024 02:21:13 PM
-- Design Name: 
-- Module Name: top_tb - Behavioral
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

entity top_tb is
--  Port ( );
end top_tb;

architecture Behavioral of top_tb is
    component top is
        Port ( S_OUT : out STD_LOGIC;
               SYNC : out STD_LOGIC;
               SCLK : out STD_LOGIC;
               LED : out STD_LOGIC_VECTOR (7 downto 0);
               LED2 : out STD_LOGIC_VECTOR (7 downto 0);
               CLK : in STD_LOGIC;
               RST : in STD_LOGIC;
               S_IN : in STD_LOGIC;
               SER_OUT : out STD_LOGIC);
    end component;

    signal t_clk : std_logic := '0';
    signal t_rst : std_logic := '0';
    signal t_s_in : std_logic := '1';
    
    signal DB1 : std_logic_vector(7 downto 0) := x"AA";
    signal DB2 : std_logic_vector(7 downto 0) := x"40";
    signal DB3 : std_logic_vector(7 downto 0) := x"40";

begin
    uut: top port map(
        clk => t_clk,
        rst => t_rst,
        s_in => t_s_in);

    process 
    begin
        wait for 5 ns;
        t_clk <= not t_clk;
    end process;

    process 
    begin
        wait for 10 ns;
        t_rst <= '1';
        wait for 10 ns;
        t_rst <= '0';

        wait for 50 ns;
        t_s_in <= '0';
        wait for 32 us;
        for i in 0 to 7 loop
            t_s_in <= DB1(i);
            wait for 32 us;
        end loop;
        t_s_in <= '1';
        wait for 32 us;
        
        wait for 50 ns;
        t_s_in <= '0';
        wait for 32 us;
        for i in 0 to 7 loop
            t_s_in <= DB2(i);
            wait for 32 us;
        end loop;
        t_s_in <= '1';
        wait for 32 us;
        
        wait for 50 ns;
        t_s_in <= '0';
        wait for 32 us;
        for i in 0 to 7 loop
            t_s_in <= DB3(i);
            wait for 32 us;
        end loop;
        t_s_in <= '1';
        wait for 32 us;
        
        
        
        

    end process;


end Behavioral;
