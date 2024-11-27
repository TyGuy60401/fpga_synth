----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/27/2024 02:45:54 PM
-- Design Name: 
-- Module Name: Top - Behavioral
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
use work.extra_signals.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Top is
    Port ( S_OUT : out STD_LOGIC;
           SYNC : out STD_LOGIC;
           SCK : out STD_LOGIC;
           CLK : in STD_LOGIC;
           RST : in STD_LOGIC;
           S_IN : in STD_LOGIC);
end Top;

architecture Behavioral of Top is

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
    
    component UART_RX is
    Port ( sdata_rx : in STD_LOGIC;
           rst_rx : in STD_LOGIC;
           clk_rx : in STD_LOGIC;
           ready : out STD_LOGIC;
           pdata_rx : out STD_LOGIC_VECTOR (7 downto 0));
    end component;
    
    component Summer is
    Port ( PL_array : in player_array;
           PL_ACT : in STD_LOGIC_VECTOR (7 downto 0);
           CLK : in STD_LOGIC;
           SUM : out STD_LOGIC_VECTOR (11 downto 0));
    end component;
    
    component Transmitter is
    Port ( SUM : in STD_LOGIC_VECTOR (11 downto 0);
           CLK : in STD_LOGIC;
           SCK : out STD_LOGIC;
           BUSY : out STD_LOGIC;
           S_OUT : out STD_LOGIC);
    end component;
    
    signal SUM_ntrl : STD_LOGIC_VECTOR (11 downto 0);
    signal RDY_ntrl : STD_LOGIC;
    signal PDATA_ntrl : STD_LOGIC_VECTOR (7 downto 0);

begin

    SUMMER_INST : Summer port map (
        SUM => SUM_ntrl,
        CLK => CLK,
        PL_ACT => ,
        PL_array => );
        
    TRANSMITTER_INST : Transmitter port map (
        SUM => SUM_ntrl,
        CLK => CLK,
        SCK => SCK,
        BUSY => SYNC,
        S_OUT => S_OUT);
        
    MIDI_RX_INST : UART_RX port map (
        clk_rx => CLK,
        rst_rx => RST,
        sdata_rx => S_IN,
        ready => RDY_ntrl,
        pdata_rx => PDATA_ntrl);
        
    MIDI_LOGIC_INST : MIDI_LOGIC port map (
        CLK => CLK,
        RST => RST,
        RX_RDY => RDY_ntrl,
        RX_PDATA => PDATA_ntrl,
        CHANNELS => ,
        WAIT_COUNTS => ,
        VELOCITIES => ,
        PLAYER_ENS => );

end Behavioral;
