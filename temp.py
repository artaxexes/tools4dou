#!/usr/bin/python
# -*- coding: utf-8 -*-

from sys import argv
import re



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
txt1 = "EXONERAR, a pedido, FULANO FERREIRA do cargo de Presidente da República, código DAS 9.001. EXONERAR CICRANO SANTOS do cargo de Vice-presidente da República, código DAS 9.002."
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

# replacement
'''
txt1 = "Eu    estou  aqui   na                    sua  casa."
txt2 = re.sub(r' {2,}', " ", txt1)
print txt1
print txt2
'''

print "\nEOF"
