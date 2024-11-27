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
           VELOCITY_D: in STD_LOGIC_VECTOR (6 downto 0);
           DECAY_CONTROL: in STD_LOGIC_VECTOR (6 downto 0);
           WAVE_IN_D : in STD_LOGIC_VECTOR (11 downto 0);
           PLY_ACT_D : out STD_LOGIC;
           WAVE_OUT_D : out STD_LOGIC_VECTOR (11 downto 0));
end Decay;

architecture Behavioral of Decay is

type state is (WAITING,PLAYING,DECAY);

signal curr_state: state;
signal next_state: state;

signal s_WAVE_SIG: STD_LOGIC_VECTOR (11 downto 0);

signal DECAY_AM: unsigned (9 downto 0); 

begin

s_WAVE_SIG <= WAVE_IN_D;

process (curr_state, PLAY_D, DECAY_AM) begin

case curr_state is

    when WAITING =>
    
        PLY_ACT_D <= '0';
        WAVE_OUT_D <= (others => 'Z');
        
        if PLAY_D = '1' then
            next_state <= PLAYING;
        else
            next_state <= WAITING;
        end if;
        
    when PLAYING =>
    
        PLY_ACT_D <= '1';
        WAVE_OUT_D <= s_WAVE_SIG;
        
        if PLAY_D = '1' then
            next_state <= PLAYING;
        else
            next_state <= DECAY;
        end if;
        
    when DECAY =>
        
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

process (CLK_D, RST_D) begin

    if RST_D = '1' then
    elsif rising_edge(CLK_D) then
        curr_state <= next_state;
    end if;

end process;

end Behavioral;
