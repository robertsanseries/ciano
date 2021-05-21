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
using Ciano.Views;
using Ciano.Widgets;
using Ciano.Objects;
using Ciano.Utils;
using Ciano.Enums;

namespace Ciano.Controllers {

    /**
     * The {@code ConverterController} class is responsible for handling all the major
     * rules and actions of the application.
     *
     * @since 0.1.0
     */
    public class ConverterController {

        public  Gee.ArrayList<RowConversion>    convertions;
        private Gee.ArrayList<ItemConversion>   list_items;
        private Gtk.Application                 application;
        private Ciano.Services.Settings          settings;
        private ConverterView                   converter_view;
        private DialogPreferences               dialog_preferences;
        private DialogConvertFile               dialog_convert_file;       
        private TypeItemEnum                    type_item;
        private string                          name_format_selected;
        private int                             id_item;

        /**
         * Constructs a new object {@code ConverterView} responsible for:
         * 1 - Initialize values that are handled by the class.
         * 2 - Get an instance of the {@code Settings} class.
         * 3 - Start the Items array for conversion and the item counter.
         * 4 - Load the methods that are responsible for the action of the dialogs. 
         *
         * @see Ciano.Views.ConverterView
         * @see Ciano.Config.Settings
         * @see Ciano.Objects.ItemConversion
         * @see on_activate_button_preferences
         * @see on_activate_button_item
         * @param {@code Gtk.ApplicationWindow} window
         * @param {@code Gtk.Application}       application
         * @param {@code ConverterView}         converter_view
         */
        public ConverterController (Gtk.ApplicationWindow window, Gtk.Application application,  ConverterView converter_view) {
            this.converter_view = converter_view;
            this.application    = application;
            
            this.settings   = Ciano.Services.Settings.get_instance ();
            this.list_items = new Gee.ArrayList<ItemConversion> ();
            this.id_item    = 1;
            
            on_activate_button_preferences (window);
            on_activate_button_item (window);
        }

        /**
         * When select the preferences option in the settings icon located in the headerbar, 
         * this method will call the "DialogPreferences".
         *
         * @see Ciano.Widgets.DialogPreferences
         * @param  {@code Gtk.ApplicationWindow} window
         * @return {@code void}
         */
        private void on_activate_button_preferences (Gtk.ApplicationWindow window) {
            this.converter_view.headerbar.item_selected.connect (() => {
                this.dialog_preferences = new DialogPreferences (window);
                this.dialog_preferences.show_all ();
            }); 
        }

        /**
         * When selecting which type to convert:
         * 1 - Stores the name of the selected type.
         * 2 - Call the {@code mount_array_with_supported_formats} method to define the types of formats that will be
         *     possible to add in the {@code Gtk.TreeView} of {@code DialogConvertFile} for conversion.
         * 3 - Build the {@code DialogConvertFile}.
         *
         * @see Ciano.Widgets.DialogConvertFile
         * @see mount_array_with_supported_formats
         * @param  {@code Gtk.ApplicationWindow} window
         * @return {@code void}
         */
        private void on_activate_button_item (Gtk.ApplicationWindow window) {
            this.converter_view.source_list.item_selected.connect ((item) => {

                this.name_format_selected = item.name;
                var types = mount_array_with_supported_formats (item.name);

                this.dialog_convert_file = new DialogConvertFile (this, types, item.name, window);
                this.dialog_convert_file.show_all ();
            });
        }

