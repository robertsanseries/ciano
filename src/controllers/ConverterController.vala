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

		public ConverterController (Gtk.ApplicationWindow app, ConverterView converter_view) {
			this.app = app;
			this.converter_view = converter_view;

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

		private string [] mount_array_with_supported_formats (string name_format) {
			string [] formats = null;
			
			switch (name_format) {
				case Properties.TEXT_MP4:
                    formats = {
                        Properties.TEXT_3GP, Properties.TEXT_MPG, Properties.TEXT_AVI,
                        Properties.TEXT_WMV, Properties.TEXT_FLV, Properties.TEXT_SWF
                    };
                    break;
				case Properties.TEXT_3GP:
                    formats = {
                        Properties.TEXT_MP4, Properties.TEXT_MPG, Properties.TEXT_AVI,
                        Properties.TEXT_WMV, Properties.TEXT_FLV, Properties.TEXT_SWF
                    };
                    break;
				case Properties.TEXT_MPG:
                    formats = {
                        Properties.TEXT_MP4, Properties.TEXT_3GP, Properties.TEXT_AVI, 
                        Properties.TEXT_WMV, Properties.TEXT_FLV, Properties.TEXT_SWF
                    };
                    break;
				case Properties.TEXT_AVI:
                    formats = {
                        Properties.TEXT_MP4, Properties.TEXT_3GP, Properties.TEXT_MPG,
                        Properties.TEXT_WMV, Properties.TEXT_FLV, Properties.TEXT_SWF
                    };
                    break;
				case Properties.TEXT_WMV:
                    formats = {
                        Properties.TEXT_MP4, Properties.TEXT_3GP, Properties.TEXT_MPG,
                        Properties.TEXT_AVI, Properties.TEXT_FLV, Properties.TEXT_SWF
                    };
                    break;
				case Properties.TEXT_FLV:
                    formats = {
                        Properties.TEXT_MP4, Properties.TEXT_3GP, Properties.TEXT_MPG,
                        Properties.TEXT_AVI, Properties.TEXT_WMV, Properties.TEXT_SWF
                    };
                    break;
				case Properties.TEXT_SWF:
					formats = {
						Properties.TEXT_MP4, Properties.TEXT_3GP, Properties.TEXT_MPG,
						Properties.TEXT_AVI, Properties.TEXT_WMV, Properties.TEXT_FLV
					};
					break;

				case Properties.TEXT_MP3:
                    formats = {
                        Properties.TEXT_WMA, Properties.TEXT_AMR, Properties.TEXT_OGG,
                        Properties.TEXT_AAC, Properties.TEXT_WAV
                    };
                    break;
				case Properties.TEXT_WMA:
                    formats = {
                        Properties.TEXT_MP3, Properties.TEXT_AMR, Properties.TEXT_OGG, 
                        Properties.TEXT_AAC, Properties.TEXT_WAV
                    };
                    break;
				case Properties.TEXT_AMR:
                    formats = {
                        Properties.TEXT_MP3, Properties.TEXT_WMA, Properties.TEXT_OGG, 
                        Properties.TEXT_AAC, Properties.TEXT_WAV
                    };
                    break;
				case Properties.TEXT_OGG:
                    formats = {
                        Properties.TEXT_MP3, Properties.TEXT_WMA, Properties.TEXT_AMR,
                        Properties.TEXT_AAC, Properties.TEXT_WAV
                    };
                    break;
				case Properties.TEXT_AAC:
                    formats = {
                        Properties.TEXT_MP3, Properties.TEXT_WMA, Properties.TEXT_AMR,
                        Properties.TEXT_OGG, Properties.TEXT_WAV
                    };
                    break;
				case Properties.TEXT_WAV:
					formats = {
						Properties.TEXT_MP3, Properties.TEXT_WMA, Properties.TEXT_AMR,
						Properties.TEXT_OGG, Properties.TEXT_AAC
					};
					break;

				case Properties.TEXT_JPG:
                    formats = {
                        Properties.TEXT_BMP, Properties.TEXT_PNG, Properties.TEXT_TIF, 
                        Properties.TEXT_ICO, Properties.TEXT_GIF, Properties.TEXT_TGA
                    };
                    break;
				case Properties.TEXT_BMP:
                    formats = {
                        Properties.TEXT_JPG, Properties.TEXT_PNG, Properties.TEXT_TIF,
                        Properties.TEXT_ICO, Properties.TEXT_GIF, Properties.TEXT_TGA
                    };
                    break;
				case Properties.TEXT_PNG:
                    formats = {
                        Properties.TEXT_JPG, Properties.TEXT_BMP, Properties.TEXT_TIF, 
                        Properties.TEXT_ICO, Properties.TEXT_GIF, Properties.TEXT_TGA
                    };
                    break;
				case Properties.TEXT_TIF:
                    formats = {
                        Properties.TEXT_JPG, Properties.TEXT_BMP, Properties.TEXT_PNG,
                        Properties.TEXT_ICO, Properties.TEXT_GIF, Properties.TEXT_TGA
                    };
                    break;
				case Properties.TEXT_ICO:
                    formats = {
                        Properties.TEXT_JPG, Properties.TEXT_BMP, Properties.TEXT_PNG,
                        Properties.TEXT_TIF, Properties.TEXT_GIF, Properties.TEXT_TGA
                    };
                    break;
				case Properties.TEXT_GIF:
                    formats = {
                        Properties.TEXT_JPG, Properties.TEXT_BMP, Properties.TEXT_PNG,
                        Properties.TEXT_TIF, Properties.TEXT_ICO, Properties.TEXT_TGA
                    };
                    break;
				case Properties.TEXT_TGA:
					formats = {
						Properties.TEXT_JPG, Properties.TEXT_BMP, Properties.TEXT_PNG,
						Properties.TEXT_TIF, Properties.TEXT_ICO, Properties.TEXT_GIF
					};
                    break;
			}

			return formats;
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

            Gtk.TreeModelForeachFunc load_list_for_conversion = (model, path, iter) => {
                GLib.Value cell1;
                GLib.Value cell2;

                list_store.get_value (iter, 0, out cell1);
                list_store.get_value (iter, 1, out cell2);

                var item = new ItemConversion (id_item, cell1.get_string (), cell2.get_string (), TypeItemEnum.VIDEO, this.name_format_selected, 0);
                this.list_items.add (item);
                
                string uri = item.directory + item.name;
                execute_command_async.begin (get_command (uri), item, name_format);
                
                this.id_item++;
               
                return false;
            };

            list_store.foreach (load_list_for_conversion);
		}
		
        public string[] get_command (string uri) {
			int index = uri.last_index_of(".");
            string new_file = uri.substring(0, index + 1) + this.name_format_selected.down ();

            var array = new GenericArray<string> ();
            array.add ("ffmpeg");
            array.add ("-y");
            array.add ("-stats");
            array.add ("-i");
            array.add (uri);
            array.add (new_file);

            return array.data;
        }
		
        public async void execute_command_async (string[] spawn_args, ItemConversion item, string name_format) {
            try {
                string[] spawn_env  = Environ.get ();
                Pid child_pid;

                int standard_input;
                int standard_output;
                int standard_error;
                
                Process.spawn_async_with_pipes (
                    null, 
                    spawn_args,
                    spawn_env,
                    SpawnFlags.SEARCH_PATH | SpawnFlags.DO_NOT_REAP_CHILD, 
                    null,
                    out child_pid,
                    out standard_input,
                    out standard_output,
                    out standard_error
                );

                var row = new RowConversion("media-video", item.name, 0, name_format);
                this.converter_view.list_conversion.list_box.add (row);

                try {

                    IOChannel channel = new IOChannel.unix_new (standard_error);
                    process_line (ref row.progress_bar, channel, "stderr");

                } catch (IOChannelError e) {
                    message ("IOChannelError: %s\n", e.message);
                } catch (ConvertError e) {
                    message ("ConvertError: %s\n", e.message);
                }

                ChildWatch.add (child_pid, (pid, status) => {
                    Process.close_pid (pid);
                });

            } catch (SpawnError e) {
                GLib.critical ("Error: %s\n", e.message);
            }
        }
        
        private bool process_line (ref Gtk.ProgressBar progress_bar,  IOChannel channel, string stream_name) {
             try {
                string line;
                int total = 0;

                while (channel.read_line (out line, null, null) == IOStatus.NORMAL &&  line != null) {                    

                    if(line.contains("Duration:")) {
                        int i = line.index_of ("Duration:");
                        string duration = line.substring(i + 10, 11);

                        total = TimeUtil.duration_in_seconds (duration);
                    }

                    if(line.contains("time=")) {
                        int i = line.index_of ("time=");
                        string duration = line.substring(i+5, 11);

                        int loading = TimeUtil.duration_in_seconds (duration);
                        double progress = 100 * loading / total;
                        progress_bar.set_fraction (progress);
                        message ("convertendo:" + progress.to_string ());
                    }
                }
                message ("convertido!");
                
            } catch (IOChannelError e) {
                GLib.critical ("%s: IOChannelError: %s\n", stream_name, e.message);
                return false;
            } catch (ConvertError e) {
                GLib.critical ("%s: ConvertError: %s\n", stream_name, e.message);
                return false;
            }

            return true;
        }
	}
}