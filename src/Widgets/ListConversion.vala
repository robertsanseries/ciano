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
using Ciano.Utils;

namespace Ciano.Widgets {

    /**
     * The ListConversion class is responsible for displaying the list of items 
     * that are being converted or have been converted.
     *
     * @see Gtk.Grid
     * @since 0.1.0
     */
    public class ListConversion : Gtk.Grid {

        public Gtk.Stack stack;
        public Gtk.ListBox list_box;
        public Gtk.Box welcome_box;

        /**
         * Tracks the number of items currently in the list box.
         */
        public int item_quantity = 0;

        /**
         * Constructs a new ListConversion object.
         * Initializes the stack to switch between a welcome view and the actual conversion list.
         */
        public ListConversion () {
            this.stack = new Gtk.Stack ();
            this.stack.transition_type = Gtk.StackTransitionType.CROSSFADE;

            this.build_welcome_view ();

            this.list_box = new Gtk.ListBox ();
            this.list_box.hexpand = true;
            this.list_box.vexpand = true;
            this.list_box.selection_mode = Gtk.SelectionMode.NONE;
            this.list_box.add_css_class ("list-conversion");

            this.stack.add_named (this.welcome_box, Constants.WELCOME_VIEW);
            this.stack.add_named (this.list_box, Constants.LIST_BOX_VIEW);

            var scrolled = new Gtk.ScrolledWindow ();
            scrolled.hscrollbar_policy = Gtk.PolicyType.NEVER;
            scrolled.vscrollbar_policy = Gtk.PolicyType.AUTOMATIC;
            scrolled.set_child (this.stack);
            scrolled.hexpand = true;
            scrolled.vexpand = true;

            this.attach (scrolled, 0, 0, 1, 1);
        }

        /**
         * Assembles the welcome view components using pure GTK widgets.
         * This aligns with elementary OS design by avoiding Adwaita specific status pages.
         */
        private void build_welcome_view () {
            this.welcome_box = new Gtk.Box (Gtk.Orientation.VERTICAL, 6);
            this.welcome_box.valign = Gtk.Align.CENTER;
            this.welcome_box.halign = Gtk.Align.CENTER;
            this.welcome_box.add_css_class ("list-conversion-welcome");

            var title_label = new Gtk.Label (Properties.TEXT_EMPTY_CONVERTING_LIST);
            title_label.add_css_class ("title");

            var desc_label = new Gtk.Label (Properties.TEXT_SELECT_OPTION_TO_CONVERT);
            desc_label.add_css_class ("subtitle");
            desc_label.wrap = true;
            desc_label.justify = Gtk.Justification.CENTER;

            this.welcome_box.append (title_label);
            this.welcome_box.append (desc_label);
        }
    }
}
