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
           state : out std_logic_vector (7 downto 0);
           PLAYER_ENS : out STD_LOGIC_VECTOR (PLAYER_COUNT - 1 downto 0));
end MIDI_LOGIC;

architecture Behavioral of MIDI_LOGIC is
    type Tstate is (idle, status_byte, 
                    ON_DB1, ON_DB2_1, ON_DB2_2, 
                    OFF_DB1, OFF_DB2_1, OFF_DB2_2,
                    DC1, DC2_1, DC2_2,
                    W1, W2, W3, W4, W5, W6, W7, W8);

    signal cs : Tstate := idle;
    signal channel : std_logic_vector (3 downto 0) := "0000";
    signal n : integer := 0;
    signal note : std_logic_vector (7 downto 0) := "00000000";
    signal velocity : std_logic_vector (6 downto 0) := "1000000";
    signal hash : std_logic_vector (9 downto 0) := "0000000000";
    signal control : std_logic_vector (6 downto 0) := "0000000";

    type hash_array is array (0 to PLAYER_COUNT - 1) of std_logic_vector (9 downto 0);
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
            note <= "00000000";
            velocity <= "1000000";
            hash <= "0000000000";
            control <= "0000000";
        elsif rising_edge(CLK) then
            case cs is
                when idle =>
                    state <= x"01";
                    if RX_RDY = '1' then
                        cs <= status_byte;
                    end if;
                when status_byte =>
                    state <= x"02";
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
                    state <= x"03";
                    note <= RX_PDATA;
                    cs <= W2;
                when ON_DB2_1 =>
                    state <= x"04";
                    if channel = "0000" or channel = "0001" or channel = "0010" then
                        cs <= ON_DB2_2;
                    else
                        cs <= idle;
                    end if;
                    
                    -- finding the first item in the array that is empty
                    for i in hash_arr'range loop
                        if hash_arr(i) = "0000000000" then
                            idx <= i;
                            exit;
                        end if;
                    end loop;
                when ON_DB2_2 =>
                    state <= x"05";


                    hash_arr(idx) <= channel(1 downto 0) & note;
                    VELOCITIES(idx) <= RX_PDATA(6 downto 0);
                    CHANNELS(idx) <= channel(1 downto 0);
                    PLAYER_ENS(idx) <= '1';
                    WAIT_COUNTS(idx) <= NOTE_COUNTS(to_integer(unsigned(note)));
                    DECAYS(idx) <= channel_decays(to_integer(unsigned(channel)));
                    
                    cs <= idle;
                when OFF_DB1 =>
                    state <= x"06";
                    note <= RX_PDATA;
                    cs <= OFF_DB2_1;
                when OFF_DB2_1 =>
                    state <= x"07";
                    if channel = "0000" or channel = "0001" or channel = "0010" then
                        cs <= OFF_DB2_2;
                    else
                        cs <= idle;
                    end if;
                    
                    for i in PLAYER_COUNT - 1 downto 0 loop
                        if (hash_arr(i) = channel(1 downto 0) & note) then
                            idx <= i;
                        end if;
                    end loop;
                when OFF_DB2_2 =>
                    state <= x"07";
                    
                    PLAYER_ENS(idx) <= '0';
                    hash_arr(idx) <= (others => '0');
                    cs <= idle;
                when DC1 =>
                    state <= x"08";
                    control <= RX_PDATA(6 downto 0);
                    cs <= W8;
                when DC2_1 =>
                    state <= x"09";
                    if control = x"21" then
                        cs <= DC2_2;
                    else
                        cs <= idle;
                    end if;
                when DC2_2 =>
                    state <= x"0A";
                    channel_decays(to_integer(unsigned(channel))) <= RX_PDATA(6 downto 0);
                    cs <= idle;
                when W1 =>
                    state <= x"0B";
                    if RX_RDY = '1' then
                        cs <= ON_DB1;
                    end if;
                when W2 =>
                    state <= x"0C";
                    if RX_RDY = '1' then
                        cs <= ON_DB2_1;
                    end if;
                when W3 =>
                    state <= x"0D";
                    if RX_RDY = '1' then
                        cs <= OFF_DB1;
                    end if;
                when W4 =>
                    state <= x"0E";
                    if RX_RDY = '1' then
                        cs <= OFF_DB2_1;
                    end if;
                when W5 =>
                    state <= x"0F";
                    if RX_RDY = '1' then
                        cs <= W6;
                    end if;
                when W6 =>
                    state <= x"10";
                    if RX_RDY = '1' then
                        cs <= idle;
                    end if;
                when W7 =>
                    state <= x"11";
                    if RX_RDY = '1' then
                        cs <= DC1;
                    end if;
                when W8 =>
                    state <= x"12";
                    if RX_RDY = '1' then
                        cs <= DC2_2;
                    end if;
            end case;
        end if;
    
    end process;

end Behavioral;
