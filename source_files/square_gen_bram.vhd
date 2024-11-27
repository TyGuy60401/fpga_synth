----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/18/2024 02:55:53 PM
-- Design Name: 
-- Module Name: square_gen_bram - Behavioral
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

entity square_gen_bram is
    Port ( clk_sqr : in STD_LOGIC;
           en_sqr : in STD_LOGIC;
           we_sqr : in STD_LOGIC_VECTOR (0 downto 0);
           addr_sqr : in STD_LOGIC_VECTOR (5 downto 0);
           din_sqr : in STD_LOGIC_VECTOR (11 downto 0);
           dout_sqr : out STD_LOGIC_VECTOR (11 downto 0));
end square_gen_bram;

architecture Behavioral of square_gen_bram is

component square_gen IS
  PORT (
    clka : IN STD_LOGIC;
    ena : IN STD_LOGIC;
    wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    addra : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
    dina : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
    douta : OUT STD_LOGIC_VECTOR(11 DOWNTO 0)
  );
END component square_gen;

begin

U0: square_gen port map(
    clka => clk_sqr,
    ena => en_sqr,
    wea => we_sqr,
    addra => addr_sqr,
    dina => din_sqr,
    douta => dout_sqr
);
end Behavioral;
