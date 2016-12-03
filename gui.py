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
    self.parent = ttk.Frame(parent, padding='1 8 12 12')
    self.parent.grid(column=0, row=0, stick=(N, W, E, S))
    self.parent.columnconfigure(0, weight=1)
    self.parent.rowconfigure(0, weight=1)
    for child in parent.winfo_children(): child.grid_configure(padx=5, pady=5)
    self.entry2()
    self.entry3()
    self.btn2()
    self.entry1()
    self.combobox()
    self.btn3()
    self.btn1()
    self.label()
    
  def entry2(self):
    self.entry2_value = StringVar()
    self.entry2_gui = ttk.Entry(self.parent, width=30, textvariable=self.entry2_value)
    self.entry2_gui.insert(0, 'formato 00/00/0000, data inicial')
    self.entry2_gui.bind('<Button-1>', lambda e: self.entry2_gui.delete(0, 'end')) 
    self.entry2_gui.grid(column=1, row=1, sticky=(W, E))

  def entry3(self):
    self.entry3_value = StringVar()
    self.entry3_gui = ttk.Entry(self.parent, width=30, textvariable=self.entry3_value)
    self.entry3_gui.insert(0, 'formato 00/00/0000, data final')
    self.entry3_gui.bind('<Button-1>', lambda e: self.entry3_gui.delete(0, 'end')) 
    self.entry3_gui.grid(column=1, row=2, sticky=(W, E))

  def combobox(self):
    self.combobox_value = StringVar()
    self.combobox_gui = ttk.Combobox(self.parent, textvariable=self.combobox_value, state='readonly')
    self.combobox_gui['values'] = ('selecione o nosql...', 'mongodb', 'elasticsearch')
    self.combobox_gui.current(0)
    self.combobox_gui.grid(column=1, row=3, sticky=(W, E))

  def entry1(self):
    self.entry1_value = StringVar()
    self.entry1_gui = ttk.Entry(self.parent, width=30, textvariable=self.entry1_value)
    self.entry1_gui.insert(0, 'url para o nosql')
    self.entry1_gui.bind('<Button-1>', lambda e: self.entry1_gui.delete(0, 'end')) 
    self.entry1_gui.grid(column=1, row=4, sticky=(W, E))

  def btn2(self):
    self.btn2_gui = ttk.Button(self.parent, text='download', command=self.__init_download)
    self.btn2_gui.grid(column=1, row=5, sticky=(W, E))

  def btn3(self):
    self.btn3_gui = ttk.Button(self.parent, text='ingestor', command=self.__init_ingest)
    self.btn3_gui.grid(column=1, row=6, sticky=(W, E))
    self.btn3_gui.state(['disabled'])

  def btn1(self):
    self.btn1_gui = ttk.Button(self.parent, text='limpar', command=self.clear_fields)
    self.btn1_gui.grid(column=1, row=7, sticky=(W, E))

  def label(self):
    self.label_value = StringVar()
    self.label_status = ttk.Label(self.parent, textvariable=self.label_value, anchor = 'center').grid(column=1, row=8, sticky=(W, E))

  def clear_fields(self):
    self.combobox_gui.current(0)
    self.entry1_value.set('')
    self.entry2_value.set('')
    self.entry3_value.set('')

  def __init_download(self):
     self.btn1_gui.state(['disabled'])
     self.btn2_gui.state(['disabled'])
     self.btn3_gui.state(['disabled'])
     self.entry1_gui.state(['disabled'])
     self.entry2_gui.state(['disabled'])
     self.entry3_gui.state(['disabled'])
     self.combobox_gui.state(['disabled'])
     self.label_value.set('\nbaixando...')
     messagebox.showinfo('scrpr4dou', 'iniciando download, aguarde...')
     global col
     col = scrpr4dou.Collection(self.combobox_value.get(), self.entry1_value.get(), self.entry2_value.get(), self.entry3_value.get())
     if col.to_local(datetime.datetime.now()):
       self.btn3_gui.state(['!disabled'])
       messagebox.showinfo('scrpr4dou', 'download concluido')
       self.label_value.set('pode ser feito ingest do conteudo baixado')

  def __init_ingest(self):
    self.label_value.set('ingesting...')
    self.btn3_gui.state(['disabled'])
    if col.to_nosql():
      messagebox.showinfo('scrpr4dou', 'ingestao concluida')
    else:
      messagebox.showinfo('scrpr4dou', 'problemas na ingestao')
    self.label_value.set('')
    self.clear_fields
    self.btn1_gui.state(['!disabled'])
    self.btn2_gui.state(['!disabled'])
    self.btn3_gui.state(['!disabled'])
    self.entry1_gui.state(['!disabled'])
    self.entry2_gui.state(['!disabled'])
    self.entry3_gui.state(['!disabled'])
    self.combobox_gui.state(['!disabled'])


if __name__ == '__main__':
  root = Tk()
  root.title('scrpr4dou')
  app = Application(root)
  root.mainloop()