        /**
         * Method responsible for adding one or more files to {@code Gtk.TreeView} from {@code DialogConvertFile}.
         *
         * @see Ciano.Widgets.DialogConvertFile
         * @see Ciano.Configs.Properties
         * @param  {@code Gtk.Dialog}    parent_dialog
         * @param  {@code Gtk.TreeView}  tree_view
         * @param  {@code Gtk.TreeIter}  iter
         * @param  {@code Gtk.ListStore} list_store
         * @param  {@code string []}     formats
         * @return {@code void}
         */
        public void on_activate_button_add_file (Gtk.Dialog parent_dialog, Gtk.TreeView tree_view, Gtk.TreeIter iter, Gtk.ListStore list_store, string [] formats) {
            var chooser_file = new Gtk.FileChooserDialog (Properties.TEXT_SELECT_FILE, parent_dialog, Gtk.FileChooserAction.OPEN);
            chooser_file.select_multiple = true;

            var filter = new Gtk.FileFilter ();

            foreach (string format in formats) {
                filter.add_pattern ("*.".concat (format.down ()));
            }       

            chooser_file.set_filter (filter);
            chooser_file.add_buttons (Properties.TEXT_CANCEL, Gtk.ResponseType.CANCEL, Properties.TEXT_ADD, Gtk.ResponseType.OK);

            if (chooser_file.run () == Gtk.ResponseType.OK) {

                SList<string> uris = chooser_file.get_filenames ();

                foreach (unowned string uri in uris)  {
                    
                    var file         = File.new_for_uri (uri);
                    int index        = file.get_basename ().last_index_of("/");
                    string name      = file.get_basename ().substring(index + 1, -1);
                    string directory = file.get_basename ().substring(0, index + 1);

                    list_store.append (out iter);
                    list_store.set (iter, 0, name, 1, directory);
                    tree_view.expand_all ();
                }
            }

            chooser_file.hide ();
        }
        
        /**
         * Removeable add-on method added in {@code Gtk.TreeView} {@code DialogConvertFile}
         * 
         * @param  {@code Gtk.Dialog}     parent_dialog
         * @param  {@code Gtk.TreeView}   tree_view
         * @param  {@code Gtk.ListStore}  list_store
         * @param  {@code Gtk.ToolButton} button_remove
         * @return {@code void}
         */
        public void on_activate_button_remove (Gtk.Dialog parent_dialog, Gtk.TreeView tree_view, Gtk.ListStore list_store, Gtk.ToolButton button_remove) {

            Gtk.TreePath path;
            Gtk.TreeViewColumn column;

            tree_view.get_cursor (out path, out column);

            if(path != null) {
                Gtk.TreeIter iter;
                
                list_store.get_iter (out iter, path);
                list_store.remove (ref iter);

                if (path.to_string () == "0") {
                    button_remove.sensitive = false;
                }
            }
        }
        
        /**
         * Method responsible for initiating action when user clicks "start conversion" 
         * button on {@code Gtk.TreeView} from {@code DialogConvertFile}.
         * 
         * In each foreach item {@code load_list_for_conversion} will perform the following action:
         * 1 - Get the name and directory of the file.
         * 2 - Creates an {@code ItemConversion} to store the status of each item.
         * 3 - Adds {@code ItemConversion} to {@code list list_items}.
         * 4 - {@code start_conversion_process} method responsible for starting the item conversion..
         * 
         * @see Ciano.Configs.Constants
         * @see Ciano.Objects.ItemConvertion
         * @see start_conversion_process
         * @param  {@code Gtk.ListStore} list_store
         * @param  {@code string}        name_format
         * @return {@code void}
         */
        public void on_activate_button_start_conversion (Gtk.ListStore list_store, string name_format){

            this.converter_view.list_conversion.stack.set_visible_child_name (Constants.LIST_BOX_VIEW);
            this.converter_view.list_conversion.stack.show_all ();

            Gtk.TreeModelForeachFunc load_list_for_conversion = (model, path, iter) => {
                GLib.Value cell1;
                GLib.Value cell2;

                list_store.get_value (iter, 0, out cell1);
                list_store.get_value (iter, 1, out cell2);

                var item = new ItemConversion (
                    id_item, 
                    cell1.get_string (), 
                    cell2.get_string (),
                    this.name_format_selected,
                    0,
                    this.type_item
                );

                this.list_items.add (item);
                
                start_conversion_process (item, name_format);
                this.id_item++;
               
                return false;
            };

            list_store.foreach (load_list_for_conversion);
        }

