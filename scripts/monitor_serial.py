import serial

COM_PORT = 'COM4'

def main():
    # Configure the serial connection
    ser = serial.Serial(
<<<<<<< HEAD:scripts/test_serial.py
        port='COM6',
=======
        port=COM_PORT,
>>>>>>> 8aacaf4afb6dd5c2531a4686f8b1d6c99865caaa:scripts/monitor_serial.py
        baudrate=31250,
        bytesize=serial.EIGHTBITS,
        parity=serial.PARITY_NONE,
        stopbits=serial.STOPBITS_ONE,
        timeout=1  # Adjust as needed for your application
    )

    try:
<<<<<<< HEAD:scripts/test_serial.py
        print("Monitoring COM6 at 31.25 kBaud. Press Ctrl+C to stop.")
=======
        print(f"Monitoring {COM_PORT} at 31.25 kBaud. Press Ctrl+C to stop.")
>>>>>>> 8aacaf4afb6dd5c2531a4686f8b1d6c99865caaa:scripts/monitor_serial.py
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
