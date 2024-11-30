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
    Port ( NOTE_PL : in STD_LOGIC_VECTOR (15 downto 0);
           CLK_PL : in STD_LOGIC;
           RST_PL : in STD_LOGIC;
           PLAY_PL : in STD_LOGIC;
           TONE_PL : in STD_LOGIC_VECTOR (1 downto 0);
           LOAD_PL : out STD_LOGIC;
           WAVE_O_PL : out STD_LOGIC_VECTOR (11 downto 0));
end Player;

architecture Behavioral of Player is

component Freq_gen is
    Port ( NOTE_FG : in STD_LOGIC_VECTOR (15 downto 0);
           CLK_FG : in STD_LOGIC;
           RST_FG : in STD_LOGIC;
           NOTE_INDEX_FG : out STD_LOGIC_VECTOR (5 downto 0));
end component Freq_gen;

component sin_gen_bram is
    Port ( clk_sin : in STD_LOGIC;
           en_sin : in STD_LOGIC;
           we_sin : in STD_LOGIC_VECTOR (0 downto 0);
           addr_sin : in STD_LOGIC_VECTOR (5 downto 0);
           din_sin : in STD_LOGIC_VECTOR (11 downto 0);
           dout_sin : out STD_LOGIC_VECTOR (11 downto 0));
end component sin_gen_bram;

component tri_gen_bram is
    Port ( clk_tri : in STD_LOGIC;
           en_tri : in STD_LOGIC;
           we_tri : in STD_LOGIC_VECTOR (0 downto 0);
           addr_tri : in STD_LOGIC_VECTOR (5 downto 0);
           din_tri : in STD_LOGIC_VECTOR (11 downto 0);
           dout_tri : out STD_LOGIC_VECTOR (11 downto 0));
end component tri_gen_bram;

component square_gen_bram is
    Port ( clk_sqr : in STD_LOGIC;
           en_sqr : in STD_LOGIC;
           we_sqr : in STD_LOGIC_VECTOR (0 downto 0);
           addr_sqr : in STD_LOGIC_VECTOR (5 downto 0);
           din_sqr : in STD_LOGIC_VECTOR (11 downto 0);
           dout_sqr : out STD_LOGIC_VECTOR (11 downto 0));
end component square_gen_bram;

signal s_addr : STD_LOGIC_VECTOR (5 downto 0);

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

U1: sin_gen_bram port map(
    clk_sin => CLK_PL,
    en_sin => '1',
    we_sin => "0",
    addr_sin => s_addr,
    din_sin => x"000",
    dout_sin => s_sin_out
);

U2: tri_gen_bram port map(
    clk_tri => CLK_PL,
    en_tri => '1',
    we_tri => "0",
    addr_tri => s_addr,
    din_tri => x"000",
    dout_tri => s_tri_out
);

U3: square_gen_bram port map(
    clk_sqr => CLK_PL,
    en_sqr => '1',
    we_sqr => "0",
    addr_sqr => s_addr,
    din_sqr => x"000",
    dout_sqr => s_sqr_out
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

