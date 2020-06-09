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
     * The {@code DialogPreferences} class is responsible for displaying the dialog
     * box where the user can configure the action of some application elements.
     *
     * @see Gtk.Dialog
     * @since 0.1.0
     */
    public class DialogPreferences : Gtk.Dialog {

        private Ciano.Services.Settings settings;
        private Gtk.FileChooserButton  output_folder;
        private Gtk.Switch             output_source_file_folder;
        private Gtk.Switch             complete_notify;
        private Gtk.Switch             error_notify;

        /**
         * Constructs a new {@code DialogPreferences} object responsible for assembling the dialog box structure and
         * get the instance of the {@code Settings} class with the last values set to be set in its components.
         *
         * @see Ciano.Configs.Properties
         * @see Ciano.Services.Settings
         * @see init_options
         * @see mount_options
         * @param {@code Gtk.Window} parent
         */
        public DialogPreferences (Gtk.Window parent) {
            this.title = Properties.TEXT_PREFERENCES;
            this.resizable = false;
            this.deletable = false;
            this.set_transient_for (parent);
            this.set_default_size (500, 350);
            this.set_size_request (500, 350);
            this.set_modal (true);

            this.settings = Ciano.Services.Settings.get_instance ();

            var grid = new Gtk.Grid ();
            grid.row_spacing = 5;
            grid.column_spacing = 5;
            grid.margin = 7;
            grid.margin_top = 5;

            init_options ();
            mount_options (grid);

            this.get_content_area ().add (grid);
        }

        /**
         * Set the last values defined in the widgets.
         *
         * @see Ciano.Config.Settings
         * @see Ciano.Utils.StringUtil
         * @return {@code void}
         */
        private void init_options () {
            this.output_folder = new Gtk.FileChooserButton (StringUtil.EMPTY, Gtk.FileChooserAction.SELECT_FOLDER);
            this.output_folder.hexpand = true;
            this.output_folder.set_current_folder (this.settings.output_folder);
            this.output_folder.selection_changed.connect (() => {
                this.settings.output_folder = this.output_folder.get_file ().get_path ();
            });

            this.output_source_file_folder = new Gtk.Switch ();
            this.settings.schema.bind ("output-source-file-folder", this.output_source_file_folder, "active", SettingsBindFlags.DEFAULT);
            this.output_source_file_folder.notify["active"].connect (() => {
                if (this.output_source_file_folder.active) {
                    this.output_folder.sensitive = false;
                } else {
                    this.output_folder.sensitive = true;
                }
            });

            this.complete_notify = new Gtk.Switch ();
            this.settings.schema.bind ("complete-notify", this.complete_notify, "active", SettingsBindFlags.DEFAULT);

            this.error_notify = new Gtk.Switch ();
            this.settings.schema.bind ("error-notify", this.error_notify, "active", SettingsBindFlags.DEFAULT);

            if (this.output_source_file_folder.active) {
                this.output_folder.sensitive = false;
            }
        }

        /**
         * Assemble the entire grid. "line by line".
         *
         * @param  {@code Gtk.Grid}
         * @return {@code void}
         */
        private void mount_options (Gtk.Grid grid) {
            var row = 0;

            mount_section_output_folder (grid, ref row);

            mount_section_notify (grid, ref row);

            mount_buttons (grid, ref row);
        }

        /**
         * Mounts the section on output folder.
         *
         * @see Ciano.Configs.Properties
         * @see add_section
         * @see add_option
         * @param  {@code Gtk.Grid} grid
         * @param  {@code int} row
         * @return {@code void}
         */
        private void mount_section_output_folder (Gtk.Grid grid, ref int row) {
            // Section name: Output Folder
            var label_output_folder = new Gtk.Label (Properties.TEXT_OUTPUT_FOLDER);
            add_section (grid, label_output_folder, ref row);

                // Option: Output to source file folder
                var label_output_source_file_folder = new Gtk.Label (Properties.TEXT_OUTPUT_SOURCE_FILE_FOLDER);
                add_option (grid, label_output_source_file_folder, this.output_source_file_folder, ref row);

                // Option: Select output
                var label_select_output_folder = new Gtk.Label (Properties.TEXT_SELECT_OUTPUT_FOLDER);
                add_option (grid, label_select_output_folder, this.output_folder, ref row);
        }

        /**
         * Mount notification section.
         *
         * @see Ciano.Configs.Properties
         * @see add_section
         * @see add_option
         * @param  {@code Gtk.Grid} grid
         * @param  {@code int} row
         * @return {@code void}
         */
        private void mount_section_notify (Gtk.Grid grid, ref int row) {
            // Section name: Notify
            var label_notify = new Gtk.Label (Properties.TEXT_NOTIFY);
            add_section (grid, label_notify, ref row);

                // Option: Complete Notify
                var label_complete_notify = new Gtk.Label (Properties.TEXT_COMPLETE_NOTIFY);
                add_option (grid, label_complete_notify, this.complete_notify, ref row);

                // Option: Erro Notify
                var label_error_notify = new Gtk.Label (Properties.TEXT_ERRO_NOTIFY);
                add_option (grid, label_error_notify, this.error_notify, ref row);
        }

        /**
         * Mount buttons section.
         *
         * @see Ciano.Configs.Properties
         * @param  {@code Gtk.Grid} grid
         * @param  {@code int} row
         * @return {@code void}
         */
        private void mount_buttons (Gtk.Grid grid, ref int row) {
            var close_button = new Gtk.Button.with_label (Properties.TEXT_CLOSE);
            close_button.clicked.connect (() => { this.destroy (); });
            close_button.margin_top = 15;
            close_button.halign     = Gtk.Align.END;

            grid.attach (close_button, 3, row, 1, 1);
        }

        /**
         * Responsible for setting the label at the beginning of each section.
         *
         * @param  {@code Gtk.Grid}  grid
         * @param  {@code Gtk.Label} name
         * @param  {@code int}       row
         * @return {@code void}
         */
        private void add_section (Gtk.Grid grid, Gtk.Label name, ref int row) {
            name.halign     = Gtk.Align.START;
            name.use_markup = true;
            name.set_markup ("<b>%s</b>".printf (name.get_text ()));
            name.get_style_context ().add_class ("title-section-dialog");

            if (row > 0) {
                name.margin_top = 10;
            }

            grid.attach (name, 0, row, 1, 1);

            row++;
        }

        /**
         * Responsible for adding an option widget.
         *
         * @param  {@code Gtk.Grid}   grid
         * @param  {@code Gtk.Label}  label
         * @param  {@code Gtk.Switch} widget
         * @param  {@code int}          row
         * @return {@code void}
         */
        private void add_option (Gtk.Grid grid, Gtk.Label label, Gtk.Widget widget, ref int row) {
            label.halign         = Gtk.Align.END;
            label.hexpand        = true;
            label.margin_start    = 35;
            label.margin_top     = 0;

            widget.halign     = Gtk.Align.START;
            widget.hexpand    = true;
            widget.margin_top = 0;

            grid.attach (label, 0, row, 1, 1);
            grid.attach_next_to (widget, label, Gtk.PositionType.RIGHT, 3, 1);

            row++;
        }
    }
}

