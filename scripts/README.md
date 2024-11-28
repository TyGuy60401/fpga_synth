# SCRIPTS

You can put any scripts that you want in here.

## transmit_serial.py

Use transmit_serial.py to transmit three bytes at a time to the board.
For example:

python transmit_serial.py 90 40 30

That will turn a note on in MIDI channel 1 (address/tone
0). It is note 0x40 (E4) at velocity 0x30 (48).

## monitor_serial.py

Use this script and it will read from the serial port in groups of 3
bytes and print them out to the console.
