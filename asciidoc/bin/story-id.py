#!/usr/bin/env python2

from __future__ import print_function

import os
import random
import sys

MAX_LEN = 9
ALPHABET='0123456789abcdefghijklmnopqrstuvwxyz'
LEN_ALPHA=len(ALPHABET)

urandom = random.SystemRandom()
rnum = urandom.randint(0, LEN_ALPHA**MAX_LEN-1)

def base62(a):
	baseit = (
		lambda a=a, b=LEN_ALPHA: (not a) and '0' or
		baseit(a-a%b, b*LEN_ALPHA) + ALPHABET[a%b%(LEN_ALPHA-1) or -1*bool(a%b)]
	)
	return baseit()

#http://stackoverflow.com/a/36875787

result = base62(rnum).lstrip('0').zfill(MAX_LEN)

if len(sys.argv) == 2:
	print(result, end='')
else:
	print(result)
