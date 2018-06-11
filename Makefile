CC=gcc
CFLAGS=-Wall -Wextra -Wno-missing-field-initializers -Wno-missing-braces -Wno-unused-function -Wno-unneeded-internal-declaration -Wno-unused-parameter -g
LDLIBS=-lm
LEX=flex
BISON=bison
BFLAGS=--report=solved --defines
AR=ar
SRC=$(wildcard *.c)
OBJ=$(SRC:.c=.o)

nev: libnev.a

libnev.a: scanner.o parser.o expr.o var.o freevar.o func.o never.o symtab.o \
          typecheck.o gencode.o utils.o bytecode.o vm.o gc.o object.o nev.o \
          constred.o tailrec.o optimize.o libmath.o libvm.o

tests: test_object test_scanner test_symtab \
       test_freevar test_vm test_gc test_libmath

run_tests:
	./test_object
	./test_symtab
	./test_freevar
	./test_vm
	./test_gc
	./test_libmath

test_object: object.o

test_scanner: scanner.o

test_symtab: symtab.o var.o freevar.o func.o expr.o

test_freevar: symtab.o var.o freevar.o func.o expr.o

test_vm: vm.o gc.o object.o utils.o libmath.o libvm.o expr.o var.o freevar.o func.o symtab.o

test_gc: gc.o object.o

test_libmath: test_libmath.o libmath.o libvm.o func.o expr.o var.o object.o freevar.o gc.o symtab.o utils.o

lib%.a: %.o
	$(AR) r $@ $?

%.c : %.y
	$(BISON) $(BFLAGS) -o $@ $<

deps:
	$(CC) -MM *.c *.h > .deps

include .deps

.PHONY: clean
clean:
	@rm -f $(OBJ) libnev.a nev

