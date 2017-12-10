answer: answer.o
	ld answer.o -o answer -arch i386 -macosx_version_min 10.6 -lc /usr/lib/crt1.o

answer.o: answer.asm
	nasm -f macho answer.asm