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

using Ciano.Services;
using Ciano.Utils;

namespace Ciano.Widgets {

    public class DialogInformations : Gtk.Dialog {

        public DialogInformations (Window parent) {
            this.title = _("Supported Formats");
            this.border_width= 5;
            this.deletable= false;
            this.resizable= false;
            this.set_default_size (500, 350);
            this.set_size_request (500, 350);
            this.set_transient_for (parent);
            this.set_modal (true);

            var column_start = new Gtk.Grid ();
            column_start.orientation = Gtk.Orientation.VERTICAL;
            column_start.hexpand = true;
            column_start.row_spacing = 5;

            var videos_label = new TitleLabel (_("Video"));
            column_start.add (videos_label);
            column_start.add (new OptionLabel ("MP4"));
            column_start.add (new OptionLabel ("3GP"));
            column_start.add (new OptionLabel ("MPG"));
            column_start.add (new OptionLabel ("AVI"));
            column_start.add (new OptionLabel ("WMV"));
            column_start.add (new OptionLabel ("SWF"));
            column_start.add (new OptionLabel ("MOV"));
            column_start.add (new OptionLabel ("MKV"));
            column_start.add (new OptionLabel ("VOB"));
            column_start.add (new OptionLabel ("OGV"));
            column_start.add (new OptionLabel ("WEBM"));

            var column_center = new Gtk.Grid ();
            column_center.orientation = Gtk.Orientation.VERTICAL;
            column_center.hexpand = true;
            column_center.row_spacing = 5;

            var music_label = new TitleLabel (_("Music"));
            column_center.add (music_label);
            column_center.add (new OptionLabel ("MP3"));
            column_center.add (new OptionLabel ("WMA"));
            column_center.add (new OptionLabel ("AMR"));
            column_center.add (new OptionLabel ("OGG"));
            column_center.add (new OptionLabel ("AAC"));
            column_center.add (new OptionLabel ("MMF"));
            column_center.add (new OptionLabel ("M4A"));
            column_center.add (new OptionLabel ("WAV"));
            column_center.add (new OptionLabel ("FLAC"));
            column_center.add (new OptionLabel ("AIFF"));

            var column_end = new Gtk.Grid ();
            column_end.orientation = Gtk.Orientation.VERTICAL;
            column_end.hexpand = true;
            column_end.row_spacing = 5;

            var image_label = new TitleLabel (_("Image"));
            column_end.add (image_label);
            column_end.add (new OptionLabel ("JPG"));
            column_end.add (new OptionLabel ("BMP"));
            column_end.add (new OptionLabel ("PNG"));
            column_end.add (new OptionLabel ("TIF"));
            column_end.add (new OptionLabel ("ICO"));
            column_end.add (new OptionLabel ("GIF"));
            column_end.add (new OptionLabel ("TGA"));

            Gtk.Box box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 5);
            box.pack_start (column_start, true, true, 8);
            box.add (new Gtk.Separator (Gtk.Orientation.VERTICAL));
            box.pack_start (column_center, true, true, 8);
            box.add (new Gtk.Separator (Gtk.Orientation.VERTICAL));
            box.pack_start (column_end, true, true, 8);

            Gtk.Box content_area = (Gtk.Box) this.get_content_area ();
            content_area.add (box);

            var close_button = (Gtk.Button) this.add_button (_("Close"), Gtk.ResponseType.CANCEL);
            close_button.clicked.connect (() => { this.destroy (); });
        }
    }

    private class TitleLabel : Gtk.Label {
            
        public TitleLabel (string label) {
            this.label = label;
            this.hexpand = true;
            this.halign = Gtk.Align.CENTER;
            this.get_style_context ().add_class (Granite.STYLE_CLASS_H4_LABEL);
        }
    }

    private class OptionLabel : Gtk.Label {
            
        public OptionLabel (string label) {
            this.label = label;
            this.halign = Gtk.Align.START;
        }
    }
}