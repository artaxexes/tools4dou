#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import os
import re
import datetime
import urllib.request
import pymongo
import elasticsearch
import PyPDF2

class Collection:

  """ set of dou pages """

  def __init__(self, nosql_name, nosql_url, nosql_port, date_initial, date_final):
    """ private members """
    self.__nosql_name = nosql_name
    self.__nosql_url = nosql_url
    self.__nosql_port = nosql_port
    self.__date_initial = date_initial
    self.__date_final = date_final
    self.__dou_url = 'http://pesquisa.in.gov.br/imprensa'
    self.__coding = 'ISO-8859-1'
    self.__mask_type = ('dot_folder', 'slash', 'dot_file')


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

  def __str_to_date(self, str_date):
    return datetime.date(int(str_date[6:10]), int(str_date[3:5]), int(str_date[0:2]))

  def __date_range(self, begin, end):
    begin_date = self.__str_to_date(begin)
    end_date = self.__str_to_date(end)
    period = []
    if begin_date <= end_date:
      for day in range((end_date - begin_date).days + 1):
        date = begin_date + datetime.timedelta(day)
        if date.weekday() <= 4:
          period.append(self.__date_time_mask(date, self.__mask_type[1]))
    return period

  def __date_time_mask(self, date_time, mask_type):
    if mask_type == 'dot_folder':
      return date_time.strftime('%Y.%m.%d.%Hh%Mm%Ss')
    elif mask_type == 'dot_file':
      return date_time.strftime('%Y.%m.%d')
    return date_time.strftime('%d/%m/%Y')

  def __mount_url(self, begin, end):
    days = self.__date_range(begin, end)
    urls = []
    for d in days:
        for j in range(1, 4):
          pages = self.__page_number(str(j), d)
          for p in range(1, (pages + 1)):
            urls.append((d, str(j), str(p), self.__dou_url + '/servlet/INPDFViewer?jornal=' + str(j) + '&pagina=' + str(p) + '&data=' + d + '&captchafield=firistAccess'))
    return urls



  """ public methods """

  def to_local(self, path):
    global folder
    folder  = self.__date_time_mask(path, self.__mask_type[0])
    os.mkdir(folder)
    urls = self.__mount_url(self.__date_initial, self.__date_final)
    for url in urls:
      filepath = folder + '/' + self.__date_time_mask(self.__str_to_date(url[0]), self.__mask_type[2]) + 'cad' + url[1] + 'pg' + url[2] + '.pdf'
      urllib.request.urlretrieve(url[3], filepath)
    return True

  def to_nosql(self):
    files = os.listdir(folder)
    if self.__nosql_name == 'MongoDB':
      # mongodb
      mongo_conf = (self.__nosql_url, int(self.__nosql_port), 'dou', folder)
      client = pymongo.MongoClient(mongo_conf[0], mongo_conf[1])
      db = client[mongo_conf[2]]
      collection = db[mongo_conf[3]]
      # files
      for f in files:
        pdf = PyPDF2.PdfFileReader(folder + '/' + f)
        content = pdf.getPage(0).extractText()
        result = collection.insert_one({'file':f, 'folder':folder, 'content':content})
      client.close()
      return True
    elif self.__nosql_name == 'Elasticsearch':
      return False
