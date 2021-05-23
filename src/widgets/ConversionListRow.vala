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

    public class ConversionListRow : Gtk.ListBoxRow {

        public Gtk.Image icon_image { get; set; }
        public Gtk.Label name_label { get; set; }
        public Gtk.Label file_size { get; set; }
        public Gtk.Label status { get; set; }
        public Gtk.ProgressBar progress { get; set; }
        public Gtk.Button status_button { get; set; }

        public ConversionListRow (string icon_status, Archive archive) {
            var grid = new Gtk.Grid ();
            grid.margin = 12;
            grid.margin_top = 6;
            grid.margin_bottom = 6;
            grid.column_spacing = 12;
            grid.row_spacing = 1;
            grid.hexpand = true;

            this.icon_image = new Gtk.Image.from_icon_name ("media-video", Gtk.IconSize.DIALOG);

            this.name_label = new Gtk.Label (archive.name);
            this.name_label.halign = Gtk.Align.START;
            this.name_label.get_style_context ().add_class ("h3");

            this.file_size = new Gtk.Label ("<small>%s</small>".printf ("0 byte 900 MB"));
            this.file_size.halign = Gtk.Align.START;
            this.file_size.use_markup = true;

            this.progress = new Gtk.ProgressBar ();
            this.progress.hexpand = true;
            this.progress.fraction = archive.progress;
            this.progress.get_style_context ().add_class ("GtkProgress");
            
            switch (icon_status) {
                case "media-playback-start-symbolic":
                    status_button = new Gtk.Button.from_icon_name ("media-playback-start-symbolic");
                    status_button.tooltip_text = _("Pause torrent");
                    break;

                case "media-playback-pause-symbolic":
                    status_button = new Gtk.Button.from_icon_name ("media-playback-pause-symbolic");
                    status_button.tooltip_text =_("Resume torrent");
                    break;

                case "process-completed":
                    status_button = new Gtk.Button.from_icon_name ("process-completed");
                    status_button.tooltip_text =_("Process completed");
                    //status_button.activate = false;
                    break;
            }

            status_button.get_style_context ().add_class ("flat");            
            /*status_button.clicked.connect (() => {
                //toggle_pause ();
            });*/

            this.status = new Gtk.Label ("<small>%s</small>".printf (archive.status));
            this.status.halign = Gtk.Align.START;
            this.status.use_markup = true;

            var finaly_button = new Gtk.Button.from_icon_name ("process-completed");
            finaly_button.valign = Gtk.Align.CENTER;
            finaly_button.get_style_context ().add_class (Gtk.STYLE_CLASS_FLAT);

            var remove_button = new Gtk.Button.from_icon_name ("edit-delete-symbolic", Gtk.IconSize.SMALL_TOOLBAR);
            remove_button.tooltip_text = _("Remove from list");
            remove_button.valign = Gtk.Align.CENTER;
            remove_button.get_style_context ().add_class (Gtk.STYLE_CLASS_FLAT);
            remove_button.opacity = 0;

            Gtk.Box button_box = new Gtk.Box (Gtk.Orientation.VERTICAL, 0);
            button_box.pack_start (remove_button, false, false, 0);
            button_box.pack_start (status_button, false, false, 7);
            
            grid.attach (icon_image, 0, 0, 1, 4);
            grid.attach (this.name_label, 1, 0, 1, 1);
            grid.attach (this.file_size, 1, 1, 1, 1);
            grid.attach (this.progress, 1, 2, 1, 1);
            grid.attach (this.status, 1, 3, 1, 1);
            grid.attach (button_box, 2, 0, 1, 4);

            this.add (grid);
            this.get_style_context ().add_class ("GtkListBoxRow");
        }

        public void remove_item () {
            //torrent_removed (torrent);
            this.destroy ();
        }
    }
}
