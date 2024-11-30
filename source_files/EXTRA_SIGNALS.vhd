----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/27/2024 09:38:49 AM
-- Design Name: 
-- Module Name: EXTRA_SIGNALS - Behavioral
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

package EXTRA_SIGNALS is
    constant PLAYER_COUNT : integer := 8;
    
    type velocities_array is array (PLAYER_COUNT - 1 downto 0) of STD_LOGIC_VECTOR (6 downto 0);
    type wait_counts_array is array (PLAYER_COUNT - 1 downto 0) of STD_LOGIC_VECTOR (23 downto 0);
    type channels_array is array (PLAYER_COUNT - 1 downto 0) of STD_LOGIC_VECTOR (1 downto 0);
    type decays_array is array(PLAYER_COUNT - 1 downto 0) of STD_LOGIC_VECTOR (6 downto 0);
    type player_array is array(7 downto 0) of std_logic_vector (11 downto 0);
    
    type note_count_array is array (21 to 127) of std_logic_vector (23 downto 0);

    constant NOTE_COUNTS : note_count_array := (
--     C        C#         D        D#         E         F        F#         G        G#         A        A#         B
                                                                                              x"ddf2",  x"d17b",  x"c5ba",
    x"baa1",  x"b028",  x"a645",  x"9cef",  x"9421",  x"8bd2",  x"83f9",  x"7c8f",  x"7593",  x"6ef9",  x"68bd",  x"62dd",
    x"5d50",  x"5814",  x"5322",  x"4e77",  x"4a10",  x"45e9",  x"41fc",  x"3e47",  x"3ac9",  x"377c",  x"345e",  x"316e",
    x"2ea8",  x"2c0a",  x"2991",  x"273b",  x"2508",  x"22f4",  x"20fe",  x"1f23",  x"1d64",  x"1bbe",  x"1a2f",  x"18b7",
    x"1754",  x"1605",  x"14c8",  x"139d",  x"1284",  x"117a",  x"107f",  x"0f91",  x"0eb2",  x"0ddf",  x"0d17",  x"0c5b",
    x"0baa",  x"0b02",  x"0a64",  x"09ce",  x"0942",  x"08bd",  x"083f",  x"07c8",  x"0759",  x"06ef",  x"068b",  x"062d",
    x"05d5",  x"0581",  x"0532",  x"04e7",  x"04a1",  x"045e",  x"041f",  x"03e4",  x"03ac",  x"0377",  x"0345",  x"0316",
    x"02ea",  x"02c0",  x"0299",  x"0273",  x"0250",  x"022f",  x"020f",  x"01f2",  x"01d6",  x"01bb",  x"01a2",  x"018b",
    x"0175",  x"0160",  x"014c",  x"0139",  x"0128",  x"0117",  x"0107",  x"00f9",  x"00eb",  x"00dd",  x"00d1",  x"00c5",
    x"00ba",  x"00b0",  x"00a6",  x"009c",  x"0094",  x"008b",  x"0083",  x"007c"
    );

end EXTRA_SIGNALS;

