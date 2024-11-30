library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Transmitter_tb is
    -- No ports for a test bench
end Transmitter_tb;

architecture Behavioral of Transmitter_tb is

    -- Component Declaration for the Transmitter
    component Transmitter is
        Port ( SUM_TX : in STD_LOGIC_VECTOR (11 downto 0);
               RST_TX: in STD_LOGIC;
               CLK_TX : in STD_LOGIC;
               LOAD_TX : in STD_LOGIC;
               BUSY_TX : out STD_LOGIC;
               SCLK_TX : out STD_LOGIC;
               DOUT_TX : out STD_LOGIC;
               SYNC_TX : out STD_LOGIC);
    end component Transmitter;

    -- Testbench Signals
    signal SUM_DA2_TB : STD_LOGIC_VECTOR (11 downto 0);
    signal RST_DA2_TB: STD_LOGIC;
    signal CLK_DA2_TB : STD_LOGIC := '0';
    signal SCLK_DA2_TB : STD_LOGIC;
    signal DINA_DA2_TB : STD_LOGIC;
    signal SYNC_DA2_TB : STD_LOGIC;
    signal LOAD_DA2_TB : STD_LOGIC;
    signal BUSY_DA2_TB : STD_LOGIC;


begin

    -- Instantiate the Unit Under Test (UUT)
    UUT: Transmitter
        Port map (
            SUM_TX => SUM_DA2_TB,
            RST_TX => RST_DA2_TB,
            CLK_TX => CLK_DA2_TB,
            LOAD_TX => LOAD_DA2_TB,
            BUSY_TX => BUSY_DA2_TB,
            SCLK_TX => SCLK_DA2_TB,
            DOUT_TX => DINA_DA2_TB,
            SYNC_TX => SYNC_DA2_TB
        );

CLK_DA2_TB <= NOT(CLK_DA2_TB) after 2 ns;


process begin
    --RESET
    RST_DA2_TB <= '1';
        wait for 10 ns;
    RST_DA2_TB <= '0';
    LOAD_DA2_TB <= SCLK_DA2_TB;
        wait for 100 ns;
    SUM_DA2_TB <= x"f3a";
    LOAD_DA2_TB <= '0';
        wait for 203000 ns;
    SUM_DA2_TB <= x"aab";
        wait for 203000 ns;
        LOAD_DA2_TB <= '1';
        wait for 406000 ns;
end process;

end Behavioral;

