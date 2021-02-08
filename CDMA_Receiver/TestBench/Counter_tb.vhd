library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE ieee.std_logic_unsigned.all;
use IEEE.NUMERIC_STD.all;

entity Counter_tb is
	end Counter_tb;
	
architecture beh of Counter_tb is
	
	constant clk_period	: time	:= 100 ns;
	constant Nbit_c	:positive	:= 5;
	
	component Counter
	generic (
		Nbit_c : positive := 5
		);
	port (
		a_c : in std_logic_vector (Nbit_c-1 downto 0) ;
		b_c : out std_logic_vector(Nbit_c-1 downto 0) ;
		cin_c : in std_logic;
		reset_c : in std_logic;
		clk_c : in std_logic;
		cout_c : out std_logic;
		start_c : in std_logic
		);
	end component;
	
	signal a_ext	: std_logic_vector (Nbit_c-1 downto 0) := (others => '0');
	signal b_ext	: std_logic_vector (Nbit_c-1 downto 0) := (others => '0');
	signal cin_ext	: std_logic := '0';
	signal reset_ext	:std_logic := '0';
	signal clk_ext	: std_logic := '0';
	signal cout_ext	:std_logic;
	signal start_c_ext: std_logic:='0';
	signal testing	: boolean := true;
	
	begin
		clk_ext <= not clk_ext after clk_period/2 when testing else '0';
		
		dut: Counter
		generic map (
			Nbit_c => Nbit_c
			)
		port map(
			a_c => a_ext,
			b_c => b_ext,
			cin_c => cin_ext,
			reset_c => reset_ext,
			clk_c => clk_ext,
			cout_c => cout_ext,
			start_c => start_c_ext
			);
			
		stimulus : process
			begin
				start_c_ext <= '1';
				a_ext <= (others => '0');
				reset_ext <= '0';
				wait for 250 ns;
				a_ext <= "00110";
				reset_ext <= '1';
				cin_ext <= '1';
				wait for 800 ns;
				a_ext <= "01110";
				reset_ext <= '0';
				cin_ext <= '0';
				wait for 400 ns;
				a_ext <= "01010";
				reset_ext <= '0';
				cin_ext <= '1';
				wait for 400 ns;
				a_ext <= "11001";
				reset_ext <= '0';
				cin_ext <= '0';
				wait for 1008 ns;
				a_ext <= "00110";
				reset_ext <= '1';
				cin_ext <= '1';
				wait for 500 ns;
				testing <= false;
		end process;
	end beh;				