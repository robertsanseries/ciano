/*
 * Copyright (c) 2026 Robert San <robertsanseries@gmail.com>
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

bool gtk_available = false;

bool skip_without_display () {
    if (!gtk_available) {
        Test.skip ("no display available");
        return true;
    }

    return false;
}

int main (string[] args) {
    Test.init (ref args);
    gtk_available = Gtk.init_check ();

    Test.add_func ("/widget-util/set-visible/hide", () => {
        if (skip_without_display ()) {
            return;
        }

        var label = new Gtk.Label ("x");
        assert_true (label.visible);

        WidgetUtil.set_visible (label, false);
        assert_false (label.visible);
    });

    Test.add_func ("/widget-util/set-visible/show", () => {
        if (skip_without_display ()) {
            return;
        }

        var button = new Gtk.Button ();
        button.visible = false;

        WidgetUtil.set_visible (button, true);
        assert_true (button.visible);
    });

    Test.add_func ("/widget-util/set-visible/idempotent", () => {
        if (skip_without_display ()) {
            return;
        }

        var label = new Gtk.Label ("x");

        WidgetUtil.set_visible (label, false);
        WidgetUtil.set_visible (label, false);
        assert_false (label.visible);

        WidgetUtil.set_visible (label, true);
        WidgetUtil.set_visible (label, true);
        assert_true (label.visible);
    });

    Test.add_func ("/widget-util/set-visible/notifies-once-per-change", () => {
        if (skip_without_display ()) {
            return;
        }

        var label = new Gtk.Label ("x");
        int count = 0;

        label.notify["visible"].connect (() => {
            count++;
        });

        WidgetUtil.set_visible (label, false);
        WidgetUtil.set_visible (label, false);
        WidgetUtil.set_visible (label, true);

        assert_cmpint (count, CompareOperator.EQ, 2);
    });

    Test.add_func ("/widget-util/set-visible/does-not-affect-siblings", () => {
        if (skip_without_display ()) {
            return;
        }

        var box = new Gtk.Box (Gtk.Orientation.VERTICAL, 0);
        var first = new Gtk.Label ("1");
        var second = new Gtk.Label ("2");
        box.append (first);
        box.append (second);

        WidgetUtil.set_visible (first, false);

        assert_false (first.visible);
        assert_true (second.visible);
        assert_true (box.visible);
    });

    Test.add_func ("/widget-util/set-visible/hidden-parent-keeps-child-flag", () => {
        if (skip_without_display ()) {
            return;
        }

        var box = new Gtk.Box (Gtk.Orientation.VERTICAL, 0);
        var child = new Gtk.Label ("c");
        box.append (child);

        WidgetUtil.set_visible (box, false);

        // "visible" is the widget's own flag, not its effective visibility
        assert_true (child.visible);
        assert_false (child.is_visible ());
    });

    return Test.run ();
}
