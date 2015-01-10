#!/usr/bin/python

import sys
import re
import urllib


TAB = '    '


def catfile(str):
    while True:
        try:
            m = re.finditer('\nCatfile .*\n', str).next()
            filename = str[m.start() + 9:m.end() - 1]
            with open(filename, "r") as fh:
                content = fh.read()
                content = TAB + content.replace('\n', '\n' + TAB)
                content = content[:-len(TAB)]  # remove trailing \t
            str = ''.join([str[:m.start()+1], content, str[m.end():]])
        except StopIteration:
            break
    return str


def caturl(str):
    while True:
        try:
            m = re.finditer('\nCaturl .*\n', str).next()
            url = str[m.start() + 8:m.end() - 1]
            f = urllib.urlopen(url)
            content = f.read()
            str = ''.join([str[:m.start()+1], content, str[m.end():]])
        except StopIteration:
            break
    return str


def preprocess(str):
    str = catfile(str)
    str = caturl(str)
    return str


def main():
    input_md = sys.argv[1]
    with open(input_md, "r") as fh:
        str = fh.read()
    str = preprocess(str)
    with open(input_md, "w") as fh:
        fh.write(str)

if __name__ == '__main__':
    main()
