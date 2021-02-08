library IEEE;
use IEEE.std_logic_1164.all;


entity RippleCarryAdder is										-- Descrizione dell'architettura del RippleCarryAdder
	generic (Nbit : positive:= 6);
	port (
		a_rca	: in std_logic_vector (Nbit-1 downto 0) ;		
		b_rca   : in std_logic_vector (Nbit-1 downto 0) ;
		cin_rca	: in std_logic ;
		s_rca	: out std_logic_vector(Nbit-1 downto 0);
		cout_rca: out std_logic;
		reset_rca: in std_logic
		);
end RippleCarryAdder;

architecture beh of RippleCarryAdder is
begin
	combinational_p: process(a_rca,b_rca,cin_rca,reset_rca) 		-- Il process viene attivato se uno o più degli elementi nella sensitivity list cambia
	variable c : std_logic_vector (Nbit+1 downto 0);				-- Definizione della variabile di supporto c
begin
	if (reset_rca='1') then										-- Se il reset vale '1' l'uscita del ripple carry adder viene impostata a '0'
		
		s_rca<=(others=>'0');
	
	else
		
			c(0) := cin_rca;									-- il bit meno significativo di c assume il valore del carry in
			for i in 0 to Nbit-1 loop							-- vengono usate le formule del ripple carry adder secondo cui 
				s_rca(i) <= a_rca(i) xor b_rca(i) xor c(i);		-- S(i)= P(i) xor C(i) dove P(i) = A(i) xor B(i)
				c(i+1) := (a_rca(i) and b_rca(i)) or (a_rca(i)and c(i)) or (b_rca(i) and c(i));		-- C(i+1)= A(i)and B(i) or A(i)and C(i) or B(i) and C(i)
			end loop;
			cout_rca <= c(Nbit);								-- il bit più significativo di c è il carry out del ripple carry adder
	
	end if;
	end process combinational_p;
end beh;