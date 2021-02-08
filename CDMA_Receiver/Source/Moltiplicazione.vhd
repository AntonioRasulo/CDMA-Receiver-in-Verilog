library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;			-- Questa libreria mi consente di fare il prodotto fra vettori
use ieee.std_logic_unsigned.all;

entity Moltiplicazione is
	generic (Nbit : positive:= 3);
	port (
		clk_m		: in std_logic;
		l_m		: in std_logic_vector (Nbit-1 downto 0);
		m_m		: in std_logic_vector (Nbit-1 downto 0);
		z_m		: out std_logic_vector((Nbit-1)*2+1 downto 0);
		reset_m : in std_logic
		);
end Moltiplicazione;

architecture rtl of Moltiplicazione is
begin

	Moltiplicazione_p: process(clk_m,reset_m)							-- Se clk_m e/o reset_m cambiano allora il process viene attivato
	--variable product	: std_logic_vector((Nbit-1)*2+1 downto 0);			
	begin
		if (reset_m= '1') then											-- Se reset_m è pari a '1' l'uscita del moltiplicatore è '0'
		
			z_m<=(others=>'0');									
		
		elsif (clk_m'event and clk_m='1') then		-- altrimenti se c'è un fronte di salita del clock
			
															
				z_m<=l_m*m_m;						-- l' uscita è il prodotto dei vettori in ingresso
		end if;
	end process Moltiplicazione_p;
	

end rtl;