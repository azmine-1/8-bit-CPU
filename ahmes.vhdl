LIBRARY ieee ;
USE ieee.std_logic_1164.all ;
USE ieee.std_logic_unsigned.all ;

ENTITY ahmes IS
	PORT
	(
		address_bus	: OUT STD_LOGIC_VECTOR(7 DOWNTO 0);


		data_in		: IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		data_out	: OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
		mem_write	: OUT std_logic;	
		clk			: IN std_logic;		
		reset		: IN std_logic;		
		ERROR		: OUT STD_LOGIC;	


		OPERACAO 	: OUT STD_LOGIC_VECTOR (3 DOWNTO 0);	
		OPER_A		: OUT STD_LOGIC_VECTOR(7 DOWNTO 0);		
		OPER_B		: OUT STD_LOGIC_VECTOR(7 DOWNTO 0);		
		RESULT		: IN STD_LOGIC_VECTOR(7 DOWNTO 0);		
		Cout		: OUT STD_LOGIC;						
		N,Z,C,B,V 	: IN STD_LOGIC							
	);
END ahmes;

ARCHITECTURE cpu OF ahmes IS


constant NOP : STD_LOGIC_VECTOR(7 DOWNTO 0):="00000000";
constant STA : STD_LOGIC_VECTOR(7 DOWNTO 0):="00010000";
constant LDA : STD_LOGIC_VECTOR(7 DOWNTO 0):="00100000";
constant ADD : STD_LOGIC_VECTOR(7 DOWNTO 0):="00110000";
constant IOR : STD_LOGIC_VECTOR(7 DOWNTO 0):="01000000";
constant IAND: STD_LOGIC_VECTOR(7 DOWNTO 0):="01010000";
constant INOT: STD_LOGIC_VECTOR(7 DOWNTO 0):="01100000";
constant SUB : STD_LOGIC_VECTOR(7 DOWNTO 0):="01110000";
constant JMP : STD_LOGIC_VECTOR(7 DOWNTO 0):="10000000";
constant JN  : STD_LOGIC_VECTOR(7 DOWNTO 0):="10010000";
constant JP  : STD_LOGIC_VECTOR(7 DOWNTO 0):="10010100";
constant JV  : STD_LOGIC_VECTOR(7 DOWNTO 0):="10011000";
constant JNV : STD_LOGIC_VECTOR(7 DOWNTO 0):="10011100";
constant JZ  : STD_LOGIC_VECTOR(7 DOWNTO 0):="10100000";
constant JNZ : STD_LOGIC_VECTOR(7 DOWNTO 0):="10100100";
constant JC  : STD_LOGIC_VECTOR(7 DOWNTO 0):="10110000";
constant JNC : STD_LOGIC_VECTOR(7 DOWNTO 0):="10110100";
constant JB  : STD_LOGIC_VECTOR(7 DOWNTO 0):="10111000";
constant JNB : STD_LOGIC_VECTOR(7 DOWNTO 0):="10111100";
constant SHR : STD_LOGIC_VECTOR(7 DOWNTO 0):="11100000";
constant SHL : STD_LOGIC_VECTOR(7 DOWNTO 0):="11100001";
constant IROR: STD_LOGIC_VECTOR(7 DOWNTO 0):="11100010";
constant IROL: STD_LOGIC_VECTOR(7 DOWNTO 0):="11100011";
constant HLT : STD_LOGIC_VECTOR(7 DOWNTO 0):="11110000";



constant ULA_ADD : STD_LOGIC_VECTOR(3 DOWNTO 0):="0001";
constant ULA_SUB : STD_LOGIC_VECTOR(3 DOWNTO 0):="0010";
constant ULA_OU  : STD_LOGIC_VECTOR(3 DOWNTO 0):="0011";
constant ULA_E   : STD_LOGIC_VECTOR(3 DOWNTO 0):="0100";
constant ULA_NAO : STD_LOGIC_VECTOR(3 DOWNTO 0):="0101";
constant ULA_DLE : STD_LOGIC_VECTOR(3 DOWNTO 0):="0110";
constant ULA_DLD : STD_LOGIC_VECTOR(3 DOWNTO 0):="0111";
constant ULA_DAE : STD_LOGIC_VECTOR(3 DOWNTO 0):="1000";
constant ULA_DAD : STD_LOGIC_VECTOR(3 DOWNTO 0):="1001";

