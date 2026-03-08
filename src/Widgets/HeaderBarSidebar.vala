/*
 * Copyright (c) 2026 Robert San <robertsanseries@gmail.com>
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

using Ciano.Configs;
using Ciano.Services;
using Ciano.Utils;

namespace Ciano.Widgets {

    /**
     * The HeaderBarSidebar class is responsible for displaying the top bar 
     * specifically for the sidebar area.
     *
     * @see Gtk.Box
     * @since 0.1.0
     */
    public class HeaderBarSidebar : Gtk.Box {

        private Gtk.HeaderBar headerbar;

        /**
         * Signal emitted when an item is selected within the sidebar context.
         */
        public signal void item_selected ();

        /**
         * Constructs a new HeaderBarSidebar object.
         * Sets the title and applies the specific CSS class for sidebar styling.
         *
         * @see Gtk.HeaderBar
         */
        public HeaderBarSidebar () {
            Object (orientation: Gtk.Orientation.VERTICAL);

            this.headerbar = new Gtk.HeaderBar ();
            this.headerbar.show_title_buttons = true;
            this.headerbar.decoration_layout = "close:";
            this.headerbar.add_css_class ("headerbar-sidebar");
            this.append (this.headerbar);

            var title_label = new Gtk.Label (Constants.PROGRAME_NAME);
            title_label.add_css_class ("title");
            title_label.vexpand = false;

            this.headerbar.set_title_widget (title_label);
        }
    }
}
