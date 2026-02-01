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
using Ciano.Services;
using Ciano.Utils;

namespace Ciano.Widgets {

    /**
     * The {@code HeaderBar} class is responsible for displaying top bar. Similar to a horizontal box.
     *
     * @see Gtk.HeaderBar
     * @since 0.1.0
     */
    public class HeaderBar : Adw.HeaderBar {

        public signal void item_selected ();
        
        public Gtk.MenuButton app_menu;

        /**
         * Constructs a new {@code HeaderBar} object. Sets the title of the top bar and
         * adds widgets that are displayed.
         *
         * @see Ciano.Configs.Properties
         * @see icon_settings
         */
        public HeaderBar () {
            var title_label = new Gtk.Label (Constants.PROGRAME_NAME);
            title_label.add_css_class ("title");
            this.title_widget = title_label;

            icon_open_output_folder ();
            icon_settings ();
        }

        private void icon_open_output_folder () {
            var output_folder = new Gtk.Button();
            output_folder.set_image (new Gtk.Image.from_icon_name ("folder-saved-search", Gtk.IconSize.LARGE_TOOLBAR));
            output_folder.tooltip_text = (Properties.TEXT_OPEN_OUTPUT_FOLDER);
            
            output_folder.clicked.connect(() => {
                var settings = Ciano.Services.Settings.get_instance ();
                FileUtil.open_folder_file_app(settings.output_folder);                
            });

            this.pack_start (output_folder);
        }

        /**
         * Add gear icon to open settings menu.
         * 
         * @see menu_settings
         * @return {@code void}
         */
        private void icon_settings () {
            this.app_menu = new Gtk.MenuButton();
            this.app_menu.set_image (new Gtk.Image.from_icon_name ("open-menu", Gtk.IconSize.LARGE_TOOLBAR));
            this.app_menu.tooltip_text = (Properties.TEXT_SETTINGS);

           var menu_model = new Gio.Menu ();
            menu_model.append (Properties.TEXT_PREFERENCES, "app.preferences");

            this.app_menu.menu_model = menu_model;
            this.pack_end (this.app_menu);
        }
    }
}
