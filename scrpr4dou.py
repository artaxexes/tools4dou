#!/usr/bin/python3
# -*- coding: utf-8 -*-

import os
import re
import datetime
import urllib.request
import pymongo
import elasticsearch

class Collection:

  """ set of dou pages """

  def __init__(self, nosql_name, nosql_url, date_initial, date_final):
    """ public members """
    self.nosql_name = nosql_name
    self.nosql_url = nosql_url
    self.date_initial = date_initial
    self.date_final = date_final
    """ private members """
    self.__dou_url = 'http://pesquisa.in.gov.br/imprensa'
    self.__coding = 'ISO-8859-1'
    self.__mask_type = ('dot', 'slash')


  """ private methods"""

  def __reachability(self):
    response = urllib.request.urlopen(self.__dou_url)
    if response.getcode() in list(range(200, 300)):
      return True
    return False

  def __page_number(self, journal, date):
    pages = 0
    if self.__reachability():
      url(self.__dou_url + '/jsp/visualiza/index.jsp?jornal=' + journal + '&pagina=1&data=' + date + '&captchafield=firistAccess')
      response = urllib.request.urlopen(url):
      page = response.read()
      html = page.decode(self.__coding)
      match = re.search('totalArquivos=(\d{1,4})', html)
      if match:
        pages = match.group(1)
        return pages
    return pages

  def __date_range(self):
    begin = datetime.date(int(self.date_initial[6:10]), int(self.date_initial[3:5]), int(self.dt_init[0:2]))
    end = datetime.date(int(self.dt_final[6:10]), int(self.dt_final[3:5]), int(self.dt_final[0:2]))
    period = []
    if begin < end:
      for day in range((end - begin).days + 1):
        date = begin + datetime.timedelta(day)
        period.append((self.__date_time_mask(date, self.__mask_type[1]), date.weekday()))
    return period 

  def __date_time_mask(date_time, mask_type):
    if mask_type == 'dot':
      return date_time.strftime('%d.%m.%Y.%Hh%M%S')
    return date_time.strftime('%d/%m/%Y')



  """ public methods """

  def to_local(self, path):
    folder = self.__date_time_mask(path, self.__mask_type[0])
    os.mkdir(folder)
    days = self.__date_range()
    for day in days:
      if day[1] <= 4:
        for journal in range(1, 4):
          pages = self.__page_number(journal, day[0])
          for page in range(1, pages + 1):
            jn = str(journal)
            pg = str(page)
            url = self.__dou_url + '/servlet/INPDFViewer?jornal=' + jn + '&pagina=' + pg + '&data=' + day + '&captchafield=firistAccess'
            filepath = folder + '/' + jn + '.' + pg + '.' + self.__date_time_mask(day, self.__masktype[0])
            print('savingi ' + filepath + ' intoi ' + folder)
            #urllib.request.urlretrieve(url, filepath)
