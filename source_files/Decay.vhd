----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/26/2024 07:41:04 PM
-- Design Name: 
-- Module Name: Note_Natural_Decay - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Decay is
    Port ( PLAY_D : in STD_LOGIC;
           CLK_D : in STD_LOGIC;
           RST_D : in STD_LOGIC;
           DECAY_CONTROL: in STD_LOGIC_VECTOR (6 downto 0);
           WAVE_IN_D : in STD_LOGIC_VECTOR (11 downto 0);
           PLY_ACT_D : out STD_LOGIC;
           WAVE_OUT_D : out STD_LOGIC_VECTOR (11 downto 0);
           DEC_TEST_OUT: out STD_LOGIC_VECTOR (6 downto 0));
end Decay;

architecture Behavioral of Decay is

type state is (WAITING,PLAYING,DECAY);

signal curr_state: state;
signal next_state: state;

signal s_WAVE: STD_LOGIC_VECTOR (11 downto 0);

signal DECAY_NOTE: unsigned(18 downto 0);

signal DECAY_AM: unsigned (6 downto 0);
signal cnt: integer;

begin

s_WAVE <= WAVE_IN_D;
DEC_TEST_OUT <= std_logic_vector(DECAY_NOTE(6 downto 0));

-- COMBINATIONAL LOGIC FOR STATE MACHINE
process (curr_state, PLAY_D, DECAY_AM) begin

case curr_state is

    when WAITING =>
        PLY_ACT_D <= '0';

        if PLAY_D = '1' then
            next_state <= PLAYING;
        else
            next_state <= WAITING;
        end if;
        
    when PLAYING =>
        PLY_ACT_D <= '1';
        
        if PLAY_D = '1' then
            next_state <= PLAYING;
        else
            next_state <= DECAY;
        end if;
        
    when DECAY =>
        
        PLY_ACT_D <= '1';
        if PLAY_D = '1' then
            next_state <= PLAYING;
        else
            if DECAY_AM = 0 then
                next_state <= WAITING;
            else
                next_state <= DECAY;
            end if;
        end if;
        
end case;

end process;

-- CLOCKED NEXT STATE
process (CLK_D, RST_D, curr_state) begin

    if RST_D = '1' then
        DECAY_NOTE(18 downto 12) <= (others => '0');
        DECAY_NOTE(11 downto 0) <= unsigned(WAVE_IN_D);
    elsif rising_edge(CLK_D) then
        curr_state <= next_state;
            
        if curr_state = WAITING then
            DECAY_NOTE(18 downto 12) <= (others => '0');
            DECAY_NOTE(11 downto 0) <= unsigned(WAVE_IN_D);
            WAVE_OUT_D <= (others => 'Z');
        elsif curr_state = PLAYING then
            WAVE_OUT_D <= WAVE_IN_D;
        elsif curr_state = DECAY then
            WAVE_OUT_D <= std_logic_vector(DECAY_NOTE(11 downto 0));
            DECAY_NOTE <= ((DECAY_AM * unsigned(s_WAVE)) / 128) + ((4096 - (DECAY_AM * 32)) / 2);
        end if;
        
    end if;

end process;

-- Slow Clock for delay
process (CLK_D, RST_D, curr_state) begin
    if RST_D = '1' then
        cnt <= 0;
        DECAY_AM <= unsigned(DECAY_CONTROL);
    elsif rising_edge(clk_D) then
        if curr_state = WAITING then
            cnt <= 0;
        elsif curr_state = PLAYING then
            cnt <= 0;
            DECAY_AM <=  unsigned(DECAY_CONTROL);
        elsif cnt <= 1562500 and curr_state = DECAY then
            cnt <= cnt + 1;
        else
            cnt <= 0;
            if DECAY_AM > 0 then
                DECAY_AM <= DECAY_AM - 1;
            else
                DECAY_AM <=  unsigned(DECAY_CONTROL);
            end if;
        end if;
    end if;
end process;

end Behavioral;
