#!/usr/bin/env python

import sys
import string
import random

def generate_str(length=6, chars=string.ascii_letters + string.digits):
    return ''.join(random.choice(chars) for _ in range(length))

def main(argv):
    if len(argv) > 0:
        argv[0] = int(argv[0])
    id = generate_str(*argv)
    print 'Generated String:', id

if __name__ == "__main__":
    main(sys.argv[1:])
