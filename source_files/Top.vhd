----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/27/2024 02:45:54 PM
-- Design Name: 
-- Module Name: Top - Behavioral
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
use work.extra_signals.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Top is
    Port ( S_OUT : out STD_LOGIC;
           SYNC : out STD_LOGIC;
           SCLK : out STD_LOGIC;
           LED : out STD_LOGIC_VECTOR (7 downto 0);
           LED2 : out STD_LOGIC_VECTOR (7 downto 0);
           CLK : in STD_LOGIC;
           RST : in STD_LOGIC;
           S_IN : in STD_LOGIC;
           SER_OUT : out STD_LOGIC);
end Top;

architecture Behavioral of Top is

    component MIDI_LOGIC is
        Port ( CLK : in STD_LOGIC;
               RST : in STD_LOGIC;
               RX_RDY : in STD_LOGIC;
               RX_PDATA : in STD_LOGIC_VECTOR (7 downto 0);
               CHANNELS : out channels_array;
               WAIT_COUNTS : out wait_counts_array;
               VELOCITIES : out velocities_array;
               DECAYS : out decays_array;
               state : out std_logic_vector (7 downto 0);
               PLAYER_ENS : out STD_LOGIC_VECTOR (PLAYER_COUNT - 1 downto 0));
    end component;
    
    component UART_RX is
    Port ( sdata_rx : in STD_LOGIC;
           rst_rx : in STD_LOGIC;
           clk_rx : in STD_LOGIC;
           ready : out STD_LOGIC;
           pdata_rx : out STD_LOGIC_VECTOR (7 downto 0));
    end component;
    
    component UART_TX is
        Port ( CLK : in STD_LOGIC;
               PDATA : in STD_LOGIC_VECTOR (7 downto 0);
               LOAD : in STD_LOGIC;
               BUSY : out STD_LOGIC;
               DONE : out STD_LOGIC;
               SDATA : out STD_LOGIC);
    end component;
    
    component Summer is
    Port ( PL_array : in player_array;
           PL_ACT : in STD_LOGIC_VECTOR (7 downto 0);
           CLK : in STD_LOGIC;
           SUM : out STD_LOGIC_VECTOR (11 downto 0));
    end component;
    
    component Transmitter is
        Port ( SUM_TX : in STD_LOGIC_VECTOR (11 downto 0);
               RST_TX: in STD_LOGIC;
               CLK_TX : in STD_LOGIC;
               LOAD_TX : in STD_LOGIC;
               SCLK_TX : out STD_LOGIC;
               DOUT_TX : out STD_LOGIC;
               SYNC_TX : out STD_LOGIC);
    end component Transmitter;
    
    component Player is
        Port ( NOTE_PL : in STD_LOGIC_VECTOR (15 downto 0);
               CLK_PL : in STD_LOGIC;
               RST_PL : in STD_LOGIC;
               PLAY_PL : in STD_LOGIC;
               TONE_PL : in STD_LOGIC_VECTOR (1 downto 0);
               WAVE_O_PL : out STD_LOGIC_VECTOR (11 downto 0));
    end component;
    
    component Velocity is
    Port ( WAVE_IN_V : in STD_LOGIC_VECTOR (11 downto 0);
           VELOCITY_V : in STD_LOGIC_VECTOR (6 downto 0);
           PLY_ACT_V: in STD_LOGIC;
           CLK_V : in STD_LOGIC;
           WAVE_OUT_V : out STD_LOGIC_VECTOR (11 downto 0)
           );        
    end component Velocity;
    
    component Decay is
    Port ( PLAY_D : in STD_LOGIC;
           CLK_D : in STD_LOGIC;
           RST_D : in STD_LOGIC;
           DECAY_CONTROL: in STD_LOGIC_VECTOR (6 downto 0);
           WAVE_IN_D : in STD_LOGIC_VECTOR (11 downto 0);
           PLY_ACT_D : out STD_LOGIC;
           WAVE_OUT_D : out STD_LOGIC_VECTOR (11 downto 0);
           DEC_TEST_OUT: out STD_LOGIC_VECTOR (6 downto 0));
    end component Decay;

    
    signal state_ntrl : STD_LOGIC_VECTOR (7 downto 0);
    
    signal SUM_ntrl : STD_LOGIC_VECTOR (11 downto 0);
    signal RDY_ntrl : STD_LOGIC;
    signal PDATA_ntrl : STD_LOGIC_VECTOR (7 downto 0);

    signal PL_ACT_ntrl : STD_LOGIC_VECTOR (PLAYER_COUNT - 1 downto 0) := (others => '0');
    signal PL_array_ntrl : player_array := (others => (others => '0'));
    signal VEL_array_ntrl : player_array := (others => (others => '0'));
    signal DEC_array_ntrl : player_array := (others => (others => '0'));

    signal wait_counts_ntrl : wait_counts_array := (others => (others => '0'));
    signal channels_ntrl : channels_array := (others => (others => '0'));
    signal velocities_ntrl : velocities_array := (others => (others => '0'));
    signal decays_ntrl : decays_array := (others => (others => '0'));
    signal player_ens_ntrl : std_logic_vector (PLAYER_COUNT - 1 downto 0) := (others => '0');
    
    signal decays_test : decays_array := (others => (others => '0'));
    
    constant max_decay : decays_array := (others => (others => '1'));
    
