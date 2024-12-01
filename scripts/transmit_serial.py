import serial
import sys
from load_config import *

config = load_config()

COM_PORT = config['COM_PORT']

def main(argv):
    ser = serial.Serial(
        port=COM_PORT,
        baudrate=31250,
        bytesize=serial.EIGHTBITS,
        parity=serial.PARITY_NONE,
        stopbits=serial.STOPBITS_ONE,
        timeout=1
    )

    status_byte = eval('0x90')
    data_byte_1 = eval('0x41')
    data_byte_2 = eval('0x27')
    if argv[1:]:
        status_byte = eval(f'0x{argv[1]}')
    if argv[2:]:
        data_byte_1 = eval(f'0x{argv[2]}')
    if argv[3:]:
        data_byte_2 = eval(f'0x{argv[3]}')


    message = bytes([status_byte, data_byte_1, data_byte_2])
    print(len(message))

    ser.write(message)
    data = ser.read(3)
    print(data.hex())
    ser.close()

if __name__ == "__main__":
    main(sys.argv)
