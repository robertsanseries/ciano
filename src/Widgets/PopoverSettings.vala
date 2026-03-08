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
     * PopoverSettings provides a quick-access menu for theme selection
     * and application shortcuts (Preferences/About).
     */
    public class PopoverSettings : Gtk.Popover {

        Gtk.CheckButton group_leader = null;

        /**
         * Constructs a new PopoverSettings instance.
         * @param relative_to The widget that triggers this popover.
         */
        public PopoverSettings () {
            Object (
                has_arrow: true,
                autohide: true
            );

            var app = (Ciano.Application) GLib.Application.get_default ();
            this.update_theme_classes (app.get_current_theme_name ());

            app.theme_changed.connect ((theme_name) => {
                this.update_theme_classes (theme_name);
            });

            this.set_child (this.build_content ());
            this.add_css_class ("popover-settings");
        }

        /**
         * Assembles the main container for the popover content.
         * @return A vertical Gtk.Box containing all settings sections.
         */
        private Gtk.Widget build_content () {
            var box = new Gtk.Box (Gtk.Orientation.VERTICAL, 0);
            box.margin_top = 6;
            box.margin_bottom = 6;
            box.append (this.build_appearance_section ());
            return box;
        }

        /**
         * Builds the appearance section, including theme toggles and shortcuts.
         * @return A widget containing the appearance settings layout.
         */
        private Gtk.Widget build_appearance_section () {
            var settings = Ciano.Services.Settings.get_instance ();
            var app = (Ciano.Application) GLib.Application.get_default ();

            var root = new Gtk.Box (Gtk.Orientation.VERTICAL, 0);

            // Row: Follow system appearance
            var follow_button = new Gtk.Button ();
            follow_button.add_css_class ("flat");
            follow_button.add_css_class ("popover-row-button");

            var follow_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 6);
            follow_box.margin_start = 12;
            follow_box.margin_end = 12;
            follow_box.margin_top = 2;
            follow_box.margin_bottom = 2;

            var follow_label = new Gtk.Label (Properties.TEXT_FOLLOW_SYSTEM_APPEARANCE);
            follow_label.halign = Gtk.Align.START;
            follow_label.hexpand = true;

            var follow_switch = new Gtk.Switch ();
            follow_switch.active = settings.follow_system_appearance;
            follow_switch.valign = Gtk.Align.CENTER;
            follow_switch.can_focus = false;

            follow_box.append (follow_label);
            follow_box.append (follow_switch);

            follow_button.set_child (follow_box);

            // Theme circle selectors (Revealed when manual theme is active)
            var theme_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 10);
            theme_box.halign = Gtk.Align.START;
            theme_box.margin_start = 10;

            theme_box.append (this.build_theme_circle ("ciano-blue", 0));
            theme_box.append (this.build_theme_circle ("ciano-blue-dark", 1));
            theme_box.append (this.build_theme_circle ("ciano-green", 2));
            theme_box.append (this.build_theme_circle ("ciano-green-dark", 3));

            var revealer = new Gtk.Revealer ();
            revealer.transition_type = Gtk.RevealerTransitionType.SLIDE_UP;
            revealer.transition_duration = 250;
            revealer.set_child (theme_box);
            revealer.reveal_child = !settings.follow_system_appearance;

            root.append (follow_button);
            root.append (revealer);

            var box_separator = new Gtk.Box (Gtk.Orientation.VERTICAL, 0); // Spacing zero para controle total via CSS

            box_separator.append (new Gtk.Separator (Gtk.Orientation.HORIZONTAL));

            root.append (box_separator);

            // Shortcut buttons: Preferences and About
            root.append (this.build_flat_button (_("Preferences"), "preferences"));
            root.append (this.build_flat_button (_("About"), "about"));

            // Logic for system appearance switch
            follow_switch.notify["active"].connect (() => {
                settings.follow_system_appearance = follow_switch.active;
                revealer.reveal_child = !follow_switch.active;
                app.apply_theme (settings.theme);
            });

            follow_button.clicked.connect (() => {
                follow_switch.active = !follow_switch.active;
            });

            return root;
        }

        /**
         * Creates a theme selection circle button.
         * @param css_class The specific CSS class for the color preview.
         * @param theme_id The ID associated with the theme.
         * @return A Gtk.ToggleButton styled as a circle.
         */
        private Gtk.Widget build_theme_circle (string css_class, int theme_id) {
            var settings = Ciano.Services.Settings.get_instance ();
            var app = (Ciano.Application) GLib.Application.get_default ();

            var button = new Gtk.CheckButton ();
            button.add_css_class ("color-button");
            button.add_css_class (css_class);

            button.can_focus = false;
            button.focusable = false;

            if (group_leader == null) {
                group_leader = button;
            } else {
                button.set_group (group_leader);
            }

            if (settings.theme == theme_id && !settings.follow_system_appearance) {
                button.active = true;
            }

            button.toggled.connect (() => {
                if (button.active) {
                    settings.follow_system_appearance = false;
                    settings.theme = theme_id;
                    app.apply_theme (theme_id);
                }
            });

            return button;
        }

        /**
         * Helper to build a flat list-style button for the popover.
         * @param label_text The display text.
         * @param action_name The name of the application action to trigger.
         * @return A flat Gtk.Button.
         */
        private Gtk.Button build_flat_button (string label_text, string action_name) {
            var app = (Ciano.Application) GLib.Application.get_default ();
            var button = new Gtk.Button ();
            button.add_css_class ("flat");
            button.add_css_class ("popover-row-button");
            button.halign = Gtk.Align.FILL;
            button.hexpand = true;

            var label = new Gtk.Label (label_text);
            label.halign = Gtk.Align.START;
            label.margin_start = 12;
            label.margin_end = 12;
            label.margin_top = 4;
            label.margin_bottom = 4;
            label.add_css_class ("label-settings");

            button.set_child (label);
            button.clicked.connect (() => {
                this.popdown ();
                app.activate_action (action_name, null);
            });

            return button;
        }

        /**
         * Updates the popover's CSS classes to match current theme.
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
