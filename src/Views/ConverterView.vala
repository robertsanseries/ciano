/*
 * Copyright (c) 2017 Robert San <robertsanseries@gmail.com>
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
using Ciano.Widgets;
using Ciano.Utils;

namespace Ciano.Views {

    /**
     * The ConverterView class is responsible for assembling the main application layout,
     * featuring a sidebar for format selection and a main area for conversion tracking.
     *
     * @see Gtk.Grid
     * @since 0.1.0
     */
    public class ConverterView : Gtk.Grid {

        private Gtk.ApplicationWindow app;
        public SourceListSidebar source_list;
        public ListConversion list_conversion;

        /**
         * Constructs a new ConverterView object.
         * Sets up a fixed dual-pane layout using Gtk.Box and a custom separator
         * to ensure a non-resizable sidebar.
         *
         * @param app The parent Gtk.ApplicationWindow.
         */
        public ConverterView (Gtk.ApplicationWindow app) {
            this.app = app;

            var settings = Ciano.Services.Settings.get_instance ();
            this.app.set_default_size (settings.window_width, settings.window_height);
            this.app.set_size_request (700, 450);

            // Main Layout Container
            // Uses a Gtk.Box instead of Gtk.Paned to prevent user resizing,
            // maintaining a consistent fixed-width sidebar.
            var main_layout_container = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);
            main_layout_container.hexpand = true;
            main_layout_container.vexpand = true;

            // Sidebar Construction (Fixed Width)
            var headerbar_sidebar = new HeaderBarSidebar ();
            this.source_list = new SourceListSidebar ();

            var sidebar_box = new Gtk.Box (Gtk.Orientation.VERTICAL, 0);
            sidebar_box.add_css_class ("box-background-navigation-sidebar");
            sidebar_box.width_request = 200;
            sidebar_box.hexpand = false;
            sidebar_box.append (headerbar_sidebar);
            sidebar_box.append (this.source_list);

            // Static Separator Line
            // Replaces the interactive Gtk.Paned separator to avoid
            // resize cursors and unexpected layout shifts.
            var separator_line = new Gtk.Separator (Gtk.Orientation.VERTICAL);
            separator_line.add_css_class ("main-splitter-line");

            // Main Content Construction (Flexible Width)
            var headerbar_maincontent = new HeaderBarMainContent ();
            this.list_conversion = new ListConversion ();

            var content_box = new Gtk.Box (Gtk.Orientation.VERTICAL, 0);
            content_box.hexpand = true; // Absorbs all remaining window width
            content_box.append (headerbar_maincontent);
            content_box.append (this.list_conversion);

            // Assembly
            main_layout_container.append (sidebar_box);
            main_layout_container.append (separator_line);
            main_layout_container.append (content_box);

            this.attach (main_layout_container, 0, 0, 1, 1);
        }
    }
}
