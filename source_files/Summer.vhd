----------------------------------------------------------------------------------
-- Company: Weber State University
-- Engineer: Thomas DuCourant
-- 
-- Create Date: 11/26/2024 02:03:39 PM
-- Design Name: Group Project Summer

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use work.extra_signals.all;

entity Summer is
    Port ( PL_array : in player_array;
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
            int_PL_TOT := to_integer(unsigned(PL_array(0))) + int_PL_TOT;
            ACT := ACT + 1;
        end if;
        if PL_ACT(1) = '1' then
            int_PL_TOT := to_integer(unsigned(PL_array(1))) + int_PL_TOT;
            ACT := ACT + 1;
        end if;
        if PL_ACT(2) = '1' then
            int_PL_TOT := to_integer(unsigned(PL_array(2))) + int_PL_TOT;
            ACT := ACT + 1;
        end if;
        if PL_ACT(3) = '1' then
            int_PL_TOT := to_integer(unsigned(PL_array(3))) + int_PL_TOT;
            ACT := ACT + 1;
        end if;
        if PL_ACT(4) = '1' then
            int_PL_TOT := to_integer(unsigned(PL_array(4))) + int_PL_TOT;
            ACT := ACT + 1;
        end if;
        if PL_ACT(5) = '1' then
            int_PL_TOT := to_integer(unsigned(PL_array(5))) + int_PL_TOT;
            ACT := ACT + 1;
        end if;
        if PL_ACT(6) = '1' then
            int_PL_TOT := to_integer(unsigned(PL_array(6))) + int_PL_TOT;
            ACT := ACT + 1;
        end if;
        if PL_ACT(7) = '1' then
            int_PL_TOT := to_integer(unsigned(PL_array(7))) + int_PL_TOT;
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