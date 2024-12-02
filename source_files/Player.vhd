----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/18/2024 12:55:44 PM
-- Design Name: 
-- Module Name: Player - Behavioral
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

entity Player is
    Port ( NOTE_PL : in STD_LOGIC_VECTOR (23 downto 0);
           CLK_PL : in STD_LOGIC;
           RST_PL : in STD_LOGIC;
           TONE_PL : in STD_LOGIC_VECTOR (1 downto 0);
           WAVE_O_PL : out STD_LOGIC_VECTOR (11 downto 0));
end Player;

architecture Behavioral of Player is

component Freq_gen is
    Port ( NOTE_FG : in STD_LOGIC_VECTOR (23 downto 0);
           CLK_FG : in STD_LOGIC;
           RST_FG : in STD_LOGIC;
           NOTE_INDEX_FG : out STD_LOGIC_VECTOR (6 downto 0));
end component Freq_gen;

component sin_high_res IS
  PORT (
    clka : IN STD_LOGIC;
    ena : IN STD_LOGIC;
    wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    addra : IN STD_LOGIC_VECTOR(6 DOWNTO 0);
    dina : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
    douta : OUT STD_LOGIC_VECTOR(11 DOWNTO 0)
  );
END component sin_high_res;

component Tri_high_res IS
  PORT (
    clka : IN STD_LOGIC;
    ena : IN STD_LOGIC;
    wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    addra : IN STD_LOGIC_VECTOR(6 DOWNTO 0);
    dina : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
    douta : OUT STD_LOGIC_VECTOR(11 DOWNTO 0)
  );
END component Tri_high_res;

component sqr_high_res IS
  PORT (
    clka : IN STD_LOGIC;
    ena : IN STD_LOGIC;
    wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    addra : IN STD_LOGIC_VECTOR(6 DOWNTO 0);
    dina : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
    douta : OUT STD_LOGIC_VECTOR(11 DOWNTO 0)
  );
END component sqr_high_res;

signal s_addr : STD_LOGIC_VECTOR (6 downto 0);

signal s_sin_out : STD_LOGIC_VECTOR (11 downto 0);
signal s_tri_out : STD_LOGIC_VECTOR (11 downto 0);
signal s_sqr_out : STD_LOGIC_VECTOR (11 downto 0);

signal s_TONE_CHOICE_OUT : STD_LOGIC_VECTOR (11 downto 0);

begin

U0: freq_gen port map(
    NOTE_FG => NOTE_PL,
    CLK_FG => CLK_PL,
    RST_FG => RST_PL,
    NOTE_INDEX_FG => s_addr
);

U1: sin_high_res port map(
    clka => CLK_PL,
    ena => '1',
    wea => "0",
    addra => s_addr,
    dina => x"000",
    douta => s_sin_out
);

U2: tri_high_res port map(
    clka => CLK_PL,
    ena => '1',
    wea => "0",
    addra => s_addr,
    dina => x"000",
    douta => s_tri_out
);

U3: sqr_high_res port map(
    clka => CLK_PL,
    ena => '1',
    wea => "0",
    addra => s_addr,
    dina => x"000",
    douta => s_sqr_out
);

WAVE_O_PL <= s_TONE_CHOICE_OUT;

process (clk_pl) begin
if rising_edge(clk_pl) then
case tone_pl is
    when "00" =>
        s_TONE_CHOICE_OUT <= s_sin_out;
    when "01" =>
        s_TONE_CHOICE_OUT <= s_tri_out;
    when "10" =>
        s_TONE_CHOICE_OUT <= s_sqr_out;
    when others =>
        s_TONE_CHOICE_OUT <= (others => 'Z');
end case;
end if;
end process;

end Behavioral;

