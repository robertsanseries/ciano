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

using Ciano.Services;
using Ciano.Utils;

namespace Ciano.Widgets {

    /**
     * The DialogPreferences class is responsible for displaying the dialog
     * box where the user can configure application-wide settings.
     *
     * @see Gtk.Dialog
     * @since 0.1.0
     */
    public class DialogPreferences : Gtk.Dialog {

        private Ciano.Services.Settings settings;

        // UI Widgets
        private Gtk.Button output_folder_button;
        private Gtk.Switch output_source_file_folder;
        private Gtk.Switch complete_notify;
        private Gtk.Switch error_notify;
        private Gtk.Switch use_cpu_cores_limit;
        private Gtk.SpinButton max_simultaneous_conversions;
        private int saved_manual_limit;

        /**
         * Constructs a new DialogPreferences object.
         * Sets up the window properties and assembles the layout grid.
         *
         * @param parent The parent window for transient placement.
         */
        public DialogPreferences (Gtk.Window parent) {
            Object (
                transient_for: parent,
                modal: true,
                title: _("Preferences")
            );

            this.set_resizable (false);
            this.set_default_size (500, -1); // Height adjusts to content
            this.add_css_class ("dialog-preferences");

            // In GTK4/elementary style, we use a clean header without standard buttons
            var header = new Gtk.HeaderBar ();
            header.set_show_title_buttons (false);
            this.set_titlebar (header);

            this.settings = Ciano.Services.Settings.get_instance ();

            var grid = new Gtk.Grid ();
            grid.row_spacing = 8;
            grid.column_spacing = 12;
            grid.margin_top = 18;
            grid.margin_bottom = 18;
            grid.margin_start = 24;
            grid.margin_end = 24;

            this.init_options ();
            this.mount_options (grid);

            this.set_child (grid);
        }

        /**
         * Initializes preference widgets and binds them to the GSettings schema.
         */
        private void init_options () {
            // Source folder switch
            this.output_source_file_folder = new Gtk.Switch ();
            this.output_source_file_folder.valign = Gtk.Align.CENTER;

            this.settings.schema.bind (
                    "output-source-file-folder",
                    this.output_source_file_folder,
                    "active", SettingsBindFlags.DEFAULT
            );

            // Output folder selection button (replaces GtkFileChooserButton in GTK4)
            this.output_folder_button = new Gtk.Button.with_label (this.settings.output_folder);
            this.output_folder_button.hexpand = true;
            this.output_folder_button.valign = Gtk.Align.CENTER;
            this.output_folder_button.clicked.connect (() => {
                this.select_output_folder.begin ();
            });

            // Sensitivity logic: disable manual folder selection if "same folder" is active
            this.output_folder_button.sensitive = !this.output_source_file_folder.active;
            this.output_source_file_folder.notify["active"].connect (() => {
                this.output_folder_button.sensitive = !this.output_source_file_folder.active;
            });

            // Notification switches
            this.complete_notify = new Gtk.Switch ();
            this.complete_notify.valign = Gtk.Align.CENTER;
            this.settings.schema.bind ("complete-notify", this.complete_notify, "active", SettingsBindFlags.DEFAULT);

            this.error_notify = new Gtk.Switch ();
            this.error_notify.valign = Gtk.Align.CENTER;
            this.settings.schema.bind ("error-notify", this.error_notify, "active", SettingsBindFlags.DEFAULT);

            // Conversion limit widgets
            this.use_cpu_cores_limit = new Gtk.Switch ();
            this.use_cpu_cores_limit.valign = Gtk.Align.CENTER;
            this.settings.schema.bind ("use-cpu-cores-limit", this.use_cpu_cores_limit, "active", SettingsBindFlags.DEFAULT);

            int num_processors = (int) GLib.get_num_processors ();
            int max_limit = num_processors;
            this.saved_manual_limit = this.settings.max_simultaneous_conversions.clamp (1, max_limit);

            this.max_simultaneous_conversions = new Gtk.SpinButton.with_range (1, max_limit, 1);
            this.max_simultaneous_conversions.valign = Gtk.Align.CENTER;

            // When switch is ON: display CPU count (read-only, informational)
            // When switch is OFF: display user's saved value
            if (this.use_cpu_cores_limit.active) {
                this.max_simultaneous_conversions.value = (double) num_processors;
            } else {
                this.max_simultaneous_conversions.value = (double) this.saved_manual_limit;
            }

            // Only persist to settings when the user is controlling the value manually
            this.max_simultaneous_conversions.value_changed.connect (() => {
                if (!this.use_cpu_cores_limit.active) {
                    this.settings.max_simultaneous_conversions = (int) this.max_simultaneous_conversions.value;
                }
            });

            this.max_simultaneous_conversions.sensitive = !this.use_cpu_cores_limit.active;
            this.use_cpu_cores_limit.notify["active"].connect (() => {
                if (this.use_cpu_cores_limit.active) {
                    this.saved_manual_limit = (int) this.max_simultaneous_conversions.value;
                    this.max_simultaneous_conversions.value = (double) num_processors;
                } else {
                    this.max_simultaneous_conversions.value = (double) this.saved_manual_limit;
                }
                this.max_simultaneous_conversions.sensitive = !this.use_cpu_cores_limit.active;
            });
        }

