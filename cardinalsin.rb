#!/usr/bin/env ruby1.8
# Cardinal Sin
# © 2009 Omari Stephens <xsdg@xsdg.org>
#
# This software is released under the GNU General Public License (GNU GPL).
# Please read the included file COPYING for more information.
# This software comes with no warranty of any kind, use at your own risk!

require 'gtk2'
require 'pathname'
require 'set'

IMAGE_DIR = Pathname.new('images/')

# store [hash, sets, path, image]
# hash is a hash of the canonical path
store = Gtk::ListStore.new(Integer, Set, Pathname, Gdk::Pixbuf)

IMAGE_DIR.children.each {
    |img|
    iter = store.append
    iter[0] = img.realpath.hash
    iter[1] = Set.new
    iter[2] = img
    iter[3] = Gdk::Pixbuf.new(img.to_s)
    }

button = Gtk::Button.new("Hello World")

tmp_set = Gtk::IconView.new(store)
tmp_set.pixbuf_column = 3

tmp = Gtk::VPaned.new
tmp.add1(tmp_set)
tmp.add2(button)

window = Gtk::Window.new

window.set_title "Cardinal Sin"
window.set_size_request(640, 480)
window.signal_connect("destroy") {
    Gtk.main_quit
    }

window.add(tmp)
window.show_all

Gtk.main
