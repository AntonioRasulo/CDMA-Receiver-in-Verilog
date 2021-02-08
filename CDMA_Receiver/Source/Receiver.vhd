library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.NUMERIC_STD.all;
use IEEE.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity Receiver is						--Descrizione dell'architettura del ricevitore CDMA					
	generic (
			Nbit : positive:= 3;								
			Nbit_c: positive:=6
	);
	port (
		codeword : in std_logic_vector(Nbit-1 downto 0);		-- Porta di ingresso che riceve il segnale informativo
		bitstream : out std_logic_vector(Nbit-1 downto 0);		-- Porta di uscita che dice quale simbolo è stato ricevuto
		chipstream : in std_logic_vector(Nbit-1 downto 0);		-- È la parola di codice
		reset_r : in std_logic;			-- Porta di ingresso per il reset
		clk_r : in std_logic			-- Porta di ingresso per il clock
	);
end Receiver;

architecture Struct of Receiver is
	
	signal s_cin: std_logic:='0';							-- Segnale usato per mettere il carry di ingresso del counter a massa
	signal s_cout: std_logic:='0';							-- Segnale usato per mettere il carry di uscita del counter a massa
	signal s_qa: std_logic_vector (Nbit-1 downto 0);		-- Segnale usato per collegare l'uscita del registro DFCA all'ingresso del moltiplicatore	
	signal s_qb: std_logic_vector (Nbit-1 downto 0);		-- Segnale usato per collegare l'uscita del registro DFCB all'ingresso del moltiplicatore
	signal s_dc: std_logic_vector (Nbit_c-1 downto 0);		-- Segnale usato per collegare l'uscita del moltiplicatore all'ingresso del registro DFCC
	signal s_qc: std_logic_vector (Nbit_c-1 downto 0);		-- Segnale usato per collegare l'uscita del registro DFCC all'ingresso del contatore
	signal s_de: std_logic_vector (Nbit_c-1 downto 0);		-- Segnale usato per collegare l'uscita del contatore all'ingresso del registro DFCE
	signal s_qe: std_logic_vector(Nbit_c-1 downto 0);		-- Segnale usato per collegare l'uscita del registro DFCE all'ingresso del divisore
	signal s_dd: std_logic_vector (Nbit-1 downto 0);		-- Segnale usato per collegare l'uscita del divisore all'ingresso del registro DFCD
	signal s_qd: std_logic_vector (Nbit-1 downto 0);		-- Segnale in uscita al DFCD
	

	component Moltiplicazione								-- Richiamo del componente moltiplicazione
		generic (Nbit : positive:= 3);
		port (
			clk_m		: in std_logic;						-- Segnale di clock
			l_m		: in std_logic_vector (Nbit-1 downto 0);-- Operando della moltiplicazione
			m_m		: in std_logic_vector (Nbit-1 downto 0);-- Operando della moltiplicazione
			z_m		: out std_logic_vector((Nbit-1)*2+1 downto 0);-- Risultato della moltiplicazione
			reset_m	: in std_logic							-- Porta di ingresso reset
			);
	end component;

	component DFC											-- Richiamo del registro
		generic (Nbit : positive:=3);
		port (
			clk_d : in std_logic ;							-- Segnale di clock
			reset_d : in std_logic ;						-- Porta di ingresso reset
			d_d : in std_logic_vector(Nbit-1 downto 0) ;	-- Ingresso
			q_d : out std_logic_vector(Nbit-1 downto 0)		-- Uscita
		);
	end component;
	
	component Divider										-- Richiamo del componente Divider
		generic (
			Nbit : positive:=3;
			Nbit_c : positive:=6
		);
		port (
			dividendo: in std_logic_vector (Nbit_c-1 downto 0);	-- Operando della divisione
			quoziente: out std_logic_vector (Nbit-1 downto 0);	-- Risultato della divisione
			clk_div: in std_logic								-- Segnale di clock
		);
	end component;
	
	component Counter										-- Richiamo del componente Counter
		generic (Nbit_c :positive:=6);
		port (
			a_c : in std_logic_vector (Nbit_c-1 downto 0) ;	-- Ingresso del contatore
			b_c : out std_logic_vector(Nbit_c-1 downto 0) ;	-- Uscita del contatore
			cin_c : in std_logic;							-- Carry in del contatore
			reset_c : in std_logic;							-- Porta di ingresso reset
			clk_c : in std_logic;							-- Porta di ingresso per il clock
			cout_c : out std_logic							-- Carry out del contatore
		);
	end component;
	begin
				
				i_Moltiplicazione: Moltiplicazione			-- Definizione del blocco usato per la moltiplicazine
						generic map(Nbit=>Nbit)
						port map(							-- Definizione dei collegamenti
							clk_m => clk_r,					
							l_m => s_qa,					
							m_m => s_qb,					
							z_m => s_dc,			
							reset_m => reset_r				
						);
				
				i_DFCA: DFC									-- Definizione di uno dei due registri in ingresso al moltiplicatore
					generic map (Nbit=>Nbit)
					port map(								-- Definizione dei collegamenti
						d_d => codeword,						
						clk_d => clk_r,						
						reset_d => reset_r,					
						q_d => s_qa
					);
			
				i_DFCB: DFC									-- Definizione di uno dei due registri in ingresso al moltiplicatore
					generic map (Nbit=>Nbit)
					port map(								-- Definizione dei collegamenti
						d_d => chipstream,
						clk_d => clk_r,
						reset_d => reset_r,
						q_d => s_qb
					);
			
				i_DFCC: DFC									-- Definizione del registro fra l'uscita del moltiplicatore e l'ingresso del contatore
					generic map (Nbit=>Nbit_c)
					port map(								-- Definizione dei collegamenti
						d_d => s_dc,
						clk_d => clk_r,
						reset_d => reset_r,
						q_d => s_qc
					);

				i_DFCD: DFC									-- Definizione del registro fra l'uscita del blocco divisore e l'uscita del ricevitore
					generic map (Nbit=>Nbit)
					port map(								-- Definizione dei collegamenti
						d_d => s_dd,
						clk_d => clk_r,
						reset_d => reset_r,
						q_d => s_qd
					);
	

				i_DFCE: DFC									-- Definizione del registro posto fra l'uscita del contatore e l'ingresso del divisore
					generic map (Nbit=>Nbit_c)
					port map(								-- Definizione dei collegamenti
						d_d => s_de,
						clk_d => clk_r,
						reset_d => reset_r,
						q_d => s_qe
					);
	
		
				i_Counter: Counter							-- Definizione del contatore
					generic map (Nbit_c=>Nbit_c)
					port map(								-- Definizione dei collegamenti
						a_c => s_qc,
						b_c => s_de,
						cin_c => s_cin,
						reset_c => reset_r,
						clk_c => clk_r,
						cout_c => s_cout
					);
				i_Divider: Divider							-- Definizione del divisore
					generic map (
						Nbit => Nbit,
						Nbit_c => Nbit_c
					)
					port map(								-- Definizione dei collegamenti
						dividendo => s_qe,
						quoziente => s_dd,
						clk_div	=> clk_r
					);
				bitstream <= s_qd;						-- Uscita del ricevitore
	
	end Struct;