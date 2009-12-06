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
        attr_reader :pixbuf_column, :text_column

        def initialize(model)
            super()
            @model = model
            @pixbuf_column = nil
            @text_column = nil
            @children = {}

            @box = Gtk::HBox.new
            viewport = Gtk::Viewport.new(self.hadjustment, self.vadjustment)
            viewport.add(@box)
            self.add(viewport)
            self.vscrollbar_policy=Gtk::POLICY_NEVER

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
        class IconViewItem < Gtk::Image
            def initialize(pixbuf, position)
                @position = position
                super(pixbuf)
            end
        end

        def handle_model_signal(signal, model, path, iter)
            case signal
                when 'row-inserted'
                    #puts "Got row-inserted signal with iter #{iter}"
                    insert_elem(model, path, iter)
                when 'row-changed'
                    #puts "Got row-changed signal with iter #{iter}"
                    modify_elem(model, path, iter)
                else
                    puts "Got unhandled tree model signal #{signal}"
            end
        end

        def insert_elem(model, path, iter)
            return if @pixbuf_column.nil?

            sep = Gtk::VSeparator.new

            siter = iter.to_s
            item = IconViewItem.new(iter[@pixbuf_column], siter)
            @box.add(item)
            @box.add(sep)
            @children[siter] = item
        end

        def modify_elem(model, path, iter)
            return if @pixbuf_column.nil?

            if(not iter[4].nil?)
                puts "Setting pixbuf for child #{iter.to_s} to #{iter[4].inspect}"
                @children[iter.to_s].pixbuf = iter[4]
            end
        end

    end
end
