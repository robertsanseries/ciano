/*
 * Copyright (c) 2017-2018 Robert San <robertsanseries@gmail.com>
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public
 * License as published by the Free Software Foundation; either
 * version 2 of the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * General Public License for more details.
 *
 * You should have received a copy of the GNU General Public
 * License along with this program; if not, write to the
 * Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
 * Boston, MA 02110-1301 USA
 */

using Ciano.Models.Objects;

namespace Ciano.Widgets {

    public class ConversionListBox : Gtk.ListBox {

        public ConversionListBox () {
            this.set_selection_mode (Gtk.SelectionMode.MULTIPLE);
            this.activate_on_single_click = false;
            this.button_press_event.connect (on_button_press);
            this.row_activated.connect (on_row_activated);
            this.popup_menu.connect (on_popup_menu);
        }

        public void add_archive (string icon_status, Archive archive) {
            this.add (new ConversionListRow (icon_status, archive));
        }

        private bool on_button_press (Gdk.EventButton event) {
            GLib.message ("on_button_press");
             if (event.type == Gdk.EventType.BUTTON_PRESS && event.button == Gdk.BUTTON_SECONDARY) {
                popup_menu ();
                return true;
            }
            return false;
        }

        private void on_row_activated (Gtk.ListBoxRow row) {
            GLib.message ("on_row_activated");
        }

        private bool on_popup_menu () {
            Gdk.Event event = Gtk.get_current_event ();
            var menu = new Gtk.Menu ();

            //var all_paused = true;

            Gtk.MenuItem remove_item = new Gtk.MenuItem.with_label (_("Remove"));
            remove_item.activate.connect (() => {
                (this.get_selected_row () as ConversionListRow).remove_item ();
            });

            var pause_item = new Gtk.MenuItem.with_label (_("Pause"));
           /* pause_item.activate.connect (() => {
                (this.get_selected_row () as ConversionListRow).pause_item ();
            });*/

            var unpause_item = new Gtk.MenuItem.with_label (_("Resume"));
            /*unpause_item.activate.connect (() => {
                (this.get_selected_row () as ConversionListRow).resume_item ();
            });*/

            var open_item = new Gtk.MenuItem.with_label (_("Show in File Browser"));
            /*open_item.activate.connect (() => {
                var selected_row = get_selected_row ();
                if (selected_row != null) {
                    open_torrent_location ((selected_row as TorrentListRow).id);
                }
            });*/

            var copy_magnet_item = new Gtk.MenuItem.with_label (_("Output Settings"));
            /*copy_magnet_item.activate.connect (() => {
                var selected_row = get_selected_row () as TorrentListRow;
                if (selected_row != null) {
                    selected_row.copy_magnet_link ();
                    link_copied ();
                }
            });*/

            
            /*if (all_paused) {
                menu.add (unpause_item);
            } else {
                menu.add (pause_item);
            }*/

            menu.add (remove_item);

            ///*if (items.length () < 2) {
                menu.add (copy_magnet_item);
                menu.add (open_item);
            //}

            menu.set_screen (null);
            menu.attach_to_widget (this, null);

            menu.show_all ();
            uint button;
            event.get_button (out button);
            menu.popup (null, null, null, button, event.get_time ());
            return true;
        }
    }
}