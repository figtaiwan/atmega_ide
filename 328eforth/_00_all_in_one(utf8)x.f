  Forget TEST
: Forget 'CN 2- DUP CP ! I@ DUP CONTEXT ! LAST ! DROP ;
VARIABLE DEPTH_CHECK FLUSH 
: :  : DEPTH   DEPTH_CHECK  ! ; FLUSH
: VARIABLE VARIABLE  FLUSH ;
: CONSTANT CONSTANT  FLUSH ;
: ; DEPTH DEPTH_CHECK  @ -
 ABORT" ERROR#04 程式結構不對稱"  
  [COMPILE] ; FLUSH ; IMMEDIATE
FLUSH
\ 本檔案為毛翔先生2012/8/23於德霖技術學院202實驗室創作。
HEX
\ ==============DEFINE =======================
: STOP \ 查無此字且無法譯為數值時，忽視後續字元，直至 ESC 鍵。
       \ 此處置之目的為防止後續不當之執行會導致系統損壞(經常發生)。
       
 CR
 ." ERROR#02 : 編譯錯誤 ! 請按 ESC 繼續 " 

 BEGIN 6 EMIT
 KEY DUP   D = IF ." ." 7 EMIT   THEN 
  1B = 
 UNTIL ; FLUSH

: WAIT \ 允許使用者在開機前五秒內，按任意鍵強迫進符式系統(直譯模式)
       \ 此處置之目的為允許有TURNKEY時，仍能取回系統控制權。 
CR
." 2秒內按任意鍵可進入符式系統 "
2
FOR
R@ . 8 EMIT 8 EMIT
1F4  FOR 2FF FOR  NEXT NEXT
?KEY IF  CR  DROP QUIT THEN
NEXT ; FLUSH

\ ================ ASSIGN TO ADDRESS  =================
 ' STOP 2/   ' ERR_HANDLING 2+  I! FLUSH
 ' WAIT 2/   ' ALLOW_BOOT   2+  I! FLUSH

\ 以下為陳爽先生2012/6/10於德霖技術學院202實驗室創作。

\ FORGET legal_name
HEX
: legal_name ( nfa -- nfa flg )
 DUP IC@ 1F AND OVER + ( nfa end )
 BEGIN 2DUP XOR
 WHILE DUP IC@ 21 7F WITHIN 0 =
  IF ( nfa a )
     DROP 0 EXIT
  THEN 1-
 REPEAT DROP -1 ; 
: >NAME ( cfa -- nfa | 0 )
 DUP 20 - ( cfa a )
 BEGIN 2DUP ICOUNT 1F AND + DUP 1 AND + =
  IF ( cfa nfa )
    legal_name
    IF SWAP DROP EXIT
    THEN
  THEN 2+ 2DUP =
 UNTIL XOR ; 

: REMEMBER 100 ERASE 100 100 WRITE 180 ERASE 180 180 WRITE ;
: Forget ( <name> -- )
  'CN 2- DUP CP ! I@ DUP CONTEXT ! LAST ! DROP ;

\ 以下為毛翔先生2012/8/23於德霖技術學院202實驗室修改，
\ 此處置之目的為防止有TURNKEY時，。
: FORGET ( <name> -- ) 'CN
DUP FFFF 200 WITHIN   \ FFFF will be replaced by SEALED
IF \ MAO
 2- DUP CP ! I@ DUP CONTEXT ! LAST !
'BOOT @ CONTEXT @ NAME>   >  
IF
'BOOT @ 1130 = 
  IF 
  DROP
  ELSE
 CR ." 提醒! 已自動為您取消 TURNKEY " 1130 'BOOT !
  THEN 
THEN 
REMEMBER
ELSE  \ MAO
 DROP CR \ MAO  TO BE CHANGE
THEN
 ;


FLUSH 

\ 'CN #OUT 2- DUP CP ! I@ DUP CONTEXT ! LAST ! DROP words #OUT
HEX 
VARIABLE #OUT FLUSH
0 #OUT ! 
: CR 0 #OUT ! CR ; 
: #OUT_+! ( n -- ) 48 OVER #OUT @ + <
  IF CR
  THEN #OUT +! ;
