----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/27/2024 09:33:48 AM
-- Design Name: 
-- Module Name: MIDI_LOGIC - Behavioral
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

entity MIDI_LOGIC is
    Port ( CLK : in STD_LOGIC;
           RX_RDY : in STD_LOGIC;
           RX_PDATA : in STD_LOGIC;
           CHANNELS : out STD_LOGIC;
           WAIT_COUNTS : out STD_LOGIC;
           VELOCITIES : out STD_LOGIC;
           PLAYER_ENS : out STD_LOGIC_VECTOR (7 downto 0));
end MIDI_LOGIC;

architecture Behavioral of MIDI_LOGIC is

begin


end Behavioral;
