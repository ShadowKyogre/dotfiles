#!/usr/bin/env python3
import urwid

import math
from datetime import datetime, timedelta
from collections import OrderedDict as od
from os import path
import sys
from mutagen.easyid3 import EasyID3, ID3

# Backing store for WIP tag data
WIP_TAGS={}

# Supported tags
# The 'tag' field is the EasyID3 key to read/write 
# The 'datatype' field indicates the recommended widget
SUPPORTED_TAGS = od([
	('Title',   {'key':'title',       'datatype':'string'}),
	('Album',   {'key':'album',       'datatype':'string'}),
	('Artist',  {'key':'artist',      'datatype':'string'}),
	('Disc #',  {'key':'discnumber',  'datatype':'int'}),
	('Track #', {'key':'tracknumber', 'datatype':'int'}),
	('Year',    {'key':'date',        'datatype':'date'}),
])

# UI Appearance stuff
CAPTION_FMT="{:>8}:    "
PALETTE = [
	('changed_tags', 'bold,yellow', ''),
	('field_label',  'bold,light blue',  ''),
	('invalid_field_label',  'bold,light red',  ''),
	('cleared_field_label',  'bold,light magenta',  ''),
]

class DateEdit(urwid.Edit):
	def __init__(self, caption='', edit_text=''):
		super().__init__(caption=caption, edit_text=edit_text)
		if 'invalid_field_label' == caption[0]:
			self._is_valid = False
		else:
			self._is_valid = True
		self._force_cleared = False

	def keypress(self, size, key):
		if key in '0123456789':
			if self.edit_text[self.edit_pos] == '-':
				self.edit_pos += 1
			post_edit_text = self.edit_text[:self.edit_pos] + key + self.edit_text[self.edit_pos+1:]
			try:
				datetime.strptime(post_edit_text, '%Y-%m-%d')
			except ValueError as e:
				pass
			else:
				self.edit_text = post_edit_text
				self.set_caption(('field_label', self.caption))
				self._is_valid = True
			self.edit_pos += 1
		elif key == '+':
			dt = datetime.strptime(self.edit_text, '%Y-%m-%d')
			if self.edit_pos <= 5:
				dt = dt.replace(year=dt.year+1)
			elif self.edit_pos <= 7:
				if dt.month == 12:
					dt = dt.replace(year=dt.year+1, month=1)
				else:
					dt = dt.replace(month=dt.month+1)
			else:
				dt = timedelta(days=1) + dt
			self.edit_text = dt.strftime('%Y-%m-%d')
			self.set_caption(('field_label', self.caption))
			self._is_valid = True
		elif key == '-':
			dt = datetime.strptime(self.edit_text, '%Y-%m-%d')
			if self.edit_pos <= 5:
				dt = dt.replace(year=dt.year-1)
			elif self.edit_pos <= 7:
				if dt.month == 1:
					dt = dt.replace(year=dt.year-1, month=1)
				else:
					dt = dt.replace(month=dt.month-1)
			else:
				dt = dt - timedelta(days=1)
			self.edit_text = dt.strftime('%Y-%m-%d')
			self.set_caption(('field_label', self.caption))
			self._is_valid = True
		elif key in {'up', 'down', 'left', 'right', 'home', 'end', 'tab', 'shift tab'}:
			return super().keypress(size, key)
		elif key == 'backspace':
			self._force_cleared = not self._force_cleared
			if self._force_cleared:
				self.set_caption(('cleared_field_label', self.caption))
			else:
				if self._is_valid:
					self.set_caption(('field_label', self.caption))
				else:
					self.set_caption(('invalid_field_label', self.caption))
		else:
			return

