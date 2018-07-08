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
     * The {@code Settings} class is responsible for defining all 
     * the texts that are displayed in the application and must be translated.
     *
     * @see Gtk.Grid
     * @since 0.1.0
     */
    public class Welcome : Granite.Widgets.Welcome {

        public int document_open_index      { get; set; }
        public int dialog_information_index { get; set; }

        public Welcome () {
            base (_("Convert some files"), _("Drag and drop files or open them to begin conversion."));
            
            this.margin_start = 6;
            this.margin_end = 6;

            this.document_open_index = this.append (
                "document-open", _("Open"), 
                _("Browse to open a single file")
            );

            this.dialog_information_index = this.append (
                "dialog-information", _("Load from Downloads"), 
                _("Load files from your Downloads folder")
            );
        }
    }
}