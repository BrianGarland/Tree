NAME=Christmas Tree
BIN_LIB=TREE
DBGVIEW=*SOURCE
TGTRLS=V7R1M0
SHELL=/QOpenSys/usr/bin/qsh

#----------

all: $(BIN_LIB).lib tree.rpgle
	@echo "Built all"

tree.rpgle: treefm.dspf 

#----------

%.rpgle:
	liblist -a $(BIN_LIB);\
	system "CRTBNDRPG PGM($(BIN_LIB)/$*) SRCSTMF('$*.rpgle') TEXT('$(NAME)') REPLACE(*YES) DBGVIEW($(DBGVIEW)) TGTRLS($(TGTRLS))"

%.dspf:
	system "CPYFRMSTMF FROMSTMF('$*.dspf') TOMBR('/QSYS.lib/$(BIN_LIB).lib/QSOURCE.file/$*.mbr') MBROPT(*REPLACE)"
	system "CRTDSPF FILE($(BIN_LIB)/$*) SRCFILE($(BIN_LIB)/QSOURCE) SRCMBR($*) TEXT('$(NAME)')"

%.lib:
	-system -qi "CRTLIB LIB($(BIN_LIB)) TEXT('$(NAME)')"
	-system -qi "CRTSRCPF FILE($(BIN_LIB)/QSOURCE) MBR($*) RCDLEN(112)"

clean:
	system "CLRLIB LIB($(BIN_LIB))"

erase:
	-system -qi "DLTLIB LIB($(BIN_LIB))"