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
			
			//var welcome = new Granite.Widgets.Welcome (
			//	StringUtil.EMPTY,
			//	Properties.TEXT_EMPTY_CONVERTING_LIST
			//);

			var row1 = new RowConversion ("media-video");
			var row2 = new RowConversion ("audio-x-generic");
			var row3 = new RowConversion ("media-video");
			var row4 = new RowConversion ("audio-x-generic");
			var row5 = new RowConversion ("audio-x-generic");
			var row6 = new RowConversion ("image");
			var row7 = new RowConversion ("media-video");
			var row8 = new RowConversion ("image");
			var row9 = new RowConversion ("audio-x-generic");
			var row10 = new RowConversion ("image");
			var row11 = new RowConversion ("image");
			var row12 = new RowConversion ("media-video");
			var row13 = new RowConversion ("image");


			this.list_conversion = new ListConversion();
			this.list_conversion.list_box.add (row1);
			this.list_conversion.list_box.add (row2);
			this.list_conversion.list_box.add (row3);
			this.list_conversion.list_box.add (row4);
			this.list_conversion.list_box.add (row5);
			this.list_conversion.list_box.add (row6);
			this.list_conversion.list_box.add (row7);
			this.list_conversion.list_box.add (row8);
			this.list_conversion.list_box.add (row9);
			this.list_conversion.list_box.add (row10);
			this.list_conversion.list_box.add (row11);
			this.list_conversion.list_box.add (row12);
			this.list_conversion.list_box.add (row13);

			var frame1 = new Gtk.Frame (null);
	        frame1.add (this.source_list);

			var frame2 = new Gtk.Frame (null);
			frame2.expand = true;
	        frame2.add (this.list_conversion);

			this.margin = 12;
			this.column_spacing = 12;
	        this.attach (frame1, 0, 0, 1, 1);
	        this.attach (frame2, 1, 0, 8, 1);
		}
	}
}