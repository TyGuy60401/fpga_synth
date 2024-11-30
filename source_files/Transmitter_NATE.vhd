

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Transmitter is
    Port ( SUM_TX : in STD_LOGIC_VECTOR (11 downto 0);
           RST_TX: in STD_LOGIC;
           CLK_TX : in STD_LOGIC;
           LOAD_TX : in STD_LOGIC;
           BUSY_TX : out STD_LOGIC;
           SCLK_TX : out STD_LOGIC;
           DOUT_TX : out STD_LOGIC;
           SYNC_TX : out STD_LOGIC);
end Transmitter;

architecture Behavioral of Transmitter is

    type state is (IDLE, START, TRANSMIT);
    signal curr_state: state;
    signal next_state: state;
    signal cnt: integer;
    signal slow_clock: std_logic;
    signal SUM_IN: std_logic_vector(11 downto 0);
    signal BUSY: std_logic;
    signal bits_sent: integer;
    signal index: integer;
    
begin

SCLK_TX <= slow_clock;
BUSY_TX <= BUSY;

-- SERIAL CLOCK FOR SCLK PORT
process (CLK_TX, RST_TX) begin
    curr_state <= next_state;
    if RST_TX = '1' then
        cnt <= 0;
        slow_clock <= '0';

    elsif rising_edge(CLK_TX) then
    
        case curr_state is
            when IDLE =>
                BUSY <= '0';
                if LOAD_TX = '1' and bits_sent < 17 then
                    next_state <= START;
                else
                    next_state <= IDLE;
                end if;
            when START =>
                BUSY <= '1';
                if bits_sent > 4 then
                    next_state <= TRANSMIT;
                else
                    next_state <= START;
                end if;
            when TRANSMIT =>
                BUSY <= '1';
                if bits_sent >= 17 then
                    next_state <= IDLE;
                else
                    next_state <= TRANSMIT;
                end if;
        end case;
        
        if cnt <= 4 then
            cnt <= cnt + 1;
            slow_clock <= slow_clock;
        else
            cnt <= 0;
            slow_clock <= NOT(slow_clock);            
        end if;
        
        if BUSY = '1' then
            SUM_IN <= SUM_IN;
            SYNC_TX <= '0';
            if curr_state = START then
                DOUT_TX <= '0';
            else
                DOUT_TX <= SUM_IN(index);
            end if;
        else
            SUM_IN(11 downto 0) <= SUM_TX;
            SYNC_TX <= '1';
            DOUT_TX <= '0';
        end if;
    end if;

end process;

process(slow_clock, RST_TX) begin
    if RST_TX = '1' then
        bits_sent <= 1;
        index <= 11;
    elsif rising_edge (slow_clock) then
            if bits_sent < 5 and BUSY = '1' then
                bits_sent <= bits_sent + 1;
            elsif bits_sent < 17 and BUSY = '1' then
                bits_sent <= bits_sent + 1;
                
                if index > 0  then
                    index <= index - 1;
                else
                    index <= 0;
                end if;
            else
                index <= 11;
                bits_sent <= 1;
            end if;
    end if;
end process;

end Behavioral;