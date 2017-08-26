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

using Ciano.Config;
using Ciano.Widgets;
using Ciano.Utils;

namespace Ciano.Views {

	/**
	 * @descrition 
	 * 
	 * @author  Robert San <robertsanseries@gmail.com>
	 * @type    Gtk.Grid
	 */
	public class ConverterView : Gtk.Grid {

		/**
		 * @variables
		 */
		private Gtk.ApplicationWindow app;
		public HeaderBar headerbar;
		public SourceListSidebar source_list;
		public ListConversion list_conversion;

		/**
		 * @construct
		 */
		public ConverterView (Gtk.ApplicationWindow app) {
			this.app = app;
			this.app.set_default_size (1050, 700);
			this.app.set_size_request (1050, 700);
			this.app.deletable = true;
			this.app.resizable = true;

			this.headerbar = new HeaderBar ();
			this.app.set_titlebar (this.headerbar);

			this.source_list = new SourceListSidebar ();
			var frame1 = new Gtk.Frame (null);
			frame1.add (this.source_list);

			this.list_conversion = new ListConversion();
			var frame2 = new Gtk.Frame (null);
			frame2.expand = true;
			frame2.add (this.list_conversion);

			this.margin = 12;
			this.column_spacing = 10;
			this.attach (frame1, 0, 0, 1, 1);
			this.attach_next_to (frame2, frame1, Gtk.PositionType.RIGHT , 5, 1);
		}
	}
}