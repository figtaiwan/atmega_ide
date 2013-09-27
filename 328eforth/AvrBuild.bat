@ECHO OFF
"C:\Program Files (x86)\Atmel\AVR Tools\AvrAssembler2\avrasm2.exe" -S "C:\ksanapc\ide328_2\labels.tmp" -fI -W+ie -C V2E -o "C:\ksanapc\ide328_2\328eForth.hex" -d "C:\ksanapc\ide328_2\328eForth.obj" -e "C:\ksanapc\ide328_2\328eForth.eep" -m "C:\ksanapc\ide328_2\328eForth.map" -l "C:\ksanapc\ide328_2\328eForth.lst" "C:\ksanapc\ide328_2\328eForth.asm"
