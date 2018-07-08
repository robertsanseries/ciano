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

using Ciano.Services;
using Ciano.Utils;

namespace Ciano.Widgets {

     /**
     * The {@code DialogPreferences} class is responsible for displaying the dialog
     * box where the user can configure the action of some application elements.
     *
     * @see Gtk.Dialog
     * @since 0.1.0
     */
    public class DialogInformations : Gtk.Dialog {

        private Ciano.Services.Settings settings;

        /**
         * Constructs a new {@code DialogPreferences} object responsible for assembling the dialog box structure and
         * get the instance of the {@code Settings} class with the last values set to be set in its components.
         *
         * @see Ciano.Configs.Properties
         * @see Ciano.Services.Settings
         * @see init_options
         * @see mount_options
         * @param {@code Gtk.Window} parent
         */
        public DialogInformations (Gtk.Window parent) {
            this.title = _("Information");
            this.resizable = false;
            this.deletable = true;
            this.set_transient_for (parent);
            this.set_default_size (500, 500);
            this.set_size_request (500, 500);
            this.set_modal (true);

            this.settings = Ciano.Services.Settings.get_instance ();

            var column_start = new Gtk.Grid ();
	        column_start.hexpand = true;
	        column_start.orientation = Gtk.Orientation.VERTICAL;
	        column_start.row_spacing = 12;

	        var window_header = new Granite.HeaderLabel (_("Vídeos"));
        	column_start.add (window_header);

	        var column_end = new Gtk.Grid ();
	        column_end.halign = Gtk.Align.START;
	        column_end.hexpand = true;
	        column_end.orientation = Gtk.Orientation.VERTICAL;
	        column_end.row_spacing = 12;

	        var system_header = new Granite.HeaderLabel (_("Musics"));
        	column_end.add (system_header);

            this.get_content_area ().add (column_start);
            this.get_content_area ().add (new Gtk.Separator (Gtk.Orientation.VERTICAL));
            this.get_content_area ().add (column_end);
        }
    }
}