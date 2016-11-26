#!/usr/bin/python
# -*- coding: utf-8 -*-

from tkinter import *
from tkinter import ttk

class Application:

  def __init__(self, parent):
    self.parent = ttk.Frame(parent, padding='1 4 12 12')
    self.parent.grid(column=0, row=0, stick=(N, W, E, S))
    self.parent.columnconfigure(0, weight=1)
    self.parent.rowconfigure(0, weight=1)
    for child in parent.winfo_children(): child.grid_configure(padx=5, pady=5)
    self.combo()
    self.entry()
    self.btn1()
    self.btn2()
    
  def combo(self):
    self.box_value = StringVar()
    self.box = ttk.Combobox(self.parent, textvariable=self.box_value, state='readonly')
    self.box['values'] = ('selecione o nosql...', 'mongodb', 'elasticsearch')
    self.box.current(0)
    self.box.grid(column=1, row=1, sticky=(W, E))

  def entry(self):
    self.entry_value = StringVar()
    self.entry = ttk.Entry(self.parent, width=30, textvariable=self.entry_value)
    self.entry.insert(0, 'digite uma url valida para o nosql')
    self.entry.bind('<Enter>', lambda e: self.entry.delete(0, 'end')) 
    self.entry.grid(column=1, row=2, sticky=(W, E))

  def btn1(self):
    self.btn_clear = ttk.Button(self.parent, text='clear', command=self.clear)
    self.btn_clear.grid(column=1, row=3, sticky=(W, E))

  def btn2(self):
    self.btn_down = ttk.Button(self.parent, text='download', command=self.download)
    self.btn_down.grid(column=1, row=4, sticky=(W, E))

  def clear(self):
    self.entry_value.set('')
    self.box.current(0)

  def download(self):
    print(self.box_value.get())
    print(self.entry_value.get())

if __name__ == '__main__':
  root = Tk()
  root.title('scrpr4dou')
  app = Application(root)
  root.mainloop()
