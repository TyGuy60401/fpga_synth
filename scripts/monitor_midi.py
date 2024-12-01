import rtmidi

def callback(message, data):
    print(hex(message[0][0]), message[0][1], message[0][2])


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
