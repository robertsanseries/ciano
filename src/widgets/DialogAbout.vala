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

using Gtk;
using Granite;
using Granite.Widgets;

namespace Ciano.Widgets {

	public class DialogAbout : Granite.Widgets.AboutDialog {

		public DialogAbout () {
                  this.program_name        = "Ciano";
                  this.website             = "https://robertsanseries.github.io/ciano";
                  this.website_label       = "Website";
                  this.logo_icon_name      = "com.github.robertsanseries.ciano";
                  this.version             = "0.2.0";
                  this.authors             = { "Robert San <robertsanseries@gmail.com>" };
                  this.comments            = "A multimedia file converter focused on simplicity.";
                  this.license_type        = Gtk.License.GPL_3_0;
                  this.translator_credits  = "Github Translators";
                  this.translate           = "https://robertsanseries.github.io/ciano";
                  this.help                = "https://github.com/robertsanseries/ciano/issues";
                  this.bug                 = "https://github.com/robertsanseries/ciano/issues";
		}
	}
}

