#!/usr/bin/python3
# -*- coding: utf-8 -*-

import scraper

if __name__ == '__main__':
	pdf = scraper.DOU(2, 1, '27/05/2016')
	pdf.download('pdf/')
