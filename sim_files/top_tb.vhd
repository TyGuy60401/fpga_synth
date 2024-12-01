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
               MIDI_IN : in STD_LOGIC;
               MIDI_SW : in STD_LOGIC;
               SER_OUT : out STD_LOGIC);
    end component;

    signal t_midi_in : std_logic := '0';
    signal t_midi_sw : std_logic := '1';
    signal t_clk : std_logic := '0';
    signal t_rst : std_logic := '0';
    signal t_s_in : std_logic := '1';
    
    type byte_array is array (0 to 100) of std_logic_vector(7 downto 0);
    signal DB1_array : byte_array := (x"90", x"B0", x"90", others => (others => '1'));
    signal DB2_array : byte_array := (x"40", x"21", x"44", others => (others => '1'));
    signal DB3_array : byte_array := (x"39", x"10", x"30", others => (others => '1'));

begin
    uut: top port map(
        clk => t_clk,
        rst => t_rst,
        s_in => t_s_in,
        midi_in => t_midi_in,
        midi_sw => t_midi_sw);

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
        wait;
    end process;

    process 
    begin
        for j in 0 to 100 loop
            wait for 70 ns;
            t_s_in <= '0';
            wait for 32 us;
            for i in 0 to 7 loop
                t_s_in <= DB1_array(j)(i);
                wait for 32 us;
            end loop;
            t_s_in <= '1';
            wait for 32 us;
            
            wait for 50 ns;
            t_s_in <= '0';
            wait for 32 us;
            for i in 0 to 7 loop
                t_s_in <= DB2_array(j)(i);
                wait for 32 us;
            end loop;
            t_s_in <= '1';
            wait for 32 us;
            
            wait for 50 ns;
            t_s_in <= '0';
            wait for 32 us;
            for i in 0 to 7 loop
                t_s_in <= DB3_array(j)(i);
                wait for 32 us;
            end loop;
            t_s_in <= '1';
            wait for 32 us;
        end loop;
        
        
        

    end process;


end Behavioral;
