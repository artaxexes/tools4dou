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
      url = self.__dou_url + '/jsp/visualiza/index.jsp?jornal=' + journal + '&pagina=1&data=' + date + '&captchafield=firistAccess'
      response = urllib.request.urlopen(url)
      page = response.read()
      html = page.decode(self.__coding)
      match = re.search('totalArquivos=(\d{1,4})', html)
      if match:
        pages = int(match.group(1))
    return pages

  def __date_to_str(self, date):
    return '{:02}/{:02}/{:04}'.format(date.day, date.month, date.year)

  def __str_to_date(self, date):
    return datetime.date(int(self.date_initial[6:10]), int(self.date_initial[3:5]), int(self.date_initial[0:2]))

  def __date_range(self, begin_str, end_str):
    begin = self.__str_to_date(begin_str)
    end = self.__str_to_date(end_str)
    period = []
    if begin < end:
      for day in range((end - begin).days + 1):
        date = begin + datetime.timedelta(day)
        period.append((self.__date_time_mask(date, self.__mask_type[1]), date.weekday()))
    return period 

  def __date_time_mask(self, date_time, mask_type):
    if mask_type == 'dot':
      return date_time.strftime('%Y.%m.%d.%Hh%Mm%Ss')
    return date_time.strftime('%d/%m/%Y')



  """ public methods """

  def to_local(self, path):
    folder = self.__date_time_mask(path, self.__mask_type[0])
    os.mkdir(folder)
    days = self.__date_range(self.date_initial, self.date_final)
    for day in days:
      #if date.weekday() <= 4:
      print(day)
      """
        for journal in range(1, 4):
          pages = self.__page_number(str(journal), day[0])
          print(type(pages))
          for page in range(1, (pages + 1)):
            jn = str(journal)
            pg = str(page)
            url = self.__dou_url + '/servlet/INPDFViewer?jornal=' + jn + '&pagina=' + pg + '&data=' + day + '&captchafield=firistAccess'
            filepath = folder + '/' + jn + '.' + pg + '.' + self.__date_time_mask(day, self.__masktype[0])
            print('saving ' + filepath + ' into ' + folder)
            #urllib.request.urlretrieve(url, filepath)
      """
