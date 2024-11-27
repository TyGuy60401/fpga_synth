----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/18/2024 02:55:53 PM
-- Design Name: 
-- Module Name: sin_gen_bram - Behavioral
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

entity sin_gen_bram is
    Port ( clk_sin : in STD_LOGIC;
           en_sin : in STD_LOGIC;
           we_sin : in STD_LOGIC_VECTOR (0 downto 0);
           addr_sin : in STD_LOGIC_VECTOR (5 downto 0);
           din_sin : in STD_LOGIC_VECTOR (11 downto 0);
           dout_sin : out STD_LOGIC_VECTOR (11 downto 0));
end sin_gen_bram;

architecture Behavioral of sin_gen_bram is

component sine_gen IS
  PORT (
    clka : IN STD_LOGIC;
    ena : IN STD_LOGIC;
    wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    addra : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
    dina : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
    douta : OUT STD_LOGIC_VECTOR(11 DOWNTO 0)
  );
END component sine_gen;

begin

U0: sine_gen port map(
    clka => clk_sin,
    ena => en_sin,
    wea => we_sin,
    addra => addr_sin,
    dina => din_sin,
    douta => dout_sin
);

end Behavioral;
