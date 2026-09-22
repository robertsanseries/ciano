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

using Ciano.Enums;
using Ciano.Objects;

void add_file_item_tests () {
    Test.add_func ("/objects/file-item/constructor", () => {
        var item = new FileItem ("clip.mp4", "/home/user/Videos/");

        assert_cmpstr (item.name, CompareOperator.EQ, "clip.mp4");
        assert_cmpstr (item.directory, CompareOperator.EQ, "/home/user/Videos/");
    });

    Test.add_func ("/objects/file-item/setters", () => {
        var item = new FileItem ("a", "b");
        item.name = "new.mkv";
        item.directory = "/tmp/";

        assert_cmpstr (item.name, CompareOperator.EQ, "new.mkv");
        assert_cmpstr (item.directory, CompareOperator.EQ, "/tmp/");
    });

    Test.add_func ("/objects/file-item/empty-and-utf8-values", () => {
        var empty = new FileItem ("", "");
        assert_cmpstr (empty.name, CompareOperator.EQ, "");
        assert_cmpstr (empty.directory, CompareOperator.EQ, "");

        var utf8 = new FileItem ("canção.flac", "/música/");
        assert_cmpstr (utf8.name, CompareOperator.EQ, "canção.flac");
        assert_cmpstr (utf8.directory, CompareOperator.EQ, "/música/");
    });

    Test.add_func ("/objects/file-item/is-gobject-with-properties", () => {
        var item = new FileItem ("a", "b");

        assert_true (item is Object);

        // Needed to store it in a GLib.ListStore
        var klass = (ObjectClass) typeof (FileItem).class_ref ();
        assert_nonnull (klass.find_property ("name"));
        assert_nonnull (klass.find_property ("directory"));

        Value value = Value (typeof (string));
        item.get_property ("name", ref value);
        assert_cmpstr (value.get_string (), CompareOperator.EQ, "a");
    });

    Test.add_func ("/objects/file-item/notify", () => {
        var item = new FileItem ("a", "b");
        int count = 0;
        string last = "";

        item.notify.connect ((pspec) => {
            count++;
            last = pspec.name;
        });

        item.name = "c";
        assert_cmpint (count, CompareOperator.EQ, 1);
        assert_cmpstr (last, CompareOperator.EQ, "name");

        item.directory = "d";
        assert_cmpint (count, CompareOperator.EQ, 2);
        assert_cmpstr (last, CompareOperator.EQ, "directory");
    });

    Test.add_func ("/objects/file-item/in-list-store", () => {
        var store = new ListStore (typeof (FileItem));
        store.append (new FileItem ("1.mp4", "/a/"));
        store.append (new FileItem ("2.mp4", "/b/"));

        assert_cmpuint (store.get_n_items (), CompareOperator.EQ, 2);
        assert_cmpstr (((FileItem) store.get_item (1)).name, CompareOperator.EQ, "2.mp4");
        assert_cmpstr (((FileItem) store.get_item (0)).directory, CompareOperator.EQ, "/a/");
    });
}

