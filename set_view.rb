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
    class HScrolledIconView < Gtk::ScrolledWindow
#        include Gtk::CellLayout

        attr_reader :pixbuf_column, :text_column

        def initialize(model)
            super()
            @model = model
            @pixbuf_column = nil
            @text_column = nil

            viewport = Gtk::Viewport.new(self.hadjustment, self.vadjustment)
            @box = Gtk::HBox.new
            viewport.add(@box)

            model_sigs = %w{row-inserted row-deleted row-has-child-toggled
                            row-changed rows-reordered}

            model_sigs.each {
                |sig|
                @model.signal_connect(sig) {
                    |store, path, iter|
                    handle_model_signal(sig, store, path, iter)
                    }
                }
        end

        def pixbuf_column=(col)
            @pixbuf_column = col
        end

        def text_column=(col)
            @text_column = col
        end

        private
        def handle_model_signal(signal, model, path, iter)
            case signal
                when 'row-inserted'
                    puts "Got row-inserted signal with iter #{iter}"
                when 'row-changed'
                    puts "Got row-changed signal with iter #{iter}"
                else
                    puts "Got unhandled tree model signal #{signal}"
            end
        end

        def insert_row(*args)
            sep = nil
        end
    end
end
