----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/18/2024 08:50:25 PM
-- Design Name: 
-- Module Name: PLAYER_TB - Behavioral
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

entity PLAYER_TB is
--  Port ( );
end PLAYER_TB;

architecture Behavioral of PLAYER_TB is
component Player is
    Port ( NOTE_PL : in STD_LOGIC_VECTOR (15 downto 0);
           CLK_PL : in STD_LOGIC;
           RST_PL : in STD_LOGIC;
           PLAY_PL : in STD_LOGIC;
           TONE_PL : in STD_LOGIC_VECTOR (1 downto 0);
           WAVE_O_PL : out STD_LOGIC_VECTOR (11 downto 0));
end component Player;

   signal NOTE_PL_TB : STD_LOGIC_VECTOR (15 downto 0);
   signal CLK_PL_TB : STD_LOGIC := '0';
   signal RST_PL_TB : STD_LOGIC;
   signal PLAY_PL_TB : STD_LOGIC;
   signal TONE_PL_TB : STD_LOGIC_VECTOR (1 downto 0);
   signal WAVE_O_PL_TB : STD_LOGIC_VECTOR (11 downto 0);

begin
UUT: Player port map (
   NOTE_PL => NOTE_PL_TB,
   CLK_PL => CLK_PL_TB,
   RST_PL => RST_PL_TB,
   PLAY_PL => PLAY_PL_TB,
   TONE_PL => TONE_PL_TB,
   WAVE_O_PL => WAVE_O_PL_TB
);

CLK_PL_TB <= NOT(CLK_PL_TB) after 2 ns;

process begin

RST_PL_TB <= '1';
wait for 10 ns;
RST_PL_TB <= '0';
NOTE_PL_TB <= x"0080";
TONE_PL_TB <= "00";
wait for 10 ns;
TONE_PL_TB <= "01";
wait for 10000 ns;
NOTE_PL_TB <= x"0400";
wait for 10000 ns;


end process;

end Behavioral;
