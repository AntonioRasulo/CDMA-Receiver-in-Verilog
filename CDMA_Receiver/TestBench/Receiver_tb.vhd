library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE ieee.std_logic_unsigned.all;
use IEEE.NUMERIC_STD.all;

entity Receiver_tb is
	end Receiver_tb;
	
architecture beh of Receiver_tb is
	
	constant clk_period	: time	:= 100 ns;
	constant Nbit	:positive	:= 3;
	constant Nbit_c	:positive	:= 6;
	
	component Receiver
	generic (
			Nbit : positive:= 3;								
			Nbit_c: positive:=6
		);
	port (
		codeword : in std_logic_vector(Nbit-1 downto 0);
		bitstream : out std_logic_vector(Nbit-1 downto 0);
		chipstream : in std_logic_vector(Nbit-1 downto 0);
		reset_r : in std_logic;
		clk_r : in std_logic
		);
	end component;
	
	signal codeword_ext	: std_logic_vector(Nbit-1 downto 0) :=(others => '0');
	signal bitstream_ext	: std_logic_vector(Nbit-1 downto 0) :=(others => '0');
	signal chipstream_ext	: std_logic_vector(Nbit-1 downto 0) :=(others => '0');
	signal reset_ext	:std_logic:='0';
	signal clk_ext	: std_logic:='0';
	signal testing	: boolean := true;
	
	begin
		clk_ext <= not clk_ext after clk_period/2 when testing else '0';
		
		dut: Receiver
		generic map (
			Nbit_c => Nbit_c,
			Nbit => Nbit
			)
		port map(
			codeword => codeword_ext,
			bitstream => bitstream_ext,
			chipstream => chipstream_ext,
			reset_r => reset_ext,
			clk_r => clk_ext
			);
			
		stimulus : process
			begin
				
				reset_ext <= '1';
				wait until rising_edge(clk_ext);
				reset_ext <= '0';
				wait until rising_edge(clk_ext);
				codeword_ext <= "011";
				chipstream_ext <= "001";
				wait until rising_edge(clk_ext);
				codeword_ext <= "001";
				chipstream_ext <= "001";
				wait until rising_edge(clk_ext);
				codeword_ext <= "011";
				chipstream_ext <= "001";
				wait until rising_edge(clk_ext);
				codeword_ext <= "001";
				chipstream_ext <= "001";
				wait until rising_edge(clk_ext);
				codeword_ext <= "011";
				chipstream_ext <= "001";
				wait until rising_edge(clk_ext);
				codeword_ext <= "011";
				chipstream_ext <= "001";
				wait until rising_edge(clk_ext);
				codeword_ext <= "001";
				chipstream_ext <= "001";
				wait until rising_edge(clk_ext);
				codeword_ext <= "001";
				chipstream_ext <= "001";
				wait until rising_edge(clk_ext);
				codeword_ext <= "011";
				chipstream_ext <= "001";
				wait until rising_edge(clk_ext);
				codeword_ext <= "011";
				chipstream_ext <= "001";
				wait until rising_edge(clk_ext);
				codeword_ext <= "011";
				chipstream_ext <= "001";
				wait until rising_edge(clk_ext);
				codeword_ext <= "001";
				chipstream_ext <= "001";
				wait until rising_edge(clk_ext);
				codeword_ext <= "001";
				chipstream_ext <= "001";
				wait until rising_edge(clk_ext);
				codeword_ext <= "001";
				chipstream_ext <= "001";
				wait until rising_edge(clk_ext);
				codeword_ext <= "001";
				chipstream_ext <= "001";
				wait until rising_edge(clk_ext);
				codeword_ext <= "011";
				chipstream_ext <= "001";
				wait for 1200 ns;
				testing <= false;
		end process;
	end beh;				