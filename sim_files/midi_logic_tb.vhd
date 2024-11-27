----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/27/2024 11:36:36 AM
-- Design Name: 
-- Module Name: midi_logic_tb - Behavioral
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
use work.EXTRA_SIGNALS.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity midi_logic_tb is
--  Port ( );
end midi_logic_tb;

architecture Behavioral of midi_logic_tb is
    component MIDI_LOGIC is
        Port ( CLK : in STD_LOGIC;
               RST : in STD_LOGIC;
               RX_RDY : in STD_LOGIC;
               RX_PDATA : in STD_LOGIC_VECTOR (7 downto 0);
               CHANNELS : out channels_array;
               WAIT_COUNTS : out wait_counts_array;
               VELOCITIES : out velocities_array;
               PLAYER_ENS : out STD_LOGIC_VECTOR (PLAYER_COUNT - 1 downto 0));
    end component;
    
    signal t_clk : std_logic := '0';
    signal t_rst : std_logic := '0';
    signal t_rdy : std_logic := '0';
    signal t_pdata : std_logic_vector (7 downto 0) := "00000000";
    
begin
    uut: MIDI_LOGIC port map (
        CLK => t_clk,
        RST => t_rst,
        rx_rdy => t_rdy,
        rx_pdata => t_pdata);
        
    process
    begin
        wait for 5 ns;
        t_clk <= not t_clk;
    end process;
    
    process
    begin
        wait for 100 ns;
        t_pdata <= x"90";
        wait for 10 ns;
        t_rdy <= '1';
        wait for 10 ns;
        t_rdy <= '0';
        
        wait for 40 ns;
        t_pdata <= x"4D";
        wait for 10 ns;
        t_rdy <= '1';
        wait for 10 ns;
        t_rdy <= '0';
        
        wait for 40 ns;
        t_pdata <= x"a1";
        wait for 10 ns;
        t_rdy <= '1';
        wait for 10 ns;
        t_rdy <= '0';
        
        wait;
    end process;

end Behavioral;
