import serial
import sys

COM_PORT = 'COM4'

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
    if sys.argv[1:]:
        status_byte = eval(f'0x{sys.argv[1]}')
    if sys.argv[2:]:
        data_byte_1 = eval(f'0x{sys.argv[2]}')
    if sys.argv[3:]:
        data_byte_2 = eval(f'0x{sys.argv[3]}')




    message = bytes([status_byte, 0x40, 0x25])
    print(len(message))

    ser.write(message)
    data = ser.read(3)
    print(data.hex())
    ser.close()

if __name__ == "__main__":
    main(sys.argv)