----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/29/2024 10:02:10 AM
-- Design Name: 
-- Module Name: TRANSMIT_TESTER - Behavioral
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

entity TRANSMIT_TESTER is
    Port ( 
           CLK : in STD_LOGIC;
           RST : in STD_LOGIC;
           SCLK : out STD_LOGIC;
           DOUT : out STD_LOGIC;
           SYNC : out STD_LOGIC
    );
end TRANSMIT_TESTER;

architecture Behavioral of TRANSMIT_TESTER is

component Transmitter is
    Port ( SUM_TX : in STD_LOGIC_VECTOR (11 downto 0);
           RST_TX: in STD_LOGIC;
           CLK_TX : in STD_LOGIC;
           LOAD_TX : in STD_LOGIC;
           SCLK_TX : out STD_LOGIC;
           DOUT_TX : out STD_LOGIC;
           SYNC_TX : out STD_LOGIC);
end component Transmitter;

component Player is
    Port ( NOTE_PL : in STD_LOGIC_VECTOR (15 downto 0);
           CLK_PL : in STD_LOGIC;
           RST_PL : in STD_LOGIC;
           PLAY_PL : in STD_LOGIC;
           TONE_PL : in STD_LOGIC_VECTOR (1 downto 0);
           WAVE_O_PL : out STD_LOGIC_VECTOR (11 downto 0));
end component Player;

signal slow_clock: STD_LOGIC;
signal cnt: integer;

signal wave_out: STD_LOGIC_VECTOR (11 downto 0);

begin
U0: Transmitter port map(
    SUM_TX => wave_out,
    RST_TX => RST,
    CLK_TX => CLK,
    LOAD_TX => slow_clock,
    SCLK_TX => sclk,
    DOUT_TX => DOUT,
    SYNC_TX => SYNC
);

U1: PLayer port map (
    NOTE_PL => x"0060",
    CLK_PL => CLK,
    RST_PL => RST,
    PLAY_PL => '0',
    TONE_PL => "00",
    WAVE_O_PL => wave_out
);

process (CLK, RST) begin
    if RST = '1' then
        cnt <= 0;
        slow_clock <= '0';
    elsif rising_edge (clk) then
        if cnt <= 3200 then
            cnt <= cnt + 1;
            slow_clock <= slow_clock; 
        else
            cnt <= 0;
            slow_clock <= NOT(slow_clock); 
        end if;
    end if;
end process;

end Behavioral;