class IncIntEdit(urwid.IntEdit):
	def keypress(self, size, key):
		key = urwid.IntEdit.keypress(self, size, key)
		if key is not None:
			prev_value = self.value()
			if self.edit_text == '':
				if key == '+':
					self.edit_text = str(self.value() + 1)
				elif key == '-':
					self.edit_text = str(max(self.value() - 1, 0))
				else:
					return key
			else:
				offset = 10**max(len(self.edit_text)-self.edit_pos-1, 0)
				if key == '+':
					self.edit_text = str(self.value() + offset)
				elif key == '-':
					self.edit_text = str(max(self.value() - offset, 0))
				else:
					return key

			if int(math.log10(max(prev_value, 1))) > int(math.log10(max(self.value(), 1))):
				self.edit_pos -= 1
			elif int(math.log10(max(prev_value, 1))) < int(math.log10(max(self.value(), 1))):
				self.edit_pos += 1

class ID3TagsEditor(urwid.Frame):
	def __init__(self, fname, orig_button, only_one=False):
		body = []
		necessary_data = {'orig_widget': orig_button, 'fname': fname, 'tag_widget': {}}
		audio = EasyID3(fname)
		tmp_upgrade = ID3(fname)

		for tag in SUPPORTED_TAGS:
			if fname not in WIP_TAGS or tag not in WIP_TAGS[fname]:
				data = audio.get(SUPPORTED_TAGS[tag]['key'], [''])[0]
			else:
				data = WIP_TAGS[fname][tag]
			if SUPPORTED_TAGS[tag]['datatype'] == 'int':
				try:
					data_as_int = int(data)
				except ValueError:
					try:
						data_as_int = int(data.split('/')[0])
					except ValueError:
						data_as_int = None
				row_widget = IncIntEdit(caption=('field_label', CAPTION_FMT.format(tag)),
										   default=data_as_int)
			elif SUPPORTED_TAGS[tag]['datatype'] == 'date':
				try:
					int(data)
				except ValueError:
					if data != '' and data != '0':
						row_widget = DateEdit(caption=('field_label', CAPTION_FMT.format(tag)),
						                 edit_text=data)
					else:
						row_widget = DateEdit(caption=('invalid_field_label', 
						                               CAPTION_FMT.format(tag)),
						                     edit_text='1900-01-01'.format(data))
				else:
					row_widget = DateEdit(caption=('field_label', CAPTION_FMT.format(tag)),
					                     edit_text='{}-01-01'.format(data))
			else:
				row_widget = urwid.Edit(caption=('field_label', CAPTION_FMT.format(tag)),
				                        edit_text=data)
			necessary_data['tag_widget'][tag]=row_widget
			body.append(row_widget)


		if only_one:
			go_back_button = urwid.Button('Cancel')
			urwid.connect_signal(go_back_button, 'click', exit_program)
		else:
			go_back_button = urwid.Button('Go Back')
			urwid.connect_signal(go_back_button, 'click', back_to_menu)

		if only_one:
			confirm_button = urwid.Button('OK')
			urwid.connect_signal(confirm_button, 'click', write_and_exit, necessary_data)
		else:
			confirm_button = urwid.Button('Confirm')
			urwid.connect_signal(confirm_button, 'click', write_tmp_tags, necessary_data)

		discard_button = urwid.Button('Discard')
		urwid.connect_signal(discard_button, 'click', discard_tmp_tags, necessary_data)

		if fname in WIP_TAGS:
			button_box = urwid.Columns(
				(urwid.AttrMap(confirm_button, None, focus_map='reversed'),
				urwid.AttrMap(go_back_button, None, focus_map='reversed'),
				urwid.AttrMap(discard_button, None, focus_map='reversed'))
			)
		else:
			button_box = urwid.Columns(
				(urwid.AttrMap(confirm_button, None, focus_map='reversed'),
				urwid.AttrMap(go_back_button, None, focus_map='reversed')),
			)

		super().__init__(body=urwid.ListBox(urwid.SimpleFocusListWalker(body)), footer=button_box)

# TRACK SELECTION
def make_menu(choices):
	body = []
	for c in choices:
		button = urwid.Button(path.basename(c))
		urwid.connect_signal(button, 'click', menu_item_chosen, c)
		body.append(urwid.AttrMap(button, None, focus_map='reversed'))
	return urwid.ListBox(urwid.SimpleFocusListWalker(body))

