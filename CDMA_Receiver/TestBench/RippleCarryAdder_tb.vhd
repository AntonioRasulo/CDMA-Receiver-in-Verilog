library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.std_logic_unsigned.all;
use IEEE.NUMERIC_STD.all;

entity RippleCarryAdder_tb is
	end RippleCarryAdder_tb;
	
architecture beh of RippleCarryAdder_tb is
	
	constant clk_period		: time		:= 100 ns;
	constant Nbit			: positive	:= 12;
	
	component RippleCarryAdder
	generic (
		Nbit : positive :=6
		);
	port (
		a_rca		: in std_logic_vector(Nbit-1 downto 0);
		b_rca	: in std_logic_vector(Nbit-1 downto 0);
		cin_rca	: in std_logic;
		s_rca		: out std_logic_vector(Nbit-1 downto 0);
		cout_rca	: out std_logic;
		reset_rca: in std_logic
		);
	end component;
	
	signal clk		: std_logic	:= '0';
	signal a_ext	: std_logic_vector(Nbit-1 downto 0) := (others => '0');
	signal b_ext	: std_logic_vector(Nbit-1 downto 0) := (others => '0');
	signal c_in_ext : std_logic := '0';
	signal s_ext	: std_logic_vector(Nbit-1 downto 0):= (others => '0');
	signal c_out_ext: std_logic;
	signal reset_ext: std_logic;
	signal clk_ext:std_logic:='0';
	signal testing	: boolean	:= true;
	
		begin
			clk_ext <= not clk_ext after clk_period/2 when testing else'0';
			
			dut:RippleCarryAdder
			generic map (
				Nbit => Nbit
				)
			port map(
				a_rca		=> a_ext,
				b_rca		=> b_ext,
				cin_rca		=> c_in_ext,
				s_rca		=> s_ext,
				cout_rca	=> c_out_ext,
				reset_rca	=> reset_ext
				);
			
			stimulus : process
				begin
					reset_ext <= '1';
					a_ext <= (others => '0');
					b_ext <= (others => '0');
					c_in_ext <= '0';
					wait for 200 ns;
					reset_ext <= '0';
					wait for 200 ns;
					a_ext <= "000000000110";
					b_ext <= "000000100110";
					c_in_ext <= '0';
					wait for 600 ns;
					a_ext <= "000000000000";
					b_ext <= "000000000000";
					c_in_ext <= '1';
					wait for 400 ns;
					a_ext <= (others => '0');
					b_ext <= (others => '0');
					c_in_ext <='0';
					wait for 1008 ns;
					a_ext <= "111111111111";
					b_ext <= "111111111111";
					c_in_ext <= '0';
					wait for 500 ns;
					testing <= false;
				end process;
				end beh;
		
		
		
		
		
		
		
		
		