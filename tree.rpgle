**FREE
CTL-OPT DFTACTGRP(*NO) ACTGRP(*NEW);

DCL-F TREEFM WORKSTN USROPN;

DCL-PR ReceiveDtaq EXTPGM('QRCVDTAQ');
    Dtaq    CHAR(10) CONST;
    Dtaqlib CHAR(10) CONST;
    DataLen PACKED(5:0);
    Data    CHAR(80);
    WaitTime PACKED(5:0);
END-PR;

DCL-PR system INT(10) EXTPROC('system');
    Command POINTER VALUE OPTIONS(*STRING);
END-PR;

DCL-DS RowDS;
    Row01;
    Row02;
    Row03;
    Row04;
    Row05;
    Row06;
    Row07;
    Row08;
    Row09;
    Row10;
    Row11;
    Row12;
    Row13;
    Row14;
    Row15;
    Row16;
    Row17;
    Row18;
    Rows LIKE(Row01) DIM(18) POS(1);
END-DS;

DCL-S dqData CHAR(80);
DCL-S dqLen  PACKED(5:0);
DCL-S I UNS(5);
DCL-S Wait PACKED(5:0) INZ(1);

DCL-S TREEDATA CHAR(414) INZ('-
           W           -
          WWW          -
          /_\          -
         /_R_\         -
        /_/_/_\        -
        /_\P\_\        -
       /_R_/_B_\       -
       /_\_B_\_\       -
      /_/P/_/R/_\      -
      /_\_\_B_\_\      -
     /_P_/_/_/_/_\     -
     /_\R\_\B\_P_\     -
    /_/B/_/_/_/_/_\    -
    /_\_\_\R\_\_\_\    -
   /_/R/_/B/_/_/R/_\   -
   /_\_P_\_\_B_\_\_\   -
  /_/_/_/_B_/_/_P_/_\  -
         [___]         -
');


CLOSE TreeFM;
system('DLTDTAQ DTAQ(QTEMP/AUTOREFQ)');
system('CRTDTAQ DTAQ(QTEMP/AUTOREFQ) MAXLEN(' +
            %CHAR(%SIZE(dqData)) + ')');
system('OVRDSPF FILE(TREEFM) DTAQ(QTEMP/AUTOREFQ)');
OPEN TreeFM;

DOU *IN03;
    FOR i = 1 TO 18;
        Rows(i) = %SUBST(TreeData:(i-1)*23+1:23);
        SetAttributes(Rows(i));
    ENDFOR;

    WRITE TREES1;
    ReceiveDtaq('AUTOREFQ':'QTEMP':dqLen:dqData:Wait);
    IF dqLen > 0;
        READ(E) TREEFM;
    ENDIF;
ENDDO;

*INLR = *ON;
RETURN;


DCL-PROC SetAttributes;
DCL-PI *N;
    Row  LIKE(ROW01);
END-PI;

    DCL-PR CEERAN0 EXTPROC('CEERAN0');
        Seed INT(10);
        Rand FLOAT(8);
        FC   CHAR(12);
    END-PR;

    DCL-C NORMAL x'20';
    DCL-C WHITE x'23';
    DCL-C RED x'29';
    DCL-C PINK x'39';
    DCL-C BLUE x'3B';

    DCL-C WhiteFreq 0;
    DCL-C RedFreq 4;
    DCL-C PinkFreq 5;
    DCL-C BlueFreq 6;

    DCL-S pos     UNS(5);
    DCL-S FC      CHAR(12);
    DCL-S HighVal INT(10) INZ(10);
    DCL-S LowVal  INT(10) INZ(1);
    DCL-S Rand    FLOAT(8);
    DCL-S Range   INT(10);
    DCL-S Result  INT(10);
    DCL-S Seed    INT(10) INZ(0);

    Range = (HighVal - LowVal) + 1;
    CEERAN0(seed:rand:FC);
    Result = %INT(rand*range) + LowVal;

    pos = %SCAN('W':Row);
    DOW pos <> 0;
        IF Result > WhiteFreq;
            %SUBST(Row:pos-1:1) = WHITE;
        ELSE;
            %SUBST(Row:pos-1:1) = NORMAL;
        ENDIF;
        %SUBST(Row:pos:1) = ' ';
        DOW %SUBST(Row:pos+1:1) = 'W';
            %SUBST(Row:pos+1:1) = ' ';
            Pos+=1;
        ENDDO;
        %SUBST(Row:pos+1:1) = NORMAL;
        pos = %SCAN('W':Row);
    ENDDO;

    pos = %SCAN('R':Row);
    DOW pos <> 0;
        IF Result > RedFreq;
            %SUBST(Row:pos-1:1) = RED;
        ELSE;
            %SUBST(Row:pos-1:1) = NORMAL;
        ENDIF;
        %SUBST(Row:pos:1) = ' ';
        %SUBST(Row:pos+1:1) = NORMAL;
        pos = %SCAN('R':Row);
    ENDDO;

    pos = %SCAN('P':Row);
    DOW pos <> 0;
        IF Result > PinkFreq;
            %SUBST(Row:pos-1:1) = PINK;
        ELSE;
            %SUBST(Row:pos-1:1) = NORMAL;
        ENDIF;
        %SUBST(Row:pos:1) = ' ';
        %SUBST(Row:pos+1:1) = NORMAL;
        pos = %SCAN('P':Row);
    ENDDO;

    pos = %SCAN('B':Row);
    DOW pos <> 0;
        IF Result > BlueFreq;
            %SUBST(Row:pos-1:1) = BLUE;
        ELSE;
            %SUBST(Row:pos-1:1) = NORMAL;
        ENDIF;
        %SUBST(Row:pos:1) = ' ';
        %SUBST(Row:pos+1:1) = NORMAL;
        pos = %SCAN('B':Row);
    ENDDO;


END-PROC;

