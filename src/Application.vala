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

namespace Ciano {

    /**
     * Main Application class responsible for lifecycle management,
     * action handling, and global styling.
     */
    public class Application : Gtk.Application {

        /**
         * Main window instance.
         */
        private Window window { get; private set; default = null; }

        /**
         * Base CSS provider for general layout.
         */
        private Gtk.CssProvider base_provider;

        /**
         * Dynamic CSS provider for theme-specific colors.
         */
        private Gtk.CssProvider theme_provider;

        /**
         * Current active theme name.
         */
        private string current_theme_name = "theme-blue";

        /**
         * Signal emitted when the theme is successfully changed.
         */
        public signal void theme_changed (string theme_name);

        /**
         * Constructs a new Application instance.
         */
        public Application () {
            Object (
                application_id: Constants.ID,
                flags: ApplicationFlags.DEFAULT_FLAGS
            );
        }

        /**
         * Entry point for the application activation.
         */
        public override void activate () {
            var gtk_settings = Gtk.Settings.get_default ();
            gtk_settings.gtk_icon_theme_name = "elementary";

            if (!(gtk_settings.gtk_theme_name.has_prefix ("io.elementary.stylesheet"))) {
                gtk_settings.gtk_theme_name = "io.elementary.stylesheet.blueberry";
            }

            if (window == null) {
                this.load_application_styles ();

                window = new Window (this);
                add_window (window);

                var settings = Ciano.Services.Settings.get_instance ();
                apply_theme (settings.theme);

                window.present ();
            }

            this.setup_actions ();
            this.setup_signals ();
        }

        /**
         * Configures application-wide actions and shortcuts.
         */
        private void setup_actions () {
            // Quit action
            var quit_action = new SimpleAction ("quit", null);
            quit_action.activate.connect (() => {
                if (window != null) window.destroy ();
            });
            add_action (quit_action);
            set_accels_for_action ("app.quit", {"<Ctrl>q"});

            // Preferences action
            var preferences_action = new SimpleAction ("preferences", null);
            preferences_action.activate.connect (() => {
                var dialog = new Ciano.Widgets.DialogPreferences (window);
                dialog.present ();
            });
            add_action (preferences_action);

            // About action
            var about_action = new SimpleAction ("about", null);
            about_action.activate.connect (() => {
                var dialog = new Ciano.Widgets.DialogAbout (window);
                dialog.present ();
            });
            add_action (about_action);
        }

        /**
         * Connects global signals, such as system theme changes.
         */
        private void setup_signals () {
            var gtk_settings = Gtk.Settings.get_default ();
            gtk_settings.notify["gtk-application-prefer-dark-theme"].connect (() => {
                var settings = Ciano.Services.Settings.get_instance ();
                if (settings.follow_system_appearance) {
                    apply_theme (settings.theme);
                }
            });
        }

        /**
         * Initializes and attaches CSS providers to the display.
         */
        private void load_application_styles () {
            base_provider = new Gtk.CssProvider ();
            theme_provider = new Gtk.CssProvider ();

            var display = Gdk.Display.get_default ();

            Gtk.StyleContext.add_provider_for_display (
                display,
                base_provider,
                Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION
            );

            Gtk.StyleContext.add_provider_for_display (
                display,
                theme_provider,
                Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION
            );

            base_provider.load_from_resource ("/com/github/robertsanseries/ciano/assets/css/style.css");
        }

        /**
         * Applies the selected theme based on ID and system appearance.
         * @param theme_id The ID of the theme to apply.
         */
        public void apply_theme (int theme_id) {
            var settings = Ciano.Services.Settings.get_instance ();
            var gtk_settings = Gtk.Settings.get_default ();
            bool system_dark = gtk_settings.gtk_application_prefer_dark_theme;

            string theme_name = "theme-blue";

            if (settings.follow_system_appearance) {
                // Logic for automatic system-based switching
                if (theme_id == 0 || theme_id == 1) {
                    theme_name = system_dark ? "theme-blue-dark" : "theme-blue";
                } else if (theme_id == 2 || theme_id == 3) {
                    theme_name = system_dark ? "theme-green-dark" : "theme-green";
                }
            } else {
                // Logic for manual theme selection
                string[] themes = {
                    "theme-blue",
                    "theme-blue-dark",
                    "theme-green",
                    "theme-green-dark"
                };
                if (theme_id >= 0 && theme_id < themes.length) {
                    theme_name = themes[theme_id];
                }
            }

            theme_provider.load_from_resource (
                "/com/github/robertsanseries/ciano/assets/css/" + theme_name + ".css"
            );

            this.current_theme_name = theme_name;
            this.update_window_visuals (theme_name);
            this.theme_changed (theme_name);
        }

        /**
         * Updates the window CSS classes to reflect the current theme.
         * @param theme_name The class name to add.
         */
        private void update_window_visuals (string theme_name) {
            if (window == null) return;

            string[] available_themes = {
                "theme-blue", "theme-blue-dark",
                "theme-green", "theme-green-dark"
            };

            foreach (var t in available_themes) {
                window.remove_css_class (t);
            }

            window.add_css_class (theme_name);
        }

        /**
         * Gets the current theme name.
         * @return string current theme name.
         */
        public string get_current_theme_name () {
            return current_theme_name;
        }
    }
}
