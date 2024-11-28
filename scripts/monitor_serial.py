import serial

COM_PORT = 'COM4'

def main():
    # Configure the serial connection
    ser = serial.Serial(
        port=COM_PORT,
        baudrate=31250,
        bytesize=serial.EIGHTBITS,
        parity=serial.PARITY_NONE,
        stopbits=serial.STOPBITS_ONE,
        timeout=1  # Adjust as needed for your application
    )

    try:
        print(f"Monitoring {COM_PORT} at 31.25 kBaud. Press Ctrl+C to stop.")
        while True:
            # Read data from the serial port
            data = ser.read(3)  # Read up to 16 bytes at a time (adjust as needed)
            if data:
                # Convert the data to hexadecimal format
                hex_output = ' '.join(f'{byte:02X}' for byte in data)
                print(hex_output)
    except KeyboardInterrupt:
        print("\nExiting.")
    finally:
        # Close the serial port
        ser.close()

if __name__ == "__main__":
    main()
