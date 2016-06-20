#!/usr/bin/python
import re
from sys import argv

filename = argv[1]
pattern = r'\n'

try:
	txt = open(filename).read()
except IOError as e:
	print "I/O error({0}): {1}".format(e.errno, e.strerror)

regexp = re.compile(pattern)

# sub
inline = re.sub(r'\n', ' ', txt)
inline = re.sub(r' {2,}', ' ', inline)
print inline

'''
# finditter
m = regexp.finditer(txt)
if m:
	for match in m:
		print match.group()
else:
	print "Nothing found"
'''
