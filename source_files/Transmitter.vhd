

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Transmitter is
    Port ( SUM : in STD_LOGIC_VECTOR (11 downto 0);
           CLK : in STD_LOGIC;
           SCK : out STD_LOGIC;
           BUSY : out STD_LOGIC;
           S_OUT : out STD_LOGIC);
end Transmitter;

architecture Behavioral of Transmitter is

    type Tstate is (
        IDLE,
        START,
        TRANSMIT);

    signal count : integer := 0;
    signal sclk_count : integer;
    signal state : Tstate := IDLE;
    signal SCLK : STD_LOGIC := '0';
    signal SUM1: STD_LOGIC_VECTOR(11 downto 0);
    
    
begin
    process(CLK)
    begin
        if rising_edge(CLK) then
            if count < 1 then
                count <= count + 1;
            else
                count <= 0;
                SCLK <= NOT SCLK;
                SCK <= SCLK;
            end if;
        end if;
    end process;
    
    process(SCLK, CLK)
    begin
        if falling_edge(SCLK) then 
            case state is
                when IDLE =>
                    SUM1 <= SUM;
                    BUSY <= '1';
                    S_OUT <= '0';
                    sclk_count <= 0;
                    state <= START;
                when START =>
                    BUSY <= '0';
                    if sclk_count < 4 then
                        S_OUT <= '0';
                        sclk_count <= sclk_count + 1;
                    else
                        S_OUT <= SUM1(sclk_count + 7);
                        sclk_count <= sclk_count - 1;
                        state <= TRANSMIT;
                    end if;
                when TRANSMIT =>
                    if sclk_count >= -7 then
                        S_OUT <= SUM1(sclk_count + 7);
                        sclk_count <= sclk_count - 1;
                    else
                        BUSY <= '1';
                        sclk_count <= 0;
                        SUM1 <= SUM;
                        S_OUT <= '0';
                        state <= START;
                    end if;
               end case;
          end if;
     end process;

end Behavioral;