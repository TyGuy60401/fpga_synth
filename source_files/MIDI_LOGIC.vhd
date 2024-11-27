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

use work.EXTRA_SIGNALS.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity MIDI_LOGIC is
    Port ( CLK : in STD_LOGIC;
           RST : in STD_LOGIC;
           RX_RDY : in STD_LOGIC;
           RX_PDATA : in STD_LOGIC_VECTOR (7 downto 0);
           CHANNELS : out channels_array;
           WAIT_COUNTS : out wait_counts_array;
           VELOCITIES : out velocities_array;
           DECAYS : out decays_array;
           PLAYER_ENS : out STD_LOGIC_VECTOR (PLAYER_COUNT - 1 downto 0));
end MIDI_LOGIC;

architecture Behavioral of MIDI_LOGIC is
    type Tstate is (idle, status_byte, 
                    ON_DB1, ON_DB2_1, ON_DB2_2, 
                    OFF_DB1, OFF_DB2_1, OFF_DB2_2,
                    DC1, DC2_1, DC2_2,
                    W1, W2, W3, W4, W5, W6, W7, W8);

    signal cs : Tstate := idle;
    signal channel : std_logic_vector (3 downto 0);
    signal n : integer := 0;
    signal note : std_logic_vector (7 downto 0);
    signal velocity : std_logic_vector (6 downto 0);
    signal hash : std_logic_vector (9 downto 0);
    signal control : std_logic_vector (6 downto 0);

    type hash_array is array (0 to 7) of std_logic_vector (9 downto 0);
    signal hash_arr : hash_array := (others => (others => '0'));

    type channel_decays_array is array (0 to 2) of std_logic_vector (6 downto 0);
    signal channel_decays : channel_decays_array := (others => "1000000");
    
    signal idx : integer := 0;

begin
    process (CLK, RST)
    begin
        if RST = '1' then
            cs <= idle;
            CHANNELS <= (others => (others => '0'));
            PLAYER_ENS <= (others => '0');
            VELOCITIES <= (others => (others => '0'));
            DECAYS <= (others => "1000000");
            WAIT_COUNTS <= (others => (others => '0'));
        elsif rising_edge(CLK) then
            case cs is
                when idle =>
                    if RX_RDY = '1' then
                        cs <= status_byte;
                    end if;
                when status_byte =>
                    channel <= RX_PDATA(3 downto 0);
                    n <= 0;
                    case RX_PDATA(7 downto 4) is
                        when x"9" => cs <= W1; -- note on
                        when x"8" => cs <= W3; -- note off
                        when x"B" => cs <= W7; -- decay control
                        when x"A" => cs <= W5;
                        when x"E" => cs <= W5;
                        when x"C" => cs <= W6;
                        when x"D" => cs <= W6;
                        when others =>
                            cs <= idle;
                    end case;
                    
                when ON_DB1 =>
                    note <= RX_PDATA;
                    cs <= W2;
                when ON_DB2_1 =>
                    if channel = "0000" or channel = "0001" or channel = "0010" then
                        cs <= ON_DB2_2;
                    else
                        cs <= idle;
                    end if;
                when ON_DB2_2 =>
                    
                    -- finding the first item in the array that is empty
                    for i in PLAYER_COUNT - 1 downto 0 loop
                        if (hash_arr(0) = "0000000000") then
                            idx <= i;
                        end if;
                    end loop;

                    hash_arr(idx) <= channel(1 downto 0) & note;
                    VELOCITIES(idx) <= RX_PDATA(6 downto 0);
                    CHANNELS(idx) <= channel(1 downto 0);
                    PLAYER_ENS(idx) <= '1';
                    WAIT_COUNTS(idx) <= NOTE_COUNTS(to_integer(unsigned(note)));
                    DECAYS(idx) <= channel_decays(to_integer(unsigned(channel)));
                    
                    cs <= idle;
                when OFF_DB1 =>
                    note <= RX_PDATA;
                    cs <= OFF_DB2_1;
                when OFF_DB2_1 =>
                    if channel = "0000" or channel = "0001" or channel = "0010" then
                        cs <= OFF_DB2_2;
                    else
                        cs <= idle;
                    end if;
                when OFF_DB2_2 =>
                    
                    for i in PLAYER_COUNT - 1 downto 0 loop
                        if (hash_arr(0) = channel(1 downto 0) & note) then
                            idx <= i;
                        end if;
                    end loop;
                    
                    PLAYER_ENS(idx) <= '0';
                    hash_arr(idx) <= (others => '0');
                    cs <= idle;
                when DC1 =>
                    control <= RX_PDATA(6 downto 0);
                    cs <= W8;
                when DC2_1 =>
                    if control = x"DA" then
                        cs <= DC2_2;
                    else
                        cs <= idle;
                    end if;
                when DC2_2 =>
                    channel_decays(to_integer(unsigned(channel))) <= RX_PDATA(6 downto 0);
                    cs <= idle;
                when W1 =>
                    if RX_RDY = '1' then
                        cs <= ON_DB1;
                    end if;
                when W2 =>
                    if RX_RDY = '1' then
                        cs <= ON_DB2_1;
                    end if;
                when W3 =>
                    if RX_RDY = '1' then
                        cs <= OFF_DB1;
                    end if;
                when W4 =>
                    if RX_RDY = '1' then
                        cs <= OFF_DB2_1;
                    end if;
                when W5 =>
                    if RX_RDY = '1' then
                        cs <= W6;
                    end if;
                when W6 =>
                    if RX_RDY = '1' then
                        cs <= idle;
                    end if;
                when W7 =>
                    if RX_RDY = '1' then
                        cs <= DC1;
                    end if;
                when W8 =>
                    if RX_RDY = '1' then
                        cs <= DC2_2;
                    end if;
            end case;
        end if;
    
    end process;

end Behavioral;