void add_item_conversion_tests () {
    Test.add_func ("/objects/item-conversion/constructor", () => {
        var item = new ItemConversion (7, "clip.avi", "/in/", "MP4", 0.25, TypeItemEnum.VIDEO);

        assert_cmpint (item.id, CompareOperator.EQ, 7);
        assert_cmpstr (item.name, CompareOperator.EQ, "clip.avi");
        assert_cmpstr (item.directory, CompareOperator.EQ, "/in/");
        assert_cmpstr (item.convert_to, CompareOperator.EQ, "MP4");
        assert_cmpfloat (item.progress, CompareOperator.EQ, 0.25);
        assert_true (item.type_item == TypeItemEnum.VIDEO);
    });

    Test.add_func ("/objects/item-conversion/null-convert-to-uses-default", () => {
        var item = new ItemConversion (1, "a", "b", null, 0.5, TypeItemEnum.MUSIC);

        assert_nonnull (item.convert_to);
        assert_cmpstr (item.convert_to, CompareOperator.EQ, "");
    });

    Test.add_func ("/objects/item-conversion/null-progress-uses-default", () => {
        var item = new ItemConversion (1, "a", "b", "MP3", null, TypeItemEnum.MUSIC);
        assert_cmpfloat (item.progress, CompareOperator.EQ, 0.0);
    });

    Test.add_func ("/objects/item-conversion/zero-progress", () => {
        var item = new ItemConversion (1, "a", "b", "MP3", 0, TypeItemEnum.MUSIC);
        assert_cmpfloat (item.progress, CompareOperator.EQ, 0.0);
    });

    Test.add_func ("/objects/item-conversion/progress-bounds", () => {
        var done = new ItemConversion (1, "a", "b", "MP3", 1.0, TypeItemEnum.MUSIC);
        assert_cmpfloat (done.progress, CompareOperator.EQ, 1.0);

        done.progress = 0.75;
        assert_cmpfloat (done.progress, CompareOperator.EQ, 0.75);
    });

    Test.add_func ("/objects/item-conversion/every-type", () => {
        TypeItemEnum[] types = { TypeItemEnum.VIDEO, TypeItemEnum.MUSIC, TypeItemEnum.IMAGE };

        foreach (var type in types) {
            var item = new ItemConversion (1, "a", "b", "X", 0, type);
            assert_true (item.type_item == type);
        }
    });

    Test.add_func ("/objects/item-conversion/id-values", () => {
        assert_cmpint (new ItemConversion (0, "a", "b", "X", 0, TypeItemEnum.IMAGE).id, CompareOperator.EQ, 0);
        assert_cmpint (
                new ItemConversion (int.MAX, "a", "b", "X", 0, TypeItemEnum.IMAGE).id, CompareOperator.EQ, int.MAX
        );
    });

    Test.add_func ("/objects/item-conversion/setters", () => {
        var item = new ItemConversion (1, "a", "b", "MP3", 0, TypeItemEnum.MUSIC);

        item.id = 2;
        item.name = "n";
        item.directory = "d";
        item.convert_to = "WAV";
        item.type_item = TypeItemEnum.VIDEO;

        assert_cmpint (item.id, CompareOperator.EQ, 2);
        assert_cmpstr (item.name, CompareOperator.EQ, "n");
        assert_cmpstr (item.directory, CompareOperator.EQ, "d");
        assert_cmpstr (item.convert_to, CompareOperator.EQ, "WAV");
        assert_true (item.type_item == TypeItemEnum.VIDEO);
    });

    Test.add_func ("/objects/item-conversion/notify-progress", () => {
        var item = new ItemConversion (1, "a", "b", "MP3", 0, TypeItemEnum.MUSIC);
        int count = 0;

        item.notify["progress"].connect (() => {
            count++;
        });

        item.progress = 0.5;
        item.progress = 1.0;
        item.name = "other";

        assert_cmpint (count, CompareOperator.EQ, 2);
    });

    Test.add_func ("/objects/item-conversion/properties", () => {
        var klass = (ObjectClass) typeof (ItemConversion).class_ref ();
        string[] names = { "id", "name", "directory", "convert-to", "progress", "type-item" };

        foreach (string name in names) {
            assert_nonnull (klass.find_property (name));
        }
    });

    Test.add_func ("/objects/item-conversion/instances-are-independent", () => {
        var a = new ItemConversion (1, "a", "b", null, null, TypeItemEnum.MUSIC);
        var b = new ItemConversion (2, "c", "d", null, null, TypeItemEnum.MUSIC);

        a.convert_to = "MP3";
        a.progress = 0.9;

        assert_cmpstr (b.convert_to, CompareOperator.EQ, "");
        assert_cmpfloat (b.progress, CompareOperator.EQ, 0.0);
    });
}

void add_enum_tests () {
    Test.add_func ("/enums/type-item/values", () => {
        assert_cmpint ((int) TypeItemEnum.VIDEO, CompareOperator.EQ, 0);
        assert_cmpint ((int) TypeItemEnum.MUSIC, CompareOperator.EQ, 1);
        assert_cmpint ((int) TypeItemEnum.IMAGE, CompareOperator.EQ, 2);
    });

    Test.add_func ("/enums/type-item/to-string", () => {
        assert_cmpstr (TypeItemEnum.VIDEO.to_string (), CompareOperator.EQ, "CIANO_ENUMS_TYPE_ITEM_ENUM_VIDEO");
        assert_cmpstr (TypeItemEnum.MUSIC.to_string (), CompareOperator.EQ, "CIANO_ENUMS_TYPE_ITEM_ENUM_MUSIC");
        assert_cmpstr (TypeItemEnum.IMAGE.to_string (), CompareOperator.EQ, "CIANO_ENUMS_TYPE_ITEM_ENUM_IMAGE");
    });

    Test.add_func ("/enums/column/values", () => {
        assert_cmpint ((int) ColumnEnum.NAME, CompareOperator.EQ, 0);
        assert_cmpint ((int) ColumnEnum.DIRECTORY, CompareOperator.EQ, 1);
        // N_COLUMNS must stay last, it is the number of real columns
        assert_cmpint ((int) ColumnEnum.N_COLUMNS, CompareOperator.EQ, 2);
    });
}

int main (string[] args) {
    Test.init (ref args);

    add_file_item_tests ();
    add_item_conversion_tests ();
    add_enum_tests ();

    return Test.run ();
}
