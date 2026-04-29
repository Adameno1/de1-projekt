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

<img width="1203" height="464" alt="image" src="https://github.com/user-attachments/assets/40fd6e9b-adf6-498d-9d02-fb088231f40b" />

- OK  -> LED0
- ERR -> LED1

- Správanie systému

- Po resete:

- systém vymaže všetky 4 pozície
- index zadávania sa nastaví na prvú číslicu
- LED OK a ERROR zhasnú

- Po stlačení BTNC:

- aktuálna hodnota SW3..0 sa uloží do ďalšej pozície
- index sa posunie na ďalšiu číslicu
- keď sú uložené všetky 4 číslice, ďalšie zadávanie sa ignoruje alebo čaká na compare

- Po stlačení BTNR:

- uložené 4 číslice sa porovnajú s tajným kódom
- ak sa zhodujú, rozsvieti sa LED0
- ak sa nezhodujú, rozsvieti sa LED1

# Simulacia
- safe_fsm
<img width="901" height="298" alt="image" src="https://github.com/user-attachments/assets/83cdf571-2155-460c-8958-ae818764f375" />

- digit_registers 
<img width="1114" height="471" alt="image" src="https://github.com/user-attachments/assets/d6eabe81-1501-49f3-9abe-ed933c85d713" />
Táto simulácia ukazuje, ako funguje modul `digit_registers`.

Na začiatku sa vykoná reset, takže všetky registre (`d0`, `d1`, `d2`, `d3`) sú nastavené na hodnotu `0`.

Následne pri každom signáli `store_en = 1` sa uloží hodnota zo vstupu `digit_in` do registra podľa hodnoty `digit_index`.

Hodnoty sa ukladajú postupne:
- `digit_index = 0` → uloží sa `2` do `d0`
- `digit_index = 1` → uloží sa `5` do `d1`
- `digit_index = 2` → uloží sa `8` do `d2`
- `digit_index = 3` → uloží sa `0` do `d3`

Výsledkom je uložené číslo **2580**.

Hodnoty zostávajú uložené, kým nepríde nový zápis alebo reset.

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
   - Počas tohto cvičenia sme dokončili schému zapojenia
   - spravili sme design sources pre code_compare, digit_register a safe_fsm
   - Posledným krokom ktorý sme spravili bolo, že sme vygenerovali ku každému design sources testbench ktorý sme následne upravili podľa potrieb 
3. Cvičenie :
   
4. Cvičenie :

5. Cvičenie :
