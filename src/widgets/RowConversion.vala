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
using Ciano.Utils;

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
        public Gtk.Label 		size_time_bitrate;
        public Gtk.Button 		button_cancel;
        public Gtk.Button       button_remove;
        public  Gtk.Label       convert_to;

		public RowConversion (string icon, string name, double progress, string name_format) {

			this.container = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);
            this.container.margin = 3;

            var icone = new Gtk.Image.from_icon_name (icon, Gtk.IconSize.DIALOG);
			this.box_name_progress = new Gtk.Box (Gtk.Orientation.VERTICAL, 0);

            this.name_video = new Gtk.Label (name);
            this.name_video.halign = Gtk.Align.START;

            this.progress_bar = new Gtk.ProgressBar ();
            this.progress_bar.set_fraction (progress);
            this.convert_to = new Gtk.Label (name_format);
            this.convert_to.set_use_markup (true);

            this.size_time_bitrate = new Gtk.Label (StringUtil.EMPTY);
            this.size_time_bitrate.halign = Gtk.Align.START;

            this.button_cancel = new Gtk.Button.with_label (" Cancel ");
            this.button_cancel.get_style_context ().add_class (Gtk.STYLE_CLASS_DESTRUCTIVE_ACTION);
            this.button_cancel.tooltip_text = ("Cancel Conversion");
            this.button_cancel.valign = Gtk.Align.CENTER;
            this.button_cancel.halign = Gtk.Align.CENTER;

            this.button_remove = new Gtk.Button.with_label ("Remove");
            this.button_remove.get_style_context ().add_class (Gtk.STYLE_CLASS_SUGGESTED_ACTION);
            this.button_remove.tooltip_text = ("Remove item from list");
            this.button_remove.valign = Gtk.Align.CENTER;
            this.button_remove.halign = Gtk.Align.CENTER;
            this.button_remove.clicked.connect(() => {
                this.destroy ();
            });
            
            box_name_progress.pack_start (this.name_video, true, true);
            box_name_progress.pack_start (this.progress_bar, true, true);
            box_name_progress.pack_start (this.size_time_bitrate,true,true);

            this.container.pack_start (icone, false, false, 5);
            this.container.pack_start (box_name_progress, true, true, 5);
            this.container.pack_start (this.convert_to, false, false, 2);
            this.container.pack_start (this.button_cancel, false, false, 8);
            this.container.pack_start (this.button_remove, false, false, 8);

            this.selectable = false;
            this.activatable = false;
            this.add(container);
            this.show_all ();
		}
	}
}