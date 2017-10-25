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
     * The {@code Settings} class is responsible for defining all 
     * the texts that are displayed in the application and must be translated.
     *
     * @see Gtk.Grid
     * @since 0.1.0
     */
    public class ConverterView : Gtk.Grid {

        private Gtk.ApplicationWindow    app;
        public HeaderBar                 headerbar;
        public SourceListSidebar         source_list;
        public ListConversion            list_conversion;

        /**
         * Constructs a new {@code ConverterView} object responsible for putting
         * together the main structure of the application: header bar, list of options
         * on the left and list of conversions on the right.
         *
         * @see Ciano.Widgets.HeaderBar
         * @see Ciano.Widgets.SourceListSidebar
         * @see Ciano.Widgets.ListConversion
         * @param {@code Gtk.ApplicationWindow} app
         */
        public ConverterView (Gtk.ApplicationWindow app) {
            this.app = app;
            this.app.set_default_size (1050, 700);
            this.app.set_size_request (1050, 700);
            this.app.deletable = true;
            this.app.resizable = true;
            this.app.get_style_context ().add_class ("window-background-color");

            this.headerbar = new HeaderBar ();
            this.app.set_titlebar (this.headerbar);

            this.source_list = new SourceListSidebar ();
            var frame = new Gtk.Frame (null);
            frame.add (this.source_list);
            frame.width_request = 185;

            this.list_conversion = new ListConversion ();
            
            var paned = new Gtk.Paned (Gtk.Orientation.HORIZONTAL);
            paned.pack1 (frame, false, false);
            paned.pack2 (list_conversion, true, false);
            this.add (paned);
        }
    }
}