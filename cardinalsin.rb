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
require 'set_view'

IMAGE_DIR = Pathname.new('images/')
ICON_SIZE = 240

# store [hash, sets, path, filename/title, image]
# hash is a hash of the canonical path
store = Gtk::ListStore.new(Integer, Set, Pathname, String, Gdk::Pixbuf)

real_tmp_set = CSTK::HScrolledIconView.new(store)

IMAGE_DIR.children.sort.each {
    |img|
    begin
        pixbuf = Gdk::Pixbuf.new(img.to_s)

        rescue Gdk::PixbufError
        # probably wasn't an image; skip it
        next
    end

    iter = store.append
    iter[0] = img.realpath.hash
    iter[1] = Set.new
    iter[2] = img
    iter[3] = img.basename
    w = pixbuf.width
    h = pixbuf.height
    if(w > h)
        # landscape orientation
        iter[4] = pixbuf.scale(ICON_SIZE, h*ICON_SIZE/w)
    else
        # portrait or square
        iter[4] = pixbuf.scale(w*ICON_SIZE/h, ICON_SIZE)
    end
    }

tmp_set = Gtk::IconView.new(store)
tmp_set.pixbuf_column = 4
tmp_set.text_column = 3

sw = Gtk::ScrolledWindow.new
sw.add_with_viewport(tmp_set)

tmp = Gtk::VPaned.new
tmp.add1(real_tmp_set)
tmp.add2(sw)

window = Gtk::Window.new

window.title = "Cardinal Sin"
window.set_size_request(640, 480)
window.border_width = 10
window.signal_connect("destroy") {
    Gtk.main_quit
    }

window.add(tmp)
window.show_all

Gtk.main
