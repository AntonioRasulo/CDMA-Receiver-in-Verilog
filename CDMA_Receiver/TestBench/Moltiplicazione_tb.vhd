library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE ieee.std_logic_unsigned.all;
use IEEE.NUMERIC_STD.all;

entity Moltiplicazione_tb is
	end Moltiplicazione_tb;
	
architecture beh of Moltiplicazione_tb is
	
	constant clk_period	: time	:= 100 ns;
	constant Nbit	:positive	:= 2;								
			
	
	component Moltiplicazione
	generic (
		Nbit	:positive	:=2
		);
	port (
		clk_m		: in std_logic;
		l_m		: in std_logic_vector (Nbit downto 0);
		m_m		: in std_logic_vector (Nbit downto 0);
		z_m		: out std_logic_vector(Nbit*2+1 downto 0);
		reset_m : in std_logic
		);
	end component;
	
	signal l_m_ext	: std_logic_vector (Nbit downto 0):= (others => '0');
	signal m_m_ext	: std_logic_vector (Nbit downto 0):= (others => '0');
	signal z_m_ext	: std_logic_vector (Nbit*2+1 downto 0):= (others => '0');
	signal clk_m_ext	: std_logic := '0';
	signal reset_m_ext	:std_logic:='0';
	signal testing	: boolean := true;
	
	begin
		clk_m_ext <= not clk_m_ext after clk_period/2 when testing else '0';
		
		dut: Moltiplicazione
		generic map (
			Nbit => Nbit
			)
		port map(
			l_m => l_m_ext,
			m_m => m_m_ext,
			z_m => z_m_ext,
			clk_m => clk_m_ext,
			reset_m => reset_m_ext
			);
			
		stimulus : process
			begin
				
				l_m_ext <= (others => '0');
				m_m_ext <= (others => '0');
				wait for 250 ns;
				l_m_ext <= "010";
				m_m_ext <= "001";
				wait for 800 ns;
				l_m_ext <= "111";
				m_m_ext <= "001";
				wait for 1008 ns;
				l_m_ext <= "000";
				m_m_ext <= "010";
				wait for 500 ns;
				testing <= false;
		end process;
	end beh;