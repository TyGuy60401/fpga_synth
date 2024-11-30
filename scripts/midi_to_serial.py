import rtmidi
import serial

from load_config import *
config = load_config()
COM_PORT = config['COM_PORT']

ser = serial.Serial(
    port=COM_PORT,
    baudrate=31250,
    bytesize=serial.EIGHTBITS,
    parity=serial.PARITY_NONE,
    stopbits=serial.STOPBITS_ONE,
    timeout=1
)

def callback(message, data):
    print(hex(message[0][0]), message[0][1], message[0][2])
    ser_message = bytes(message[0][0], message[0][1], message[0][2])
    ser.write(ser_message)

midiin = rtmidi.MidiIn()
available_ports = midiin.get_ports()
if available_ports:
    print("Choose a MIDI port")
    for i, port  in enumerate(available_ports):
        print(f"{i}:\t", port)

    try:
        choice = int(input(">> "))
        midiin.open_port(0)
    except Exception as e:
        print(e)
        print("Exiting...")
        exit()
else:
    midiin.open_virtual_port("My virtual input")

midiin.set_callback(callback)

print("Waiting for MIDI input...\nPress Ctrl+C to exit.")
try:
    while True:
        pass  # Keep the script running
except KeyboardInterrupt:
    print("Exiting...")
finally:
    midiin.close_port()
