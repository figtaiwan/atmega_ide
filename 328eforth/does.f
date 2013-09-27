\ does.f 20130920  TABLE DOES CON DEFER

: i! $1FF 2* EXECUTE ;
: doTABLE R> 2* ; \ FORGET TABLE
: TABLE TOKEN $,n OVERT [ ' doTABLE 2/ ] LITERAL call, FLUSH ;
\ FORGET DOES
: DOES R> LAST @ NAME> 2+ i! FLUSH ;
: CON TABLE , DOES R> 2* I@ ;
  2 CON TWO
: NOOP ; \ FORGET DEFER
: DEFER TABLE [ ' NOOP ] LITERAL , DOES R> 2* I@ EXECUTE ;
  DEFER XXX
: IS ( cfa <defer> -- ) ' 2+ 2+ i! FLUSH ;
: XXX1 ;
' XXX1 IS XXX
: XXX2 ." XXX2" ;
' XXX2 IS XXX

\ : SBI ( b a -- ) 8 * OR $9A00 OR , ;
\ : CBI ( b a -- ) 8 * OR $9800 OR , ;
\ FORGET c8a5b3:
: c8a5b3:   ( c <ins> -- ) TABLE , DOES ( b a -- )
  $1F AND 8 * OR
  R> 2* I@ OR , ;
$9A00 c8a5b3: SBI  $9800 c8a5b3: CBI

: CODE TOKEN $,n OVERT ; \ FORGET END-CODE
: END-CODE $9508 , FLUSH ;
\ FORGET INIT
CODE INIT ( b a -- ) 5 $24 SBI END-CODE
CODE HI ( b a -- ) 5 $25 SBI END-CODE
CODE LO ( b a -- ) 5 $25 CBI END-CODE
REMEMBER
INIT HI 1000 MS LO

: c4k4d4k4: ( c <ins> -- ) TABLE , DOES ( k d -- )
  $0F AND 16 * OVER $0F AND OR SWAP $F0 16 * OR
  R> 2* I@ OR , ;
$7000 c4k4d4k4: ANDI $5000 c4k4d4k4: SUBI $6000 c4k4d4k4: ORI
$3000 c4k4d4k4: CPI  $E000 c4k4d4k4: LDI
