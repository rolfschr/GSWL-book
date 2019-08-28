#!/usr/bin/env python3
"""
Preprocess the given markdown input.
"""

import sys
import re
import urllib


TAB = '    '


def catfile(s):
    """
    Find all occurences of 'Catfile <filepath>' and replace them by the content
    of <filepath>.
    """
    while True:
        try:
            m = next(re.finditer('\nCatxfile .*\n', s))
            filepath = s[m.start() + 9:m.end() - 1]
            with open(filepath, "r") as fh:
                content = fh.read()
                content = TAB + content.replace('\n', '\n' + TAB)
                content = content[:-len(TAB)]  # remove trailing \t
            s = ''.join([s[:m.start()+1], content, s[m.end():]])
        except StopIteration:
            break
    return s


def caturl(s):
    """
    Find all occurences of 'Caturl <url>' and replace them by the content
    of <url>.
    """
    while True:
        try:
            m = next(re.finditer('\nCaturl .*\n', s))
            url = s[m.start() + 8:m.end() - 1]
            f = urllib.urlopen(url)
            content = f.read()
            s = ''.join([s[:m.start()+1], content, s[m.end():]])
        except StopIteration:
            break
    return s


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
