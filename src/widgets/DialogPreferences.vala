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

namespace Ciano.Widgets {

    public class DialogPreferences : Gtk.Dialog {

        private int row = 0;

        public DialogPreferences (Gtk.Window parent) {
            this.title = _("Preferences");
            this.resizable = false;
            this.deletable = false;
            this.set_transient_for (parent);
            this.set_default_size (500, 350);
            this.set_size_request (500, 350);
            this.set_modal (true);

            Ciano.Services.Settings settings = Ciano.Services.Settings.get_instance ();

            Gtk.Grid grid = new Gtk.Grid ();
            grid.row_spacing = 5;
            grid.column_spacing = 5;
            grid.margin = 7;
            grid.margin_top = 5;
            
            Gtk.FileChooserButton output_folder = new Gtk.FileChooserButton (StringUtil.EMPTY, Gtk.FileChooserAction.SELECT_FOLDER);
            output_folder.hexpand = true;
            output_folder.set_current_folder (settings.output_folder);
            output_folder.selection_changed.connect (() => {
                settings.output_folder = output_folder.get_file ().get_path ();
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

            var label_output_folder = new Gtk.Label (_("Output folder:"));
            add_section (grid, label_output_folder);

            var label_output_source_file_folder = new Gtk.Label (_("Files origin:"));
            add_option (grid, label_output_source_file_folder, output_source_file_folder);

            var label_select_output_folder = new Gtk.Label (_("Select the output folder:"));
            add_option (grid, label_select_output_folder, output_folder);

            var label_notify = new Gtk.Label (_("Notifications:"));
            add_section (grid, label_notify);

            var label_complete_notify = new Gtk.Label (_("Notify about completed action:"));
            add_option (grid, label_complete_notify, complete_notify);
            
            var label_error_notify = new Gtk.Label (_("Notify about an error:"));
            add_option (grid, label_error_notify, error_notify);

            Gtk.Box content_area = (Gtk.Box) this.get_content_area ();
            content_area.add (grid);

            var close_button = (Gtk.Button) add_button (_("Close"), Gtk.ResponseType.CANCEL);
            close_button.clicked.connect (() => { 
                this.destroy (); 
            });
        }

        private void add_section (Gtk.Grid grid, Gtk.Label name) {
            name.halign     = Gtk.Align.START;
            name.use_markup = true;
            name.set_markup ("<b>%s</b>".printf (name.get_text ()));
            name.get_style_context ().add_class ("title-section-dialog");

            if (this.row > 0) {
                name.margin_top = 10;
            }

            grid.attach (name, 0, this.row, 1, 1);

            this.row++;
        }

        private void add_option (Gtk.Grid grid, Gtk.Label label, Gtk.Widget widget) {
            label.halign         = Gtk.Align.END;
            label.hexpand        = true;
            label.margin_left    = 35;
            label.margin_top     = 0;

            widget.halign     = Gtk.Align.START;
            widget.hexpand    = true;
            widget.margin_top = 0;            

            grid.attach (label, 0, this.row, 1, 1);
            grid.attach_next_to (widget, label, Gtk.PositionType.RIGHT, 3, 1);

            this.row++;
        }
    }
}