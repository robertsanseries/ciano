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

        private Archive? _archive;
        public Gtk.Button status_button;

        public ConversionListRow (string icon_status, Archive? archive) {
            this._archive;
            this.set_selectable (false);

            var grid = new Gtk.Grid ();
            grid.margin = 12;
            grid.margin_top = 6;
            grid.margin_bottom = 6;
            grid.column_spacing = 12;
            grid.row_spacing = 1;
            grid.hexpand = true;

            var icon_image = new Gtk.Image.from_icon_name ("media-video", Gtk.IconSize.DIALOG);

            var name = new Gtk.Label ("name");
            name.halign = Gtk.Align.START;
            name.get_style_context ().add_class ("h3");

            var completeness = new Gtk.Label ("<small>%s</small>".printf ("0 byte 900 MB"));
            completeness.halign = Gtk.Align.START;
            completeness.use_markup = true;

            var progress = new Gtk.ProgressBar ();
            progress.hexpand = true;
            progress.fraction = 1.0;
            //progress.opacity = 0;

            // open-menu-symbolic
            // selection-remove
            // selection-checked
            // list-remove
            // dialog-error
            // edit-delete-symbolic
            
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

            var status = new Gtk.Label ("<small>%s</small>".printf ("generate_status_text"));
            status.halign = Gtk.Align.START;
            status.use_markup = true;

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
            grid.attach (name, 1, 0, 1, 1);
            grid.attach (completeness, 1, 1, 1, 1);
            grid.attach (progress, 1, 2, 1, 1);
            grid.attach (status, 1, 3, 1, 1);
            grid.attach (button_box, 2, 0, 1, 4);

            this.add (grid);
        }
    }
}