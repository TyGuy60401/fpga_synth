----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/23/2024 08:06:58 PM
-- Design Name: 
-- Module Name: UART_TX - Behavioral
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

entity UART_TX is
    Port ( CLK : in STD_LOGIC;
           PDATA : in STD_LOGIC_VECTOR (7 downto 0);
           LOAD : in STD_LOGIC;
           BUSY : out STD_LOGIC;
           DONE : out STD_LOGIC;
           SDATA : out STD_LOGIC);
end UART_TX;

architecture Behavioral of UART_TX is
    type Tstate is (
        idle,
        start,
        wait_baud,
        send_data,
        stop
    );

    signal state: Tstate := idle;

    signal baud_count : integer := 0;
    constant wait_cycles : integer := 3200;

    signal in_data : std_logic_vector (7 downto 0) := "00000000";
    signal data_index : integer := 0;
begin
    process (CLK)
    begin
        if rising_edge(CLK) then
            case state is
                when idle =>
                    baud_count <= 0;
                    in_data <= PDATA;
                    DONE <= '0';
                    BUSY <= '0';
                    SDATA <= '1';
                    if LOAD = '1' then
                        state <= start;
                    end if;
                when start =>
                    SDATA <= '0';
                    state <= wait_baud;
                    BUSY <= '1';
                when wait_baud =>
                    if baud_count < wait_cycles then
                        baud_count <= baud_count + 1;
                    else
                        baud_count <= 0;
                        state <= send_data;
                    end if;
                when send_data =>
                    if data_index < 8 then
                        SDATA <= in_data(data_index);
                        state <= wait_baud;
                        data_index <= data_index + 1;
                    else
                        state <= stop;
                        data_index <= 0;
                    end if;
                when stop =>
                    SDATA <= '1';
                    if baud_count < wait_cycles then
                        baud_count <= baud_count + 1;
                    else
                        baud_count <= 0;
                        state <= idle;
                    end if;
            end case;
        end if;
    end process;
end Behavioral;
