#!/usr/bin/env ruby1.8
# Cardinal Sin
# © 2009 Omari Stephens <xsdg@xsdg.org>
#
# This software is released under the GNU General Public License (GNU GPL).
# Please read the included file COPYING for more information.
# This software comes with no warranty of any kind, use at your own risk!

### Create a horizontal scrolled view for a ListStore

require 'gtk2'

module CSTK
    class HScrolledIconView < Gtk::HBox
#        include Gtk::CellLayout

        attr_reader :pixbuf_column, :text_column

        def initialize(list_store)
            @store = list_store
            @pixbuf_column = nil
            @text_column = nil

            model_sigs = %w{row-inserted row-deleted row-has-child-toggled
                            row-changed rows-reordered}

            model_sigs.each {
                |sig|
                @store.signal_connect(sig) {
                    |store, path, iter|
                    puts "#{sig} #{path.to_s} #{iter.to_s}"}
                }
        end

        def pixbuf_column=(col)
            @pixbuf_column = col
        end

        def text_column=(col)
            @text_column = col
        end
    end
end
