----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/18/2024 03:11:14 PM
-- Design Name: 
-- Module Name: Freq_gen - Behavioral
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

entity Freq_gen is
    Port ( NOTE_FG : in STD_LOGIC_VECTOR (15 downto 0);
           CLK_FG : in STD_LOGIC;
           RST_FG : in STD_LOGIC;
           NOTE_INDEX_FG : out STD_LOGIC_VECTOR (5 downto 0));
end Freq_gen;

architecture Behavioral of Freq_gen is

signal cnt : unsigned (15 downto 0);
signal s_NOTE_INDEX_FG: unsigned (5 downto 0);


begin
NOTE_INDEX_FG <= std_logic_vector(s_NOTE_INDEX_FG);

process(CLK_FG, RST_FG) begin

    if RST_FG = '1' then
        cnt <= (others => '0');
        s_NOTE_INDEX_FG <= (others => '0');
        
    elsif rising_edge(CLK_FG) then
    
        if cnt < unsigned(NOTE_FG) then
            cnt <= cnt + 1;
        elsif s_NOTE_INDEX_FG >= x"3f" then
            s_NOTE_INDEX_FG <= (others => '0');
            cnt <= (others => '0');
        else
            s_NOTE_INDEX_FG <= s_NOTE_INDEX_FG + 1;
            cnt <= (others => '0');
            
        end if;
    else
    end if;
end process;

end Behavioral;

