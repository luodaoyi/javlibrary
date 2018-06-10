#!/usr/bin/env python2
# -*- coding: utf-8 -*
#The MIT License (MIT)
# Copyright (c) 2015 daite

# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:

# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
from scrapy import Selector
import codecs
import requests
import argparse
import os

class ImageDownloader:
	def __init__(self, root_dir_name):
		'''
		:: init function 
		:: set root directory path when given root dir name
		'''
		self.root_dir_name = root_dir_name
		self.root_dir_path = os.path.join(os.getcwd(), root_dir_name)
		if not os.path.exists(self.root_dir_path):
			os.mkdir(self.root_dir_path)

	def get_image_urls(self, res_text):
		'''
		:: getting image urls from response_text
		'''
		self.img_urls = Selector(text=res_text).xpath('//a/@href').re('.*jpg$')
		return self.img_urls

	def get_description(self, res_text):
		'''
		:: getting description from response_text
		'''
		self.desc_contents = Selector(text=res_text).xpath('//blockquote/text()').extract()
		return self.desc_contents

	def save_stuff(self, sub_dir_name, img_urls, desc_contents, text_file_name='description.txt'):
		'''
		:: save images and description each subdir
		'''
		self.sub_dir_path = os.path.join(self.root_dir_path, sub_dir_name)
		self.sub_dir_desc_file_name = os.path.join(self.sub_dir_path, text_file_name)
		if not os.path.exists(self.sub_dir_path):
			os.mkdir(self.sub_dir_path)
		os.chdir(self.sub_dir_path)
		with codecs.open(self.sub_dir_desc_file_name,  'a', encoding='utf-8') as f:
			for content in desc_contents:
				f.write(content)
		for img_url in img_urls:
			cmd = 'wget -nc -t 1 %s &' %img_url
			os.system(cmd)
		os.chdir(self.root_dir_path)

	def multi_save_stuff(self, urlgen, start_num, end_num):
		'''
		:: multi save function 
		'''
		for movie_num in range(start_num, end_num + 1):
			url = urlgen(movie_num)
			res_text = requests.get(url).text
			img_urls = self.get_image_urls(res_text)
			desc_contents = self.get_description(res_text)
			if not img_urls:
				print('No images!!!!')
				continue
			sub_dir_name = url.split('/')[-1].strip('.html')
			self.save_stuff(sub_dir_name, img_urls, desc_contents)

if __name__ == '__main__':

	gana_urlgen = lambda x : 'http://blog.livedoor.jp/kirekawa39-siro/archives/200GANA-%d.html' %x
	siro_urlgen = lambda x : 'http://blog.livedoor.jp/kirekawa39-siro/archives/siro-%d.html' %x
	
	parser = argparse.ArgumentParser()
	parser.add_argument("start", type=int, help='start number')
	parser.add_argument("end", type=int, help='end number')
	parser.add_argument('-g', '--gana', 
			    help='download image from gana200', 
			    action="store_true")
	parser.add_argument('-s', '--siro', 
			    help='download image from siro', 
			    action="store_true")
	args = parser.parse_args()
	if args.gana:
		i = ImageDownloader('GANA200')
		i.multi_save_stuff(gana_urlgen, args.start, args.end)
	elif args.siro:
		i = ImageDownloader('SIRO')
		i.multi_save_stuff(siro_urlgen, args.start, args.end)
	else:
		parser.print_help()
		exit(1)