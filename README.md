# Digitálny trezor 

# Popis problému
Tento projekt implementuje 4-ciferný digitálny trezor na FPGA.  
Používateľ zadáva štyri desiatkové číslice pomocou prepínačov SW[3:0].  
Každá číslica je potvrdená stlačením tlačidla a uložená do interných registrov.  
Po zadaní všetkých štyroch číslic sa uložený kód porovná s prednastavenou kombináciou.  
Výsledok je indikovaný pomocou LED diód a zadaný kód je zobrazený na sedemsegmentovom displeji.

# Doska
Nexys A7-50T

# Cieľ projektu
Implementovať jednoduchý digitálny kombinačný zámok s:
- zadávaním 4-ciferného kódu
- ukladaním zadaných číslic
- porovnaním s prednastaveným kódom
- vizuálnou indikáciou úspechu/neúspechu
- výstupom na sedemsegmentový displej
# Bloková schéma
<img width="460" height="480" alt="image" src="https://github.com/user-attachments/assets/692d85e2-f509-4e5f-802a-b6036dda4241" />



# Tabulka vstupov a výstupov

| Signál    |    Typ | Šírka | Funkcia                 |
| --------- | -----: | ----: | ----------------------- |
| CLK100MHZ |  input |     1 | systémový clock         |
| BTNU      |  input |     1 | reset                   |
| BTNC      |  input |     1 | uloženie číslice        |
| BTNR      |  input |     1 | porovnanie kódu         |
| SW        |  input |     4 | aktuálne zadaná číslica |
| LED       | output |    16 | indikácia výsledku      |
| AN        | output |     8 | výber číslice 7-seg     |
| SEG       | output |     7 | segmenty                |
| DP        | output |     1 | desatinná bodka         |

# Hierarchia modulov
- top_safe
- safe_fsm
- digit_registers
- code_compare
- display_driver
- bin2seg
- debouncer
- clk_en

# Rozdelenie úloh v tíme
- Petrik – vstupy a riadenie, obsluha tlačidiel, časť safe_fsm
- Gazovic – dátová časť, digit_registers, code_compare, definícia preset kódu, testbench pre porovnanie
- Huspenina – výstupy a integrácia, LED signalizácia, top-level prepájanie a .xdc

# Git workflow
Repozitár bude priebežne aktualizovaný počas každého cvičenia.
1. Cvičenie :
   - Počas prvého cvičenia sme spravili základ pre tvorenie nášho projektu, rozdelili si úlohy
   - Začali dávať dokopy blokovú schému a celkovú predstavu toho ako bude fungovať náš projekt
   - Pridali do repozitára bin2seg, clk_en, debounce, display_driver a nexys.xdc
2. Cvičenie :

3. Cvičenie :
   
4. Cvičenie :

5. Cvičenie :
