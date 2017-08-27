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

using Ciano.Config;
using Ciano.Views;
using Ciano.Widgets;
using Ciano.Objects;
using Ciano.Utils;
using Ciano.Enums;

namespace Ciano.Controllers {

    /**
     * @descrition 
     * 
     * @author  Robert San <robertsanseries@gmail.com>
     * @type    ConverterController
     */
    public class ConverterController {

        /**
         * @variables
         */
        private Gtk.ApplicationWindow app;
        private ConverterView converter_view;
        private DialogPreferences dialog_preferences;
        private DialogConvertFile dialog_convert_file;       
        public Gee.ArrayList<RowConversion> convertions;
        private Gee.ArrayList<ItemConversion> list_items;
        private int id_item;
        private string name_format_selected;
        private TypeItemEnum type_item;
        private Ciano.Config.Settings settings;

        public ConverterController (Gtk.ApplicationWindow app, ConverterView converter_view) {
            this.app = app;
            this.converter_view = converter_view;

            this.settings = Ciano.Config.Settings.get_instance ();

            this.id_item = 1;
            this.list_items = new Gee.ArrayList<ItemConversion> ();
            
            on_activate_button_preferences (app);
            on_activate_button_item (app);
        }

        private void on_activate_button_preferences (Gtk.ApplicationWindow app) {
            this.converter_view.headerbar.item_selected.connect (() => {
                this.dialog_preferences = new DialogPreferences (app);
                this.dialog_preferences.show_all ();
            }); 
        }

        private void on_activate_button_item (Gtk.ApplicationWindow app) {
            this.converter_view.source_list.item_selected.connect ((item) => {

                int index = item.name.last_index_of(".");
                this.name_format_selected = item.name.substring (index + 1, -1);

                var types = mount_array_with_supported_formats (item.name);

                if(types != null) {
                    this.dialog_convert_file = new DialogConvertFile (this, types, item.name, app);
                    this.dialog_convert_file.show_all ();
                }
            });
        }

        public void on_activate_button_add_file (Gtk.Dialog parent_dialog, Gtk.TreeView tree_view, Gtk.TreeIter iter, Gtk.ListStore list_store, string [] formats) {
            var chooser_file = new Gtk.FileChooserDialog (Properties.TEXT_SELECT_FILE, parent_dialog, Gtk.FileChooserAction.OPEN);
            chooser_file.select_multiple = true;

            var filter = new Gtk.FileFilter ();

            foreach (string format in formats) {
                filter.add_pattern ("*.".concat (format.down ()));
            }       

            chooser_file.set_filter (filter);
            chooser_file.add_buttons ("Cancel", Gtk.ResponseType.CANCEL, "Add", Gtk.ResponseType.OK);

            if (chooser_file.run () == Gtk.ResponseType.OK) {

                SList<string> uris = chooser_file.get_filenames ();

                foreach (unowned string uri in uris)  {
                    
                    var file         = File.new_for_uri (uri);
                    int index        = file.get_basename ().last_index_of("/");
                    string name      = file.get_basename ().substring(index + 1, -1);
                    string directory = file.get_basename ().substring(0, index + 1);

                    if (name.length > 50) {    
                        name = name.slice(0, 48) + "...";
                    }

                    if (directory.length > 50) {    
                        directory = directory.slice(0, 48) + "...";
                    }

                    list_store.append (out iter);
                    list_store.set (iter, 0, name, 1, directory);
                    tree_view.expand_all ();
                }
            }

            chooser_file.hide ();
        }
        
        public void on_activate_button_remove (Gtk.Dialog parent_dialog, Gtk.TreeView tree_view, Gtk.ListStore list_store, Gtk.ToolButton button_remove) {

            Gtk.TreePath path;
            Gtk.TreeViewColumn column;

            tree_view.get_cursor (out path, out column);

            if(path != null) {
                Gtk.TreeIter iter;
                
                list_store.get_iter (out iter, path);
                list_store.remove (iter);

                if (path.to_string () == "0") {
                    button_remove.sensitive = false;
                }
            }
        }
        
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
                    null,
                    null,
                    null,
                    0,
                    this.type_item
                );

                this.list_items.add (item);
                
                string uri = item.directory + item.name;
                execute_command_async.begin (get_command (uri), item, name_format);
                
                this.id_item++;
               
