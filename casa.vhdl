library ieee;
use ieee.std_logic_1164.all;
entity SmartHome is
    port (
        botao: in std_logic; -- botao modo seguro
        janela1: in std_logic; -- sensores janelas
        janela2: in std_logic; 
        janela3: in std_logic; 
        porta: in std_logic; -- sensor da porta
        tranca: in std_logic; -- sensor da tranca
        crep: in std_logic; -- sensor crepuscular
        chuva: in std_logic; -- sensor de chuva
        temp1: in integer range -20 to 50; -- sensor de temperatura 1
        temp2: in integer range -20 to 50; -- sensor de temperatura 2
        levelA: in integer range 0 to 100; -- sensor caixa A
        levelB: in integer range 0 to 100; -- sensor caixa B
        janelas: out std_logic -- led janelas
        bomba: out std_logic; -- led bomba
        valve: out std_logic -- led valvula
        alerta: out std_logic; -- sinal de alerta
        aviso: out std_logic -- sinal de aviso
    );
end entity SmartHome;

architecture Sistema of SmartHome is
begin
    process(botao, janela1, janela2, janela3, porta, tranca,crep,chuva,temp1,temp2,levelA,levelB)
        variable media : integer;
    begin
        -- checa modo seguro e janelas
        if (botao = '1' and (janela1 = '1' or janela2 = '1' or janela3 = '1')) then
            alerta <= '1'; 
        end if;
        
        -- verifica porta
        if (tranca = '0' and porta = '1') then
            alerta <= '1'; 
        end if;
        
        -- checa janelas
        if (janela1 = '1' or janela2 = '1' or janela3 = '1') then
            janelas <= '1'; 
        end if;

        -- checa janela e chuva
        if ((janela1 = '1' or janela2 = '1' or janela3 = '1') and chuva = '1') then
            aviso <= '1'; 
        end if;
        
        -- checa janelas e noite
        if ((janela1 = '1' or janela2 = '1' or janela3 = '1') and crep = '1') then
            aviso <= '1'; 
        end if;
        
        media := (temp1+temp2)/2;
        -- checa temperatura e janelas
        if ((janela1 = '1' or janela2 = '1' or janela3 = '1') and (media < 15)) then
            aviso <= '1';
        end if;

          -- checa nivel a 
          if (levelA < 20) then
            bomba <= '0';
        else
            bomba <= '1'; 
        end if;
        
        -- checa nivel b
        if (levelB = 100) then
            bomba <= '0';
        end if;
        
        -- checa nivel a menor que 15
        if (levelA < 15) then
            valve <= '1'; 
        else
            valve <= '0'; 
        end if;
    end process;
end architecture Sistema;
