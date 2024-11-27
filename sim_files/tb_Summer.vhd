library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity tb_Summer is
    -- No ports in a testbench
end tb_Summer;

architecture Behavioral of tb_Summer is

    -- Component declaration for the Unit Under Test (UUT)
    component Summer
        Port ( 
            PL0 : in STD_LOGIC_VECTOR (11 downto 0);
            PL1 : in STD_LOGIC_VECTOR (11 downto 0);
            PL2 : in STD_LOGIC_VECTOR (11 downto 0);
            PL3 : in STD_LOGIC_VECTOR (11 downto 0);
            PL4 : in STD_LOGIC_VECTOR (11 downto 0);
            PL5 : in STD_LOGIC_VECTOR (11 downto 0);
            PL6 : in STD_LOGIC_VECTOR (11 downto 0);
            PL7 : in STD_LOGIC_VECTOR (11 downto 0);
            PL_ACT : in STD_LOGIC_VECTOR (7 downto 0);
            CLK : in STD_LOGIC;
            SUM : out STD_LOGIC_VECTOR (11 downto 0)
        );
    end component;

    -- Signals for UUT inputs and outputs
    signal PL0, PL1, PL2, PL3, PL4, PL5, PL6, PL7 : STD_LOGIC_VECTOR (11 downto 0);
    signal PL_ACT : STD_LOGIC_VECTOR (7 downto 0);
    signal CLK : STD_LOGIC := '0';
    signal SUM : STD_LOGIC_VECTOR (11 downto 0);

    -- Clock period constant
    constant CLK_PERIOD : time := 10 ns;

begin

    -- Instantiate the Unit Under Test (UUT)
    uut: Summer
        port map (
            PL0 => PL0,
            PL1 => PL1,
            PL2 => PL2,
            PL3 => PL3,
            PL4 => PL4,
            PL5 => PL5,
            PL6 => PL6,
            PL7 => PL7,
            PL_ACT => PL_ACT,
            CLK => CLK,
            SUM => SUM
        );

    -- Clock generation process
    clk_process : process
    begin
        while true loop
            CLK <= '0';
            wait for CLK_PERIOD / 2;
            CLK <= '1';
            wait for CLK_PERIOD / 2;
        end loop;
    end process;

    -- Stimulus process to apply test cases
    stim_proc: process
    begin
        -- Test case 1: All inactive
        PL0 <= (others => '0');
        PL1 <= (others => '0');
        PL2 <= (others => '0');
        PL3 <= (others => '0');
        PL4 <= (others => '0');
        PL5 <= (others => '0');
        PL6 <= (others => '0');
        PL7 <= (others => '0');
        PL_ACT <= (others => '0');
        wait for 20 ns;

        -- Test case 2: One active input
        PL0 <= std_logic_vector(to_unsigned(100, 12));
        PL_ACT <= "00000001"; -- Activate only PL0
        wait for 20 ns;

        -- Test case 3: Two active inputs
        PL1 <= std_logic_vector(to_unsigned(200, 12));
        PL_ACT <= "00000011"; -- Activate PL0 and PL1
        wait for 20 ns;

        -- Test case 4: All active inputs
        PL2 <= std_logic_vector(to_unsigned(300, 12));
        PL3 <= std_logic_vector(to_unsigned(400, 12));
        PL4 <= std_logic_vector(to_unsigned(500, 12));
        PL5 <= std_logic_vector(to_unsigned(600, 12));
        PL6 <= std_logic_vector(to_unsigned(700, 12));
        PL7 <= std_logic_vector(to_unsigned(800, 12));
        PL_ACT <= "11111111"; -- Activate all inputs
        wait for 20 ns;

        -- Test case 5: Edge rounding
        PL0 <= std_logic_vector(to_unsigned(5, 12));
        PL1 <= std_logic_vector(to_unsigned(5, 12));
        PL2 <= std_logic_vector(to_unsigned(5, 12));
        PL_ACT <= "00000111"; -- Activate PL0, PL1, PL2
        wait for 20 ns;

        -- Stop simulation
        wait;
    end process;

end Behavioral;