        /**
         * Method responsible for conversion suprocess.
         *
         * @see Ciano.Widgets.Properties
         * @see Ciano.Widgets.RowConversion
         * @see get_command
         * @see get_type_icon
         * @see create_row_conversion
         * @see convert_async
         * @see validate_process_completed
         * @see validate_error_in_process
         * @param  {@code ItemConversion} item
         * @param  {@code string}         name_format
         * @return {@code void}
         */
        private void start_conversion_process (ItemConversion item, string name_format) {
            try {
                if(!this.settings.output_source_file_folder){
                    var directory = File.new_for_path (this.settings.output_folder);
                    if (!directory.query_exists ()) {
                        directory.make_directory_with_parents();
                    }
                }

                string uri = item.directory + item.name;
                SubprocessLauncher launcher = new SubprocessLauncher (SubprocessFlags.STDERR_PIPE);
                Subprocess subprocess       = launcher.spawnv (get_command (uri));
                InputStream input_stream    = subprocess.get_stderr_pipe ();

                int error                   = 0;
                bool btn_cancel             = false;
                string icon                 = get_type_icon (item);
                RowConversion row           = create_row_conversion (icon, item.name, name_format, subprocess, btn_cancel);
                
                this.converter_view.list_conversion.list_box.add (row);

                convert_async.begin (input_stream, row, item, error, (obj, async_res) => {
                    try {
                        WidgetUtil.set_visible (row.button_cancel, false);
                        WidgetUtil.set_visible (row.button_remove, true);

                        if (subprocess.wait_check ()) {
                            validate_process_completed (subprocess, row, item, error);      
                        } 
                    } catch (Error e) {
                        validate_error_in_process (subprocess, row, item, error); 
                        GLib.warning ("Error: %s\n", e.message);
                    }
                });
            } catch (Error e) {                
                GLib.warning ("Error: %s\n", e.message);
            }
        }

        /**
         * If the conversion worked correctly: update row data.
         *
         * @see Ciano.Configs.Properties
         * @see Ciano.Utils.WidgetUtil
         * @see Ciano.Widgets.RowConversion
         * @param  {@code Subprocess}    subprocess
         * @param  {@code RowConversion} row
         * @param  {@code ItemConversion} item
         * @return {@code void}
         */
        private void validate_process_completed (Subprocess subprocess, RowConversion row, ItemConversion item, int error) throws Error {
            row.progress_bar.set_fraction (1);
            row.status.label = Properties.TEXT_SUCESS_IN_CONVERSION;
            
            if (this.settings.complete_notify) {
                send_notification (item.name, Properties.TEXT_SUCESS_IN_CONVERSION);
            } 
        }

        /**
         * Validates whether the process has been canceled (subprocess.get_exit_status () == 9) 
         * or if there has been an error (subprocess.get_exit_status () == 1).
         *
         * @see Ciano.Configs.Properties 
         * @see Ciano.Utils.WidgetUtil
         * @see Ciano.Widgets.RowConversion
         * @param  {@code Subprocess}     subprocess
         * @param  {@code RowConversion}  row
         * @param  {@code ItemConversion} item
         * @return {@code void}
         */
        private void validate_error_in_process (Subprocess subprocess, RowConversion row, ItemConversion item, int error) {
            if (subprocess.get_status () == 1) {
                row.progress_bar.set_fraction (0);
                
                if (error == 0) {
                    row.status.label = Properties.TEXT_ERROR_IN_CONVERSION;
                }

                if (this.settings.complete_notify) {
                    send_notification (item.name, Properties.TEXT_ERROR_IN_CONVERSION);
                }
            }

            if (subprocess.get_status () == 9) {
                row.progress_bar.set_fraction (0);
                row.status.label = Properties.TEXT_CANCEL_IN_CONVERSION;
            }
        }
        
        /**
         * Method to execute the command assembled by the {@code get_command} method and create a subprocess to get the
         * command output response. Doing the manipulation with each returned return (every new string returned).
         * 1 - Execute the command.
         * 2 - Create the subprocess
         * 3 - Force the return for each new line using {@code yield}.
         * 4 - Checks if you hear any errors during the conversion.
         * 5 - Validates the notation rule defined in DialogPreferences.
         *
         * @see Ciano.Configs.Properties
         * @see Ciano.Widgets.RowConversion
         * @see Ciano.Widgets.ItemConversion
         * @param  {@code string[]}       spawn_args
         * @param  {@code ItemConversion} item
         * @param  {@code string}         name_format
         * @return {@code void}
         */
        public async void convert_async (InputStream input_stream, RowConversion row, ItemConversion item, int error) {
            try {
                var charset_converter   = new CharsetConverter ("utf-8", "iso-8859-1");
                var costream            = new ConverterInputStream (input_stream, charset_converter);
                var data_input_stream   = new DataInputStream (costream);
                data_input_stream.set_newline_type (DataStreamNewlineType.ANY);
              
                int total = 0;

                while (true) {
                    string str_return = yield data_input_stream.read_line_utf8_async ();

                    if (str_return == null) {
                        break; 
                    } else {
                        // there is no return on image conversion, if display is pq was generated some error.
                        if (item.type_item != TypeItemEnum.IMAGE || this.name_format_selected.down () == "gif") {
                            process_line (str_return, row, ref total, error);

                            if (error > 0) {
                                if (this.settings.error_notify) {
                                    send_notification (item.name, Properties.TEXT_ERROR_IN_CONVERSION);    
                                }
                                break;
                            }
                        } else {
                            error++;
                            break;
                        }
                    }
                }
            } catch (Error e) {
                GLib.critical ("Error: %s\n", e.message);
            }
        }