def menu_item_chosen(button, choice):
	global main, track_menu
	if not path.exists(choice):
		return

	dialog = urwid.LineBox(ID3TagsEditor(choice, button), 
	                       title="Tags for {}".format(choice))
	main.get_body().original_widget = urwid.Overlay(dialog, track_menu,
	                                      'center', ('relative', 80),
	                                      'middle', ('relative', 80))

def back_to_menu(button):
	global main, track_menu
	main.get_body().original_widget = track_menu
# /TRACK SELECTION

# TAG UPDATING
def discard_tmp_tags(button, data):
	del WIP_TAGS[data['fname']]
	orig_button = data['orig_widget']
	orig_button.set_label(path.basename(data['fname']))
	back_to_menu(button)

def update_tmp_tags(data):
	fname, tag_widgets = data['fname'], data['tag_widget']
	WIP_TAGS[fname] = {}
	for tag in tag_widgets:
		if isinstance(tag_widgets[tag], DateEdit):
			if tag_widgets[tag]._force_cleared:
				WIP_TAGS[fname][tag] = ''
			elif tag_widgets[tag]._is_valid:
				WIP_TAGS[fname][tag] = tag_widgets[tag].edit_text
		else:
			WIP_TAGS[fname][tag] = tag_widgets[tag].edit_text

def write_and_exit(button, data):
	update_tmp_tags(data)
	apply_edits_program(button)

def write_tmp_tags(button, data):
	update_tmp_tags(data)
	orig_button = data['orig_widget']
	if isinstance(orig_button.get_label(), str):
		orig_button.set_label([('changed_tags', '*'), orig_button.get_label()])
	back_to_menu(button)

def apply_edits_program(button):
	for key in WIP_TAGS:
		#set values with EasyID3
		audio = EasyID3(key)
		for tag in WIP_TAGS[key]:
			audio[SUPPORTED_TAGS[tag]['key']]=str(WIP_TAGS[key][tag])
		audio.save()

		#then downgrade using this
		#audio = ID3(key)
		#audio.update_to_v23()
		#audio.save()
	raise urwid.ExitMainLoop()
# /TAG UPDATING

def exit_program(button):
	raise urwid.ExitMainLoop()

def keystroke(key):
	global main
	if key in ('tab', 'shift tab'):
		focus = main.get_focus()
		focus_widget = main.get_body()
		if focus == 'body':
			main.set_focus('footer')
		else:
			main.set_focus('body')
	elif key == 'up':
		try:
			if isinstance(main.get_focus_widgets()[-3], urwid.LineBox):
				frame = main.get_focus_widgets()[-3].original_widget
				frame.set_focus('body')
		except IndexError as e:
			pass
	elif key == 'down':
		try:
			if isinstance(main.get_focus_widgets()[-3], urwid.LineBox):
				frame = main.get_focus_widgets()[-3].original_widget
				frame.set_focus('footer')
		except IndexError as e:
			pass

tracks = sys.argv[1:]
track_count = len(tracks)

if track_count == 0:
	exit(0)
elif track_count == 1:
	main_title = urwid.Text("Tags for {}".format(tracks[0]))
	main = ID3TagsEditor(tracks[0], None, only_one=True)
	main.header = main_title
	urwid.MainLoop(main, PALETTE, unhandled_input=keystroke).run()
else:
	exit_button = urwid.Button('Cancel')
	urwid.connect_signal(exit_button, 'click', exit_program)
	good_exit_button = urwid.Button('Ok')
	urwid.connect_signal(good_exit_button, 'click', apply_edits_program)

	button_box = urwid.Columns(
		(urwid.AttrMap(good_exit_button, None, focus_map='reversed'),
		urwid.AttrMap(exit_button, None, focus_map='reversed'),)
	)

	track_menu = urwid.Padding(make_menu(tracks), left=2, right=2)
	main_title = urwid.Text('Edit tags for...')
	main = urwid.Frame(header=urwid.WidgetPlaceholder(main_title),
					   body=urwid.WidgetPlaceholder(track_menu),
					   footer=urwid.WidgetPlaceholder(button_box))
	urwid.MainLoop(main, PALETTE, unhandled_input=keystroke).run()
