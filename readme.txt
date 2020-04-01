Ghenea Iustina 332CC

Varianta B

Rularea temei:

make => creare executabil
make run1 => ruleaza tema pentru fisierul de intrare input1.xml
make run2 => ruleaza tema pentru fisierul de intrare input2.xml
make run3 => ruleaza tema pentru fisierul de intrare input3.xml
make run4 => ruleaza tema pentru fisierul de intrare input4.xml

Se citeste fisierul de intrare in C.
Continutul este parsat folosind flex; toate informatiile din fisier
sunt stocate intr-o structura, la momentul parsarii lor.
Scrierea are loc dupa ce parsarea cu ajutorul flex ia sfarsit.

Pentru parsare s-au folosit 6 stari:

IGNORE = stare folosita pentru a ignora versiunea XML a fisierului de intrare
TAG = starea contine reguli care se ocupa cu calcularea indentarii si stocarea
      informatiilor utile care se pot afla intre "<" si ">";
      de asemenea, din starea TAG se poate trece in starea ATTRIBUTE sau in
      starea BETWEEN_WITHOUT
BETWEEN_WITHOUT = stare in care se ajunge daca un tag nu contine atribute,
                  iar intre deschidea si inchiderea aceluiasi tag exista continut;
                  stocheaza textul in structura auxiliara
ATTRIBUTE = starea folosita pentru a stoca numele atributului;
            din aceasta stare se trece in starea VALUE, deoarece orice atribut
            are si o valoare
VALUE = stare care stocheaza valoarea atributului sau in structura;
        din aceasta stare ne putem intoarce in starea ATTRIBUTE in cazul in care
        exista mai mult de un atribut, sau putem trece in starea BETWEEN_WITH
        daca nu mai exista alte atribute
BETWEEN_WITH = stare in care se ajunge daca un tag contine atribute, iar intre
                deschiderea si inchiderea aceluiasi tag exista continut;
                stocheaza textul in structura auxiliara

Comentariile sunt ignorate inafara oricarei stari.
Tagurile de inchidere compun regula in urma careia se contorizeaza indentarea.