        /**
         * Create row conversion.
         *
         * @see Ciano.Widgets.RowConversion 
         * @see Ciano.Utils.WidgetUtil
         * @param  {@code string}     icon
         * @param  {@code string}     item_name
         * @param  {@code string}     name_format
         * @param  {@code Subprocess} subprocess
         * @return {@code void}
         */
        private RowConversion create_row_conversion (string icon, string item_name, string name_format, Subprocess subprocess, bool btn_cancel) {
            var row = new RowConversion (icon, item_name, 0, name_format);
            
            row.button_cancel.clicked.connect(() => {
                subprocess.force_exit ();
                btn_cancel = true;
                WidgetUtil.set_visible (row.button_cancel, false);
                WidgetUtil.set_visible (row.button_remove, true);
            });

            row.button_remove.clicked.connect(() => {
                row.destroy ();
                this.converter_view.list_conversion.item_quantity += -1;
                if(this.converter_view.list_conversion.item_quantity == 0) {
                    this.converter_view.list_conversion.stack.set_visible_child_full (Constants.WELCOME_VIEW, Gtk.StackTransitionType.SLIDE_RIGHT);
                }
            });            

            this.converter_view.list_conversion.item_quantity += 1;                
            WidgetUtil.set_visible (row.button_remove, false);                

            return row;
        }

        /**
         * Responsible for returning the icon name to the type defined in {@code ItemConversion}.
         *
         * @see Ciano.Objects.ItemConversion
         * @see Ciano.Enums.TypeItemEnum
         * @see Ciano.Utils.StringUtil
         * @param  {@code ItemConversion} item
         * @return {@code string}         icon
         */
        private string get_type_icon (ItemConversion item) {
            string icon = StringUtil.EMPTY;

            switch (item.type_item) {
                case TypeItemEnum.VIDEO:
                    icon = "video-x-generic";
                    break;
                case TypeItemEnum.MUSIC:
                    icon = "audio-x-generic";
                    break;
                case TypeItemEnum.IMAGE:
                    icon = "image-x-generic";
                    break;
                default:
                    icon = "text-x-generic";
                    break;
            }

            return icon;
        }
        
