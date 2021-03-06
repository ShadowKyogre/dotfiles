import datetime
import math
import pprint
from importlib import reload
import random
import rlcompleter, readline
import re
import sys

try:
	import dateutil
except ImportError as e:
	pass

try:
	import swisseph
except ImportError as e:
	pass

sys.displayhook = pprint.pprint
# readline.parse_and_bind('tab: complete')

try:
	from jedi.utils import setup_readline
	setup_readline()
except ImportError:
	# Fallback to the stdlib readline completer if it is installed.
	# Taken from http://docs.python.org/2/library/rlcompleter.html
	print("Jedi is not installed, falling back to readline")
	try:
		import readline
		import rlcompleter
		readline.parse_and_bind("tab: complete")
	except ImportError:
		print("Readline is not installed either. No tab completion is enabled.")

import importlib as ilib

def sample_multi(entries, min=0, max=None):
	if max is None:
		max = len(entries)
	this_many = random.randint(min,max)
	return random.sample(entries, this_many)

def mat_list(string):
	"""
	Takes a MATLAB style string and translates it into an appropriate array.
	replaces _convert_from_string in here: https://github.com/numpy/numpy/blob/master/numpy/matrixlib/defmatrix.py
	"""
	el_sep = re.compile(r',|, | ')
	result = []
	for sublist in re.split(r'\n|;',string.strip()):
		result.append([ complex(s) for s in el_sep.split(sublist) ])
		if len(result) > 0:
			if len(result[0]) != len(result[-1]):
				raise ValueError("Array given is uneven!")
	if len(result) == 1:
		return result[0]
	else:
		return result