                return false;
            };

            list_store.foreach (load_list_for_conversion);
        }
        
        public async void execute_command_async (string[] spawn_args, ItemConversion item, string name_format) {
            try {
                // Make a subprocess that accepts piping (accepts additional arguments).
                var launcher = new SubprocessLauncher (SubprocessFlags.STDERR_PIPE);

                // Set how the subprocess will be launche.
                var subprocess = launcher.spawnv (spawn_args);

                // Create a variable with subprocess arguments.
                var input_stream = subprocess.get_stderr_pipe ();

                // Create a DIS to read such arguments.
                var data_input_stream = new DataInputStream (input_stream);

                string icon;

                switch (item.type_item) {
                    case TypeItemEnum.VIDEO:
                        icon = "media-video";
                        break;
                    case TypeItemEnum.MUSIC:
                        icon = "audio-x-generic";
                        break;
                    case TypeItemEnum.IMAGE:
                        icon = "image";
                        break;
                    default:
                        icon = "file";
                        break;
                }

                var row = new RowConversion(icon, item.name, 0, name_format);
                WidgetUtil.set_visible (row.button_remove, false);
                
                row.button_cancel.clicked.connect(() => {
                    subprocess.force_exit ();
                    WidgetUtil.set_visible (row.button_cancel, false);
                    WidgetUtil.set_visible (row.button_remove, true);

                });

                this.converter_view.list_conversion.list_box.add (row);
                
                int total = 0;

                    while (true) {
                        size_t length;
                        string str_return = yield data_input_stream.read_line_utf8_async (Priority.HIGH, null, out length);
                        
                        if (str_return == null) {
                            WidgetUtil.set_visible (row.button_cancel, false);
                            WidgetUtil.set_visible (row.button_remove, true);
                            
                            if(item.type_item == TypeItemEnum.IMAGE) {
                               row.progress_bar.set_fraction(1);
                            }
                            break; 
                        } else {
                            message(str_return.replace("\\u000d", "\n"));
                            process_line(str_return, ref row.progress_bar,ref row.size_time_bitrate, ref total);
                        }
                    }
            } catch (SpawnError e) {
                GLib.critical ("Error: %s\n", e.message);
            } catch (Error e) {
                GLib.message("Erro %s\n", e.message);
            }
        }
        
        private void process_line (string str_return,  ref Gtk.ProgressBar progress_bar, ref Gtk.Label size_time_bitrate, ref int total) {

            string time = StringUtil.EMPTY;
            string size = StringUtil.EMPTY;
            string bitrate = StringUtil.EMPTY;

            if(str_return.contains("Duration:")) {
                int i = str_return.index_of ("Duration:");
                string duration = str_return.substring(i + 10, 11);

                total = TimeUtil.duration_in_seconds (duration);
            }

            if(str_return.contains("time=") && str_return.contains("size=") && str_return.contains("bitrate=") ) {
                int x = str_return.index_of ("time=");
                time = str_return.substring(x+5, 11);

                int loading = TimeUtil.duration_in_seconds (time);
                double progress = 100 * loading / total;
                progress_bar.set_fraction (progress);
        
                int y = str_return.index_of ("size=");
                size = str_return.substring(y+5, 11);
            
                int i = str_return.index_of ("bitrate=");
                bitrate = str_return.substring(i+5, 11);

                
                size_time_bitrate.label = "size: " + size.strip () + " - time: " + time.strip () + " - bitrate: " + bitrate.strip ();
            }
        }

         public string[] get_command (string uri) {
            int index = uri.last_index_of(".");

            string new_file;

            if(this.settings.output_source_file_folder){
                new_file = uri.substring(0, index + 1) + this.name_format_selected.down ();
            } else {
                new_file = this.settings.output_folder + this.name_format_selected.down ();
            }

            var array = new GenericArray<string> ();
            
            if(this.type_item == TypeItemEnum.VIDEO || this.type_item == TypeItemEnum.MUSIC) {
                array.add ("ffmpeg");
                array.add ("-y");
                array.add ("-i");
                array.add (uri);
                array.add (new_file);
            } else if (this.type_item == TypeItemEnum.IMAGE) {
                array.add ("convert");
                array.add (uri);
                array.add (new_file);
            }

            return array.data;
        }

        private string [] mount_array_with_supported_formats (string name_format) {
            string [] formats = null;
            
            switch (name_format) {
                case Properties.TEXT_MP4:
                    this.type_item = TypeItemEnum.VIDEO;
                    formats = {
                        Properties.TEXT_3GP, Properties.TEXT_MPG, Properties.TEXT_AVI,
                        Properties.TEXT_WMV, Properties.TEXT_FLV, Properties.TEXT_SWF
                    };
                    break;
                case Properties.TEXT_3GP:
                    this.type_item = TypeItemEnum.VIDEO;
                    formats = {
                        Properties.TEXT_MP4, Properties.TEXT_MPG, Properties.TEXT_AVI,
                        Properties.TEXT_WMV, Properties.TEXT_FLV, Properties.TEXT_SWF
                    };
                    break;
                case Properties.TEXT_MPG:
                    this.type_item = TypeItemEnum.VIDEO;
                    formats = {
                        Properties.TEXT_MP4, Properties.TEXT_3GP, Properties.TEXT_AVI, 
                        Properties.TEXT_WMV, Properties.TEXT_FLV, Properties.TEXT_SWF
                    };
                    break;
                case Properties.TEXT_AVI:
                    this.type_item = TypeItemEnum.VIDEO;
                    formats = {
                        Properties.TEXT_MP4, Properties.TEXT_3GP, Properties.TEXT_MPG,
                        Properties.TEXT_WMV, Properties.TEXT_FLV, Properties.TEXT_SWF
                    };
                    break;
                case Properties.TEXT_WMV:
                    this.type_item = TypeItemEnum.VIDEO;
                    formats = {
                        Properties.TEXT_MP4, Properties.TEXT_3GP, Properties.TEXT_MPG,
                        Properties.TEXT_AVI, Properties.TEXT_FLV, Properties.TEXT_SWF
                    };
                    break;
                case Properties.TEXT_FLV:
                    this.type_item = TypeItemEnum.VIDEO;
                    formats = {
                        Properties.TEXT_MP4, Properties.TEXT_3GP, Properties.TEXT_MPG,
                        Properties.TEXT_AVI, Properties.TEXT_WMV, Properties.TEXT_SWF
                    };
                    break;
                case Properties.TEXT_SWF:
                    this.type_item = TypeItemEnum.VIDEO;
                    formats = {
                        Properties.TEXT_MP4, Properties.TEXT_3GP, Properties.TEXT_MPG,
                        Properties.TEXT_AVI, Properties.TEXT_WMV, Properties.TEXT_FLV
                    };
                    break;

                case Properties.TEXT_MP3:
                    this.type_item = TypeItemEnum.MUSIC;
                    formats = {
                        Properties.TEXT_WMA, Properties.TEXT_AMR, Properties.TEXT_OGG,
                        Properties.TEXT_AAC, Properties.TEXT_WAV
                    };
                    break;
                case Properties.TEXT_WMA:
                    this.type_item = TypeItemEnum.MUSIC;
                    formats = {
                        Properties.TEXT_MP3, Properties.TEXT_AMR, Properties.TEXT_OGG, 
                        Properties.TEXT_AAC, Properties.TEXT_WAV
                    };
                    break;
                case Properties.TEXT_OGG:
                    this.type_item = TypeItemEnum.MUSIC;
                    formats = {
                        Properties.TEXT_MP3, Properties.TEXT_WMA, Properties.TEXT_AMR,
                        Properties.TEXT_AAC, Properties.TEXT_WAV
                    };
                    break;
                case Properties.TEXT_AAC:
                    this.type_item = TypeItemEnum.MUSIC;
                    formats = {
                        Properties.TEXT_MP3, Properties.TEXT_WMA, Properties.TEXT_AMR,
                        Properties.TEXT_OGG, Properties.TEXT_WAV
                    };
                    break;
                case Properties.TEXT_WAV:
                    this.type_item = TypeItemEnum.MUSIC;
                    formats = {
                        Properties.TEXT_MP3, Properties.TEXT_WMA, Properties.TEXT_AMR,
                        Properties.TEXT_OGG, Properties.TEXT_AAC
                    };
                    break;

                case Properties.TEXT_JPG:
                    this.type_item = TypeItemEnum.IMAGE;
                    formats = {
                        Properties.TEXT_BMP, Properties.TEXT_PNG, Properties.TEXT_TIF, 
                        Properties.TEXT_ICO, Properties.TEXT_GIF, Properties.TEXT_TGA
                    };
                    break;
                case Properties.TEXT_BMP:
                    this.type_item = TypeItemEnum.IMAGE;
                    formats = {
                        Properties.TEXT_JPG, Properties.TEXT_PNG, Properties.TEXT_TIF,
                        Properties.TEXT_ICO, Properties.TEXT_GIF, Properties.TEXT_TGA
                    };
                    break;
                case Properties.TEXT_PNG:
                    this.type_item = TypeItemEnum.IMAGE;
                    formats = {
                        Properties.TEXT_JPG, Properties.TEXT_BMP, Properties.TEXT_TIF, 
                        Properties.TEXT_ICO, Properties.TEXT_GIF, Properties.TEXT_TGA
                    };
                    break;
                case Properties.TEXT_TIF:
                    this.type_item = TypeItemEnum.IMAGE;
                    formats = {
                        Properties.TEXT_JPG, Properties.TEXT_BMP, Properties.TEXT_PNG,
                        Properties.TEXT_ICO, Properties.TEXT_GIF, Properties.TEXT_TGA
                    };
                    break;
                case Properties.TEXT_ICO:
                    this.type_item = TypeItemEnum.IMAGE;
                    formats = {
                        Properties.TEXT_JPG, Properties.TEXT_BMP, Properties.TEXT_PNG,
                        Properties.TEXT_TIF, Properties.TEXT_GIF, Properties.TEXT_TGA
                    };
                    break;
                case Properties.TEXT_GIF:
                    this.type_item = TypeItemEnum.IMAGE;
                    formats = {
                        Properties.TEXT_JPG, Properties.TEXT_BMP, Properties.TEXT_PNG,
                        Properties.TEXT_TIF, Properties.TEXT_ICO, Properties.TEXT_TGA
                    };
                    break;
                case Properties.TEXT_TGA:
                    this.type_item = TypeItemEnum.IMAGE;
                    formats = {
                        Properties.TEXT_JPG, Properties.TEXT_BMP, Properties.TEXT_PNG,
                        Properties.TEXT_TIF, Properties.TEXT_ICO, Properties.TEXT_GIF
                    };
                    break;
            }

            return formats;
        }
    }
}