        /**
         * Responsible for processing the returned row and validate the return and execution of actions accordingly.
         * 1 - Monitors the time, size, duration, and bitrate of each item.
         * 2 - Also check the error if it happens.
         *
         * @see Ciano.Widgets.RowConversion
         * @see Ciano.Configs.Properties
         * @see Ciano.Utils.StringUtil
         * @see Ciano.Utils.TimeUtil
         * @param      {@code string}           str_return
         * @param  ref {@code Gtk.ProgressBar}  progress_bar
         * @param  ref {@code Gtk.Label}        status
         * @param  ref {@code int}              total
         * @return {@code void}
         */
        private void process_line (string str_return, RowConversion row, ref int total, int error) {
            string time     = StringUtil.EMPTY;
            string size     = StringUtil.EMPTY;
            string bitrate  = StringUtil.EMPTY;

            if (str_return.contains ("Duration:")) {
                int index       = str_return.index_of ("Duration:");
                string duration = str_return.substring (index + 10, 11);

                total = TimeUtil.duration_in_seconds (duration);
            }

            if (str_return.contains ("time=") && str_return.contains ("size=") && str_return.contains ("bitrate=") ) {
                int index_time  = str_return.index_of ("time=");
                time            = str_return.substring ( index_time + 5, 11);

                int loading     = TimeUtil.duration_in_seconds (time);
                double progress = (100 * loading) / total;
                row.progress_bar.set_fraction (progress / 100);
        
                int index_size  = str_return.index_of ("size=");
                size            = str_return.substring ( index_size + 5, 11);
            
                int index_bitrate = str_return.index_of ("bitrate=");
                bitrate           = str_return.substring ( index_bitrate + 8, 11);

                row.status.label = Properties.TEXT_PERCENTAGE + progress.to_string() + "%" + Properties.TEXT_SIZE_CUSTOM + size.strip () + Properties.TEXT_TIME_CUSTOM + time.strip () + Properties.TEXT_BITRATE_CUSTOM + bitrate.strip ();
            }

            if (str_return.contains ("No such file or directory")) {
                row.status.label = Properties.MSG_ERROR_NO_SUCH_FILE_DIRECTORY;
                row.status.get_style_context ().add_class ("color-label-error");
                error++;
            } else if (str_return.contains ("Invalid argument")) {
                row.status.label = Properties.MSG_ERROR_INVALID_ARGUMENT;
                row.status.get_style_context ().add_class ("color-label-error");
                error++;
            } else if (str_return.contains ("Experimental codecs are not enabled")) {
                row.status.label = Properties.MSG_ERROR_CODECS;
                row.status.get_style_context ().add_class ("color-label-error");
                error++;
            } else if (str_return.contains ("Invalid data found when processing input")) {
                row.status.label = Properties.MSG_ERROR_INVALID_INPUT_DATA;
                row.status.get_style_context ().add_class ("color-label-error");
                error++;
            }
        }

        /**
         * Assemble the command to be executed by the terminal depending on the type of the item.
         *
         * @see Ciano.Enums.TypeItemEnum
         * @see get_uri_new_file
         * @param  {@code string} uri
         * @return {@code void}
         */
        public string[] get_command (string uri) {
            var array = new GenericArray<string> ();
            var new_file = get_uri_new_file (uri);
            
            if (this.type_item == TypeItemEnum.VIDEO || this.type_item == TypeItemEnum.MUSIC) {
                array.add ("ffmpeg");
                array.add ("-y");
                array.add ("-i");
                array.add (uri);
                
                if (this.name_format_selected.down () == "3gp" || this.name_format_selected.down () == "flv") {
                    array.add ("-vcodec");
                    array.add ("libx264");
                    array.add ("-acodec");
                    array.add ("aac");
                }

                if(this.name_format_selected.down () == "mmf") {
                    array.add ("-ar");
                    array.add ("44100");
                }

                array.add ("-strict");
                array.add ("-2");
                array.add (new_file);
            } else if (this.type_item == TypeItemEnum.IMAGE) {
                if (this.name_format_selected.down () == "gif") {
                    array.add ("ffmpeg");
                    array.add ("-y");
                    array.add ("-i");
                    array.add (uri);

                    if("webm" == FileUtil.get_file_extension_name(uri)) {
                        array.add ("-pix_fmt");
                        array.add ("rgb8");
                    } else {
                        array.add ("-ss");
                        array.add ("00:00:00.000");
                        array.add ("-vf");
                        array.add ("format=rgb8,format=rgb24");                       
                    }
                } else {
                    array.add ("convert");
                    array.add (uri);
                }

                array.add (new_file);
            }

            return array.data;
        }

        /**
         * Return the uri with the filename and extension to which it will be converted.
         * Method obeys the "paste output" rules in {@code DialogPreferences}.
         * 
         * @param  {@code string uri}
         * @return {@code void}
         */
        private string get_uri_new_file (string uri) {
            string new_file;

            if (this.settings.output_source_file_folder) {
                int index = uri.last_index_of(".");
                new_file = uri.substring(0, index + 1) + this.name_format_selected.down ();
            } else {
                int index_start = uri.last_index_of("/");
                int index_end = uri.last_index_of(".");
                var file = uri.substring(index_start, index_start - index_end);

                int index = file.last_index_of(".");
                new_file = this.settings.output_folder + file.substring(0, index + 1) + this.name_format_selected.down ();
            }

            return new_file;
        }

        /**
         * Send notification.
         * 
         * @param  {@code string}    file_name
         * @param  {@code string}    body_text
         * @return {@code void}
         */
        private void send_notification (string file_name, string body_text) {
            var notification = new Notification (file_name);
            var image = new Gtk.Image.from_icon_name ("com.github.robertsanseries.ciano", Gtk.IconSize.DIALOG);
            notification.set_body (body_text);
            notification.set_icon (image.gicon);
            this.application.send_notification ("finished", notification);
        }

