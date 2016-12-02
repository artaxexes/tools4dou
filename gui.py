#!/usr/bin/python3
# -*- coding: utf-8 -*-

from tkinter import * 
from tkinter import ttk
from tkinter import messagebox
import datetime
import scrpr4dou

class Application:

  def __init__(self, parent):
    self.parent = ttk.Frame(parent, padding='1 7 12 12')
    self.parent.grid(column=0, row=0, stick=(N, W, E, S))
    self.parent.columnconfigure(0, weight=1)
    self.parent.rowconfigure(0, weight=1)
    for child in parent.winfo_children(): child.grid_configure(padx=5, pady=5)
    self.combobox()
    self.entry1()
    self.entry2()
    self.entry3()
    self.btn1()
    self.btn2()
    self.label()
    
  def combobox(self):
    self.combobox_value = StringVar()
    self.combobox_gui = ttk.Combobox(self.parent, textvariable=self.combobox_value, state='readonly')
    self.combobox_gui['values'] = ('selecione o nosql...', 'mongodb', 'elasticsearch')
    self.combobox_gui.current(0)
    self.combobox_gui.grid(column=1, row=1, sticky=(W, E))

  def entry1(self):
    self.entry1_value = StringVar()
    self.entry1_gui = ttk.Entry(self.parent, width=30, textvariable=self.entry1_value)
    self.entry1_gui.insert(0, 'url para o nosql')
    self.entry1_gui.bind('<Button-1>', lambda e: self.entry1_gui.delete(0, 'end')) 
    self.entry1_gui.grid(column=1, row=2, sticky=(W, E))

  def entry2(self):
    self.entry2_value = StringVar()
    self.entry2_gui = ttk.Entry(self.parent, width=30, textvariable=self.entry2_value)
    self.entry2_gui.insert(0, '01/12/2016')
    self.entry2_gui.bind('<Button-1>', lambda e: self.entry2_gui.delete(0, 'end')) 
    self.entry2_gui.grid(column=1, row=3, sticky=(W, E))

  def entry3(self):
    self.entry3_value = StringVar()
    self.entry3_gui = ttk.Entry(self.parent, width=30, textvariable=self.entry3_value)
    self.entry3_gui.insert(0, '05/12/2016')
    self.entry3_gui.bind('<Button-1>', lambda e: self.entry3_gui.delete(0, 'end')) 
    self.entry3_gui.grid(column=1, row=4, sticky=(W, E))

  def btn1(self):
    self.btn1_btn = ttk.Button(self.parent, text='limpar', command=self.clear_fields)
    self.btn1_btn.grid(column=1, row=5, sticky=(W, E))

  def btn2(self):
    self.btn2_btn = ttk.Button(self.parent, text='download', command=self.init_download)
    self.btn2_btn.grid(column=1, row=6, sticky=(W, E))

  def label(self):
    self.label_value = StringVar()
    self.label_status = ttk.Label(self.parent, textvariable=self.label_value, anchor = 'center').grid(column=1, row=7, sticky=(W, E))

  def clear_fields(self):
    self.combobox_gui.current(0)
    self.entry1_value.set('')
    self.entry2_value.set('')
    self.entry3_value.set('')

  def init_download(self):
     self.btn1_btn.state(['disabled'])
     self.btn2_btn.state(['disabled'])
     self.label_value.set('\nbaixando...')
     messagebox.showinfo('scrpr4dou', 'download iniciado, aguarde...')
     col = scrpr4dou.Collection(self.combobox_value.get(), self.entry1_value.get(), self.entry2_value.get(), self.entry3_value.get())
     scraper = col.to_local(datetime.datetime.now())
     if scraper:
       self.btn1_btn.state(['!disabled'])
       self.btn2_btn.state(['!disabled'])
       self.label_value.set('')
       messagebox.showinfo('scrpr4dou', 'download concluido, os arquivos estao na pasta raiz do programa')

if __name__ == '__main__':
  root = Tk()
  root.title('scrpr4dou')
  app = Application(root)
  root.mainloop()
