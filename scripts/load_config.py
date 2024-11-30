def remove_newline(s):
    if s[-1] == '\n':
        return s[:-1]
    return s

def load_config(config_file='.config'):
    config_dict = {}
    with open(config_file, 'r') as config:
        for line in config.readlines():
            split_line = remove_newline(line).split('=')
            config_dict[split_line[0]] = split_line[1]
    return config_dict


def main():
    print(load_config())


if __name__ == "__main__":
    main()
