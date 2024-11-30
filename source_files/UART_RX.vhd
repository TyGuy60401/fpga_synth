----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/09/2024 02:12:45 PM
-- Design Name: 
-- Module Name: UART_RX - Behavioral
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

entity UART_RX is
    Port ( sdata_rx : in STD_LOGIC;
           rst_rx : in STD_LOGIC;
           clk_rx : in STD_LOGIC;
           ready : out STD_LOGIC;
           pdata_rx : out STD_LOGIC_VECTOR (7 downto 0));
end UART_RX;

architecture Behavioral of UART_RX is

type state_type is (IDLE, START_READ, READ, OUTPUT);

signal curr_state: state_type;
signal next_state: state_type;
signal counter: integer;
signal bit_counter: integer;


begin

    -- State Transition Logic
    process(curr_state, sdata_rx, counter, bit_counter)
    begin
        
        case curr_state is
        
            -- Wait for a 0 to start recieving
            when IDLE =>
                if sdata_rx = '0' then
                    next_state <= START_READ;
                else
                    next_state <= IDLE;
                end if;
                
            -- Set offset for center read of baud cycle
            when START_READ =>
                if counter = 1600 then
                    next_state <= READ;
                else
                    next_state <= START_READ;
                end if;
            
            -- Wait to recieve 8 bits
            when READ =>
                if bit_counter = 9 then
                    next_state <= OUTPUT;
                else
                    next_state <= READ;
                end if;
                
            -- Read ready strobe to output read information
            when OUTPUT =>
                if sdata_rx = '1' then
                    next_state <= IDLE;
                end if;
                
            when others =>
                next_state <= IDLE;
                
        end case;
    end process;

    -- Sequential logic for each state
    process(clk_rx, rst_rx)
    begin
        if rst_rx = '1' then
            counter <= 0;
            bit_counter <= 0;
            curr_state <= IDLE;
            ready <= '0';
            pdata_rx <= (others => '0');
        elsif rising_edge(clk_rx) then
            curr_state <= next_state;

                -- Logic for the IDLE State
                if curr_state = IDLE then
                    counter <= 0;
                    bit_counter <= 0;
                    ready <= '0';
                
                -- Logic for the START_READ state
                -- Set clock with offset to read center of baud cycle
                elsif curr_state = START_READ then
                    if counter /= 1600 then
                        counter <= counter + 1;
                    else
                        counter <= 0;
                    end if;
                
                -- Logic for the READ state
                -- Increment bit counter 
                elsif curr_state = READ then
                    if counter /= 3200 then
                    
                        counter <= counter + 1;                     
                        if counter = 3199 and bit_counter < 8 then
                            pdata_rx(bit_counter) <= sdata_rx;
                        end if;
    
                    else
                        bit_counter <= bit_counter + 1;
                        counter <= 0;                  
                    end if;
                    
                elsif curr_state = OUTPUT then
                    ready <= '1';
                    
                end if;
        end if;
    end process;

end Behavioral;
