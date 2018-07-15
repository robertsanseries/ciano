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

namespace Ciano.Widgets {

    public class Welcome : Granite.Widgets.Welcome {

        public Welcome () {
            base (_("Convert some files"), _("Drag and drop files or open them to begin conversion."));
            
            this.margin_start = 6;
            this.margin_end = 6;

            this.append (
                "document-open", _("Open"), 
                _("Browse to open a single file")
            );

            this.append (
                "dialog-information", _("Supported Formats"), 
                _("Information about supported file types")
            );
        }
    }
}