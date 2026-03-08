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

using Ciano.Utils;

namespace Ciano.Widgets {

    /**
     * The RowConversion class represents a single item in the conversion list.
     * It displays the file name, conversion progress, status, and control buttons.
     *
     * @see Gtk.ListBoxRow
     * @since 0.1.0
     */
    public class RowConversion : Gtk.ListBoxRow {

        private Gtk.Box container;
        private Gtk.Box box_info;

        public int row_id;
        public Gtk.ProgressBar progress_bar;
        public Gtk.Label name_label;
        public Gtk.Label status_label;
        public Gtk.Button button_cancel;
        public Gtk.Button button_remove;
        public Gtk.Label format_label;

        /**
         * Constructs a new RowConversion object.
         * * @param icon The icon name for the file type.
         * @param name The name of the file being converted.
         * @param progress Initial progress fraction (0.0 to 1.0).
         * @param name_format The target format name (e.g., "MP4").
         */
        public RowConversion (string icon, string name, double progress, string name_format) {
            this.container = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 12);
            this.container.margin_start = 12;
            this.container.margin_end = 12;
            this.container.margin_top = 8;
            this.container.margin_bottom = 8;

            // File Icon
            var file_icon = new Gtk.Image.from_icon_name (icon);
            file_icon.pixel_size = 48;
            file_icon.valign = Gtk.Align.CENTER;

            // Main info container (Name, Progress, Status)
            this.box_info = new Gtk.Box (Gtk.Orientation.VERTICAL, 4);
            this.box_info.hexpand = true;

            // File Name Label with ellipsizing
            this.name_label = new Gtk.Label (name);
            this.name_label.halign = Gtk.Align.START;
            this.name_label.ellipsize = Pango.EllipsizeMode.END;
            this.name_label.add_css_class ("bold");

            // Progress Bar
            this.progress_bar = new Gtk.ProgressBar ();
            this.progress_bar.add_css_class ("progress_bar");
            this.update_progress (progress);

            // Target Format Label
            this.format_label = new Gtk.Label (name_format);
            this.format_label.valign = Gtk.Align.CENTER;
            this.format_label.add_css_class ("dim-label");

            // Status Label
            this.status_label = new Gtk.Label (_("Starting…"));
            this.status_label.halign = Gtk.Align.START;
            this.status_label.add_css_class ("dim-label");
            this.status_label.set_markup ("<span size='small'>%s</span>".printf (_("Starting…")));

            // Control Buttons
            this.button_cancel = new Gtk.Button.with_label (_("Cancel"));
            this.button_cancel.tooltip_text = _("Cancel conversion");
            this.button_cancel.valign = Gtk.Align.CENTER;
            this.button_cancel.add_css_class ("flat");
            this.button_cancel.add_css_class ("destructive-action");

            this.button_remove = new Gtk.Button.with_label (_("Remove"));
            this.button_remove.tooltip_text = _("Remove item from list");
            this.button_remove.valign = Gtk.Align.CENTER;
            this.button_remove.add_css_class ("btn-remove");

            // Assembly
            this.box_info.append (this.name_label);
            this.box_info.append (this.progress_bar);
            this.box_info.append (this.status_label);

            this.container.append (file_icon);
            this.container.append (this.box_info);
            this.container.append (this.format_label);
            this.container.append (this.button_cancel);
            this.container.append (this.button_remove);

            this.selectable = false;
            this.activatable = false;
            this.set_child (this.container);
        }

        /**
         * Updates the progress bar fraction and applies completion styles.
         * * @param fraction The new progress value (0.0 to 1.0).
         */
        public void update_progress (double fraction) {
            this.progress_bar.set_fraction (fraction);

            if (fraction >= 1.0) {
                this.progress_bar.add_css_class ("complete");
            } else {
                this.progress_bar.remove_css_class ("complete");
            }
        }
    }
}
