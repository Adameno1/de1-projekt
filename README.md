# Digitálny trezor 

# Popis problému
Tento projekt implementuje 4-ciferný digitálny trezor na FPGA.  
Používateľ zadáva štyri desiatkové číslice pomocou prepínačov SW[3:0].  
Každá číslica je potvrdená stlačením tlačidla a uložená do interných registrov.  
Po zadaní všetkých štyroch číslic sa uložený kód porovná s prednastavenou kombináciou.  
Výsledok je indikovaný pomocou LED diód a zadaný kód je zobrazený na sedemsegmentovom displeji.

# Doska
Nexys A7-50T

<img width="548" height="444" alt="image" src="https://github.com/user-attachments/assets/2f41cb2c-db93-429b-81d6-729d45902930" />

# Cieľ projektu
Implementovať jednoduchý digitálny kombinačný zámok s:
- zadávaním 4-ciferného kódu
- ukladaním zadaných číslic
- porovnaním s prednastaveným kódom
- vizuálnou indikáciou úspechu/neúspechu
- výstupom na sedemsegmentový displej

# Bloková schéma

<img width="1418" height="439" alt="image" src="https://github.com/user-attachments/assets/6a19197f-e8d6-4616-8922-19c93c5dc5a6" />

# Video
[Video de1 projekt](https://youtu.be/J3Og28kZ9ew)
## Správanie systému

### Po resete (BTNU)

- systém vymaže všetky 4 uložené číslice
- aktuálna pozícia zadávania sa nastaví na prvú číslicu
- zelená aj červená LED zhasnú
- displej začne znova blikať na prvej pozícii

---

### Po stlačení BTNC

- aktuálna hodnota zo switchov `SW[3:0]` sa uloží do aktuálnej pozície
- index zadávania sa posunie na ďalšiu číslicu
- aktuálne zadávaná číslica na displeji bliká
- ostatné číslice svietia stabilne

Po zadaní všetkých 4 číslic:

- ďalšie stláčanie BTNC už neposúva index
- systém čaká na porovnanie kódu

---

### Po stlačení BTNR

- uložené 4 číslice sa porovnajú s tajným kódom `2580`

Ak je kód správny:

- rozsvieti sa zelená LED `LED16_G`
- červená LED zostane zhasnutá
- blikanie displeja sa vypne

Ak je kód nesprávny:

- rozsvieti sa červená LED `LED16_R`
- zelená LED zostane zhasnutá
- blikanie displeja sa vypne

# Súbory projektu

## Sources

### [bin2seg.vhd](./sources/bin2seg.vhd)
Modul na prevod 4-bitovej binárnej hodnoty na signály pre 7-segmentový displej.  
Princíp spočíva v dekódovaní čísiel 0–F na jednotlivé segmenty displeja.

---

### [clk_en.vhd](./sources/clk_en.vhd)
Generátor clock enable signálu.  
Používa sa na spomalenie určitých operácií, napríklad multiplexovania displeja alebo blikania číslic.

---

### [code_compare.vhd](./sources/code_compare.vhd)
Modul na porovnanie zadaného kódu so správnym kódom.  
Po prijatí signálu `compare_en` porovná uložené číslice s definovaným heslom a nastaví výstup `code_ok` alebo `code_err`.

---

### [debounce.vhd](./sources/debounce.vhd)
Modul na odstránenie zákmitov mechanických tlačidiel.  
Zabezpečuje, aby jedno stlačenie tlačidla vytvorilo iba jeden čistý impulz.

---

### [digit_register.vhd](./sources/digit_register.vhd)
Register na ukladanie jednotlivých číslic zadávaného kódu.  
Podľa aktuálneho indexu uloží číslicu zo switchov do príslušného registra.

---

### [display_driver.vhd](./sources/display_driver.vhd)
Ovládač 7-segmentového displeja.  
Zabezpečuje multiplexovanie číslic, dekódovanie segmentov a blikanie aktuálne zadávanej číslice.

---

### [nexys.xdc](./sources/nexys.xdc)
Constraint súbor FPGA dosky Nexys A7.  
Obsahuje mapovanie portov návrhu na fyzické piny FPGA dosky.

---

### [safe_fsm.vhd](./sources/safe_fsm.vhd)
Hlavný riadiaci FSM modul projektu.  
Riadi postup zadávania číslic, posúvanie pozície a spustenie porovnania kódu.

---

# Simulacia
# [safe_fsm.vhd](./sources/safe_fsm.vhd)

# [safe_fsm_tb.vhd](./tesbench/safe_fsm_tb.vhd)

<img width="901" height="298" alt="image" src="https://github.com/user-attachments/assets/83cdf571-2155-460c-8958-ae818764f375" />

Táto simulácia ukazuje, ako funguje riadiaci modul `safe_fsm`.

Na začiatku je reset, takže všetky výstupy sú v nulovom stave a `digit_index` je nastavený na `0`.

Počas simulácie sa generujú pulzy na vstupoch `btn_store` a `btn_compare`, ktoré simulujú stláčanie tlačidiel.

Pri každom pulze `btn_store = 1`:
- sa aktivuje `store_en`
- `digit_index` sa zvýši o 1 (0 → 1 → 2 → 3)

To znamená, že sa postupne vyberajú pozície pre ukladanie číslic.

Keď príde pulz `btn_compare = 1`:
- aktivuje sa `compare_en`
- tým sa spustí porovnanie zadaného kódu

Po dosiahnutí hodnoty `digit_index = 3` už index ďalej nerastie a zostáva na poslednej pozícii.

# [digit_register.vhd](./sources/digit_register.vhd)

# [digit_registers_tb.vhd](./tesbench/digit_registers_tb.vhd)

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

# [code_compare.vhd](./sources/code_compare.vhd)

# [code_compare_tb.vhd](./tesbench/code_compare_tb.vhd)

<img width="1108" height="465" alt="image" src="https://github.com/user-attachments/assets/d641ba31-aa9c-4ead-835b-9167c1ac0c1d" />

Táto simulácia ukazuje, ako funguje modul `code_compare`, ktorý porovnáva zadaný kód s uloženým správnym kódom.

Na začiatku je reset, takže výstupy `code_ok` a `code_err` sú nastavené na `0`.

Potom sa najprv nastaví správny kód:
- `d0 = 2`
- `d1 = 5`
- `d2 = 8`
- `d3 = 0`

Pri pulze `compare_en = 1`:
- modul vykoná porovnanie
- keďže kód je správny, nastaví sa:
  - `code_ok = 1`
  - `code_err = 0`

Táto hodnota zostane uložená, kým nepríde ďalšie porovnanie alebo reset.

Následne sa zmení jedna číslica (`d2 = 9`), čím vznikne nesprávny kód **2590**.

Pri ďalšom pulze `compare_en = 1`:
- modul opäť vykoná porovnanie
- tentokrát je kód nesprávny, takže:
  - `code_ok = 0`
  - `code_err = 1`

Na konci simulácie sa môže znova aktivovať reset, ktorý vynuluje výstupy späť na `0`.

# [display_driver.vhd](./sources/display_driver.vhd) 

# [display_driver_tb.vhd](./tesbench/display_driver_tb.vhd)
<img width="1179" height="535" alt="image" src="https://github.com/user-attachments/assets/90ca30e9-57a4-4c7a-80be-3b728757150d" />

Táto simulácia overuje správnu funkcionalitu modulu `display_driver`.

Modul:

- multiplexuje jednotlivé číslice displeja
- prepína aktívne anódy pomocou signálu `anode`
- dekóduje číslice cez modul `bin2seg`
- zabezpečuje blikanie aktuálne vybranej číslice

Počas simulácie sa najskôr zobrazí hodnota:

`2580`

a následne:

`4321`

Simulácia zároveň potvrdzuje správnu činnosť:

- multiplexovania displeja
- dekódovania segmentov
- prepínania číslic
- logiky blikania


# Tabuľka vstupov a výstupov

| Signál | Typ | Šírka | Funkcia |
|--------|------|--------|----------|
| CLK100MHZ | input | 1 | hlavný 100 MHz clock |
| BTNU | input | 1 | reset celého systému |
| BTNC | input | 1 | uloženie aktuálnej číslice |
| BTNR | input | 1 | porovnanie zadaného kódu |
| SW | input | 4 | zadávanie 4-bitovej číslice |
| LED16_G | output | 1 | signalizácia správneho kódu |
| LED16_R | output | 1 | signalizácia nesprávneho kódu |
| AN | output | 8 | výber aktívnej číslice 7-segmentového displeja |
| SEG | output | 7 | segmenty 7-segmentového displeja |
| DP | output | 1 | desatinná bodka displeja |
| store_en | interný signál | 1 | povolenie zápisu číslice do registra |
| compare_en | interný signál | 1 | spustenie porovnania kódu |
| digit_index | interný signál | 2 | index aktuálne zadávanej číslice |
| d0–d3 | interný signál | 4 × 4 | uložené číslice zadaného kódu |
| display_data | interný signál | 16 | spojené dáta pre display driver |
| blink_enable | interný signál | 1 | povolenie blikania aktuálnej číslice |

# Hierarchia modulov

- top_safe
  - debounce
  - safe_fsm
  - digit_registers
  - code_compare
  - display_driver
    - clk_en
    - bin2seg
  
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
   - prvý krát sme generovali bitstream
   - úprava repozitára
4. Cvičenie :
   - opravili sme funkčnosť kódu, aby čísla svietili správne
   - upravili sme kód aby bol viac user friendly a to tak že číslo ktoré práve zadávame bliká
   - zmenili sme LEDky ktoré svietia z led0 a led1 na LED16_R a LED16_G
   - úprava repozitára
5. Cvičenie :
   - upravili sme kód aby posledné číslo prestalo blikať po potvrdení kódu
   - pridali sme relé ktoré zopne keď zadáme správny kód
   - natočili finálne video
   - úprava repozitára
