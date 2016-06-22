#!/usr/bin/python
# -*- coding: utf-8 -*-

import sys
import re
import os



# basic test
'''
files = []
tests = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
for n in tests:
	if n % 2 == 0:
		files.append(n)
print files
'''

# regexp test
'''
txt1 = "Ánddrei está no chão da casa do pai dele agora. Gabriele está no teto da casa do vizinho agora."
pttr = r'(.*?) está no (.*?) da casa do (.*?) agora\. ?'
txt2 = re.findall(pttr, txt1)
for x in txt2:
	for y in x:
		print y.decode('utf-8')
'''

# regexp
'''
txt1 = "EXONERAR FULANO FERREIRA do cargo de Presidente da República, código DAS 9.001. EXONERAR, a pedido, CICRANO SANTOS do cargo de Vice-presidente da República, código DAS 9.002."
pttr = r'EXONERAR(, a pedido,)? (.*?) do cargo de (.*?), código (DAS \d\.\d\d\d)\. ?'
txt2 = re.findall(pttr, txt1)
for x in txt2:
	for y in x:
		y = y.decode('utf-8')
		if (y == ", a pedido,"):
			print "a pedido"
		elif not y:
			print "nao pedido"
		else:
			print y
'''

# regexp 2
'''
pttr = r'EXONERAR(, a pedido,)? (.*?) do cargo de (.*?), código (DAS \d\d\d\.\d)\.'
fo = open('txt/2016_06_21_dou0002_page001.txt', 'r')
txt1 = fo.read()
txt1 = re.sub(r'\n', ' ', txt1)
txt1 = re.sub(r' {2,}', ' ', txt1)
txt2 = re.findall(pttr, txt1)
for m in txt2:
	for n in m:
		n = n.decode('utf-8')
		if (n == ", a pedido,"):
			print "a pedido"
		elif not n:
			print "nao pedido"
		else:
			print n
'''

# regexp 3 
'''
#for m in regexp.finditer(txt):
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
'''

# replacement
'''
txt1 = "Eu estou  aqui   na    sua     casa."
txt2 = re.sub(r' {2,}', " ", txt1)
print txt1
print txt2
'''

# files list
'''
try:
	path = argv[1]
	files = os.listdir(path)
	files.sort()
	for f in files:
		if not os.path.isdir(path + f):
			print f
except OSError as e:
	print "OSError({0}): {1}".format(e.errno, e.strerror)
'''

print "\nEOF"
