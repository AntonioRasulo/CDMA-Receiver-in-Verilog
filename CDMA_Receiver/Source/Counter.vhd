library IEEE;
use IEEE.std_logic_1164.all;

entity Counter is											--Descrizione dell'architettura del contatore
	generic (Nbit_c : positive:= 6);
	port (
		a_c : in std_logic_vector (Nbit_c-1 downto 0) ;		-- Vettore in ingresso al contatore, si vuole ottenere la somma dei suoi elementi
		b_c : out std_logic_vector(Nbit_c-1 downto 0) ; 	-- Vettore in uscita al contatore che contiene i risultati delle somme
		cin_c : in std_logic;								-- Carry in in ingresso al contatore
		reset_c : in std_logic;								-- Porta per il reset del contatore
		clk_c : in std_logic;								-- Porta per il segnale di clock	
		cout_c : out std_logic								-- Carry out in uscita al contatore
	);
end Counter;

architecture Struct of Counter is
	signal s_s :std_logic_vector(Nbit_c-1 downto 0):=(others => '0');	-- Segnale usato per collegare l'uscita del ripple carry adder all'ingresso del registro
	signal q_s :std_logic_vector(Nbit_c-1 downto 0):=(others => '0');	-- Segnale usato per collegare l'uscita del registro ad uno dei due ingressi del ripple carry adder
	
	component RippleCarryAdder										-- Richiamo del componente ripple carry adder
		generic (Nbit : positive:= 6) ;
		port (														
			a_rca : in std_logic_vector(Nbit-1 downto 0) ;			-- Porta di ingresso per uno dei due operandi della somma
			b_rca : in std_logic_vector(Nbit-1 downto 0) ;			-- Porta di ingresso per uno dei due operandi della somma
			cin_rca : in std_logic ;								-- Porta per il carry in del ripple carry adder
			s_rca : out std_logic_vector (Nbit-1 downto 0) ;		-- Porta di uscita per il risultato della somma
			cout_rca : out std_logic;								-- Porta per il carry out del ripple carry adder
			reset_rca: in std_logic									-- Porta di ingresso per il reset
		);
	end component;
	
	component DFC													-- Richiamo del componente DFC
		generic (Nbit : positive:=6);
		port (
			clk_d : in std_logic ;
			reset_d : in std_logic ;
			d_d : in std_logic_vector(Nbit-1 downto 0) ;
			q_d : out std_logic_vector(Nbit-1 downto 0)
		);
	end component;
	
	begin
	
		
			i_RCA: RippleCarryAdder
				generic map(Nbit=>Nbit_c)
				port map(
					a_rca => a_c,
					b_rca => q_s,
					cin_rca => cin_c,
					s_rca => s_s,
					cout_rca => cout_c,
					reset_rca => reset_c
				);
	
			i_DFC: DFC
				generic map(Nbit=>Nbit_c)
				port map(
					clk_d => clk_c,
					reset_d => reset_c,
					d_d => s_s,
					q_d => q_s
				);
			b_c <= q_s;
		
	
	end Struct;
	