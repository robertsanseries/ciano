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
using Ciano.Utils;

namespace Ciano.Services {

    /**
     * The {@code Settings} class is responsible for managing application 
     * preferences and synchronizing them with the GSettings database.
     *
     * @since 0.1.0
     */
    public class Settings : Object {

        /**
         * This static property represents the {@code Settings} type.
         */
        private static Settings? instance;

        /**
         * This property represents the internal GSettings backend.
         * It is responsible for synchronizing application properties 
         * with the system's configuration database.
         * Object of type {@code GLib.Settings} as declared.
         */
        public GLib.Settings schema;

        /**
         * This property will represent the width of the main window.
         * Stored in pixels, it is used to restore the user's preferred 
         * window size upon application startup.
         * Variable of type {@code int} as declared.
         */
        public int window_width { get; set; }

        /**
         * This property will represent the height of the main window.
         * Stored in pixels, it is used to restore the user's preferred 
         * window size upon application startup.
         * Variable of type {@code int} as declared.
         */
        public int window_height { get; set; }

        /**
         * This property {@code bool} corresponds to {@code true} if the
         * main window should be launched in a maximized state. If active,
         * the window will occupy the entire screen.
         * Otherwise the value will be {@code false}.
         */
        public bool is_maximized { get; set; }

        /**
         * This property will receive the name of the output folder which
         * can be altered through dialog preferences.
         * Variable of type {@code string} as declared.
         */
        public string output_folder { get; set; default = ""; }

        /**
         * This property {@code bool} corresponds to {@code true} if option
         * save the converted files to the same folder is active.
         * Otherwise the value will be {@code false}.
         */
        public bool output_source_file_folder { get; set; }

        /**
         * This property {@code bool} corresponds to {@code true} if option
         * "shutdown computer" in dialog preferences is enabled.
         * Otherwise the value will be {@code false}.
         */
        public bool shutdown_computer { get; set; }

        /**
         * This property {@code bool} corresponds to {@code true} if 
         * the "open output folder" option is enabled.
         * Otherwise the value will be {@code false}.
         */
        public bool open_output_folder { get; set; }

        /**
         * This property {@code bool} corresponds to {@code true} if 
         * the "complete notify" option is enabled by displaying 
         * a notification at the end of the conversion.
         */
        public bool complete_notify { get; set; }

        /**
         * This property {@code bool} corresponds to {@code true} if
         * the "error notify" option is enabled by displaying 
         * a notification when there is a conversion error. 
         */
        public bool error_notify { get; set; }

        /**
         * This property will represent the current theme index selected by the user.
         * Used to load specific CSS color definitions (e.g., blue, green).
         * Variable of type {@code int} as declared.
         */
        public int theme { get; set; }

        /**
         * This property {@code bool} corresponds to {@code true} if the application
         * should automatically switch between light and dark themes based on 
         * the system's appearance settings.
         */
        public bool follow_system_appearance { get; set; default = true; }

        /**
         * Constructs a new {@code Settings} object and binds all properties
         * to the GSettings schema. Sets a default output folder if none is configured.
         *
         * @see Ciano.Utils.StringUtil#is_empty(string)
         * @see Ciano.Configs.Constants
         */
        private Settings () {
            schema = new GLib.Settings (Constants.ID);

            // Window Binds
            schema.bind ("window-width", this, "window-width", SettingsBindFlags.DEFAULT);
            schema.bind ("window-height", this, "window-height", SettingsBindFlags.DEFAULT);
            schema.bind ("is-maximized", this, "is-maximized", SettingsBindFlags.DEFAULT);

            // Theme Binds
            schema.bind ("theme", this, "theme", SettingsBindFlags.DEFAULT);
            schema.bind ("follow-system-appearance", this, "follow-system-appearance", SettingsBindFlags.DEFAULT);

            // Preferences Binds
            schema.bind ("output-folder", this, "output-folder", SettingsBindFlags.DEFAULT);
            schema.bind ("output-source-file-folder", this, "output-source-file-folder", SettingsBindFlags.DEFAULT);
            schema.bind ("shutdown-computer", this, "shutdown-computer", SettingsBindFlags.DEFAULT);
            schema.bind ("open-output-folder", this, "open-output-folder", SettingsBindFlags.DEFAULT);
            schema.bind ("complete-notify", this, "complete-notify", SettingsBindFlags.DEFAULT);
            schema.bind ("error-notify", this, "error-notify", SettingsBindFlags.DEFAULT);

            // Set default output folder if empty
            if (StringUtil.is_empty (this.output_folder)) {
                this.output_folder = Environment.get_home_dir () + Constants.DIRECTORY_CIANO;
            }
        }

        /**
         * Returns a single instance of this class.
         * * @return {@code Settings}
         */
        public static unowned Settings get_instance () {
            if (instance == null) {
                instance = new Settings ();
            }

            return instance;
        }
    }
}
