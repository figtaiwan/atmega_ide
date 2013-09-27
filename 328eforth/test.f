\ C:\ksanapc\atmega_ide\328eforth\test.f
: t 8
  FOR CR 9 R@ - 8
    FOR DUP 9 R@ - x
    NEXT DROP
  NEXT ;
  t 
\ test.f
DECIMAL
\ FORGET V
VARIABLE V 1000 V !
5 PB OUTPUT
: W V @ MS ;
: H 5 PB HIGH ;
: L 5 PB LOW ;
: F H W L W ;
: .s CR DEPTH DUP ." DEPTH" . ?DUP IF ." --" 1- FOR R@ PICK . NEXT THEN ;
\ FORGET Z
: Z
  BEGIN  F 6 EMIT ?KEY DUP
    IF          ( k true ) OVER 17 =  \ is key ^Q  quick
      IF    .s  ( k true ) V @ 2/ ."  quick as" DUP . V ! 2DROP 0
      ELSE      ( k true ) OVER 26 =  \ is key ^Z  easy
        IF  .s  ( k true ) V @ 2*  ."  easy as" DUP . V ! 2DROP 0
        ELSE    ( k true ) DROP 27 =  \ is key esc escape
        THEN    ( flag   )
      THEN
    THEN
  UNTIL
; \ Z
