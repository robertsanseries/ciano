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
		private string urlDestino;
        private Subprocess subprocess;
        public Gee.ArrayList<RowConversion> convertions;
        private Gee.ArrayList<ItemConversion> list_items;
        private int id_item;

		/**
		 * @construct
		 */
		public ConverterController (Gtk.ApplicationWindow app, ConverterView converter_view) {
			this.app = app;
			this.converter_view = converter_view;

            this.id_item = 1;
            this.list_items = new Gee.ArrayList<ItemConversion> ();
			
			on_activate_button_preferences (app);
			on_activate_button_item (app);
		}

		/**
		 * [on_preferences_button_clicked description]
		 * @param  {[type]} Gtk.ApplicationWindow app           [description]
		 * @return {[type]}                       [description]
		 */
		private void on_activate_button_preferences (Gtk.ApplicationWindow app) {
			this.converter_view.headerbar.item_selected.connect (() => {
				this.dialog_preferences = new DialogPreferences (app);
				this.dialog_preferences.show_all ();
			});	
		}

		/**
		 * [on_item_button_clicked description]
		 * @param  {[type]} Gtk.ApplicationWindow app           [description]
		 * @return {[type]}                       [description]
		 */
		private void on_activate_button_item (Gtk.ApplicationWindow app) {
			this.converter_view.source_list.item_selected.connect ((item) => {

				var types = mount_array_with_supported_formats (item.name);

				if(types != null) {
					this.dialog_convert_file = new DialogConvertFile (this, types, app);
					this.dialog_convert_file.show_all ();
				}
			});
		}

		/**
		 * [mount_array_with_supported_formats description]
		 * @param  {[type]} string name_format     [description]
		 * @return {[type]}        [description]
		 */
		private string [] mount_array_with_supported_formats (string name_format) {
			string [] formats = null;
			
			switch (name_format) {
				case Properties.TEXT_MP4:
				case Properties.TEXT_3GP:
				case Properties.TEXT_MPG:
				case Properties.TEXT_AVI:
				case Properties.TEXT_WMV:
				case Properties.TEXT_FLV:
				case Properties.TEXT_SWF:
					formats = {
						Properties.TEXT_MP4, Properties.TEXT_3GP, Properties.TEXT_MPG,
						Properties.TEXT_AVI, Properties.TEXT_WMV, Properties.TEXT_FLV,
						Properties.TEXT_SWF
					};
					break;

				case Properties.TEXT_MP3:
				case Properties.TEXT_WMA:
				case Properties.TEXT_AMR:
				case Properties.TEXT_OGG:
				case Properties.TEXT_AAC:
				case Properties.TEXT_WAV:
					formats = {
						Properties.TEXT_MP3, Properties.TEXT_WMA, Properties.TEXT_AMR,
						Properties.TEXT_OGG, Properties.TEXT_AAC, Properties.TEXT_WAV
					};
					break;

				case Properties.TEXT_JPG:
				case Properties.TEXT_BMP:
				case Properties.TEXT_PNG:
				case Properties.TEXT_TIF:
				case Properties.TEXT_ICO:
				case Properties.TEXT_GIF:
				case Properties.TEXT_TGA:
					formats = {
						Properties.TEXT_JPG, Properties.TEXT_BMP, Properties.TEXT_PNG,
						Properties.TEXT_TIF, Properties.TEXT_ICO, Properties.TEXT_GIF,
						Properties.TEXT_TGA
					};
					break;
			}

			return formats;
		}

		/**
		 * [on_activate_button_add_file description]
		 * @param  {[type]} Gtk.Dialog    parent_dialog [description]
		 * @param  {[type]} Gtk.ListStore list_store    [description]
		 * @param  {[type]} Gtk.TreeIter  iter          [description]
		 * @param  {[type]} Gtk.TreeView  tree_view     [description]
		 * @return {[type]}               [description]
		 */
		public void on_activate_button_add_file (Gtk.Dialog parent_dialog, Gtk.TreeView tree_view, Gtk.TreeIter iter, Gtk.ListStore list_store, string [] formats) {
			// The FileChooserDialog:
			var chooser_file = new Gtk.FileChooserDialog (Properties.TEXT_SELECT_FILE, parent_dialog, Gtk.FileChooserAction.OPEN);

			// Multiple files can be selected:
			chooser_file.select_multiple = true;

			// We are only interested in jpegs:
			var filter = new Gtk.FileFilter ();

			// defined formats support
			foreach (string format in formats) {
				filter.add_pattern ("*.".concat (format.down ()));
			}		

			chooser_file.set_filter (filter);
			chooser_file.add_buttons ("Cancel", Gtk.ResponseType.CANCEL, "Add", Gtk.ResponseType.OK);

			int resp = chooser_file.run ();

			if (resp == Gtk.ResponseType.OK) {

				SList<string> uris = chooser_file.get_filenames ();

				foreach (unowned string uri in uris)  {
					
					var file = File.new_for_uri (uri);
					
					// obter a posição da ultima barra
					int index = file.get_basename ().last_index_of("/");

            		//nome do arquivo para ser exibido na grid
            		string name = file.get_basename ().substring(index + 1, -1);

            		//caminho do directorio
            		string directory = file.get_basename ().substring(0, index + 1);

            		// Cut name too big
					if (name.length > 50) {    
						name = name.slice(0, 48) + "...";
					}

					// Cut directory too big
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

		/**
		 * [on_activate_button_remove description]
		 * @param  {[type]} Gtk.Dialog    parent_dialog [description]
		 * @param  {[type]} Gtk.TreeView  tree_view     [description]
		 * @param  {[type]} Gtk.TreeIter  iter          [description]
		 * @param  {[type]} Gtk.ListStore list_store    [description]
		 * @param  {[type]} string        []            formats       [description]
		 * @return {[type]}               [description]
		 */
		public void on_activate_button_remove (Gtk.Dialog parent_dialog, Gtk.TreeView tree_view, Gtk.ListStore list_store, Gtk.ToolButton button_remove) {

			Gtk.TreePath path;
			Gtk.TreeViewColumn column;

			tree_view.get_cursor (out path, out column);

			if(path != null) {
				Gtk.TreeIter iter;
				list_store.get_iter (out iter, path);
				list_store.remove (iter);

				// Se não tiver mais item para excluir desabilita o botão remover.
				if (path.to_string () == "0") {
					button_remove.sensitive = false;
				}
			}
		}

		/**
		 * [on_activate_button_start_conversion description]
		 * @param  {[type]} Gtk.ListStore list_store    [description]
		 * @return {[type]}               [description]
		 */
		public void on_activate_button_start_conversion (Gtk.ListStore list_store){

            Gtk.TreeModelForeachFunc load_list_for_conversion = (model, path, iter) => {
                GLib.Value cell1;
                GLib.Value cell2;

                list_store.get_value (iter, 0, out cell1);
                list_store.get_value (iter, 1, out cell2);

                var item = new ItemConversion (id_item, cell1.get_string () , cell2.get_string (), null, null);
                this.list_items.add (item);
                
                this.id_item++;
               
                return false;
            };

            list_store.foreach (load_list_for_conversion);

            //message(this.list_items[0].name);


            //this.stack.visible_child_name = WELCOME_VIEW;

			foreach (ItemConversion item in this.list_items) {
				
                string uri = item.directory + item.name;

				//uri = uri.replace(" ", "\\ ");
				
				execute_command_async.begin (get_command(uri), (obj, async_res) => {
					/*try {
	                    // wait_check: true on success, false if process exited abnormally,
	                    //  or cancellable was cancelled
	                    if(this.subprocess.wait_check ()) { 

	                   	} else {

	                   	}
	                } catch (Error e) {
	                    GLib.critical(e.message);
	                }*/
				});
			}
		}

		/**
         * Get an array with the parameters to download.
         * 
         * @param  string new_url_video.
         * @return string[]
         */
        public string[] get_command (string uri) {
			int index = uri.last_index_of(".");
            string new_file = uri.substring(0, index + 1) + "wma";

            

            var array = new GenericArray<string> ();
            array.add ("ffmpeg");
            array.add ("-i");
            array.add (uri);
            array.add (new_file);

            return array.data;
        }

		/**
         * 
         *Method async to start the process 
         *
         * @param  string[] spawn_args
         * @return void
         */
        public async void execute_command_async (string[] spawn_args) {
            try {
                // Make a subprocess that accepts piping (accepts additional arguments).
                var launcher = new SubprocessLauncher (SubprocessFlags.STDOUT_PIPE);

                // Set how the subprocess will be launche.
                this.subprocess = launcher.spawnv (spawn_args);

                // Create a variable with subprocess arguments.
                var input_stream = this.subprocess.get_stdout_pipe ();

                // Create a DIS to read such arguments.
                var data_input_stream = new DataInputStream (input_stream);
                
                while (true) {
                    // The str_return string is the subprocess arguments being read, such as asynchronous.
                    string str_return = yield data_input_stream.read_line_async ();
                    
                    //If the string is null, break here.
                    if (str_return == null) {
                        message ("acabou");
                        break;
                    } else {
                        message ("executando...");
                        // Otherwise, trigger process_download with the arguments.
                        process_download(str_return);
                    }
                }
            } catch (Error e) {
                GLib.message("Erro %s", e.message);
            }
        }

        /**
         * Extract data from youtube-dl stdout.
         *
         * @author Robert San
         * @descrition Code based on the Algram - <aliasgram@gmail.com> App
         *             @link https://github.com/Algram/SaveTube/blob/master/main.vala
         * 
         * @param  string str_command 
         * @return void
         */
        public void process_download(string str_command) {
            
               message (str_command[0].to_string ());
            
        }
	}
}