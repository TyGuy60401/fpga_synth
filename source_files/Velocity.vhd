----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/27/2024 03:49:07 PM
-- Design Name: 
-- Module Name: Velocity - Behavioral
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

entity Velocity is
    Port ( WAVE_IN_V : in STD_LOGIC_VECTOR (11 downto 0);
           VELOCITY_V : in STD_LOGIC_VECTOR (6 downto 0);
           PLY_ACT_V: in STD_LOGIC;
           CLK_V : in STD_LOGIC;
           WAVE_OUT_V : out STD_LOGIC_VECTOR (11 downto 0)
           );        
end Velocity;

architecture Behavioral of Velocity is

component velocity_mem IS
  PORT (
    clka : IN STD_LOGIC;
    ena : IN STD_LOGIC;
    wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    addra : IN STD_LOGIC_VECTOR(6 DOWNTO 0);
    dina : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    douta : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
  );
END component velocity_mem;

signal s_WAVE: unsigned (19 downto 0);
signal curr_note: unsigned (11 downto 0);
signal s_VEL: STD_LOGIC_VECTOR (7 downto 0);

signal s_WAIT: STD_LOGIC;

type state is (WAITING, START, PLAYING);

signal curr_state: state;
signal next_state: state;

begin
U0: velocity_mem port map(
    clka => CLK_V,
    ena => '1',
    wea => "0",
    addra => VELOCITY_V,
    dina => (others => '0'),
    douta => S_VEL
);

WAVE_OUT_V <= std_logic_vector(s_WAVE(11 downto 0));

process (curr_state, PLY_ACT_V) begin
    case curr_state is
        when WAITING =>
            if PLY_ACT_V = '1' then
                next_state <= START;
            else
                next_state <= WAITING;
            end if;
        when START =>
            curr_note <= unsigned(WAVE_IN_V);
            next_state <= PLAYING;
        when PLAYING =>
            s_WAVE <= (curr_note * unsigned(S_VEL)) / 128;
            if PLY_ACT_V = '1' then
                next_state <= START;
            else
                next_state <= WAITING;
            end if;
    end case;
end process;

process (CLK_V) begin
    if rising_edge(CLK_V) then
        curr_state <= next_state;
    end if;
    
end process;


end Behavioral;
