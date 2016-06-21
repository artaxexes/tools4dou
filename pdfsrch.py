#!/usr/bin/python
# -*- coding: utf-8 -*-

import re
from sys import argv

filename = argv[1]
pattern = r'EXONERAR(, a pedido,)? (.*?) do cargo de (.*?), código (DAS \d\.\d\d\d)\. ?'
regexp = re.compile(pattern)

# read file content
try:
	fo = open(filename, 'r')
	f = fo.read()
except IOError:
	print "cannot find or read the data from file", filename
	if file_is_open(fo):
		fo.close()
else:
	print "successfully open and read file", filename

# replacing line breaks
f = re.sub(r'\n', " ", f)
f = re.sub(r' {2,}', " ", f)

# find pattern
for m in regexp.finditer(f):
	if (m.group(1) == ", a pedido,"):
		requested = m.group(1)
		name = m.group(2)
		post = m.group(3)
		code = m.group(4)
	else:
		requested = "nao pedido"
		name = m.group(1)
		post = m.group(2)
		code = m.group(3)
	print "requested: %s; name: %s; post: %s; code: %s" % (requested, name, post, code)
print "end"
