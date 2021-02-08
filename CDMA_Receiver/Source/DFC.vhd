library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.NUMERIC_STD.all;

entity DFC is																-- Descrizione dell'architettura del registro
	generic (Nbit : positive := 3) ; 
	port (														
		clk_d		: in std_logic;											-- Porta di ingresso per il clock
		reset_d	: in std_logic;												-- Porta di ingresso per il reset
		d_d		: in std_logic_vector (Nbit-1 downto 0) ;					-- Porta di ingresso per il dato informativo
		q_d		: out std_logic_vector (Nbit-1 downto 0):= (others => '0')	-- Porta di uscita per il dato informativo
		);
end DFC;

architecture rtl of DFC is

begin

	dfc_p: process(reset_d, clk_d)											-- Se clk_d e/o reset_d cambia il processo viene attivato
	begin
		if reset_d='1' then													-- Se il reset_d è pari a '1' l'uscita del registro è il vettore nullo
			q_d <= ( others => '0' );								
		elsif (clk_d'event and clk_d='1') then				-- altrimenti se c'è stato un fronte di salita del clock
																			-- porta l'ingresso in uscita
				q_d <= d_d;
			
		end if;
	end process dfc_p;

end rtl;