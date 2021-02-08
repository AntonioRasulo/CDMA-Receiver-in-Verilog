library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE ieee.std_logic_unsigned.all;
use IEEE.NUMERIC_STD.all;

entity DFC_tb is
	end DFC_tb;

architecture beh of DFC_tb is

	constant clk_period	: time	:= 100 ns;
	constant Nbit	:natural	:= 8;
	
	component DFC
	generic ( Nbit : natural := 8 );
		port (
			clk_d	: in std_logic;
			reset_d	: in std_logic;
			d_d		: in std_logic_vector (Nbit-1 downto 0);
			q_d		: out std_logic_vector (Nbit-1 downto 0);
			start_d : in std_logic
		);
	end component;
	
	signal clk_ext	: std_logic := '0';
	signal reset_ext	: std_logic := '0';
	signal d_ext	: std_logic_vector (Nbit-1 downto 0);
	signal q_ext	: std_logic_vector (Nbit-1 downto 0);
	signal start_d_ext: std_logic:='0';
	signal testing	: boolean := true;
	
	begin
		clk_ext <= not clk_ext after clk_period/2 when testing else '0';
		
		dut: DFC
		generic map (
			Nbit => Nbit
			)
		port map(
			clk_d => clk_ext,
			reset_d => reset_ext,
			d_d => d_ext,
			q_d => q_ext,
			start_d => start_d_ext
			);
			
			stimulus : process
				begin
				start_d_ext <= '1';
				d_ext <= (others => '0');
				reset_ext <= '0';
				wait for 200 ns;
				d_ext <= "00000110";
				reset_ext <= '0';
				wait until rising_edge(clk_ext);
				d_ext <= "00000110";
				reset_ext <= '1';
				wait for 1008 ns;
				d_ext <= (others => '0');
				reset_ext <= '1';
				wait for 500 ns;
				d_ext <= "00011110";
				reset_ext <= '0';
				wait for 500 ns;
				d_ext <= "00011110";
				reset_ext <= '1';
				wait for 500 ns;
				d_ext <= "00000000";
				reset_ext <= '0';
				wait until rising_edge(clk_ext);
				d_ext <= "11111111";
				reset_ext <= '0';
				wait for 500 ns;
				testing <= false;
			end process;
		end beh;