        /**
         * Mount array with supported formats.
         *
         * @see Ciano.Configs.Constants
         * @see get_array_formats_videos
         * @param  {@code string} name_format
         * @return {@code void}
         */
        private string [] mount_array_with_supported_formats (string name_format) {
            var formats = new GenericArray<string> ();
            
            switch (name_format) {
                case Constants.TEXT_MP4:
                    formats = get_array_formats_videos (Constants.TEXT_MP4);
                    break;
                case Constants.TEXT_3GP:
                    formats = get_array_formats_videos (Constants.TEXT_3GP);
                    break;
                case Constants.TEXT_MPG:
                    formats = get_array_formats_videos (Constants.TEXT_MPG);
                    break;
                case Constants.TEXT_AVI:
                    formats = get_array_formats_videos (Constants.TEXT_AVI);
                    break;
                case Constants.TEXT_WMV:
                    formats = get_array_formats_videos (Constants.TEXT_WMV);
                    break;
                case Constants.TEXT_FLV:
                    formats = get_array_formats_videos (Constants.TEXT_FLV);
                    break;
                case Constants.TEXT_SWF:
                    formats = get_array_formats_videos (Constants.TEXT_SWF);
                    break;
                case Constants.TEXT_MOV:
                    formats = get_array_formats_videos (Constants.TEXT_MOV);
                    break;
                case Constants.TEXT_MKV:
                    formats = get_array_formats_videos (Constants.TEXT_MKV);
                    break;
                case Constants.TEXT_VOB:
                    formats = get_array_formats_videos (Constants.TEXT_VOB);
                    break;
                case Constants.TEXT_OGV:
                    formats = get_array_formats_videos (Constants.TEXT_OGV);
                    break;
                case Constants.TEXT_WEBM:
                    formats = get_array_formats_videos (Constants.TEXT_WEBM);
                    break;

                case Constants.TEXT_MP3:
                    formats = ArrayUtil.join_generic_string_arrays ( 
                        get_array_formats_music (Constants.TEXT_MP3), 
                        get_array_formats_videos (StringUtil.EMPTY)
                    );
                    break;
                case Constants.TEXT_WMA:
                    formats = ArrayUtil.join_generic_string_arrays ( 
                        get_array_formats_music (Constants.TEXT_WMA), 
                        get_array_formats_videos (StringUtil.EMPTY)
                    );
                    break;
                case Constants.TEXT_OGG:
                    formats = ArrayUtil.join_generic_string_arrays ( 
                        get_array_formats_music (Constants.TEXT_OGG), 
                        get_array_formats_videos (StringUtil.EMPTY)
                    );
                    break;
                case Constants.TEXT_WAV:
                    formats = ArrayUtil.join_generic_string_arrays ( 
                        get_array_formats_music (Constants.TEXT_WAV), 
                        get_array_formats_videos (StringUtil.EMPTY)
                    );
                    break;
                case Constants.TEXT_AAC:
                    formats = ArrayUtil.join_generic_string_arrays ( 
                        get_array_formats_music (Constants.TEXT_AAC), 
                        get_array_formats_videos (StringUtil.EMPTY)
                    );
                    break;
                case Constants.TEXT_FLAC:
                    formats = ArrayUtil.join_generic_string_arrays ( 
                        get_array_formats_music (Constants.TEXT_FLAC), 
                        get_array_formats_videos (StringUtil.EMPTY)
                    );
                    break;
                case Constants.TEXT_AIFF:
                    formats = ArrayUtil.join_generic_string_arrays ( 
                        get_array_formats_music (Constants.TEXT_AIFF), 
                        get_array_formats_videos (StringUtil.EMPTY)
                    );
                    break;
                case Constants.TEXT_MMF:
                    formats = ArrayUtil.join_generic_string_arrays ( 
                        get_array_formats_music (Constants.TEXT_MMF), 
                        get_array_formats_videos (StringUtil.EMPTY)
                    );
                    break;
                case Constants.TEXT_M4A:
                    formats = ArrayUtil.join_generic_string_arrays ( 
                        get_array_formats_music (Constants.TEXT_M4A), 
                        get_array_formats_videos (StringUtil.EMPTY)
                    );
                    break;
                case Constants.TEXT_OPUS:
                    formats = ArrayUtil.join_generic_string_arrays ( 
                        get_array_formats_music (Constants.TEXT_OPUS),
                        get_array_formats_videos (StringUtil.EMPTY)
                    );
                    break;
                case Constants.TEXT_AT9:
                    formats = ArrayUtil.join_generic_string_arrays ( 
                        get_array_formats_music (Constants.TEXT_AT9),
                        get_array_formats_videos (StringUtil.EMPTY)
                    );
                    break;

                case Constants.TEXT_JPG:
                    formats = get_array_formats_image (Constants.TEXT_JPG);
                    break;
                case Constants.TEXT_BMP:
                    formats = get_array_formats_image (Constants.TEXT_BMP);
                    break;
                case Constants.TEXT_PNG:
                    formats = get_array_formats_image (Constants.TEXT_PNG);
                    break;
                case Constants.TEXT_TIF:
                    formats = get_array_formats_image (Constants.TEXT_TIF);
                    break;
                case Constants.TEXT_ICO:
                    formats = get_array_formats_image (Constants.TEXT_ICO);
                    break;
                case Constants.TEXT_GIF:
                    formats = ArrayUtil.join_generic_string_arrays ( 
                        get_array_formats_image (Constants.TEXT_GIF), 
                        get_array_formats_videos (StringUtil.EMPTY)
                    );
                    break;
                case Constants.TEXT_TGA:
                    formats = get_array_formats_image (Constants.TEXT_TGA);
                    break;
                case Constants.TEXT_WEBP:
                    formats = get_array_formats_image (Constants.TEXT_WEBP);
                    break;
            }

            return formats.data;
        }

