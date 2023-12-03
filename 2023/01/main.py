
import re

from functools import reduce


written_numbers = [
    'one', 'two', 'three', 'four', 'five',
    'six', 'seven', 'eight', 'nine'
]

patches = [
    ('eightwone', 'eighttwoone'),
    ('oneight', 'oneeight'),
    ('twone', 'twoone'),
    ('threeight', 'threeeight'),
    ('fiveight', 'fiveeight'),
    ('sevenine', 'sevennive'),
    ('eightwo', 'eighttwo')
]

regex_string = '|'.join(written_numbers) + '|\d'


def extract_numbers(line: str) -> (str, str):
    numbers = re.findall(regex_string, line)

    return numbers[0], numbers[-1]


def handle_line(line: str) -> int:
    line = patch_line(line)
    numbers = extract_numbers(line)
    digits = map(text_to_number, numbers)
    string_number = ''.join(digits)

    return int(string_number)


def patch_line(line: str) -> str:
    return reduce(lambda line, patch: line.replace(patch[0], patch[1]),
                  patches, line)


def text_to_number(text: str) -> str:
    if text not in written_numbers:
        return text

    written_number_index = written_numbers.index(text)

    return str(written_number_index + 1)


lines = open('input.txt').readlines()
calibration_values = map(handle_line, lines)

print(sum(calibration_values))
