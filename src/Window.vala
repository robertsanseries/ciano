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
     * The {@code Window} class is responsible for creating the main application window.
     * It manages window states like size and maximization, and sets up the primary view.
     *
     * @see Gtk.ApplicationWindow
     * @since 0.1.0
     */
    public class Window : Gtk.ApplicationWindow {

        private ConverterController converter_controller;

        /**
         * Constructs a new {@code Window} object, restoring previous dimensions and state.
         *
         * @param app The parent {@code Gtk.Application} instance.
         * @see Ciano.Configs.Constants
         * @see Ciano.Services.Settings
         */
        public Window (Gtk.Application app) {
            Object (
                application: app,
                icon_name: Constants.APP_ICON,
                deletable: true,
                resizable: true
            );

            var empty_titlebar = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);

            this.set_titlebar (empty_titlebar);
            this.add_css_class ("main-window");

            var settings = Ciano.Services.Settings.get_instance ();
            this.set_default_size (settings.window_width, settings.window_height);

            if (settings.is_maximized) {
                this.maximize ();
            }

            // Signal connections to persist window state
            this.notify["default-width"].connect (() => {
                if (!this.maximized) settings.window_width = this.default_width;
            });

            this.notify["default-height"].connect (() => {
                if (!this.maximized) settings.window_height = this.default_height;
            });

            this.notify["maximized"].connect (() => {
                settings.is_maximized = this.maximized;
            });

            build (app);
        }

        /**
         * Assembles the internal components of the window.
         * Sets the main view and focuses on the conversion list.
         *
         * @param app The parent {@code Gtk.Application} instance.
         * @see Ciano.Controllers.ConverterController
         * @see Ciano.Views.ConverterView
         */
        private void build (Gtk.Application app) {
            var converter_view = new ConverterView (this);
            this.converter_controller = new ConverterController (this, app, converter_view);

            this.set_child (converter_view);

            this.set_focus (converter_view.list_conversion);
            this.set_focus_visible (false);
        }
    }
}
