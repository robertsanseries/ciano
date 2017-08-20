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

namespace Ciano.Widgets {

	/**
	 * @descrition 
	 * 
	 * @author  Robert San <robertsanseries@gmail.com>
	 * @type    Gtk.Grid
	 */
	public class RowConversion : Gtk.ListBoxRow {
		
		public  int 			row_id;
        public  Gtk.ProgressBar progress_bar;
        public  Gtk.Label 		name_video;
        public  Gtk.Label 		value_progress;
        private Gtk.Box 		container;
        private Gtk.Box 		box_name_progress;
        private Gtk.Label 		open_in_folder;
        private Gtk.Button 		icon_cancel;

		/**
		 * @construct
		 */
		public RowConversion (string icon) {

			this.container = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);
            this.container.margin = 3;

            var icone = new Gtk.Image.from_icon_name (icon, Gtk.IconSize.DND);
			this.box_name_progress = new Gtk.Box (Gtk.Orientation.VERTICAL, 0);

			// To start screen fields with default values
            this.name_video = new Gtk.Label ("Starting...");
            this.name_video.halign = Gtk.Align.START;

            this.progress_bar = new Gtk.ProgressBar ();
            this.value_progress = new Gtk.Label ("0%");
            this.open_in_folder = new Gtk.Label ("size - 4982kB time - 00:04:56.00");

            // Cancel download icon and action when clicking it
            this.icon_cancel = new Gtk.Button.with_label ("Cancel");
            this.icon_cancel.get_style_context ().add_class (Gtk.STYLE_CLASS_DESTRUCTIVE_ACTION);
            this.icon_cancel.tooltip_text = ("Cancel Conversion");
            this.icon_cancel.valign = Gtk.Align.CENTER;
            this.icon_cancel.halign = Gtk.Align.CENTER;

            box_name_progress.pack_start (this.name_video, true, true);
            box_name_progress.pack_start (this.progress_bar, true, true);
            box_name_progress.pack_start (this.open_in_folder,true,true);

            this.container.pack_start (icone, false, false, 5);
            this.container.pack_start (box_name_progress, true, true, 5);
            this.container.pack_start (this.value_progress, false, false, 2);
            this.container.pack_start (this.icon_cancel, false, false, 8);

            this.selectable = false;
            this.activatable = false;
            this.add(container);
		}
	}
}