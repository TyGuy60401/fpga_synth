library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Transmitter_tb is
    -- No ports for a test bench
end Transmitter_tb;

architecture Behavioral of Transmitter_tb is

    -- Component Declaration for the Transmitter
    component Transmitter is
        Port (
            SUM : in STD_LOGIC_VECTOR (11 downto 0);
            CLK : in STD_LOGIC;
            SCK : out STD_LOGIC;
            BUSY : out STD_LOGIC;
            S_OUT : out STD_LOGIC
        );
    end component;

    -- Testbench Signals
    signal SUM_tb : STD_LOGIC_VECTOR(11 downto 0) := (others => '0');
    signal CLK_tb : STD_LOGIC := '0';
    signal SCK_tb : STD_LOGIC;
    signal BUSY_tb : STD_LOGIC;
    signal S_OUT_tb : STD_LOGIC;

    -- Clock Period Constants
    constant CLK_PERIOD : time := 10 ns;  -- 100 MHz clock

begin

    -- Instantiate the Unit Under Test (UUT)
    UUT: Transmitter
        Port map (
            SUM => SUM_tb,
            CLK => CLK_tb,
            SCK => SCK_tb,
            BUSY => BUSY_tb,
            S_OUT => S_OUT_tb
        );

    -- Clock Generation Process
    clk_process : process
    begin
        while True loop
            CLK_tb <= '0';
            wait for CLK_PERIOD / 2;  -- Low phase of the clock
            CLK_tb <= '1';
            wait for CLK_PERIOD / 2;  -- High phase of the clock
        end loop;
    end process;

    -- Stimulus Process
    stim_process : process
    begin
        -- Wait for initial stabilization
        wait for 100 ns;

        -- Test Case 1: Transmit a basic value
        SUM_tb <= "101010101010";  -- Example 12-bit value
        wait for 1000 ns;

        -- Test Case 2: Transmit all zeros
        SUM_tb <= (others => '0');
        wait for 1000 ns;

        -- Test Case 3: Transmit all ones
        SUM_tb <= (others => '1');
        wait for 1000 ns;

        -- Test Case 4: Transmit a specific pattern
        SUM_tb <= "111100001111";
        wait for 1000 ns;

        -- End simulation
        wait;
    end process;

end Behavioral;

