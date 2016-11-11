#!/usr/bin/python3
# -*- coding: utf-8 -*-

import scraper
import datetime
from optparse import OptionParser

def script_args():
  parser = OptionParser()
  parser.add_option('-d', '--data', action = 'store', type = 'string', dest = 'dt', help = 'data ou intervalo de data, i.e. dd-mm-yyyy ou dd-mm-yyyy:dd-mm-yyyy')
  parser.add_option('-j', '--jornal', action = 'store', type = 'int', dest = 'jn', help = 'numero entre 0 e 3 representando o numero do jornal, obs: 0 para todos os jornais')
  return parser.parse_args()

def val_dt(dt):
  try:
    msk = datetime.datetime.strptime(dt, '%d-%m-%Y')
  except ValueError:
    print('formato incorreto de data, deve-se usar dd-mm-yyyy')
    raise
  else:
    return msk 

def check_dt(dt):
  if len(dt) == 10 and val_dt(dt):
    return True
  try:
    dt_init = dt[0:10]
    dt_final = dt[11:21]
  except IndexError:
    print('formato incorreto de intervalo de data, deve-se usar dd-mm-yyyy:dd-mm-yyyy')
  else:
    if val_dt(dt_init) <= val_dt(dt_final):
      return True 
  return False


if __name__ == '__main__':

  (options, args) = script_args()
  if options.dt is None or options.jn is None:
    raise Exception('informe os dois parametros, data e jornal')
  if check_dt(options.dt) and options.jn in range(4):
    print('data e jornal ok')
    #pdf = scraper.DOU(2, 1, '27/05/2016')
    #pdf.to_local('pdf/')
