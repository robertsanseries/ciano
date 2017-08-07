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
using Ciano.Controllers;
using Ciano.Views;

namespace Ciano {

	/**
	 * @descrition 
	 * 
	 * @author  Robert San <robertsanseries@gmail.com>
	 * @type    Gtk.ApplicationWindow
	 */
	public class Window : Gtk.ApplicationWindow {
 		
  		/**
		 * @construct
		 */
		public Window (Gtk.Application app) {
			Object (
				application: app,
				icon_name: Constants.APP_ICON,
				deletable: true,
				resizable: true
			);

			style_provider ();
			build ();
		}

		/**
		 * @descrition 	Load the application's CSS.
		 * @return 		void
		 */
		private void style_provider () {
			var css_provider = new Gtk.CssProvider ();
	        css_provider.load_from_resource (Constants.URL_CSS);
    	    
    	    Gtk.StyleContext.add_provider_for_screen (
    	    	Gdk.Screen.get_default (),
    	    	css_provider,
    	    	Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION
    	    );
		}

		/**
		 * @descrition 	Load classes for application building.
		 * @return 		void
		 */
		private void build () {
			var converter_view = new ConverterView (this);
			new ConverterController (this, converter_view);

        	this.add (converter_view);
        	this.show_all ();
		}
	}
}