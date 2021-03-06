NAME=Christmas Tree
BIN_LIB=TREE
DBGVIEW=*SOURCE
TGTRLS=V7R1M0

#----------

all: treefm.dspf tree.rpgle  
	@echo "Built all"

#----------

%.rpgle:
	system "CRTBNDRPG PGM($(BIN_LIB)/$*) SRCSTMF('$*.rpgle') TEXT('$(NAME)') REPLACE(*YES) DBGVIEW($(DBGVIEW)) TGTRLS($(TGTRLS))"

%.dspf:
    -system -qi "CRTLIB LIB($(BIN_LIB))"
	-system -qi "CRTSRCPF FILE($(BIN_LIB)/QSOURCE) MBR($*) RCDLEN(112)"
	system "CPYFRMSTMF FROMSTMF('$*.dspf') TOMBR('/QSYS.lib/$(BIN_LIB).lib/QSOURCE.file/$*.mbr') MBROPT(*REPLACE)"
	system "CRTDSPF FILE($(BIN_LIB)/$*) SRCFILE($(BIN_LIB)/QSOURCE) SRCMBR($*) TEXT('$(NAME)')"
	-system -qi "DLTF FILE($(BIN_LIB)/QSOURCE)"

clean:
	system "CLRLIB $(BIN_LIB)"