#!/usr/bin/env python3
# -*- coding: utf-8 -*-

from tkinter import * 
from tkinter import ttk
from tkinter import messagebox
import os
import datetime
import scrpr4dou

class Application:

  def __init__(self, parent):
    self.parent = ttk.Frame(parent, padding='1 17 12 12')
    self.parent.grid(column=0, row=0, stick=(N, W, E, S))
    self.parent.columnconfigure(0, weight=1)
    self.parent.rowconfigure(0, weight=1)
    self.__widgets()
    for child in parent.winfo_children(): child.grid_configure(padx=5, pady=5)

  def __widgets(self):
    self.__subtitle()
    self.__lbl1()
    self.__entry1()
    self.__lbl2()
    self.__entry2()
    self.__lbl3()
    self.__combobox()
    self.__lbl4()
    self.__entry4()
    self.__lbl5()
    self.__entry5()
    self.__lbl6()
    self.__btn1()
    self.__btn2()
    self.__btn3()
    self.__lbl7()

  def __subtitle(self):
    self.lbl = ttk.Label(self.parent, text='Web Scraper para o Diário Oficial da União\n', anchor='center')
    self.lbl.grid(column=1, row=2, stick=(W, E))

  def __lbl1(self):
    self.lbl = ttk.Label(self.parent, text = 'Data inicial (padrão 00/00/0000)')
    self.lbl.grid(column=1, row=3, sticky=(W, E))
    
  def __entry1(self):
    self.entry1_value = StringVar()
    self.entry1_gui = ttk.Entry(self.parent, width=30, textvariable=self.entry1_value)
    self.entry1_gui.grid(column=1, row=4, sticky=(W, E))

  def __lbl2(self):
    self.lbl = ttk.Label(self.parent, text = 'Data final (padrão 00/00/0000)')
    self.lbl.grid(column=1, row=5, sticky=(W, E))

  def __entry2(self):
    self.entry2_value = StringVar()
    self.entry2_gui = ttk.Entry(self.parent, width=30, textvariable=self.entry2_value)
    self.entry2_gui.grid(column=1, row=6, sticky=(W, E))

  def __lbl3(self):
    self.lbl = ttk.Label(self.parent, text='NoSQL')
    self.lbl.grid(column=1, row=7, sticky=(W, E)) 

  def __combobox(self):
    self.combobox_value = StringVar()
    self.combobox_gui = ttk.Combobox(self.parent, textvariable=self.combobox_value, state='readonly')
    self.combobox_gui['values'] = ('Selecione...', 'MongoDB', 'Elasticsearch')
    self.combobox_gui.current(0)
    self.combobox_gui.grid(column=1, row=8, sticky=(W, E))

  def __lbl4(self):
    self.lbl = ttk.Label(self.parent, text='URL (padrão 0.0.0.0)')
    self.lbl.grid(column=1, row=9, sticky=(W, E))

  def __entry4(self):
    self.entry4_value = StringVar()
    self.entry4_gui = ttk.Entry(self.parent, width=30, textvariable=self.entry4_value)
    self.entry4_gui.grid(column=1, row=10, sticky=(W, E))

  def __lbl5(self):
    self.lbl = ttk.Label(self.parent, text='Porta')
    self.lbl.grid(column=1, row=11, sticky=(W, E))

  def __entry5(self):
    self.entry5_value = StringVar()
    self.entry5_gui = ttk.Entry(self.parent, width=5, textvariable=self.entry5_value)
    self.entry5_gui.grid(column=1, row=12, sticky=(W, E))

  def __lbl6(self):
    self.lbl = ttk.Label(self.parent, text='')
    self.lbl.grid(column=1, row=13, sticky=(W, E))
 
  def __btn1(self):
    self.btn1_gui = ttk.Button(self.parent, text='Baixar', command=self.__init_download)
    self.btn1_gui.grid(column=1, row=14, sticky=(W, E))

  def __btn2(self):
    self.btn2_gui = ttk.Button(self.parent, text='Inserir', command=self.__init_ingest)
    self.btn2_gui.grid(column=1, row=15, sticky=(W, E))
    self.btn2_gui.state(['disabled'])

  def __btn3(self):
    self.btn3_gui = ttk.Button(self.parent, text='Limpar', command=self.__clear_fields)
    self.btn3_gui.grid(column=1, row=16, sticky=(W, E))

  def __lbl7(self):
    self.lbl7_value = StringVar()
    self.lbl7_gui = ttk.Label(self.parent, textvariable=self.lbl7_value, anchor='center')
    self.lbl7_gui.grid(column=1, row=17, sticky=(W, E))

  def __validates(self, dt_init, dt_final, url, port):
    if re.search(r'^\d\d/\d\d/\d\d\d\d$', dt_init) and re.search(r'\d\d/\d\d/\d\d\d\d', dt_final) and re.search(r'^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}$', url) and re.search(r'^\d{1,5}$', port):
      return True
    return False

  def __clear_fields(self):
    self.combobox_gui.current(0)
    self.entry1_value.set('')
    self.entry2_value.set('')
    self.entry4_value.set('')
    self.entry5_value.set('')

  def __init_download(self):
    if not self.__validates(self.entry1_value.get(), self.entry2_value.get(), self.entry4_value.get(), self.entry5_value.get()):
      messagebox.showinfo('scrpr4dou', 'Os campos estão vazios ou não estão no padrão requerido, a saber:\n* 00/00/0000 para datas\n* http://0.0.0.0:0 para URLs\n\nExemplos:\nData inicial: 23/01/2016\nData final: 25/01/2016\nURL: http://127.0.0.1:27017')
      self.__clear_fields()
      return
    self.btn1_gui.state(['disabled'])
    self.btn2_gui.state(['disabled'])
    self.btn3_gui.state(['disabled'])
    self.entry1_gui.state(['disabled'])
    self.entry2_gui.state(['disabled'])
    self.entry4_gui.state(['disabled'])
    self.entry5_gui.state(['disabled'])
    self.combobox_gui.state(['disabled'])
    self.lbl7_value.set('\nBaixando...')
    messagebox.showinfo('scrpr4dou', 'Iniciando download, aguarde...')
    global col
    col = scrpr4dou.Collection(self.combobox_value.get(), self.entry4_value.get(), self.entry5_value.get(), self.entry1_value.get(), self.entry2_value.get())
    if col.to_local(datetime.datetime.now()):
      self.btn2_gui.state(['!disabled'])
      messagebox.showinfo('scrpr4dou', 'Download concluído')
      self.lbl7_value.set('')

  def __init_ingest(self):
    self.lbl7_value.set('Inserindo...')
    self.btn2_gui.state(['disabled'])
    if col.to_nosql():
      messagebox.showinfo('scrpr4dou', 'Inserção concluída')
    else:
      messagebox.showinfo('scrpr4dou', 'Problemas na inserção')
    self.lbl7_value.set('')
    self.__clear_fields
    self.btn1_gui.state(['!disabled'])
    self.btn2_gui.state(['!disabled'])
    self.btn3_gui.state(['!disabled'])
    self.entry1_gui.state(['!disabled'])
    self.entry2_gui.state(['!disabled'])
    self.entry4_gui.state(['!disabled'])
    self.entry5_gui.state(['!disabled'])
    self.combobox_gui.state(['!disabled'])

