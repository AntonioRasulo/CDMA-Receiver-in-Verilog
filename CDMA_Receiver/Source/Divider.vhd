library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.NUMERIC_STD.all;
use ieee.std_logic_unsigned.all;

entity Divider is												
	generic (
			Nbit : positive:= 10;								
			Nbit_c: positive:=10
	);
	port (
		dividendo: in std_logic_vector (Nbit_c-1 downto 0);
		quoziente: out std_logic_vector (Nbit-1 downto 0);
		clk_div: in std_logic
	);
end Divider;

architecture beh of Divider is
	
	
	constant divisore: integer :=16;									-- Spreading factor

begin
	
	Divider_p: process(clk_div, dividendo)								-- Se clk_div e/o dividendo cambiano allora il process viene attivato
	variable input_div: integer;											-- Variabili usate nella divisione
	variable output_quo: integer;
	variable cont:integer:=0;											-- Contatore per il numero di cicli di clock
	begin
		
		if (clk_div'event and clk_div='1') then							-- In presenza di un fronte di clock positivo
			input_div := to_integer(unsigned(dividendo));				-- Dividendo viene convertito in un intero senza segno
			output_quo := input_div / divisore;							-- Si divide il valore del segnale in ingresso per lo spreading factor
			cont:=cont+1;												-- Il contatore incrementa
			if (cont=24) then				--Se ci sono stati 24 cicli di clock viene fornito il risultato della divisione in uscita
				quoziente <= std_logic_vector(to_unsigned(output_quo, quoziente'length));	
			else
				quoziente <= ( others=> '0');
			end if;
		end if;															
	end process Divider_p;
end beh;