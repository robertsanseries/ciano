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
using Ciano.Views;
using Ciano.Widgets;

namespace Ciano.Controllers {

	/**
	 * @descrition 
	 * 
	 * @author  Robert San <robertsanseries@gmail.com>
	 * @type    ConverterController
	 */
	public class ConverterController {

		/**
		 * @variables
		 */
		private Gtk.ApplicationWindow app;
		private ConverterView converter_view;

		/**
		 * @construct
		 */
		public ConverterController (Gtk.ApplicationWindow app, ConverterView converter_view) {
			this.app = app;
			this.converter_view = converter_view;
			
			on_preferences_button_clicked (app);
			on_item_button_clicked (app);
		}

		/**
		 * [on_preferences_button_clicked description]
		 * @param  {[type]} Gtk.ApplicationWindow app           [description]
		 * @return {[type]}                       [description]
		 */
		private void on_preferences_button_clicked (Gtk.ApplicationWindow app) {
			this.converter_view.headerbar.on_preferences_button_clicked.connect (() => {
				var dialog_preferences = new DialogPreferences (app);
				dialog_preferences.show_all ();
			});	
		}

		/**
		 * [on_item_button_clicked description]
		 * @param  {[type]} Gtk.ApplicationWindow app           [description]
		 * @return {[type]}                       [description]
		 */
		private void on_item_button_clicked (Gtk.ApplicationWindow app) {
			this.converter_view.source_list.item_selected.connect ((item) => {

				var types = mount_array_with_supported_types (item.name);

				var dialog_convert_file = new DialogConvertFile (app);
				dialog_convert_file.show_all ();
			});
		}

		/**
		 * [mount_array_with_supported_types description]
		 * @param  {[type]} string name_type     [description]
		 * @return {[type]}        [description]
		 */
		private string [] mount_array_with_supported_types (string name_type) {
			string [] types = {""};
			
			switch (name_type) {
				case Properties.TEXT_MP4:
				case Properties.TEXT_3GP:
				case Properties.TEXT_MPG:
				case Properties.TEXT_AVI:
				case Properties.TEXT_WMV:
				case Properties.TEXT_FLV:
				case Properties.TEXT_SWF:
					break;

				case Properties.TEXT_MP3:
				case Properties.TEXT_WMA:
				case Properties.TEXT_AMR:
				case Properties.TEXT_OGG:
				case Properties.TEXT_AAC:
				case Properties.TEXT_WAV:
					break;

				case Properties.TEXT_JPG:
				case Properties.TEXT_BMP:
				case Properties.TEXT_PNG:
				case Properties.TEXT_TIF:
				case Properties.TEXT_ICO:
				case Properties.TEXT_GIF:
				case Properties.TEXT_TGA:
					break;
			}

			return types;
		}		
	}
}