: 1_#OUT_+! 1 #OUT_+! ; 
: DUP_#OUT_+! DUP #OUT +! ; 
: TYPE DUP_#OUT_+! TYPE ; 
: ITYPE DUP_#OUT_+! ITYPE ; 
: SPACE 1_#OUT_+! SPACE ; 
: . <# #S #> SPACE TYPE ; 
: $TYPE ( a -- ) ICOUNT ITYPE ; 
: .ID ( nfa -- ) \ show name
 ICOUNT ( nfa+1 {nfa} )
 1F AND SPACE ITYPE ; 
: >LINK ( nfa -- lfa ) 2- ; 
: words CR CONTEXT @ \ MYWORDS
 BEGIN ?DUP
 WHILE DUP .ID >LINK I@
 REPEAT ; 
: .CELL ( a -- a+2 ) \ show code at address a
 DUP I@ . 2+ ; 
: .CODES ( cfa -- )
 DUP 2/ . $"  :" $TYPE
 BEGIN .CELL 45 #OUT @ <
 UNTIL DROP ; 
: .WORD ( nfa -- ) \ show nfa, name, cfa, and codes
 ?DUP
 IF DUP 5 .R \ show nfa
  DUP IC@ \ #char and immediate and compile-only mask
  DUP 3 .R \ show
  3F AND 0F SWAP - SPACES
  DUP .ID NAME> .CODES
 THEN ; 