        /**
         * Get array formats videos.
         *
         * @see Ciano.Configs.Constants
         * @see Ciano.Enums.TypeItemEnum
         * @param  {@code string} format_video
         * @return {@code string []}
         */
        private GenericArray<string> get_array_formats_videos (string format_video) {
            var array = new GenericArray<string> ();

            if (format_video != StringUtil.EMPTY) {
                this.type_item = TypeItemEnum.VIDEO;
            }

            if(format_video != Constants.TEXT_MP4) {
                array.add (Constants.TEXT_MP4);    
                array.add (Constants.TEXT_MP4.up());    
            }
            
            if(format_video != Constants.TEXT_3GP) {
                array.add (Constants.TEXT_3GP);    
                array.add (Constants.TEXT_3GP.up());    
            }

            if(format_video != Constants.TEXT_MPG) {
                array.add (Constants.TEXT_MPG);    
                array.add (Constants.TEXT_MPG.up());       
            }

            if(format_video != Constants.TEXT_AVI) {
                array.add (Constants.TEXT_AVI);
                array.add (Constants.TEXT_AVI.up());        
            }

            if(format_video != Constants.TEXT_WMV) {
                array.add (Constants.TEXT_WMV);    
                array.add (Constants.TEXT_WMV.up());    
            }

            if(format_video != Constants.TEXT_FLV) {
                array.add (Constants.TEXT_FLV);  
                array.add (Constants.TEXT_FLV.up());      
            }

            if(format_video != Constants.TEXT_SWF) {
                array.add (Constants.TEXT_SWF);   
                array.add (Constants.TEXT_SWF.up());     
            }

            if(format_video != Constants.TEXT_MOV) {
                array.add (Constants.TEXT_MOV); 
                array.add (Constants.TEXT_MOV.up());       
            }

            if(format_video != Constants.TEXT_MKV) {
                array.add (Constants.TEXT_MKV); 
                array.add (Constants.TEXT_MKV.up());       
            }

            if(format_video != Constants.TEXT_VOB) {
                array.add (Constants.TEXT_VOB);  
                array.add (Constants.TEXT_VOB.up());      
            }

            if(format_video != Constants.TEXT_OGV) {
                array.add (Constants.TEXT_OGV);  
                array.add (Constants.TEXT_OGV.up());      
            }

            if(format_video != Constants.TEXT_WEBM && format_video != Constants.TEXT_GIF && this.type_item == TypeItemEnum.VIDEO) {
                array.add (Constants.TEXT_WEBM); 
                array.add (Constants.TEXT_WEBM.up());       
            }

            return array;
        }

