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
--     C             C#         D           D#          E           F            F#           G          G#           A        A#         B
                                                                                                                x"00ddf2",  x"00d17b",  x"00c5ba",
    x"00baa1",  x"00b028",  x"00a645",  x"009cef",  x"009421",  x"008bd2",  x"0083f9",  x"007c8f",  x"007593",  x"006ef9",  x"0068bd",  x"0062dd",
    x"005d50",  x"005814",  x"005322",  x"004e77",  x"004a10",  x"0045e9",  x"0041fc",  x"003e47",  x"003ac9",  x"00377c",  x"00345e",  x"00316e",
    x"002ea8",  x"002c0a",  x"002991",  x"00273b",  x"002508",  x"0022f4",  x"0020fe",  x"001f23",  x"001d64",  x"001bbe",  x"001a2f",  x"0018b7",
    x"001754",  x"001605",  x"0014c8",  x"00139d",  x"001284",  x"00117a",  x"00107f",  x"000f91",  x"000eb2",  x"000ddf",  x"000d17",  x"000c5b",
    x"000baa",  x"000b02",  x"000a64",  x"0009ce",  x"000942",  x"0008bd",  x"00083f",  x"0007c8",  x"000759",  x"0006ef",  x"00068b",  x"00062d",
    x"0005d5",  x"000581",  x"000532",  x"0004e7",  x"0004a1",  x"00045e",  x"00041f",  x"0003e4",  x"0003ac",  x"000377",  x"000345",  x"000316",
    x"0002ea",  x"0002c0",  x"000299",  x"000273",  x"000250",  x"00022f",  x"00020f",  x"0001f2",  x"0001d6",  x"0001bb",  x"0001a2",  x"00018b",
    x"000175",  x"000160",  x"00014c",  x"000139",  x"000128",  x"000117",  x"000107",  x"0000f9",  x"0000eb",  x"0000dd",  x"0000d1",  x"0000c5",
    x"0000ba",  x"0000b0",  x"0000a6",  x"00009c",  x"000094",  x"00008b",  x"000083",  x"00007c"
    );

end EXTRA_SIGNALS;

