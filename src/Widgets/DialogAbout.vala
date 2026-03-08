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

using Ciano.Configs;

namespace Ciano.Widgets {

    /**
     * DialogAbout provides information about the application,
     * including version, description, and links to support.
     *
     * Implemented as a Gtk.Window instead of the deprecated Gtk.Dialog,
     * avoiding warnings from gtk_dialog_get_content_area, gtk_dialog_add_button,
     * and gtk_show_uri.
     */
    public class DialogAbout : Gtk.Window {

        private const string APP_NAME = Constants.PROGRAME_NAME;
        private const string VERSION = Constants.VERSION;
        private const string DESCRIPTION = Properties.TEXT_APP_DESCRIPTION;
        private const string AUTHOR_URL = Constants.AUTHOR_URL;
        private const string HELP_URL = Constants.HELP_URL;
        private const string TRANSLATE_URL = Constants.TRANSLATE_URL;
        private const string BUG_URL = Constants.BUG_URL;

        /**
         * Constructs a new DialogAbout instance.
         * @param parent The parent window for transient placement.
         */
        public DialogAbout (Gtk.Window parent) {
            Object (
                    transient_for: parent,
                    modal: true,
                    resizable: false,
                    deletable: true
            );

            this.set_default_size (550, -1);
            this.add_css_class ("dialog-about");

            // Remove the default titlebar for a cleaner look
            var empty_titlebar = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);
            this.set_titlebar (empty_titlebar);

            this.build_ui ();
            this.connect_theme ();
        }

        /**
         * Builds the user interface components of the window.
         */
        private void build_ui () {
            var root = new Gtk.Box (Gtk.Orientation.VERTICAL, 0);

            // Main content area with margins
            var content = new Gtk.Box (Gtk.Orientation.VERTICAL, 24);
            content.margin_top = 0;
            content.margin_bottom = 18;
            content.margin_start = 18;
            content.margin_end = 18;

            // Top section: Icon and application info
            var top_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 20);

            var icon = new Gtk.Image.from_icon_name (Constants.APP_ICON);
            icon.valign = Gtk.Align.START;
            icon.pixel_size = 96;
            icon.margin_top = 60;

            var text_box = new Gtk.Box (Gtk.Orientation.VERTICAL, 6);
            text_box.hexpand = true;

            var title = new Gtk.Label ("%s %s".printf (APP_NAME, VERSION));
            title.add_css_class ("dialog-about-title");
            title.halign = Gtk.Align.START;

            var description_label = new Gtk.Label (DESCRIPTION);
            description_label.halign = Gtk.Align.START;
            description_label.wrap = true;
            description_label.max_width_chars = 45;

            var copyright = new Gtk.Label (null);
            copyright.set_markup ("© 2017–2026 <a href=\"%s\">Robert San</a>".printf (AUTHOR_URL));
            copyright.halign = Gtk.Align.START;

            var license_label = new Gtk.Label (null);
            license_label.set_markup (
                    "%s <a href=\"%s\">%s</a>.".printf (
                            Properties.TEXT_FOR_ABOUT_LICENSE,
                            Constants.LICENSE_URL,
                            Constants.LICENSE_URL
                    )
            );
            license_label.add_css_class ("dialog-about-license");
            license_label.halign = Gtk.Align.START;
            license_label.wrap = true;

            text_box.append (title);
            text_box.append (description_label);
            text_box.append (new Gtk.Label ("")); // Spacer
            text_box.append (copyright);
            text_box.append (license_label);

            top_box.append (icon);
            top_box.append (text_box);
            content.append (top_box);

            // Bottom action bar
            var action_bar = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 6);
            action_bar.margin_top = 0;
            action_bar.margin_bottom = 12;
            action_bar.margin_start = 12;
            action_bar.margin_end = 12;

            // Help button (circular flat button on the left side)
            var help_btn = new Gtk.Button.with_label ("?");
            help_btn.add_css_class ("flat");
            help_btn.add_css_class ("btn-help");
            help_btn.clicked.connect (() => this.open_uri (HELP_URL));

            // Spacer to push link buttons to the right
            var spacer = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);
            spacer.hexpand = true;

            // Link buttons
            var translate_btn = new Gtk.Button.with_label (_("Suggest Translations"));
            translate_btn.add_css_class ("flat");
            translate_btn.clicked.connect (() => this.open_uri (TRANSLATE_URL));

            var bug_btn = new Gtk.Button.with_label (_("Report a Problem"));
            bug_btn.add_css_class ("flat");
            bug_btn.clicked.connect (() => this.open_uri (BUG_URL));

            // Close button (primary/suggested action)
            var close_btn = new Gtk.Button.with_label (_("Close"));
            close_btn.add_css_class ("flat");
            close_btn.add_css_class ("btn-close");
            close_btn.clicked.connect (() => this.close ());

            action_bar.append (help_btn);
            action_bar.append (spacer);
            action_bar.append (translate_btn);
            action_bar.append (bug_btn);
            action_bar.append (close_btn);

            root.append (content);
            root.append (action_bar);

            this.set_child (root);
        }

        /**
         * Safely opens a URI using the modern GtkUriLauncher API.
         * Replaces the deprecated gtk_show_uri.
         */
        private void open_uri (string uri) {
            var launcher = new Gtk.UriLauncher (uri);
            launcher.launch.begin (this, null, (obj, res) => {
                try {
                    launcher.launch.end (res);
                } catch (Error e) {
                    warning ("Failed to open URI '%s': %s", uri, e.message);
                }
            });
        }

        /**
         * Connects the window to global theme change events.
         */
        private void connect_theme () {
            var app = (Ciano.Application) GLib.Application.get_default ();
            this.update_theme_classes (app.get_current_theme_name ());

            app.theme_changed.connect ((theme_name) => {
                this.update_theme_classes (theme_name);
            });
        }

        /**
         * Updates the window's CSS classes to match the current theme.
         */
        private void update_theme_classes (string theme_name) {
            string[] themes = {
                "theme-blue", "theme-blue-dark",
                "theme-green", "theme-green-dark"
            };

            foreach (var t in themes) {
                this.remove_css_class (t);
            }

            this.add_css_class (theme_name);
        }
    }
}
