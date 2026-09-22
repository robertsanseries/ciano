/*
 * Copyright (c) 2017, 2026 Robert San <robertsanseries@gmail.com>
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
using Ciano.Views;
using Ciano.Widgets;
using Ciano.Objects;
using Ciano.Utils;
using Ciano.Enums;

namespace Ciano.Controllers {

    /**
     * Central controller responsible for coordinating:
     * - File selection
     * - Command generation
     * - Subprocess execution
     * - UI synchronization
     */
    public class ConverterController : Object {

        private Gee.ArrayList<ItemConversion> list_items;
        private Gee.LinkedList<ItemConversion> conversion_queue;
        private int active_conversions;
        private Gtk.Application application;
        private Gtk.ApplicationWindow window;
        private Ciano.Services.Settings settings;
        private ConverterView converter_view;

        private string name_format_selected;
        private int id_item_counter;

        /**
         * Creates the controller and connects sidebar signals.
         *
         * @param window Main application window.
         * @param application Gtk application instance.
         * @param converter_view Main conversion view.
         */
        public ConverterController (
                Gtk.ApplicationWindow window,
                Gtk.Application application,
                ConverterView converter_view
        ) {
            this.converter_view = converter_view;
            this.application = application;
            this.window = window;

            this.settings = Ciano.Services.Settings.get_instance ();
            this.list_items = new Gee.ArrayList<ItemConversion> ();
            this.conversion_queue = new Gee.LinkedList<ItemConversion> ();
            this.active_conversions = 0;
            this.id_item_counter = 1;

            this.connect_sidebar_signal ();
        }

        /**
         * Connects sidebar selection to open conversion dialog.
         */
        private void connect_sidebar_signal () {
            this.converter_view.source_list.item_selected.connect ((item) => {

                if (!item.selectable) {
                    return;
                }

                this.name_format_selected = item.name;
                var formats = FormatUtil.get_input_formats (item.name);

                var dialog = new DialogConvertFile (this, formats, item.name, this.window);
                dialog.present ();
            });
        }

        /**
         * Opens GTK4 file dialog asynchronously.
         *
         * @param list_store UI store to append selected files.
         * @param formats Supported extensions.
         */
        public void on_activate_button_add_file (GLib.ListStore list_store, string[] formats) {
            this.select_files_async.begin (list_store, formats);
        }

        /**
         * Async file selection handler.
         * Uses MIME types instead of glob patterns to correctly match all known
         * file extensions and capitalizations, including variants like .3gpp,
         * .3ga for 3GP and uppercase .WAV, .MP4, etc.
         */
        private async void select_files_async (GLib.ListStore list_store, string[] formats) {
            var dialog = new Gtk.FileDialog ();
            dialog.set_title (_("Select file"));
            dialog.set_modal (true);

            var filter = new Gtk.FileFilter ();
            filter.name = _("Select file");

            foreach (string format in formats) {
                string? mime = FormatUtil.get_mime_type (format);
                if (mime != null) {
                    filter.add_mime_type (mime);
                } else {
                    filter.add_pattern ("*." + format.ascii_down ());
                    filter.add_pattern ("*." + format.up ());
                }
            }

            var filters = new GLib.ListStore (typeof (Gtk.FileFilter));
            filters.append (filter);
            dialog.set_filters (filters);

            try {
                var files = yield dialog.open_multiple (this.window, null);

                for (uint i = 0; i < files.get_n_items (); i++) {
                    var file = (File) files.get_item (i);
                    string? file_path = file.get_path ();

                    if (file_path == null) {
                        // Attempt to resolve the physical path using the URI provided by the system portal
                        var local = File.new_for_uri (file.get_uri ());
                        file_path = local.get_path ();
                    }

                    if (file_path != null) {
                        // Proceed with adding the item to the list
                        string basename = Path.get_basename (file_path);
                        string directory = Path.get_dirname (file_path) + Path.DIR_SEPARATOR_S;
                        list_store.append (new FileItem (basename, directory));
                    } else {
                        // Log a debug message if the path cannot be resolved from the URI
                        Logger.error ("Unresolvable file path: %s".printf (file.get_uri ()));
                        continue;
                    }
                }
            } catch (Error e) {
                Logger.debug ("File dialog cancelled: %s".printf (e.message));
            }
        }

        /**
         * Starts conversion for all items in the list store.
         *
         * @param list_store Store containing FileItem objects.
         * @param name_format Target format selected.
         */
        public void on_activate_button_start_conversion (GLib.ListStore list_store, string name_format) {
            this.converter_view.list_conversion.stack.set_visible_child_name (Constants.LIST_BOX_VIEW);

            var type_item = FormatUtil.resolve_type_item (name_format);

            for (uint i = 0; i < list_store.get_n_items (); i++) {

                var file_item = (FileItem) list_store.get_item (i);

                var item = new ItemConversion (
                        id_item_counter++,
                        file_item.name,
                        file_item.directory,
                        name_format,
                        0,
                        type_item
                );

                this.list_items.add (item);
                this.conversion_queue.add (item);
            }

            this.process_queue ();
        }

        /**
         * Returns the effective conversion concurrency limit.
         * Uses CPU core count when {@code use_cpu_cores_limit} is enabled,
         * otherwise falls back to the user-configured value (minimum 1).
         */
        private int get_effective_limit () {
            if (this.settings.use_cpu_cores_limit) {
                return (int) GLib.get_num_processors ();
            }

            int max_limit = (int) GLib.get_num_processors ();
            return this.settings.max_simultaneous_conversions.clamp (1, max_limit);
        }

        /**
         * Dispatches queued items while active conversions are below the limit.
         */
        private void process_queue () {
            while (this.conversion_queue.size > 0 && this.active_conversions < this.get_effective_limit ()) {
                var item = this.conversion_queue.poll ();
                this.active_conversions++;
                this.execute_conversion (item);
            }
        }

        /**
         * Creates subprocess and monitors execution.
         *
         * @param item Conversion item metadata.
         */
        private void execute_conversion (ItemConversion item) {
            try {
                var directory = File.new_for_path (item.directory);

                if (!directory.query_exists ()) {
                    directory.make_directory_with_parents ();
                }

                string input = Path.build_filename (item.directory, item.name);
                string output = this.generate_output_uri (input, item.convert_to);
                string[] args = this.get_command_arguments (input, output, item.convert_to, item.type_item);

                Logger.info ("[CMD] " + string.joinv (" ", args));
                Logger.info ("[INPUT EXISTS] " + FileUtils.test (input, FileTest.EXISTS).to_string ());
                Logger.info ("[OUTPUT DIR] " + Path.get_dirname (output));

                var launcher = new SubprocessLauncher (SubprocessFlags.STDERR_PIPE);
                var subprocess = launcher.spawnv (args);
                var row = this.create_row_conversion (item, subprocess);

                this.converter_view.list_conversion.list_box.append (row);

                this.monitor_subprocess_async.begin (subprocess, row, item);

            } catch (Error e) {
                Logger.error (e.message);
            }
        }

        /**
         * Monitors FFmpeg stderr asynchronously.
         *
         * @param proc Running subprocess.
         * @param row UI row linked to conversion.
         * @param item Conversion metadata.
         */
        private async void monitor_subprocess_async (Subprocess proc, RowConversion row, ItemConversion item) {
            var stream = new DataInputStream (proc.get_stderr_pipe ());
            var progress = new ConversionProgress ();

            try {
                while (true) {
                    string? line = yield stream.read_line_utf8_async ();

                    if (line == null) {
                        break;
                    }

                    if (item.type_item != TypeItemEnum.IMAGE || item.convert_to.ascii_down () == "gif") {
                        double fraction;
                        string status;

                        FFmpegUtil.parse_progress (line, progress, out fraction, out status);

                        if (fraction >= 0) {
                            Idle.add (() => {
                                row.update_progress (fraction);
                                row.status_label.label = status;
                                return false;
                            });
                        }
                    }

                    if (this.check_for_errors (line, row)) {
                        if (this.settings.error_notify) {
                            this.send_notification (item, _("Error in conversion"));
                        }
                        break;
                    }
                }

                yield proc.wait_async (null);
                this.finalize_ui (proc, row, item);
            } catch (Error e) {
                Logger.error (e.message);
            }
        }

        /**
         * Updates UI after subprocess termination.
         *
         * @param proc Completed subprocess.
         * @param row UI row.
         * @param item Conversion metadata.
         */
        private void finalize_ui (Subprocess proc, RowConversion row, ItemConversion item) {
            Idle.add (() => {
                WidgetUtil.set_visible (row.button_cancel, false);
                WidgetUtil.set_visible (row.button_remove, true);

                try {
                    if (proc.wait_check ()) {
                        row.update_progress (1.0);
                        row.status_label.label = _("Conversion completed");

                        if (this.settings.complete_notify) {
                            this.send_notification (item, _("Conversion completed"));
                        }
                    }

                } catch (Error e) {
                    int status = proc.get_exit_status ();

                    if (status == 9) {
                        row.status_label.label = _("Conversion canceled");
                    } else {
                        row.status_label.label = _("Error in conversion");

                        if (this.settings.complete_notify) {
                            this.send_notification (item, _("Error in conversion"));
                        }
                    }

                    Logger.error ("FFmpeg failed with exit code %d: %s".printf (status, e.message));
                }

                this.active_conversions--;
                this.process_queue ();

                return false;
            });
        }

        /**
         * Detects known FFmpeg errors in output.
         *
         * @param line Raw stderr line.
         * @param row UI row to update.
         * @return true if error detected.
         */
        private bool check_for_errors (string line, RowConversion row) {
            string? error_msg = null;

            if (line.contains ("No such file")) {
                error_msg = _("Error: No such file or directory");
            } else if (line.contains ("Invalid argument")) {
                error_msg = _("Error: Invalid argument");
            } else if (line.contains ("Experimental codecs")) {
                error_msg = _("Error: Experimental codecs are not enabled");
            } else if (line.contains ("Invalid data found")) {
                error_msg = _("Error: Invalid data found when processing input");
            }

            if (error_msg != null) {
                Idle.add (() => {
                    row.status_label.label = error_msg;
                    row.status_label.add_css_class ("color-label-error");
                    return false;
                });

                return true;
            }

            return false;
        }

        /**
         * Builds FFmpeg command arguments.
         *
         * @param input Absolute input path.
         * @param output Absolute output path.
         * @param name_format Target format for this specific item (e.g., "MP4", "GIF").
         * @param type_item Media type category for this specific item.
         * @return Argument array.
         */
        public string[] get_command_arguments (
                string input,
                string output,
                string name_format,
                TypeItemEnum type_item
        ) throws Error {
            return FFmpegUtil.build_arguments (FFmpegUtil.get_executable (), input, output, name_format, type_item);
        }

        /**
         * Generates output path respecting user settings.
         * Creates the output directory if it does not exist.
         *
         * @param uri Input path.
         * @param name_format Target format for this specific item (e.g., "MP4", "GIF").
         * @return Output path.
         */
        private string generate_output_uri (string uri, string name_format) {
            if (!this.settings.output_source_file_folder) {
                var output_dir = File.new_for_path (this.settings.output_folder);
                if (!output_dir.query_exists ()) {
                    try {
                        output_dir.make_directory_with_parents ();
                    } catch (Error e) {
                        Logger.error ("Failed to create output folder: %s".printf (e.message));
                    }
                }
            }

            return FileUtil.build_output_path (
                    uri,
                    name_format,
                    this.settings.output_source_file_folder,
                    this.settings.output_folder
            );
        }

        /**
         * Sends system notification.
         *
         * @param item Conversion metadata.
         * @param body Notification message.
         */
        private void send_notification (ItemConversion item, string body) {
            var n = new Notification (item.name);
            n.set_body (body);
            n.set_icon (new ThemedIcon (this.get_type_icon (item)));
            this.application.send_notification (null, n);
        }

        /**
         * Resolves icon name by media type.
         *
         * @param item Conversion metadata.
         * @return Freedesktop symbolic icon name.
         */
        private string get_type_icon (ItemConversion item) {
            switch (item.type_item) {
                case TypeItemEnum.VIDEO: return "media-video";
                case TypeItemEnum.MUSIC: return "audio-x-generic";
                case TypeItemEnum.IMAGE: return "image-x-generic";
                default: return "text-x-generic";
            }
        }

        /**
         * Creates row widget and connects cancel/remove actions.
         *
         * @param item Conversion metadata.
         * @param proc Subprocess instance.
         * @return RowConversion widget.
         */
        private RowConversion create_row_conversion (ItemConversion item, Subprocess proc) {
            var row = new RowConversion (this.get_type_icon (item), item.name, 0, item.convert_to);

            row.button_cancel.clicked.connect (() => {
                proc.force_exit ();
            });

            row.button_remove.clicked.connect (() => {
                this.converter_view.list_conversion.list_box.remove (row);
                this.converter_view.list_conversion.item_quantity--;

                if (this.converter_view.list_conversion.item_quantity == 0) {
                    this.converter_view.list_conversion.stack.set_visible_child_name (Constants.WELCOME_VIEW);
                }
            });

            this.converter_view.list_conversion.item_quantity++;
            WidgetUtil.set_visible (row.button_remove, false);

            return row;
        }
    }
}
