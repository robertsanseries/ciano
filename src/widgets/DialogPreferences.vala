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

namespace Ciano.Widgets {

	/**
	 * @description 
	 * 
	 * @author  Robert San <robertsanseries@gmail.com>
	 * @type    Gtk.Dialog
	 */
	public class DialogPreferences : Gtk.Dialog {

		/**
		 * @variables
		 */
		private Ciano.Config.Settings settings;
		private Gtk.FileChooserButton library_filechooser;
        private Gtk.Switch output_source_file_folder;
        private Gtk.Switch shutdown_computer;
        private Gtk.Switch open_output_folder;
        private Gtk.Switch complete_notify;
        private Gtk.Switch erro_notify;
        private Gtk.Button default_settings;

		/**
		 * @construct
		 */
		public DialogPreferences (Gtk.Window? parent) {
			this.title = "Preferences";
			this.resizable = false;
            this.deletable = false;
			this.set_transient_for (parent);
            this.set_default_size (500, 450);
            this.set_size_request (500, 450);

			this.settings = Ciano.Config.Settings.get_instance ();

			var grid = new Gtk.Grid ();
			grid.row_spacing = 5;
			grid.column_spacing = 5;
			grid.margin = 12;
			grid.margin_top = 5;
			grid.margin_bottom = 5;

			init_options ();
			mount_options (grid);

			this.get_content_area ().add (grid);
			this.show_all ();
		}

		/**
		 * @description Start the values of the options as defined by the user.
		 * @return 		void
		 */
		private void init_options () {
			this.output_source_file_folder = new Gtk.Switch ();
			this.settings.schema.bind ("output-source-file-folder", this.output_source_file_folder, "active", SettingsBindFlags.DEFAULT);

			this.shutdown_computer = new Gtk.Switch ();
			this.settings.schema.bind ("shutdown-computer", this.shutdown_computer, "active", SettingsBindFlags.DEFAULT);

			this.open_output_folder = new Gtk.Switch ();
			this.settings.schema.bind ("open-output-folder", this.open_output_folder, "active", SettingsBindFlags.DEFAULT);

			this.complete_notify = new Gtk.Switch ();
			this.settings.schema.bind ("complete-notify", this.complete_notify, "active", SettingsBindFlags.DEFAULT);

			this.erro_notify = new Gtk.Switch ();
			this.settings.schema.bind ("erro-notify", this.erro_notify, "active", SettingsBindFlags.DEFAULT);
		}

		/**
		 * @description Mount entire grid with options for user selection.
		 * @return 		void
		 */
		private void mount_options (Gtk.Grid grid) {
        	var row = 0;
			// * output folder
			var label_output_folder = new Gtk.Label ("Output folder:");
			add_section (grid, label_output_folder, ref row);

				// select output
				 var label_select_output_folder = new Gtk.Label ("Select the output folder:");
				library_filechooser = new Gtk.FileChooserButton ("",Gtk.FileChooserAction.SELECT_FOLDER);
	        	library_filechooser.hexpand = true;
	        	add_option (grid, label_select_output_folder, this.library_filechooser, ref row);

				//output to source file folder
				var label_output_source_file_folder = new Gtk.Label ("Output to source file folder:");
				add_option (grid, label_output_source_file_folder, this.output_source_file_folder, ref row);

			// * After Converting
			var label_after_converting = new Gtk.Label ("After converting:");
			add_section (grid, label_after_converting, ref row);

				// Shutdown Computer
				var label_shutdown_computer = new Gtk.Label ("Shutdown computer:");
				add_option (grid, label_shutdown_computer, this.shutdown_computer, ref row);

				//Open Output Folder
				var label_open_output_folder = new Gtk.Label ("Open output folder:");
				add_option (grid, label_open_output_folder, this.open_output_folder, ref row);

			// * Notify
			var label_notify = new Gtk.Label ("Notify:");
			add_section (grid, label_notify, ref row);

				// Complete Notify
				var label_complete_notify = new Gtk.Label ("Complete notify:");
				add_option (grid, label_complete_notify, this.complete_notify, ref row);
				
				// Erro Notify
				var label_erro_notify = new Gtk.Label ("Erro Notify:");
				add_option (grid, label_erro_notify, this.erro_notify, ref row);

			//Buttons
			default_settings = new Gtk.Button.with_label ("Default Settings");
			default_settings.clicked.connect (reset_default_settings);
			
			var close_button = new Gtk.Button.with_label ("Close");
			close_button.clicked.connect (() => { this.destroy (); });

			default_settings.margin_top = 25;
			close_button.margin_top = 25;

			grid.attach (default_settings, 0, row, 1, 1);
			grid.attach_next_to (close_button, default_settings, Gtk.PositionType.RIGHT, 3, 1);
		}

		/**
		 * @description [add_section description]
		 * @param Gtk.Grid  grid
		 * @param Gtk.Label name
		 * @param int  		row
		 */
		private void add_section (Gtk.Grid grid, Gtk.Label name, ref int row) {
            name.halign 	= Gtk.Align.START;
            name.margin_top = 10;
            name.use_markup = true;
            name.set_markup ("<b>%s</b>".printf (name.get_text ()));
            name.get_style_context ().add_class ("title-section-dialog");

            grid.attach (name, 0, row, 1, 1);

            row++;
        }

        /**
         * @description 	 [add_option description]
         * @param Gtk.Grid   grid
         * @param Gtk.Label  label
         * @param Gtk.Switch widget
         * @param int        row
         */
		private void add_option (Gtk.Grid grid, Gtk.Label label, Gtk.Widget widget, ref int row) {
			label.halign 		= Gtk.Align.END;
			label.hexpand 		= true;
			label.margin_left 	= 25;
			label.margin_top 	= 0;

			widget.halign 	= Gtk.Align.START;
			widget.hexpand 	= true;
			widget.margin_top = 0;			

			grid.attach (label, 0, row, 1, 1);
			grid.attach_next_to (widget, label, Gtk.PositionType.RIGHT, 3, 1);

			row++;
		}

		/**
		 * @description	[reset_default_settings description]
		 * @return 		[description]
		 */
		private void reset_default_settings () {
			output_source_file_folder.active = false;
			shutdown_computer.active 		 = false;
			open_output_folder.active 		 = false;
			complete_notify.active 			 = true;
			erro_notify.active 				 = true;
		}
	}
}