: NEXTWORD ( nfa -- nfa' | 0 ) \ show message IF no more words
 DUP
 IF >LINK I@
  DUP 0 =
  IF CR $"  == no more words == " $TYPE
  THEN
 THEN ; 
: WW ( nfa -- nfa' | 0 ) \ show 8 words
 7
 FOR DUP .WORD NEXTWORD CR
  DUP 0 =          \ SEE IF nfa become 0
  IF R> DROP 0 >R  \ reset loop index to leave
  THEN
 NEXT DUP 0 = 
 IF $" done " $TYPE
 THEN ; 
: MYWORDS ( -- )
 CR ." show nfa, name, cfa, and codes for each word"
 CONTEXT @
 BEGIN CR WW DUP 0 =
 UNTIL DROP ;
\ FORGET LIMIT 
HEX 
CREATE LIMIT 2 ALLOT FLUSH 
: DUP_2+_SWAP_I@ ( a -- a+2 [a] )
 DUP 2+ SWAP I@ ; 
940E CONSTANT INS_CALL 
940C CONSTANT INS_JUMP 
9508 CONSTANT INS_RET \ HEX Forget (LIT)
' doLIT   CONSTANT (LIT)
' next    CONSTANT (NEXT)
' ?branch CONSTANT (ZBRAN)
'  branch CONSTANT (BRAN)
' abort"  CONSTANT (ABORT")
' $"|     CONSTANT ($")
' ."|     CONSTANT (.") 
' doVAR   CONSTANT (CON)
: ALIGNED ( a -- b ) \ align addr to cell boundary
  DUP 1 AND + ;
: H. ( v -- ) <# #S #> TYPE ; 
: A. ( a -- ) 2/ <# # # # # # # #> TYPE ;
: H.R ( v n -- ) >R <# #S #> R> OVER - SPACES TYPE ;
: Q 22 EMIT ;
: .STR ( a -- a' )
  6 SPACES ." .DB" ICOUNT DUP . ." ,'" 2DUP ITYPE ." '" + ALIGNED ; 
: .BRAN ( a -- a+2 )
  CR DUP A. DUP_2+_SWAP_I@ ( a+2 [a] )
  DUP 5 H.R LIMIT @ MAX LIMIT ! ; \ Forget .NAME
: .NAME ( a cfa -- a' ) DUP >NAME ( a+4 cfa nfa ) ?DUP
  IF DUP IC@ ( [a] a+4 cfa nfa {nfa} )
   80 AND
   IF ."  [COMPILE]"
   THEN ( [a] a+4 cfa nfa )
   .ID SPACE ( [a] a+4 cfa )
  THEN ( [a] a+4 cfa ) DUP (LIT) =
   IF DROP ."  (LIT)" ( [a] a+4 )
    CR DUP A. DUP_2+_SWAP_I@ 5 H.R ( [a] a+6 )
   ELSE ( [a] a+4 cfa ) DUP (.") = DUP
    IF ."  (." Q ." )"
    THEN OVER (ABORT") =  DUP
    IF ."  (ABORT" Q ." )"
    THEN OR OVER ($") =  DUP
    IF ."  ($" Q ." )"
    THEN OR
    IF DROP DUP DUP IC@ ( [a] a+4 a+4 n ) 2+ 2/ 1- ( [a] a+4 a+4 c )
       FOR CR DUP A. DUP_2+_SWAP_I@ 5 H.R
       NEXT DROP ( [a] a+4 )
       .STR ( [a] a' )
    ELSE ( [a] a+4 cfa ) DUP (ZBRAN) =
     IF DROP ."  (ZBRAN)" .BRAN
     ELSE ( [a] a+4 cfa ) DUP (BRAN) =
      IF DROP ."  (BRAN)" .BRAN
      ELSE ( [a] a+4 cfa ) DUP (NEXT) =
       IF DROP ."  (NEXT)" .BRAN
       ELSE DROP ( [a] a+4 )
       THEN
      THEN
     THEN
    THEN
   THEN ( [a] a' )
  ;
: CALL? ( [a] -- f ) INS_CALL = ; 
: JMP? ( [a] -- f ) INS_JUMP = ; 
: ADR> ( [a] -- cfa )  2* ;
: RCALL? ( [a] -- f ) $F000 AND $D000 = ; 
: RJMP? ( [a] -- f ) $F000 AND $C000 = ; 
: RET? ( [a] -- f ) INS_RET = ; 
: RADR> ( [a] -- cfa ) $FFF AND DUP $800 AND
   IF $F000 OR 
   THEN 2* OVER + ; 
: .INS ( a -- a' f )
  DUP CR A. ( a )
  DUP_2+_SWAP_I@ ( a+2 [a] )
  DUP 5 H.R ( a+2 [a] )
  DUP CALL? DUP
  IF ( a+2 [a] CALL? ) 2 PICK I@ 5 H.R ."  CALL"
  THEN OVER JMP? DUP
  IF ( a+2 [a] CALL? JMP? ) 3 PICK I@ 5 H.R ."  JMP"
  THEN OR
  IF ( a+2 [a] )
     SWAP DUP_2+_SWAP_I@ ( [a] a+4 [a+2] ) DUP 5 H.R
     ADR> ( [a] a+4 cfa ) DUP (CON) =
     IF DROP DUP_2+_SWAP_I@ DUP 5 H.R ( [a] a+6 [a+4] )
        ."  (CON)" . SWAP EXIT ( a+6 [a] )
     THEN .NAME ( [a] a' )
     SWAP JMP? ( a' f )
  ELSE ( a+2 [a] ) DUP RCALL? DUP
     IF 6 SPACES ." RCALL"
     THEN OVER RJMP? DUP
     IF 6 SPACES ." RJMP"
     THEN OR
     IF ( a+2 [a] )
        SWAP OVER ( [a] a+2 [a] )
        RADR> ( [a] a+2 cfa ) DUP (CON) =
        IF DROP DUP_2+_SWAP_I@ DUP 5 H.R ( [a] a+6 [a+4] )
           ."  (CON)" . SWAP EXIT ( a+6 [a] )
        THEN ( [a] a+2 cfa ) DUP 2/ . .NAME ( [a] a' ) SWAP RJMP?
     ELSE ( a+2 [a] ) RET? DUP
        IF 6 SPACES ." RET"
        THEN
     THEN
  THEN ; 
: (SEE) ( cfa -- ) 
 DUP >NAME ?DUP
 IF DUP >LINK ( cfa nfa lfa ) CR
    DUP A. I@ DUP 5 H.R
    6 SPACES ." link " 2/ H. ( cfa nfa )
    DUP DUP IC@ 1F AND 2/
    FOR CR DUP A. DUP_2+_SWAP_I@ 5 H.R
    NEXT DROP ( cfa nfa )
    6 SPACES ." CODE " ICOUNT DUP 80 AND
    IF ." IMEDD+"
    THEN DUP 40 AND
    IF ." COMPO+"
    THEN 1F AND DUP DECIMAL
    <# #S #> TYPE HEX
    ." ,'" ITYPE ." '"
 THEN DUP 2/ LIMIT !
 BEGIN .INS ( a f )
   IF LIMIT @ OVER 2/ <
   ELSE 0
   THEN KEY 1B = OR
 UNTIL CR A. ; 
: SEE ' DUP >NAME IC@ DUP C0 AND
  IF CR
  THEN DUP 40 AND
  IF ."  compile-only"
  THEN 80 AND
  IF ."  immediate"
  THEN (SEE) ; 
FLUSH
\ FORGET MATCH
: MATCH ( $s a0 -- 0 | a ) \ check if substring $s at a0
  SWAP COUNT ?DUP
  IF ( a0 a1 n1 ) 1-
     FOR \ AFT ( a0 a1 )
         OVER IC@ OVER C@            ( CR .S ) XOR
         IF R> 2DROP 0 DUP >R 1- SWAP \ CR .S
         THEN SWAP 1+ SWAP 1+
     NEXT
  THEN DROP ;
\ : TEST1 BL WORD $" abcde" ICOUNT DROP MATCH . ; TEST1 abc
\ : TEST2 BL WORD $" abXde" ICOUNT DROP MATCH . ; TEST2 abc
\ : TEST3 BL WORD $" abcde" ICOUNT DROP MATCH . ; TEST3 aDb
\ : TEST4 BL WORD $" X"     ICOUNT DROP MATCH . ; TEST4 abc
  HEX
: INSTR ( $s $a -- flag ) \ check if substring $s in name $a
  ICOUNT 3F AND ROT ( a0 n0 $s )
  SWAP OVER ( a0 $s n0 $s ) C@ - ( a0 $s n0-n1 ) DUP 0<
  IF 2DROP DROP 0 EXIT
  THEN ( a0 $s n0-n1 ) >R >R >R 0 R> R> ( 0 a0 $s )
  SWAP R> ( 0 $s a0 n0-n1 )
  FOR ( 0 $s a ) 2DUP MATCH 
      IF ROT R> SWAP >R 
      THEN 1+ 
  NEXT 2DROP ;
\ : TEST1 BL WORD $" abcde" INSTR . ; TEST1 abc
\ : TEST2 BL WORD $" abcde" INSTR . ; TEST2 de
\ : TEST3 BL WORD $" abcde" INSTR . ; TEST3 aDb
\ : TEST4 BL WORD $" X"     INSTR . ; TEST4 abc
: words BL WORD
  CR CONTEXT @
  BEGIN ?DUP
  WHILE \ CR .S CR OVER COUNT TYPE DUP .ID 
     2DUP INSTR
     IF DUP .ID
     THEN >LINK I@
  REPEAT DROP ; 
\ words DU
HEX
: PIN>BITM ( PIN -- BITM ) 1 SWAP FOR AFT 2* THEN NEXT ;
: PB ( PIN -- BITM ADDR ) PIN>BITM $23 ;
: PC ( PIN -- BITM ADDR ) PIN>BITM $26 ;
: PD ( PIN -- BITM ADDR ) PIN>BITM $29 ;
: DIGITALREAD ( BITM ADDR -- flag ) C@ AND ; 
: SET_BITS ( BITM ADDR -- ) >R        R@ C@  OR R> C! ;
: CLR_BITS ( BITS ADDR -- ) >R INVERT R@ C@ AND R> C! ;
: INPUT  ( BITM ADDR -- ) 1+ CLR_BITS ;   \ 輸入模式
: OUTPUT ( BITM ADDR -- ) 1+ SET_BITS ;   \ 輸出模式
: HIGH   ( BITM ADDR -- ) 2+ SET_BITS ;   \ 高電位
: LOW    ( BITM ADDR -- ) 2+ CLR_BITS ;   \ 低電位
$44 CONSTANT TCCR0A \ Timer/Counter Control Register A
$45 CONSTANT TCCR0B \ Timer/Counter Control Register B
$47 CONSTANT OCR0A  \ Output Compare Register A
$48 CONSTANT OCR0B  \ Output Compare Register B
: MS ( 毫秒數 -- ) ?DUP IF FOR AFT $1CB FOR NEXT THEN NEXT THEN ;
: PD6_PWM ( 輸出量 -- ) OCR0A C! TCCR0A C@ $83  OR TCCR0A C! 3 TCCR0B C! ;
\ 0 <= 輸出量 <= 255
: PD5_PWM ( 輸出量 -- ) OCR0B C! TCCR0A C@ $23  OR TCCR0A C! 3 TCCR0B C! ;
\ 0 <= 輸出量 <= 255
: PWM_CLOCK_SELECT ( n -- ) TCCR0B C! ; \ 1-5 CLOCK LEVEL

: PD6_PWM_IO ( FLAG -- )
  IF TCCR0A C@ $83 OR TCCR0A C! ELSE TCCR0A C@ $7F AND TCCR0A C! THEN ; 
\ PWM 開關 ( FLAG=TRUE 開 80 COM0A 模式 03 FAST PWM, FLAG=FALSE 關 80 )

: PD5_PWM_IO ( FLAG -- )
  IF TCCR0A C@ $23 OR TCCR0A C! ELSE TCCR0A C@ $DF AND TCCR0A C! THEN ;
\ PWM 開關 ( FLAG=TRUE 開 20 COM0B 模式 03 FAST PWM, FLAG=FALSE 關 20 )

: AREFOFF   00 OR ;
: AFRAVCC   40 OR ;
       : RESERVED  80 OR ;
       : INTERNAL  C0 OR ;
: ADMUXSET  7C C! ;
: ADEN      80 OR ;
: ADSC      40 OR ;
       : ADATE     20 OR ;
       : ADIF      10 OR ;
       : ADIE      08 OR ;
       : ADPS2         1 ;
       : ADPS4         2 ;
: ADPS8         3 ;
       : ADPS16        4 ;
       : ADPS32        5 ;
       : ADPS64        6 ;
       : ADPS128       7 ;
: ADCSRA        7A C! ; 
: ADHIGHBYTE    78 @  ;
       : ADLOWBYTE     79 @  ;
: ANALOGREAD ( pc?--n ) 
   AFRAVCC   ADMUXSET \ 以電源作參考
   ADPS8     ADEN  ADSC ADCSRA \ 開啟AD開始轉換
   BEGIN 7A  C@ 10 AND  UNTIL \ 等待轉換完成
   ADHIGHBYTE ; \ 讀取單 pin 類比訊號
: != = IF 0 ELSE FFFF THEN ; 
: PULSEIN  
0 = IF 1 ELSE 0 THEN  ROT ROT  
  0 >R 
BEGIN  2DUP DIGITALREAD 3 PICK !=  UNTIL 
 BEGIN 2DUP 
 R> 1+ >R 
 DIGITALREAD 3 PICK = UNTIL 2DROP DROP R>  1B *   ; 
: PULSEOUT  DUP  2 / A - SWAP 50 / 4 * -  
 ROT ROT  2DUP 2DUP LOW HIGH 2 PICK   
FOR NEXT LOW DROP ; 
: TONE_SET ( N1 N2 --  ) \ 頻率震動
 ( N1 N2 相乘換算後送入計數器 產生該頻率震盪 )
 0  0 84 C! 85 C!
 A  81 C! 
 M* F M/MOD SWAP DROP >R 7FFF 2 M*  R> 
      M/MOD DUP  8A   !  88   ! DROP  ;
: KHZ ( -- 1000 ) $3E8   ; 
: HZ ( -- 1 ) 1 ; 
: PB1_TONE_IO ( flag --  ) \ 0 關閉 非0 開啟 TONE 
 IF   80 @ 40 OR  80 C! 
 ELSE 80 @ B0 AND 80 C!  
 THEN ; 
: PB2_TONE_IO ( flag --  )
 IF      80 @ 10 OR  80 C! 
 ELSE 80 @ E0 AND 80 C!  
 THEN ; 
REMEMBER
DECIMAL

HEX
VARIABLE TEMP 
\ TEMP 
: IDUMP BASE @ >R HEX 
( add -- )DUP ( add add ) 0 TEMP ! 
\ 印出 2    4    6    8    A    C    E 
 CR 8 SPACES 7 FOR  DUP 000F AND  5 .R 2+ NEXT DROP ( add ) \ 
\ 印出 EF0123456789ABCD
\ DUP  1- 2 SPACES F FOR  DUP 000F AND -1 .R 1+ NEXT DROP ( add ) 
 CR  7 
FOR  DUP >R ( ADD ) 
\ 印出 3330=> 外迴圈
     DUP 5 .R ." => "  7
\ 印出 940E 3D10 611A A4A4 E5A4 72A6 EAA6 FAB4 內迴圈
     FOR  DUP   I@  DUP F000 AND 
      IF  . ELSE 5 .R  THEN 2+ 
     NEXT 2 SPACES ( ADD' )

\ 印出   ____=_a中文字_串測  
 R> TEMP @
 IF 1+ 5F EMIT THEN
\ 檢查中文到換行時 中文 ASCII LOW BYTE 是否重複，如重複則印出空白
   F  FOR DUP  IC@ ( ADD' ADD" C )  
         DUP 20 7E WITHIN 
         IF  EMIT   
         ELSE DUP A1 FE WITHIN 
              \ 若中文 印出 2 BYTE 否則印底線
              IF EMIT 1+ DUP IC@ EMIT R> 1- >R
              ELSE ." _" DROP 
              THEN 
         THEN  1+ R@  TEMP !       
      NEXT DROP ( ADD' ) CR
NEXT DROP R> BASE !  ; 
     \  ' WORDS 9 - IDUMP 
     \  ' WORDS 8 - IDUMP
     \ : TEST ." a中文字串測試檢查長度 abcd" ;
     \ ' TEST IDUMP
HEX
\ TEMP 
: DUMP BASE @ >R HEX 
( add -- )DUP ( add add ) 0 TEMP ! 
\ 印出 2    4    6    8    A    C    E 
 CR 8 SPACES 7 FOR  DUP 000F AND  5 .R 2+ NEXT DROP ( add ) \ 
\ 印出 EF0123456789ABCD
\ DUP  1- 2 SPACES F FOR  DUP 000F AND -1 .R 1+ NEXT DROP ( add ) 
 CR  7 
FOR  DUP >R ( ADD ) 
\ 印出 3330=> 外迴圈
     DUP 5 .R ." => "  7
\ 印出 940E 3D10 611A A4A4 E5A4 72A6 EAA6 FAB4 內迴圈
     FOR  DUP   @  DUP F000 AND 
      IF  . ELSE 5 .R  THEN 2+ 
     NEXT 2 SPACES ( ADD' )
\ 印出   ____=_a中文字_串測  
 R> TEMP @
 IF 1+ 5F EMIT THEN
\ 檢查中文到換行時 中文 ASCII LOW BYTE 是否重複，如重複則印出空白
   F  FOR DUP  C@ ( ADD' ADD" C )  
         DUP 20 7E WITHIN 
         IF  EMIT   
         ELSE DUP A1 FE WITHIN 
              \ 若中文 印出 2 BYTE 否則印底線
              IF EMIT 1+ DUP C@ EMIT R> 1- >R
              ELSE ." _" DROP 
              THEN 
         THEN  1+ R@  TEMP !       
      NEXT DROP ( ADD' ) CR
NEXT DROP R> BASE !  ; 

: I! ( n addr -- ) 
DUP DUP 1-  200 WITHIN   \ MAO SECOND DUP AND 1+ WILL BE CHANGE 
IF \ MAO
I!
ELSE  \ MAO
CR ." ERROR#03 : 系統區域禁止寫入!" CR  2DROP
THEN
 ;
: SEALED CR ." ERROR#01 : 禁止移除系統字!" CR  ; \ MAO
: CALL DUP ; \ MAKEING A HEAD TO CALL I! 

' I! 1E + I@ ' CALL 2+ I! FLUSH   \ MAKE TEMP  I! 
' SEALED 1+ ' FORGET  C + I! \ MAO CHANGE FFFF TO  SEALED ADDRESS
' SEALED 2/ ' FORGET CA + I! \ MAO SHOW SEALED MESSAGE CHANGE CR
' CP 2/ ' I! 6 + CALL \ LOCK I!
'  @ 2/ ' I! A + CALL \ LOCK I! 
 FLUSH 
FORGET CALL     \   DELETE TEMP I! 

DECIMAL 
REMEMBER
\  === END === 