def show_help():
  messagebox.showinfo('scrpr4dou - Ajuda', """
  1) Insira a data inicial e a data final\n
  * para download de apenas um dia, informe-o nos dois campos\n
  2) Escolha um NoSQL caso queira armazenar o conteúdo baixado\n
  3) Informe a URL para o NoSQL\n
  4) Informe a porta para o NoSQL\n
  * MongoDB, 27017; Elastic, 9200;\n
  5) Clique em 'Baixar' e aguarde o download ser executado\n
  6) Caso tenha seguido os passos 2, 3 e 4: clique em 'Inserir' para armazenar""")

def show_about():
  messagebox.showinfo('scrpr4dou - Sobre', """
  Web Scraper específico para o Diário Oficial da União\n
  Usando Python 3.x\n\n
  Anddrei Ferreira\n
  http://github.com/artaxexes""")

if __name__ == '__main__':
  root = Tk()
  root.title('scrpr4dou')
  app = Application(root)
  
  menu_bar = Menu(root)
  menu_options = Menu(menu_bar, tearoff=0)
  menu_options.add_command(label='Ajuda', command=show_help)
  menu_options.add_command(label='Sobre', command=show_about)
  menu_options.add_separator()
  menu_options.add_command(label='Sair', command=root.quit)
  menu_bar.add_cascade(label='Opções', menu=menu_options)
  root.config(menu=menu_bar)
  
  root.mainloop()
