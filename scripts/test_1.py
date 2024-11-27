import numpy as np
import sounddevice as sd
import matplotlib.pyplot as plt

def my_hex(x):
    x_str = hex(x).split('x')[1]
    if len(x_str) > 4:
        return ""
    return 'x"' + '0' * (4 - len(x_str)) + x_str + '"'

def clk_cycles():
    # base note is C4 = midi 60 = 261.626 Hz = 382225 clk cycles
    clk_cycles_c0 = 191108
    for i in range(-1, 11):
        clk_cycles = round(clk_cycles_c0 / (2 ** (i+1)))
        freq = 100e6 / clk_cycles / 64
        print(f"C_{i}", f"{clk_cycles} CLK", f"{freq} Hz", sep='\t')

    low_note_frequencies = [8.176, 8.662, 9.177, 9.723, 10.301, 10.913, 11.562, 12.25, 12.978, 13.75, 14.568, 15.434]
    clk_cycles_list = []
    note_frequencies_list = []
    for i in range(-1, 11):
        for freq in low_note_frequencies:
            oct_freq = freq * (2 ** (i + 1))
            full_clk = 100e6 / oct_freq
            clk_64 = int(full_clk / 64)
            clk_cycles_list.append(clk_64)
            note_frequencies_list.append(100e6 / clk_64 / 64)
    print(clk_cycles_list[:128])
    print(len(clk_cycles_list[:128]))

    print(*['  '] + [f"{note:^9}" for note in ['C', 'C#', 'D', 'D#', 'E', 'F', 'F#', 'G', 'G#', 'A', 'A#', 'B']])
    n = 0
    while n < len(clk_cycles_list):
        print(*[f"{my_hex(clk):>9}," for clk in clk_cycles_list[n:n+12]], sep='')
        n += 12

    print("")
    print(*['  '] + [f"{note:^9}" for note in ['C', 'C#', 'D', 'D#', 'E', 'F', 'F#', 'G', 'G#', 'A', 'A#', 'B']])
    n = 0
    while n < len(note_frequencies_list):
        note_strings = [f"{n // 12 - 1:<2}"] + [f"{note_frequencies_list[ni]:>10.3f}" for ni in range(n, n+12)]
        print(*note_strings, sep='')
        n += 12

    # start_note = {
    #     "octave": 4,
    #     "clk_cycles": 5972
    # }
    # for i in range(-1, 11):
    #     print(i - start_note['octave'])
    # 

def sine(t, f):
    return np.sin(2*np.pi * f * t)

def square(t, f):
    return 1 if sine(t, f) > 0 else -1

def triangle(t, f):
    period = 1 / f
    t_corrected = t / period % 1
    if t_corrected < 0.25:
        return t_corrected / 0.25
    elif t_corrected < 0.5:
        return (0.5 - t_corrected) / 0.25
    elif t_corrected < 0.75:
        return -(t_corrected - 0.5) / 0.25
    return (t_corrected - 0.75) / 0.25 - 1


def discrete_wave(wave, n):
    n_vals = list(range(n))
    wave_vals = [wave(ni, 1/n) for ni in n_vals]
    plt.plot(n_vals, wave_vals, '.')
    plt.show()
    return wave_vals

def waves():
    # wave_vals = discrete_wave(sine, 16)
    # signal = []
    # for _ in range(1000):
    #     signal += wave_vals
    # # t_vals = [t for t in range(len(signal))]
    # print(wave_vals[:100])
    # sd.play(wave_vals, samplerate=192.1e3)
    # t_vals = np.linspace(0, 1, 44100)
    # sine_vals = [sine(t, 1000) for t in t_vals]
    # print(sine_vals)
    # sd.play(sine_vals, 44.1e3)
    # sd.wait()
    #
    # exit()
    t_vals = np.linspace(5, 10)
    f_note = 1/5
    sine_vals     = [sine(t, f_note)     for t in t_vals]
    square_vals   = [square(t, f_note)   for t in t_vals]
    triangle_vals = [triangle(t, f_note) for t in t_vals]

    fig = plt.figure()
    ax = plt.axes()
    fig.add_axes(ax)
    ax.plot(t_vals, sine_vals)
    ax.plot(t_vals, square_vals)
    ax.plot(t_vals, triangle_vals)
    plt.show()

def amplitudes():
    t_vals = np.linspace(0, 1, 64)
    sine_vals = np.sin(t_vals * 2 * np.pi) * 2 ** 12 / 2 + 4096 / 2
    sine_ints = np.array([int(sine_val) for sine_val in sine_vals])

    print(sine_ints)

    triangle_vals = np.array([int(triangle(t, 1) * 4096 / 2 + 4096/2) for t in t_vals])
    print(triangle_vals)

def conversions():
    vals = list(range(128))
    converted = []
    lut = {
        0: 59,
        1: 97,
        2: 99,
        4: 100,
        5: 101,
        6: 102,
        7: 103,
        8: 104,
        9: 106,
        10: 107,
        11: 108,
        12: 111,
        13: 112,
        14: 115,
        15: 116,
        16: 117,
        17: 119,
        18: 120,
        19: 121,
        20: 122
    }
    for val in vals:
        if val in lut.keys():
            converted.append(lut[val])
        else:
            converted.append(val)
    n = 0
    while n < len(converted):
        print(*[f"{val:>3}," for val in converted[n:n+12]])
        n += 12


def main():
    clk_cycles()
    # amplitudes()
    conversions()

if __name__ == "__main__":
    main()