BEGIN


	process (clk,reset)
	variable PC : STD_LOGIC_VECTOR(7 DOWNTO 0);	
	variable AC : STD_LOGIC_VECTOR(7 DOWNTO 0);	
	VARIABLE TEMP: STD_LOGIC_VECTOR(7 DOWNTO 0);	
	VARIABLE INSTR: STD_LOGIC_VECTOR(7 DOWNTO 0);	

	type Tcpu_state is (
		BUSCA, BUSCA1, DECOD,  
		DECOD_STA1, DECOD_STA2, DECOD_STA3, DECOD_STA4,		
		DECOD_LDA1, DECOD_LDA2, DECOD_LDA3,					
		DECOD_ADD1, DECOD_ADD2, DECOD_ADD3,					
		DECOD_SUB1, DECOD_SUB2, DECOD_SUB3, 				
		DECOD_IOR1, DECOD_IOR2, DECOD_IOR3, 				
		DECOD_IAND1, DECOD_IAND2, DECOD_IAND3, 				
		DECOD_JMP,											
		DECOD_SHR1,  										
		DECOD_SHL1,  										
		DECOD_IROR1, 										
		DECOD_IROL1, 										
		DECOD_STORE						
		);
	VARIABLE CPU_STATE : TCPU_STATE;  
	begin
		if (reset='1') then

			CPU_STATE := BUSCA;	
			PC := "00000000";	
			MEM_WRITE <= '0';	
			ADDRESS_BUS <= "00000000";	
			DATA_OUT <= "00000000";		
			OPERACAO <= "0000";			
		ELSIF ((clk'event and clk='1')) THEN	
			CASE CPU_STATE IS	
				WHEN BUSCA =>	
					ADDRESS_BUS <= PC;		
					ERROR <= '0';			
					CPU_STATE := BUSCA1;	
				WHEN BUSCA1 =>	
					INSTR := DATA_IN;		
					CPU_STATE := DECOD;		
				WHEN DECOD =>	
					CASE INSTR IS			


						WHEN NOP =>						
							PC := PC + 1;				
							CPU_STATE := BUSCA;			


						WHEN STA =>						
							ADDRESS_BUS <= PC + 1;		
							CPU_STATE := DECOD_STA1;	


						WHEN LDA =>						
							ADDRESS_BUS <= PC + 1;		
							CPU_STATE := DECOD_LDA1;	


						WHEN ADD =>						
							ADDRESS_BUS <= PC + 1;		
							CPU_STATE := DECOD_ADD1;	


						WHEN SUB =>						
							ADDRESS_BUS <= PC + 1;		
							CPU_STATE := DECOD_SUB1;	


						WHEN IOR =>						
							ADDRESS_BUS <= PC + 1;		
							CPU_STATE := DECOD_IOR1;	


						WHEN IAND =>				
							ADDRESS_BUS <= PC + 1;		
							CPU_STATE := DECOD_IAND1;	


						WHEN INOT =>					
							OPER_A <= AC;				
							OPERACAO <= ULA_NAO;		
							PC := PC + 1;				
							CPU_STATE := DECOD_STORE;	


						WHEN JMP =>						
							ADDRESS_BUS <= PC + 1;		
							CPU_STATE := DECOD_JMP;		


						WHEN JN =>						
							IF (N='1') THEN

								ADDRESS_BUS <= PC + 1;	
								CPU_STATE := DECOD_JMP;	
							ELSE

								PC := PC + 2;			
								CPU_STATE := BUSCA;		
							END IF;


						WHEN JP =>						
							IF (N='0') THEN

								ADDRESS_BUS <= PC + 1;	
								CPU_STATE := DECOD_JMP;	
							ELSE

								PC := PC + 2;			
								CPU_STATE := BUSCA;		
							END IF;


						WHEN JV =>						
							IF (V='1') THEN

								ADDRESS_BUS <= PC + 1;	
								CPU_STATE := DECOD_JMP;	
							ELSE

								PC := PC + 2;			
								CPU_STATE := BUSCA;		
							END IF;


						WHEN JNV =>						
							IF (V='0') THEN

								ADDRESS_BUS <= PC + 1;	
								CPU_STATE := DECOD_JMP;	
							ELSE

								PC := PC + 2;			
								CPU_STATE := BUSCA;		
							END IF;
						WHEN JZ =>						
							IF (Z='1') THEN

								ADDRESS_BUS <= PC + 1;	
								CPU_STATE := DECOD_JMP;	
							ELSE

								PC := PC + 2;			
								CPU_STATE := BUSCA;		
							END IF;
						WHEN JNZ =>						
							IF (Z='0') THEN

								ADDRESS_BUS <= PC + 1;	
								CPU_STATE := DECOD_JMP;	
							ELSE

								PC := PC + 2;			
								CPU_STATE := BUSCA;		
							END IF;
						WHEN JC =>						
							IF (C='1') THEN

								ADDRESS_BUS <= PC + 1;	
								CPU_STATE := DECOD_JMP;	
							ELSE

								PC := PC + 2;			
								CPU_STATE := BUSCA;		
							END IF;
						WHEN JNC =>						
							IF (C='0') THEN

								ADDRESS_BUS <= PC + 1;	
								CPU_STATE := DECOD_JMP;	
							ELSE

								PC := PC + 2;			
								CPU_STATE := BUSCA;		
							END IF;
						WHEN JB =>						
							IF (B='1') THEN

								ADDRESS_BUS <= PC + 1;	
								CPU_STATE := DECOD_JMP;	
							ELSE

								PC := PC + 2;			
								CPU_STATE := BUSCA;		
							END IF;
						WHEN JNB =>						
							IF (B='0') THEN

								ADDRESS_BUS <= PC + 1;	
								CPU_STATE := DECOD_JMP;	
							ELSE

								PC := PC + 2;			
								CPU_STATE := BUSCA;		
							END IF;
						WHEN SHR =>						
							CPU_STATE := DECOD_SHR1;	
						WHEN SHL =>						
							CPU_STATE := DECOD_SHL1;	
						WHEN IROR =>					
							Cout <= C;
							CPU_STATE := DECOD_IROR1;	
						WHEN IROL =>					
							Cout <= C;
							CPU_STATE := DECOD_IROL1;	
						WHEN HLT =>						
						WHEN OTHERS =>					
							PC := PC + 1;				
							ERROR <= '1';				
							CPU_STATE := BUSCA;			
					END CASE;
				WHEN DECOD_STA1 =>				
					TEMP := DATA_IN;			
					CPU_STATE := DECOD_STA2;	
				WHEN DECOD_STA2 =>				
					ADDRESS_BUS <= TEMP;
					DATA_OUT <= AC;				
					PC := PC + 1;				
					CPU_STATE := DECOD_STA3;
				WHEN DECOD_STA3 =>
					MEM_WRITE <= '1';			
					PC := PC + 1;				
					CPU_STATE := DECOD_STA4;
				WHEN DECOD_STA4 =>
					MEM_WRITE <= '0';			
					CPU_STATE := BUSCA;			
				WHEN DECOD_LDA1 =>				
					TEMP := DATA_IN;			
					CPU_STATE := DECOD_LDA2;
				WHEN DECOD_LDA2 =>
					ADDRESS_BUS <= TEMP;		
					PC := PC + 1;				
					CPU_STATE := DECOD_LDA3;
				WHEN DECOD_LDA3 =>
					AC := DATA_IN;				
					PC := PC + 1;				
					CPU_STATE := BUSCA;			
				WHEN DECOD_ADD1 =>				
					TEMP := DATA_IN;			
					CPU_STATE := DECOD_ADD2;
				WHEN DECOD_ADD2 =>
					ADDRESS_BUS <= TEMP;		
					CPU_STATE := DECOD_ADD3;
				WHEN DECOD_ADD3 =>
					OPER_A <= DATA_IN;			
					OPER_B <= AC;				
					OPERACAO <= ULA_ADD;		
					PC := PC + 1;				
					CPU_STATE := DECOD_STORE;
				WHEN DECOD_SUB1 =>				
					TEMP := DATA_IN;			
					CPU_STATE := DECOD_SUB2;
				WHEN DECOD_SUB2 =>
					ADDRESS_BUS <= TEMP;		
					CPU_STATE := DECOD_SUB3;
				WHEN DECOD_SUB3 =>
					OPER_A <= AC;				
					OPER_B <= DATA_IN;			
					OPERACAO <= ULA_SUB;		
					PC := PC + 1;				
					CPU_STATE := DECOD_STORE;
				WHEN DECOD_IOR1 =>				
					TEMP := DATA_IN;			
					CPU_STATE := DECOD_IOR2;
				WHEN DECOD_IOR2 =>
					ADDRESS_BUS <= TEMP;		
					CPU_STATE := DECOD_IOR3;
				WHEN DECOD_IOR3 =>
					OPER_A <= AC;				
					OPER_B <= DATA_IN;			
					OPERACAO <= ULA_OU;			
					PC := PC + 1;				
					CPU_STATE := DECOD_STORE;
				WHEN DECOD_IAND1 =>				
					TEMP := DATA_IN;			
					CPU_STATE := DECOD_IAND2;
				WHEN DECOD_IAND2 =>
					ADDRESS_BUS <= TEMP;		
					CPU_STATE := DECOD_IAND3;
				WHEN DECOD_IAND3 =>
					OPER_A <= AC;				
					OPER_B <= DATA_IN;			
					OPERACAO <= ULA_E;			
					PC := PC + 1;				
					CPU_STATE := DECOD_STORE;
				WHEN DECOD_JMP =>				
					PC := DATA_IN;				
					CPU_STATE := BUSCA;			
				WHEN DECOD_SHR1 =>				
					OPER_A <= AC;				
					OPERACAO <= ULA_DAD;		
					CPU_STATE := DECOD_STORE;
				WHEN DECOD_SHL1 =>				
					OPER_A <= AC;				
					OPERACAO <= ULA_DAD;		
					CPU_STATE := DECOD_STORE;
				WHEN DECOD_IROR1 =>				
					OPER_A <= AC;				
					OPERACAO <= ULA_DLD;		
					CPU_STATE := DECOD_STORE;
				WHEN DECOD_IROL1 =>				
					OPER_A <= AC;				
					OPERACAO <= ULA_DLE;		
					CPU_STATE := DECOD_STORE;					
				WHEN DECOD_STORE =>
					AC := RESULT;				
					PC := PC + 1;				
					CPU_STATE := BUSCA;			
			END CASE;
		END IF;
	end process;
END CPU;