        /**
         * Groups preference items into sections and attaches them to the grid.
         * @param grid The target grid for UI elements.
         */
        private void mount_options (Gtk.Grid grid) {
            int row = 0;

            // Section: Output Folder
            this.add_section (
                    grid,
                    _("Output folder:"),
                    ref row
            );

            this.add_option (
                    grid,
                    _("Files origin:"),
                    this.output_source_file_folder,
                    ref row
            );

            this.add_option (
                    grid,
                    _("Select the output folder:"),
                    this.output_folder_button,
                    ref row
            );

            // Section: Notifications
            this.add_section (
                    grid,
                    _("Notifications:"),
                    ref row
            );

            this.add_option (
                    grid,
                    _("Notify about completed action:"),
                    this.complete_notify,
                    ref row
            );

            this.add_option (
                    grid,
                    _("Notify about an error:"),
                    this.error_notify,
                    ref row
            );

            // Section: Conversions
            this.add_section (
                    grid,
                    _("Conversions:"),
                    ref row
            );

            this.add_option (
                    grid,
                    _("Use CPU cores as limit:"),
                    this.use_cpu_cores_limit,
                    ref row
            );

            this.add_option (
                    grid,
                    _("Max simultaneous conversions:"),
                    this.max_simultaneous_conversions,
                    ref row
            );

            // Close Button
            var close_button = new Gtk.Button.with_label (_("Close"));
            close_button.margin_top = 20;
            close_button.halign = Gtk.Align.END;
            close_button.add_css_class ("suggested-action");
            close_button.clicked.connect (() => { this.close (); });

            grid.attach (close_button, 1, row, 1, 1);
        }

        /**
         * Adds a section title in bold to the grid.
         */
        private void add_section (Gtk.Grid grid, string title, ref int row) {
            var label = new Gtk.Label ("");
            label.set_markup ("<b>%s</b>".printf (title));
            label.halign = Gtk.Align.START;
            label.margin_top = (row > 0) ? 12 : 0;
            label.margin_bottom = 4;

            grid.attach (label, 0, row, 2, 1);
            row++;
        }

        /**
         * Adds an option row with a label alinged to the right and a widget.
         */
        private void add_option (Gtk.Grid grid, string text, Gtk.Widget widget, ref int row) {
            var label = new Gtk.Label (text);
            label.halign = Gtk.Align.END;
            label.margin_start = 20; // Indentation for section items

            widget.halign = Gtk.Align.START;

            grid.attach (label, 0, row, 1, 1);
            grid.attach (widget, 1, row, 1, 1);
            row++;
        }

        /**
         * Opens a folder selection dialog using the modern Gtk.FileDialog API.
         */
        private async void select_output_folder () {
            var dialog = new Gtk.FileDialog ();
            dialog.set_title (_("Select the output folder:"));
            try {
                var folder = yield dialog.select_folder (this.get_root () as Gtk.Window, null);
                if (folder != null) {
                    this.settings.output_folder = folder.get_path ();
                    this.output_folder_button.label = folder.get_path ();
                }
            } catch (Error e) {
                warning ("Error: %s", e.message);
            }
        }
    }
}