begin

    SUMMER_INST : Summer port map (
        SUM => SUM_ntrl,
        CLK => CLK,
        PL_ACT => PL_ACT_ntrl,
        PL_array => PL_array_ntrl);
        
    TRANSMITTER_INST : Transmitter port map (
        SUM_TX => SUM_ntrl,
        RST_TX => RST,
        CLK_TX => CLK,
        LOAD_TX => '1',
        SCLK_TX => SCLK,
        DOUT_TX => S_OUT,
        SYNC_TX => SYNC);
        
    MIDI_RX_INST : UART_RX port map (
        clk_rx => CLK,
        rst_rx => RST,
        sdata_rx => S_IN,
        ready => RDY_ntrl,
        pdata_rx => PDATA_ntrl);
        
    MIDI_LOGIC_INST : MIDI_LOGIC port map (
        CLK => CLK,
        RST => RST,
        RX_RDY => RDY_ntrl,
        RX_PDATA => PDATA_ntrl,
        CHANNELS => channels_ntrl,
        WAIT_COUNTS => wait_counts_ntrl,
        VELOCITIES => velocities_ntrl,
        PLAYER_ENS => player_ens_ntrl,
        DECAYS => decays_ntrl,
        STATE => state_ntrl);
        
    player_gen: for i in 0 to PLAYER_COUNT - 1 generate
        PL: component Player port map(
            note_pl => wait_counts_ntrl(i),
            clk_pl => CLK,
            rst_pl => RST,
            play_pl => player_ens_ntrl(i),
            tone_pl => channels_ntrl(i),
            wave_o_pl => pl_array_ntrl(i));
    end generate player_gen;
    
    velocity_gen: for i in 0 to PLAYER_COUNT - 1 generate
        VEL: component velocity port map(
           WAVE_IN_V => pl_array_ntrl(i),
           VELOCITY_V => velocities_ntrl(i),
           PLY_ACT_V => player_ens_ntrl(i),
           CLK_V => CLK,
           WAVE_OUT_V => VEL_array_ntrl(i));
    end generate velocity_gen;
    
    decay_gen: for i in 0 to PLAYER_COUNT - 1 generate
        DEC: component decay port map(
           PLAY_D => player_ens_ntrl(i),
           CLK_D => CLK,
           RST_D => RST,
           DECAY_CONTROL => max_decay(i),
           WAVE_IN_D => VEL_array_ntrl(i),
           PLY_ACT_D => PL_ACT_ntrl(i),
           WAVE_OUT_D => DEC_array_ntrl(i),
           DEC_TEST_OUT => decays_test(i));
    end generate decay_gen;

    uart_tx_inst: UART_TX port map (
        CLK => CLK,
        PDATA => PDATA_ntrl,
        LOAD => RDY_ntrl,
        SDATA => SER_OUT);

    LED <= PL_ACT_ntrl;
    LED2 <= player_ens_ntrl;
end Behavioral;
