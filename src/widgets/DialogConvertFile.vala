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
using Ciano.Utils;
using Ciano.Enums;

namespace Ciano.Widgets {

	/**
	 * @description 
	 * 
	 * @author  Robert San <robertsanseries@gmail.com>
	 * @type    Gtk.Dialog
	 */
	public class DialogConvertFile : Gtk.Dialog {

		/**
		 * @construct
		 */
		public DialogConvertFile (Gtk.Window parent) {
			this.title = Properties.TEXT_CONVERT_FILE;
			this.resizable = false;
            this.deletable = false;
			this.set_transient_for (parent);
            this.set_default_size (800, 600);
            this.set_size_request (800, 600);
            this.set_modal (true);

            var label = new Gtk.Label (Properties.TEXT_ADD_ITEMS_TO_CONVERSION);
			label.halign = Gtk.Align.START;
			label.margin = 5;

			var frame = mount_frame ();
			var grid_buttons = mount_buttons ();
            
			var grid = new Gtk.Grid ();
			grid.orientation = Gtk.Orientation.VERTICAL;
			grid.margin_left = 15;
			grid.margin_right = 15;
			grid.margin_top = 0;
			grid.margin_bottom = 0;
			grid.add (label);
			grid.add (frame);
			grid.add (grid_buttons);

			this.get_content_area ().add (grid);
		}

		private Gtk.Frame mount_frame () {

			var treeview = mount_treeview ();
            var toolbar = mount_toolbar ();

            var grid_itens = new Gtk.Grid ();
            grid_itens.orientation = Gtk.Orientation.VERTICAL;
	        grid_itens.add (treeview);
	        grid_itens.add (toolbar);

			var frame = new Gtk.Frame (null);
			frame.add (grid_itens);	

			return frame;
		}

		private Gtk.ScrolledWindow mount_treeview () {
			var list_store = new Gtk.ListStore (ColumnEnum.N_COLUMNS ,typeof (string), typeof (Icon), typeof (string), typeof (bool));

			var view = new Gtk.TreeView.with_model (list_store);
			view.vexpand = true;
			view.headers_visible = false;

			var scrolled = new Gtk.ScrolledWindow (null, null);
			scrolled.expand = true;
			scrolled.add (view);

			return scrolled;
		}

		private Gtk.Toolbar mount_toolbar () {
			var toolbar = new Gtk.Toolbar ();
			toolbar.get_style_context ().add_class (Gtk.STYLE_CLASS_INLINE_TOOLBAR);
			toolbar.set_icon_size (Gtk.IconSize.SMALL_TOOLBAR);

			var add_file_button = new Gtk.ToolButton (new Gtk.Image.from_icon_name ("application-add-symbolic", Gtk.IconSize.SMALL_TOOLBAR), null);
			add_file_button.tooltip_text = Properties.TEXT_ADD_FILE;
			add_file_button.clicked.connect (() => {
				//if (app_chooser.visible == false) {
				//	app_chooser.show_all ();
				//}
			});

			var add_folder_button = new Gtk.ToolButton (new Gtk.Image.from_icon_name ("folder-new-symbolic", Gtk.IconSize.SMALL_TOOLBAR), null);
			add_folder_button.tooltip_text = Properties.TEXT_ADD_FOLDER;
			add_folder_button.clicked.connect (() => {
				var chooser = new Gtk.FileChooserDialog (Properties.TEXT_SELECT_A_FOLDER, null, Gtk.FileChooserAction.SELECT_FOLDER);
				chooser.add_buttons ("Cancel", Gtk.ResponseType.CANCEL, "Add", Gtk.ResponseType.OK);
				int res = chooser.run ();
				chooser.hide ();
				if (res == Gtk.ResponseType.OK) {
					string folder = chooser.get_filename ();
					//if (this.path_blacklist.is_duplicate (folder) == false) {
					//	path_blacklist.block (folder);
					//}
				}
			});

			var remove_button = new Gtk.ToolButton (new Gtk.Image.from_icon_name ("list-remove-symbolic", Gtk.IconSize.SMALL_TOOLBAR), null);
			remove_button.tooltip_text = Properties.TEXT_DELETE;
			remove_button.sensitive = false;
			remove_button.clicked.connect (() => {
				/*Gtk.TreePath path;
				Gtk.TreeViewColumn column;
				view.get_cursor (out path, out column);
				Gtk.TreeIter iter;
				list_store.get_iter (out iter, path);
				Value is_app;
				list_store.get_value (iter, NotColumns.IS_APP, out is_app);
				if (is_app.get_boolean () == true) {
					string name;
					list_store.get (iter, NotColumns.PATH, out name);
					app_blacklist.unblock (name);
				} else {
					string name;
					list_store.get (iter, NotColumns.PATH, out name);
					path_blacklist.unblock (name);
				}

				#if VALA_0_36
				list_store.remove (ref iter);
				#else
				list_store.remove (iter);
				#endif*/
			});
			

			toolbar.insert (add_file_button, -1);
			toolbar.insert (add_folder_button, -1);
			toolbar.insert (remove_button, -1);

			return toolbar;
		}

		private Gtk.Grid mount_buttons () {

			var calcel_button = new Gtk.Button.with_label (Properties.TEXT_CANCEL);
			calcel_button.clicked.connect (() => { this.destroy (); });
			calcel_button.margin_right = 10;
			
			var convert_button = new Gtk.Button.with_label (Properties.TEXT_START_CONVERSION);
			convert_button.get_style_context ().add_class ("suggested-action");
			//convert_button.clicked.connect (() => { this.destroy (); });

			var grid_buttons = new Gtk.Grid ();
			grid_buttons.margin_top = 10;
			grid_buttons.halign = Gtk.Align.END;
	        grid_buttons.attach (calcel_button, 0, 0, 1, 1);
			grid_buttons.attach_next_to (convert_button, calcel_button, Gtk.PositionType.RIGHT, 3, 1);

			return grid_buttons;
		}

	}
}