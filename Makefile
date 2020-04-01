#Ghenea Iustina 332CC
all: myXMLparser

lex.yy.c: myXMLparser.l
	flex myXMLparser.l

myXMLparser: lex.yy.c
	gcc -o myXMLparser lex.yy.c -lfl

run1:
	./myXMLparser input1.xml

run2:
	./myXMLparser input2.xml

run3:
	./myXMLparser input3.xml

run4:
	./myXMLparser input4.xml

clean:
	rm -rf myXMLparser lex.yy.c
