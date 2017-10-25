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
using Ciano.Configs;

namespace Ciano.Widgets {

    /**
     * The {@code RowConversion} class is responsible for displaying list of items that
     * are being converted or have been converted   
     *
     * @see Gtk.ListBoxRow
     * @since 0.1.0
     */
    public class RowConversion : Gtk.ListBoxRow {
        
        private Gtk.Box         container;
        private Gtk.Box         box_name_progress;
        public  int             row_id;
        public  Gtk.ProgressBar progress_bar;
        public  Gtk.Label       name_video;
        public  Gtk.Label       value_progress;
        public  Gtk.Label       status;
        public  Gtk.Button      button_cancel;
        public  Gtk.Button      button_remove;
        public  Gtk.Label       convert_to;

        /**
         * Constructs a new {@code RowConversion} object that will display the status of each 
         * item during conversion.
         *
         * @see Ciano.Utils.StringUtil
         * @see Ciano.Configs.Properties
         * @param {@code string} icon
         * @param {@code string} name
         * @param {@code double} progress
         * @param {@code string} name_format
         */
        public RowConversion (string icon, string name, double progress, string name_format) {
            this.container = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);
            this.container.margin = 3;

            var icone = new Gtk.Image.from_icon_name (icon, Gtk.IconSize.DIALOG);
            this.box_name_progress = new Gtk.Box (Gtk.Orientation.VERTICAL, 0);

            if (name.length > 85) {
               this.name_video = new Gtk.Label (name.slice (0, 85) + "...");
            } else {
                this.name_video = new Gtk.Label (name);
            }
            this.name_video.halign = Gtk.Align.START;

            this.progress_bar = new Gtk.ProgressBar ();
            this.progress_bar.get_style_context ().add_class ("progress_bar");
            this.progress_bar.set_fraction (progress);
            
            this.convert_to = new Gtk.Label (name_format);
            this.convert_to.set_use_markup (true);

            this.status = new Gtk.Label (Properties.TEXT_STARTING);
            this.status.halign = Gtk.Align.START;

            this.button_cancel = new Gtk.Button.with_label (Properties.TEXT_CANCEL);
            this.button_cancel.get_style_context ().add_class (Gtk.STYLE_CLASS_DESTRUCTIVE_ACTION);
            this.button_cancel.tooltip_text = (Properties.TEXT_CANCEL_CONVERSION);
            this.button_cancel.valign = Gtk.Align.CENTER;
            this.button_cancel.halign = Gtk.Align.CENTER;

            this.button_remove = new Gtk.Button.with_label (Properties.TEXT_REMOVE);
            this.button_remove.tooltip_text = (Properties.TEXT_REMOVE_ITEM_FROM_LIST);
            this.button_remove.valign = Gtk.Align.CENTER;
            this.button_remove.halign = Gtk.Align.CENTER;
            
            box_name_progress.pack_start (this.name_video, true, true);
            box_name_progress.pack_start (this.progress_bar, true, true);
            box_name_progress.pack_start (this.status, true,true);

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