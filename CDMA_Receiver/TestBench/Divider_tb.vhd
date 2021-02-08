library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE ieee.std_logic_unsigned.all;
use IEEE.NUMERIC_STD.all;

entity Divider_tb is
	end Divider_tb;
	
architecture beh of Divider_tb is
	
	constant clk_period	: time	:= 100 ns;
	constant Nbit_c	:positive	:= 10;
	constant Nbit	:positive	:= 10;								
			
	
	component Divider
	generic (
		Nbit_c	:positive	:=10;
		Nbit	:positive	:=10
		);
	port (
		dividendo: in std_logic_vector (Nbit_c-1 downto 0);
		quoziente: out std_logic_vector (Nbit-1 downto 0);
		clk_div: in std_logic;
		start_div: in std_logic
		);
	end component;
	
	signal dividendo_ext	: std_logic_vector (Nbit_c-1 downto 0);
	signal quoziente_ext	: std_logic_vector (Nbit-1 downto 0):= (others => '0');
	signal clk_ext	: std_logic := '0';
	signal start_div_ext: std_logic:='0';
	signal testing	: boolean := true;
	
	begin
		clk_ext <= not clk_ext after clk_period/2 when testing else '0';
		
		dut: Divider
		generic map (
			Nbit => Nbit,
			Nbit_c => Nbit_c
			)
		port map(
			dividendo => dividendo_ext,
			quoziente => quoziente_ext,
			clk_div => clk_ext,
			start_div => start_div_ext
			);
			
		stimulus : process
			begin
				start_div_ext <= '1';
				dividendo_ext <= (others => '0');
				wait for 250 ns;
				dividendo_ext <= "0000010000";
			--	start_div_ext <= '0';
				wait for 800 ns;
				dividendo_ext <= "0000100000";
				wait for 500 ns;				
				dividendo_ext <= "0001000000";
				wait until rising_edge(clk_ext);
			--	start_div_ext <= '1';
				dividendo_ext <= "0010000000";
				wait for 1008 ns;
				dividendo_ext <= "0100000000";
				wait for 500 ns;
				testing <= false;
		end process;
	end beh;