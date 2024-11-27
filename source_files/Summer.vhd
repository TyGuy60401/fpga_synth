----------------------------------------------------------------------------------
-- Company: Weber State University
-- Engineer: Thomas DuCourant
-- 
-- Create Date: 11/26/2024 02:03:39 PM
-- Design Name: Group Project Summer

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity Summer is
    Port ( PL0 : in STD_LOGIC_VECTOR (11 downto 0);
           PL1 : in STD_LOGIC_VECTOR (11 downto 0);
           PL2 : in STD_LOGIC_VECTOR (11 downto 0);
           PL3 : in STD_LOGIC_VECTOR (11 downto 0);
           PL4 : in STD_LOGIC_VECTOR (11 downto 0);
           PL5 : in STD_LOGIC_VECTOR (11 downto 0);
           PL6 : in STD_LOGIC_VECTOR (11 downto 0);
           PL7 : in STD_LOGIC_VECTOR (11 downto 0);
           PL_ACT : in STD_LOGIC_VECTOR (7 downto 0);
           CLK : in STD_LOGIC;
           SUM : out STD_LOGIC_VECTOR (11 downto 0));
end Summer;

architecture Behavioral of Summer is

begin
    process(PL_ACT)
        variable int_PL_TOT: integer;
        variable ACT: integer;
        variable int_SUM: integer;
        variable round: integer;
    begin
        int_PL_TOT := 0;
        ACT := 0;
        if PL_ACT(0) = '1' then
            int_PL_TOT := to_integer(unsigned(PL0)) + int_PL_TOT;
            ACT := ACT + 1;
        end if;
        if PL_ACT(1) = '1' then
            int_PL_TOT := to_integer(unsigned(PL1)) + int_PL_TOT;
            ACT := ACT + 1;
        end if;
        if PL_ACT(2) = '1' then
            int_PL_TOT := to_integer(unsigned(PL2)) + int_PL_TOT;
            ACT := ACT + 1;
        end if;
        if PL_ACT(3) = '1' then
            int_PL_TOT := to_integer(unsigned(PL3)) + int_PL_TOT;
            ACT := ACT + 1;
        end if;
        if PL_ACT(4) = '1' then
            int_PL_TOT := to_integer(unsigned(PL4)) + int_PL_TOT;
            ACT := ACT + 1;
        end if;
        if PL_ACT(5) = '1' then
            int_PL_TOT := to_integer(unsigned(PL5)) + int_PL_TOT;
            ACT := ACT + 1;
        end if;
        if PL_ACT(6) = '1' then
            int_PL_TOT := to_integer(unsigned(PL6)) + int_PL_TOT;
            ACT := ACT + 1;
        end if;
        if PL_ACT(7) = '1' then
            int_PL_TOT := to_integer(unsigned(PL7)) + int_PL_TOT;
            ACT := ACT + 1;
        end if;
                    
        if ACT > 0 then                 
            round := int_PL_TOT mod ACT;
            if round > 3 then
                int_SUM := int_PL_TOT / ACT + 1;
            else
                int_SUM := int_PL_TOT / ACT;
            end if;
        else
            int_SUM := 2048;
        end if;
            
        SUM <= std_logic_vector(to_unsigned(int_SUM, 12));
        
    end process;
end Behavioral;
