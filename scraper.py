# -*- coding: utf-8 -*-

import urllib.request

class DOU():
  def __init__(self, journal, page, date):
    self.journal = journal
    self.page = page
    self.date = date
    self.url = 'http://pesquisa.in.gov.br/imprensa/servlet/INPDFViewer?jornal={0}&pagina={1}&data={2}&captchafield=firistAccess'.format(journal, page, date)

  def pdf_to_txt(self):
    print('pdf to txt')

  def check(self):
    f = urllib.request.urlopen(self.url)
    if f.info().__getitem__('Content-Type') == 'application/pdf':
      return True
    return False

  def to_local(self, folder):
    if self.check():
      path = folder + '{2}.{1}.{0}.jornal{3}pagina{4}.pdf'.format(self.date[0:2], self.date[3:5], self.date[6:11], self.journal, self.page)
      urllib.request.urlretrieve(self.url, path)

  def to_mongodb(self, url):
    print('to mongodb')

  def to_elastic(self, url):
    print('to elastic')
