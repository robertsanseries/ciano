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

namespace Ciano.Widgets {

	/**
	 * @descrition 
	 * 
	 * @author  Robert San <robertsanseries@gmail.com>
	 * @type    Gtk.Grid
	 */
	public class ListConversion : Gtk.Grid {
		
		public Gtk.Stack stack;
        public Gtk.ListBox list_box;		

		/**
		 * @construct
		 */
		public ListConversion () {

            this.stack = new Gtk.Stack ();
            this.stack.transition_type = Gtk.StackTransitionType.CROSSFADE;

            var welcome = new Granite.Widgets.Welcome (
              Properties.TEXT_EMPTY_CONVERTING_LIST,
              Properties.TEXT_SELECT_OPTION_TO_CONVERT
            );

            //this.stack.add_named (welcome, Constants.WELCOME_VIEW);

            this.list_box = new Gtk.ListBox ();
            this.list_box.expand = true;
            this.stack.add_named (this.list_box, Constants.LIST_BOX_VIEW);            

            var scrolled = new Gtk.ScrolledWindow (null, null);
            scrolled.hscrollbar_policy = Gtk.PolicyType.NEVER;
            scrolled.add (this.stack);

           this.add (scrolled);
		}
	}
}