        /**
         * Get array formats music.
         *
         * @see Ciano.Configs.Constants
         * @see Ciano.Enums.TypeItemEnum
         * @param  {@code string} format_music
         * @return {@code void}
         */
        private GenericArray<string> get_array_formats_music (string format_music) {
            var array = new GenericArray<string> ();

            if (format_music != StringUtil.EMPTY) {
                this.type_item = TypeItemEnum.MUSIC;
            }

            if(format_music != Constants.TEXT_MP3) {
                array.add (Constants.TEXT_MP3);   
                array.add (Constants.TEXT_MP3.up()); 
            }
            
            if(format_music != Constants.TEXT_WMA) {
                array.add (Constants.TEXT_WMA);    
                array.add (Constants.TEXT_WMA.up());
            }

            if(format_music != Constants.TEXT_AMR) {
                array.add (Constants.TEXT_AMR);    
                array.add (Constants.TEXT_AMR.up());
            }

            if(format_music != Constants.TEXT_OGG) {
                array.add (Constants.TEXT_OGG);    
                array.add (Constants.TEXT_OGG.up());
            }

            if(format_music != Constants.TEXT_WAV) {
                array.add (Constants.TEXT_WAV);    
                array.add (Constants.TEXT_WAV.up());
            }

            if(format_music != Constants.TEXT_AAC) {
                array.add (Constants.TEXT_AAC);    
                array.add (Constants.TEXT_AAC.up());
            }

            if(format_music != Constants.TEXT_FLAC) {
                array.add (Constants.TEXT_FLAC);    
                array.add (Constants.TEXT_FLAC.up());
            }

            if(format_music != Constants.TEXT_AIFF) {
                array.add (Constants.TEXT_AIFF);    
                array.add (Constants.TEXT_AIFF.up());
            }

            if(format_music != Constants.TEXT_MMF) {
                array.add (Constants.TEXT_MMF);    
                array.add (Constants.TEXT_MMF.up());
            }

            if(format_music != Constants.TEXT_M4A) {
                array.add (Constants.TEXT_M4A);    
                array.add (Constants.TEXT_M4A.up());
            }

            if(format_music != Constants.TEXT_OPUS) {
                array.add (Constants.TEXT_OPUS);    
                array.add (Constants.TEXT_OPUS.up());
            }

            return array;
        }

        /**
         * Get array formats image.
         *
         * @see Ciano.Configs.Constants
         * @see Ciano.Enums.TypeItemEnum
         * @param  {@code string} format_image
         * @return {@code string []}
         * @since 0.1.5
         */
        private GenericArray<string> get_array_formats_image (string format_image) {
            var array = new GenericArray<string> ();

            if (format_image != StringUtil.EMPTY) {
                this.type_item = TypeItemEnum.IMAGE;
            }

            if(format_image != Constants.TEXT_JPG) {
                array.add (Constants.TEXT_JPG);    
                array.add (Constants.TEXT_JPG.up());
            }
            
            if(format_image != Constants.TEXT_BMP) {
                array.add (Constants.TEXT_BMP);    
                array.add (Constants.TEXT_BMP.up());
            }

            if(format_image != Constants.TEXT_PNG) {
                array.add (Constants.TEXT_PNG);    
                array.add (Constants.TEXT_PNG.up());
            }

            if(format_image != Constants.TEXT_TIF) {
                array.add (Constants.TEXT_TIF);    
                array.add (Constants.TEXT_TIF.up());
            }

            if(format_image != Constants.TEXT_ICO) {
                array.add (Constants.TEXT_ICO);    
                array.add (Constants.TEXT_ICO.up());
            }

            if(format_image != Constants.TEXT_GIF) {
                array.add (Constants.TEXT_GIF);    
                array.add (Constants.TEXT_GIF.up());
            }

            if(format_image != Constants.TEXT_TGA) {
                array.add (Constants.TEXT_TGA);    
                array.add (Constants.TEXT_TGA.up());
            }

            if(format_image != Constants.TEXT_WEBP) {
                array.add (Constants.TEXT_WEBP);    
                array.add (Constants.TEXT_WEBP.up());
            }
            
            return array;
        }
    }
}
