/*
 * Copyright (c) 2017-2018 Robert San <robertsanseries@gmail.com>
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
using Ciano.Views;

namespace Ciano.Widgets {

    public class PopoverPreferences : Gtk.Dialog {

        public PopoverPreferences (ApplicationView parent) {
            this.title = _("Preferences");
            this.resizable = false;
            this.deletable = false;
            this.set_transient_for (parent);
            this.set_default_size (450, 500);
            this.set_size_request (450, 500);
            this.set_modal (true);

            Gtk.Stack stack = new Gtk.Stack ();
            stack.set_transition_type (Gtk.StackTransitionType.SLIDE_LEFT_RIGHT);
            stack.add_titled (get_general_box (parent), "general", _("General"));
            stack.add_titled (get_behavior_box (), "behavior", _("Behavior"));
            
            Gtk.StackSwitcher stackswitcher = new Gtk.StackSwitcher ();
            stackswitcher.set_stack (stack);
            stackswitcher.set_halign (Gtk.Align.CENTER);

            Gtk.Box content_area = (Gtk.Box) this.get_content_area ();
            content_area.spacing = 10;
            content_area.add (stackswitcher);
            content_area.add (stack);

            Gtk.Button close_button = (Gtk.Button) add_button (_("Close"), Gtk.ResponseType.CANCEL);
            close_button.clicked.connect (() => { 
                this.destroy (); 
            });
        }

        private Gtk.Grid get_general_box (ApplicationView parent) {

            Ciano.Services.Settings settings = Ciano.Services.Settings.get_instance ();
            
            Gtk.FileChooserButton output_folder = new Gtk.FileChooserButton (StringUtil.EMPTY, Gtk.FileChooserAction.SELECT_FOLDER);
            output_folder.hexpand = true;
            output_folder.set_current_folder (settings.output_folder);
            output_folder.selection_changed.connect (() => {
                settings.output_folder = output_folder.get_file ().get_path ();
            });

            Gtk.ComboBoxText theme = new Gtk.ComboBoxText ();
            theme.width_request =  170;
            theme.append_text ("dark");
            theme.append_text ("default");
            theme.append_text ("elementary");
            theme.set_active (settings.theme);
            theme.changed.connect (() => {
                settings.theme = theme.get_active ();
                parent.load_css_provider ();
            });            

            Gtk.ComboBoxText language = new Gtk.ComboBoxText ();
            language.width_request =  170;
            language.append_text ("Chinese  - Simplified");
            language.append_text ("Dutch");
            language.append_text ("English");
            language.append_text ("French");
            language.append_text ("Lithuanian");
            language.append_text ("Portuguese - Brazil");
            language.append_text ("Spanish");
            language.set_active (settings.language);
            language.changed.connect (() => {
                settings.language = language.get_active ();
            });
            
            Gtk.Switch output_source_file_folder = new Gtk.Switch ();
            settings.schema.bind ("output-source-file-folder", output_source_file_folder, "active", SettingsBindFlags.DEFAULT);
            output_source_file_folder.notify["active"].connect (() => {
                if (output_source_file_folder.active) {
                    output_folder.sensitive = false;
                } else {
                    output_folder.sensitive = true;
                }
            });

            if (output_source_file_folder.active) {
                output_folder.sensitive = false;
            }

            Gtk.Switch complete_notify = new Gtk.Switch ();
            settings.schema.bind ("complete-notify", complete_notify, "active", SettingsBindFlags.DEFAULT);

            Gtk.Switch error_notify = new Gtk.Switch ();
            settings.schema.bind ("error-notify", error_notify, "active", SettingsBindFlags.DEFAULT);

            int row = 1;

            Gtk.Grid grid = new Gtk.Grid ();
            grid.row_spacing = 5;
            grid.column_spacing = 5;
            grid.margin = 7;
            grid.margin_top = 5;

            Gtk.Label label_output_folder = new Gtk.Label (_("Output folder:"));
            add_section (grid, label_output_folder, ref row);

            Gtk.Label label_output_source_file_folder = new Gtk.Label (_("Files origin:"));
            add_option (grid, label_output_source_file_folder, output_source_file_folder, ref row);

            Gtk.Label label_select_output_folder = new Gtk.Label (_("Select the output folder:"));
            add_option (grid, label_select_output_folder, output_folder, ref row);

            Gtk.Label label_notify = new Gtk.Label (_("Notifications:"));
            add_section (grid, label_notify, ref row);

            Gtk.Label label_complete_notify = new Gtk.Label (_("Notify about completed action:"));
            add_option (grid, label_complete_notify, complete_notify, ref row);
            
            Gtk.Label label_error_notify = new Gtk.Label (_("Notify about an error:"));
            add_option (grid, label_error_notify, error_notify, ref row);

            Gtk.Label label_interface = new Gtk.Label (_("Interface:"));
            add_section (grid, label_interface, ref row);

            Gtk.Label label_theme = new Gtk.Label (_("Theme:"));
            add_option (grid, label_theme, theme, ref row);

            //Gtk.Label label_language = new Gtk.Label (_("Language:"));
            //add_option (grid, label_language, language, ref row);

            return grid;
        }

        private Gtk.Grid get_behavior_box () {

            Ciano.Services.Settings settings = Ciano.Services.Settings.get_instance ();
            
            Gtk.SpinButton simultaneous_conversion_spinner = new Gtk.SpinButton.with_range(1, 10, 1);
            simultaneous_conversion_spinner.width_request =  170;
            simultaneous_conversion_spinner.value = (double) settings.simultaneous_conversion;
            simultaneous_conversion_spinner.value_changed.connect(() => {
                settings.simultaneous_conversion = (int) simultaneous_conversion_spinner.value;
            });

            Gtk.Switch delete_source_files = new Gtk.Switch ();
            settings.schema.bind ("delete-source-files", delete_source_files, "active", SettingsBindFlags.DEFAULT);

            Gtk.Switch delete_files_conversion_fails = new Gtk.Switch ();
            settings.schema.bind ("delete-files-conversion-fails", delete_files_conversion_fails, "active", SettingsBindFlags.DEFAULT);

            Gtk.Switch open_output_folder_end = new Gtk.Switch ();
            settings.schema.bind ("open-output-folder-end", open_output_folder_end, "active", SettingsBindFlags.DEFAULT);

            Gtk.Switch suspend_computer = new Gtk.Switch ();
            settings.schema.bind ("suspend-computer", suspend_computer, "active", SettingsBindFlags.DEFAULT);

            Gtk.Switch off_computer = new Gtk.Switch ();
            settings.schema.bind ("off-computer", off_computer, "active", SettingsBindFlags.DEFAULT);

            Gtk.Switch continue_conversion = new Gtk.Switch ();
            settings.schema.bind ("continue-conversion", continue_conversion, "active", SettingsBindFlags.DEFAULT);
            
            int row = 1;

            Gtk.Grid grid = new Gtk.Grid ();
            grid.row_spacing = 5;
            grid.column_spacing = 5;
            grid.margin = 7;
            grid.margin_top = 5;

            Gtk.Label conversion_label = new Gtk.Label (_("Conversion:"));
            add_section (grid, conversion_label, ref row);

            Gtk.Label label_language = new Gtk.Label (_("Simultaneous conversation:"));
            add_option (grid, label_language, simultaneous_conversion_spinner, ref row);

            Gtk.Label after_conversion_label = new Gtk.Label (_("After conversion:"));
            add_section (grid, after_conversion_label, ref row);

            Gtk.Label delete_source_files_label = new Gtk.Label (_("Delete source files:"));
            add_option (grid, delete_source_files_label, delete_source_files, ref row);

            Gtk.Label delete_files_conversion_fails_label = new Gtk.Label (_("Delete files if conversion fails:"));
            add_option (grid, delete_files_conversion_fails_label, delete_files_conversion_fails, ref row);

            Gtk.Label open_output_folder_label = new Gtk.Label (_("Open output folder:"));
            add_option (grid, open_output_folder_label, open_output_folder_end, ref row);

            Gtk.Label suspend_computer_label = new Gtk.Label (_("Suspend the computer:"));
            add_option (grid, suspend_computer_label, suspend_computer, ref row);

            Gtk.Label off_computer_label = new Gtk.Label (_("Turn off the computer:"));
            add_option (grid, off_computer_label, off_computer, ref row);

            Gtk.Label work_area_label = new Gtk.Label (_("Work area integration:"));
            add_section (grid, work_area_label, ref row);

            Gtk.Label continue_conversion_label = new Gtk.Label (_("Continue conversion when closed:"));
            add_option (grid, continue_conversion_label, continue_conversion, ref row);

            return grid;
        }

        private void add_section (Gtk.Grid grid, Gtk.Label name, ref int row) {
            name.halign     = Gtk.Align.START;
            name.use_markup = true;
            name.set_markup ("<b>%s</b>".printf (name.get_text ()));
            name.get_style_context ().add_class (Granite.STYLE_CLASS_H4_LABEL);

            if (row > 0) {
                name.margin_top = 10;
            }

            grid.attach (name, 0, row, 1, 1);

            row++;
        }

        private void add_option (Gtk.Grid grid, Gtk.Label label, Gtk.Widget widget, ref int row) {
            label.halign         = Gtk.Align.END;
            label.hexpand        = true;
            label.margin_left    = 10;
            label.margin_top     = 0;

            widget.halign     = Gtk.Align.START;
            widget.hexpand    = true;
            widget.margin_top = 0;            

            grid.attach (label, 0, row, 1, 1);
            grid.attach_next_to (widget, label, Gtk.PositionType.RIGHT, 1, 1);

            row++;
        }
    }
}