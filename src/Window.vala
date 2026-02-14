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

using Ciano.Configs;
using Ciano.Controllers;
using Ciano.Views;

namespace Ciano {

    /**
     * Class responsible for creating the u window and will contain contain other widgets. 
     * allowing the user to manipulate the window (resize it, move it, close it, ...).
     *
     * @see Gtk.ApplicationWindow
     * @since 0.1.0
     */
    public class Window : Gtk.ApplicationWindow {
         
        /**
         * Constructs a new {@code Window} object.
         *
         * @see Ciano.Configs.Constants
         * @see style_provider
         * @see build
         */
        public Window (Gtk.Application app) {
            Object (
                application: app,
                icon_name: Constants.APP_ICON,
                deletable: true,
                resizable: true
            );
            
            this.set_titlebar (new Gtk.Grid () { visible = false });

            var settings = Ciano.Services.Settings.get_instance ();
            this.set_default_size (settings.window_width, settings.window_height);
            
            if (settings.is_maximized) {
                this.maximize ();
            }
            
            this.notify["default-width"].connect (() => {
                if (!this.maximized) settings.window_width = this.default_width;
            });
            
            this.notify["default-height"].connect (() => {
                if (!this.maximized) settings.window_height = this.default_height;
            });
            
            this.notify["maximized"].connect (() => {
                settings.is_maximized = this.maximized;
            });

            style_provider ();
            build (app);
        }

        /**
         * Load the application's CSS.
         *
         * @see Ciano.Configs.Constants
         * @return {@code void}
         */
        private void style_provider () {
            var css_provider = new Gtk.CssProvider ();
            css_provider.load_from_resource (Constants.URL_CSS);
            
            Gdk.Display display = Gdk.Display.get_default ();
            
            if (display != null) {
                Gtk.StyleContext.add_provider_for_display (
                    display,
                    css_provider,
                    Gtk.STYLE_PROVIDER_PRIORITY_USER
                );
            }
        }

        /**
         * Load classes for application building.
         *
         * @see Ciano.Controllers.ConverterController
         * @see Ciano.Views.ConverterView
         * @return {@code void}
         */
        private void build (Gtk.Application app) {
            var converter_view = new ConverterView (this);
            new ConverterController (this, app, converter_view);

            this.set_child (converter_view);
            this.present ();
        }
    }
}
