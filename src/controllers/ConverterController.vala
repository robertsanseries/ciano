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
        private Gtk.Application application;

        public ConverterController (Gtk.ApplicationWindow app, Gtk.Application application,  ConverterView converter_view) {
            this.app = app;
            this.converter_view = converter_view;
            this.application = application;

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
                var launcher            = new SubprocessLauncher (SubprocessFlags.STDERR_PIPE);
                var subprocess          = launcher.spawnv (spawn_args);
                var input_stream        = subprocess.get_stderr_pipe ();
                var data_input_stream   = new DataInputStream (input_stream);

                var icon = get_type_icon (item);
                var row  = create_row_conversion (icon, item.name, name_format, subprocess);
                
                this.converter_view.list_conversion.list_box.add (row);
                
                int total = 0;

                    while (true) {
                        string str_return = yield data_input_stream.read_line_utf8_async ();
                        
                        if (str_return == null) {
                            WidgetUtil.set_visible (row.button_cancel, false);
                            WidgetUtil.set_visible (row.button_remove, true);
                            
                            if(item.type_item == TypeItemEnum.IMAGE) {
                               row.progress_bar.set_fraction(1);
                            }

                            var notification = new Notification (item.name);
                            var image = new Gtk.Image.from_icon_name ("com.github.robertsanseries.ciano", Gtk.IconSize.DIALOG);
                            notification.set_body ("Conversion completed");
                            notification.set_icon (image.gicon);
                            this.application.send_notification ("finished", notification);

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

        private RowConversion create_row_conversion (string icon, string item_name, string name_format, Subprocess subprocess) {
            var row = new RowConversion(icon, item_name, 0, name_format);
            row.button_cancel.clicked.connect(() => {
                subprocess.force_exit ();
                WidgetUtil.set_visible (row.button_cancel, false);
                WidgetUtil.set_visible (row.button_remove, true);
            });
                
            WidgetUtil.set_visible (row.button_remove, false);                

            return row;
        }

        private string get_type_icon (ItemConversion item) {
            string icon = StringUtil.EMPTY;

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

            return icon;
        }
        
        private void process_line (string str_return,  ref Gtk.ProgressBar progress_bar, ref Gtk.Label size_time_bitrate, ref int total) {
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
                double progress = 100 * loading / total;
                progress_bar.set_fraction (progress);
        
                int index_size  = str_return.index_of ("size=");
                size            = str_return.substring ( index_size + 5, 11);
            
                int index_bitrate   = str_return.index_of ("bitrate=");
                bitrate             = str_return.substring ( index_bitrate + 5, 11);

                
                size_time_bitrate.label = "size: " + size.strip () + " - time: " + time.strip () + " - bitrate: " + bitrate.strip ();
            }
        }

         public string[] get_command (string uri) {
            var array = new GenericArray<string> ();
            var new_file = get_uri_new_file (uri);
            
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

        private string [] mount_array_with_supported_formats (string name_format) {
            string [] formats = null;
            
            switch (name_format) {
                case Properties.TEXT_MP4:
                    formats = get_array_formats_videos (Properties.TEXT_MP4);
                    break;
                case Properties.TEXT_3GP:
                    formats = get_array_formats_videos (Properties.TEXT_3GP);
                    break;
                case Properties.TEXT_MPG:
                    formats = get_array_formats_videos (Properties.TEXT_MPG);
                    break;
                case Properties.TEXT_AVI:
                    formats = get_array_formats_videos (Properties.TEXT_AVI);
                    break;
                case Properties.TEXT_WMV:
                    formats = get_array_formats_videos (Properties.TEXT_WMV);
                    break;
                case Properties.TEXT_FLV:
                    formats = get_array_formats_videos (Properties.TEXT_FLV);
                    break;
                case Properties.TEXT_SWF:
                    formats = get_array_formats_videos (Properties.TEXT_SWF);
                    break;

                case Properties.TEXT_MP3:
                    formats = get_array_formats_music (Properties.TEXT_MP3);
                    break;
                case Properties.TEXT_WMA:
                    formats = get_array_formats_music (Properties.TEXT_WMA);
                    break;
                case Properties.TEXT_OGG:
                    formats = get_array_formats_music (Properties.TEXT_OGG);
                    break;
                case Properties.TEXT_AAC:
                    formats = get_array_formats_music (Properties.TEXT_AAC);
                    break;
                case Properties.TEXT_WAV:
                    formats = get_array_formats_music (Properties.TEXT_WAV);
                    break;

                case Properties.TEXT_JPG:
                    formats = get_array_formats_image (Properties.TEXT_JPG);
                    break;
                case Properties.TEXT_BMP:
                    formats = get_array_formats_image (Properties.TEXT_BMP);
                    break;
                case Properties.TEXT_PNG:
                    formats = get_array_formats_image (Properties.TEXT_PNG);
                    break;
                case Properties.TEXT_TIF:
                    formats = get_array_formats_image (Properties.TEXT_TIF);
                    break;
                case Properties.TEXT_ICO:
                    formats = get_array_formats_image (Properties.TEXT_ICO);
                    break;
                case Properties.TEXT_GIF:
                    formats = get_array_formats_image (Properties.TEXT_GIF);
                    break;
                case Properties.TEXT_TGA:
                    formats = get_array_formats_image (Properties.TEXT_TGA);
                    break;
            }

            return formats;
        }

        private string [] get_array_formats_videos (string format_video) {
            var array = new GenericArray<string> ();

            this.type_item = TypeItemEnum.VIDEO;

            if(format_video != Properties.TEXT_MP4) {
                array.add (Properties.TEXT_MP4);    
            }
            
            if(format_video != Properties.TEXT_3GP) {
                array.add (Properties.TEXT_3GP);    
            }

            if(format_video != Properties.TEXT_MPG) {
                array.add (Properties.TEXT_MPG);    
            }

            if(format_video != Properties.TEXT_AVI) {
                array.add (Properties.TEXT_AVI);    
            }

            if(format_video != Properties.TEXT_WMV) {
                array.add (Properties.TEXT_WMV);    
            }

            if(format_video != Properties.TEXT_FLV) {
                array.add (Properties.TEXT_FLV);    
            }

            if(format_video != Properties.TEXT_SWF) {
                array.add (Properties.TEXT_SWF);    
            }

            return array.data;
        }

        private string [] get_array_formats_music (string format_music) {
            var array = new GenericArray<string> ();

            this.type_item = TypeItemEnum.MUSIC;

            if(format_music != Properties.TEXT_MP3) {
                array.add (Properties.TEXT_MP3);    
            }
            
            if(format_music != Properties.TEXT_WMA) {
                array.add (Properties.TEXT_WMA);    
            }

            if(format_music != Properties.TEXT_AMR) {
                array.add (Properties.TEXT_AMR);    
            }

            if(format_music != Properties.TEXT_OGG) {
                array.add (Properties.TEXT_OGG);    
            }

            if(format_music != Properties.TEXT_AAC) {
                array.add (Properties.TEXT_AAC);    
            }

            if(format_music != Properties.TEXT_WAV) {
                array.add (Properties.TEXT_WAV);    
            }

            return array.data;
        }

        private string [] get_array_formats_image (string format_image) {
            var array = new GenericArray<string> ();

            this.type_item = TypeItemEnum.IMAGE;

            if(format_image != Properties.TEXT_JPG) {
                array.add (Properties.TEXT_JPG);    
            }
            
            if(format_image != Properties.TEXT_BMP) {
                array.add (Properties.TEXT_BMP);    
            }

            if(format_image != Properties.TEXT_PNG) {
                array.add (Properties.TEXT_PNG);    
            }

            if(format_image != Properties.TEXT_TIF) {
                array.add (Properties.TEXT_TIF);    
            }

            if(format_image != Properties.TEXT_ICO) {
                array.add (Properties.TEXT_ICO);    
            }

            if(format_image != Properties.TEXT_GIF) {
                array.add (Properties.TEXT_GIF);    
            }

            if(format_image != Properties.TEXT_TGA) {
                array.add (Properties.TEXT_TGA);    
            }

            return array.data;
        }
    }
}