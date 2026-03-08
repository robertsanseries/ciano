/*
 * Copyright (c) 2026 Robert San <robertsanseries@gmail.com>
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

using Ciano.Services;
using Ciano.Utils;
using Ciano.Widgets;

namespace Ciano.Widgets {

    /**
     * The HeaderBarMainContent class is responsible for displaying the top bar 
     * of the main content area.
     *
     * @see Gtk.Box
     * @since 0.1.0
     */
    public class HeaderBarMainContent : Gtk.Box {

        private Gtk.HeaderBar headerbar;
        public Gtk.MenuButton app_menu;

        /**
         * Signal emitted when an item is selected within the bar's context.
         */
        public signal void item_selected ();

        /**
         * Constructs a new HeaderBarMainContent object. 
         * Sets up the internal HeaderBar and adds functional action icons.
         *
         * @see Ciano.Configs.Properties
         * @see icon_settings
         */
        public HeaderBarMainContent () {
            Object (orientation: Gtk.Orientation.VERTICAL);

            this.headerbar = new Gtk.HeaderBar ();
            this.headerbar.show_title_buttons = true;
            this.headerbar.decoration_layout = ":maximize";
            this.headerbar.add_css_class ("headerbar-maincontent");
            this.append (this.headerbar);

            var title_label = new Gtk.Label ("");
            title_label.add_css_class ("title");
            this.headerbar.set_title_widget (title_label);

            this.icon_settings ();
            this.icon_open_output_folder ();
        }

        /**
         * Adds a button to quickly open the saved output folder.
         */
        private void icon_open_output_folder () {
            var output_folder = new Gtk.Button ();
            output_folder.icon_name = "folder-saved-search";
            output_folder.tooltip_text = _("Open output folder");
            output_folder.add_css_class ("image-button");
            output_folder.add_css_class ("icon-folder-saved-search");

            output_folder.clicked.connect (() => {
                var settings = Ciano.Services.Settings.get_instance ();
                FileUtil.open_folder_file_app (settings.output_folder);
            });

            this.headerbar.pack_end (output_folder);
        }

        /**
         * Configures the settings menu button with its respective popover.
         *
         * @see PopoverSettings
         */
        private void icon_settings () {
            var settings_icon = new Gtk.MenuButton ();
            settings_icon.icon_name = "open-menu";
            settings_icon.tooltip_text = _("Settings");
            settings_icon.add_css_class ("image-button");
            settings_icon.add_css_class ("icon-open-menu");

            settings_icon.set_create_popup_func ((button) => {
                var popover = new PopoverSettings ();
                button.set_popover (popover);
            });

            this.headerbar.pack_end (settings_icon);
        }
    }
}
