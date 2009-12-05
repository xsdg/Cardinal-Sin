#!/usr/bin/env ruby1.8
# Cardinal Sin
# © 2009 Omari Stephens <xsdg@xsdg.org>
#
# This software is released under the GNU General Public License (GNU GPL).
# Please read the included file COPYING for more information.
# This software comes with no warranty of any kind, use at your own risk!

require 'gtk2'

button = Gtk::Button.new("Hello World")
button2 = Gtk::Button.new("Howdy")
tmp = Gtk::VPaned.new
tmp.add1(button)
tmp.add2(button2)

window = Gtk::Window.new

window.set_title "Cardinal Sin"
window.set_size_request(640, 480)
window.signal_connect("destroy") {
    Gtk.main_quit
    }

window.add(tmp)
window.show_all

Gtk.main
