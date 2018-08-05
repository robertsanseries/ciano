/*
 * MIT License
 *
* Copyright (c) 2018 Robert San <robertsanseries@gmail.com>
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

using com.github.robertsanseries.FFmpegCliWrapper.Exceptions;
using com.github.robertsanseries.FFmpegCliWrapper.Probe;

namespace com.github.robertsanseries.FFmpegCliWrapper {

    public errordomain MyError {
        INVALID_FORMAT
    }

    public class FFprobe {

        /* Propriedade */
        public FFprobeFormat format               { get; set; }
        public Gee.HashSet<FFprobeStream> streams { get; set; }
       
        /* Constructor */
        public FFprobe (string input) {
            try {
                GLib.message ("init class FFprobe");

                string standard_output;
                string standard_error;
                int exit_status;

                Process.spawn_command_line_sync (
                    "ffprobe -show_format -show_streams -v quiet -print_format json ".concat(input), 
                    out standard_output, out standard_error, out exit_status
                );

                if (exit_status != 0)
                    throw new IOException.MESSAGE (standard_error);

                this.format  = new FFprobeFormat ();
                this.streams = new Gee.HashSet<FFprobeStream> ();

                this.process_json (standard_output);
            } catch (Error e) {
                GLib.error (e.message);
            }
        }

        private void process_json (string json) throws Error {
            var parser = new Json.Parser();
            parser.load_from_data (json);

            unowned Json.Node node = parser.get_root();

            this.validate_node_type_object (node);

            unowned Json.Object obj = node.get_object ();

            if (obj.has_member ("streams")) {
                unowned Json.Node streams = obj.get_member ("streams");
                this.process_streams (streams);
            }

            if (obj.has_member ("format")) {
                unowned Json.Node format = obj.get_member ("format");
                this.process_format (format);
            }
        }

        private void process_streams (Json.Node node) throws Error {
            this.validate_node_type_array (node);

            unowned Json.Array array = node.get_array ();
            int i = 1;

            foreach (unowned Json.Node item in array.get_elements ()) {
                this.process_streams_array (item, i);
                i++;
            }
        }

        private void process_streams_array (Json.Node node, uint number) throws Error {
            this.validate_node_type_object (node);

            unowned Json.Object obj = node.get_object ();

            FFprobeStream ffprobe_stream = new FFprobeStream();

            if (obj.has_member ("index"))
                ffprobe_stream.index = (int) obj.get_int_member ("index");

            if (obj.has_member ("codec_name"))
                ffprobe_stream.codec_name = obj.get_string_member ("codec_name");

            if (obj.has_member ("codec_long_name"))
                ffprobe_stream.codec_long_name = obj.get_string_member ("codec_long_name");
            
            if (obj.has_member ("profile"))
                ffprobe_stream.profile = obj.get_string_member ("profile");
            
            if (obj.has_member ("codec_type"))
                ffprobe_stream.codec_type = obj.get_string_member ("codec_type");

            if (obj.has_member ("codec_time_base"))
                ffprobe_stream.codec_time_base = obj.get_string_member ("codec_time_base");

            if (obj.has_member ("codec_tag_string"))
                ffprobe_stream.codec_tag_string = obj.get_string_member ("codec_tag_string");

            if (obj.has_member ("codec_tag"))
                ffprobe_stream.codec_tag = obj.get_string_member ("codec_tag");

            if (obj.has_member ("width"))
                ffprobe_stream.width = (int) obj.get_int_member ("width");

            if (obj.has_member ("height"))
                ffprobe_stream.height = (int) obj.get_int_member ("height");

            if (obj.has_member ("coded_width"))
                ffprobe_stream.coded_width = (int) obj.get_string_member ("coded_width");

            if (obj.has_member ("coded_height"))
                ffprobe_stream.coded_height = (int) obj.get_string_member ("coded_height");
            
            if (obj.has_member ("has_b_frames"))
                ffprobe_stream.has_b_frames = (int) obj.get_int_member ("has_b_frames");

            if (obj.has_member ("sample_aspect_ratio"))
                ffprobe_stream.sample_aspect_ratio = obj.get_string_member ("sample_aspect_ratio");

            if (obj.has_member ("display_aspect_ratio"))
                ffprobe_stream.display_aspect_ratio = obj.get_string_member ("display_aspect_ratio");

            if (obj.has_member ("pix_fmt"))
                ffprobe_stream.pix_fmt = obj.get_string_member ("pix_fmt");

            if (obj.has_member ("level"))
                ffprobe_stream.level = (int) obj.get_int_member ("level");

            if (obj.has_member ("chroma_location"))
                ffprobe_stream.chroma_location = obj.get_string_member ("chroma_location");

            if (obj.has_member ("refs"))
                ffprobe_stream.refs = (int) obj.get_int_member ("refs");

            if (obj.has_member ("is_avc"))
                ffprobe_stream.is_avc = obj.get_string_member ("is_avc");

            if (obj.has_member ("nal_length_size"))
                ffprobe_stream.nal_length_size = obj.get_string_member ("nal_length_size");

            if (obj.has_member ("r_frame_rate"))
                ffprobe_stream.r_frame_rate = obj.get_string_member ("r_frame_rate");

            if (obj.has_member ("avg_frame_rate"))
                ffprobe_stream.avg_frame_rate = obj.get_string_member ("avg_frame_rate");
            
            if (obj.has_member ("time_base"))
                ffprobe_stream.time_base = obj.get_string_member ("time_base");
            
            if (obj.has_member ("start_pts"))
                ffprobe_stream.start_pts = (long) obj.get_int_member ("start_pts");

            if (obj.has_member ("start_time"))
                ffprobe_stream.start_time = long.parse (obj.get_string_member ("start_time"));

            if (obj.has_member ("duration_ts"))
                ffprobe_stream.duration_ts = (long) obj.get_int_member ("duration_ts");

            if (obj.has_member ("duration"))
                ffprobe_stream.duration = long.parse (obj.get_string_member ("duration"));

            if (obj.has_member ("bit_rate"))
                ffprobe_stream.bit_rate = long.parse (obj.get_string_member ("bit_rate"));

            if (obj.has_member ("bits_per_raw_sample"))
                ffprobe_stream.bits_per_raw_sample = int.parse (obj.get_string_member ("bits_per_raw_sample"));

            if (obj.has_member ("nb_frames"))
                ffprobe_stream.nb_frames = long.parse (obj.get_string_member ("nb_frames"));

            if (obj.has_member ("disposition"))
                ffprobe_stream.disposition  = this.process_disposition (obj.get_member ("disposition"));

            if (obj.has_member ("tags"))
                ffprobe_stream.tags = this.process_streams_tags (obj.get_member ("tags"));

            this.streams.add(ffprobe_stream);
        }
       
        private FFprobeDisposition process_disposition (Json.Node node) throws Error {
            this.validate_node_type_object (node);

            unowned Json.Object obj = node.get_object ();

            FFprobeDisposition ffprobe_disposition = new FFprobeDisposition ();

            if (obj.has_member ("default"))
                ffprobe_disposition.default_ = (int) obj.get_int_member ("default");

            if (obj.has_member ("dub"))
                ffprobe_disposition.dub = (int) obj.get_int_member ("dub");

            if (obj.has_member ("original"))
                ffprobe_disposition.original = (int) obj.get_int_member ("original");

            if (obj.has_member ("comment"))
                ffprobe_disposition.comment = (int) obj.get_int_member ("comment");

            if (obj.has_member ("lyrics"))
                ffprobe_disposition.lyrics = (int) obj.get_int_member ("lyrics");

            if (obj.has_member ("karaoke"))
                ffprobe_disposition.karaoke = (int) obj.get_int_member ("karaoke");

            if (obj.has_member ("forced"))
                ffprobe_disposition.forced = (int) obj.get_int_member ("forced");

            if (obj.has_member ("hearing_impaired"))
                ffprobe_disposition.hearing_impaired = (int) obj.get_int_member ("hearing_impaired");

            if (obj.has_member ("visual_impaired"))
                ffprobe_disposition.visual_impaired = (int) obj.get_int_member ("visual_impaired");

            if (obj.has_member ("clean_effects"))
                ffprobe_disposition.clean_effects = (int) obj.get_int_member ("clean_effects");

            if (obj.has_member ("attached_pic"))
                ffprobe_disposition.attached_pic = (int) obj.get_int_member ("attached_pic");

            return ffprobe_disposition;
        }

        private Gee.HashMap<string, string> process_streams_tags (Json.Node node) throws Error {
            this.validate_node_type_object (node);

            unowned Json.Object obj = node.get_object ();

            Gee.HashMap<string, string> tags = new Gee.HashMap<string, string> ();

            if (obj.has_member ("language"))
                tags.set ("language", obj.get_string_member ("language"));

            if (obj.has_member ("handler_name"))
                tags.set ("handler_name", obj.get_string_member ("handler_name"));

            return tags;
        }

        private void process_format (Json.Node node) throws Error {
            this.validate_node_type_object (node);

            unowned Json.Object obj = node.get_object ();

            if (obj.has_member ("filename"))
                this.format.filename = obj.get_string_member ("filename");

            if (obj.has_member ("nb_streams"))
                this.format.nb_streams = (int) obj.get_int_member ("nb_streams");

            if (obj.has_member ("nb_programs"))
                this.format.nb_programs = (int) obj.get_int_member ("nb_programs");

            if (obj.has_member ("format_name"))
                this.format.format_name = obj.get_string_member ("format_name");

            if (obj.has_member ("format_long_name"))
                this.format.format_long_name = obj.get_string_member ("format_long_name");

            if (obj.has_member ("start_time"))
                this.format.start_time = int.parse (obj.get_string_member ("start_time"));

            if (obj.has_member ("duration"))
                this.format.duration = int.parse (obj.get_string_member ("duration"));

            if (obj.has_member ("size"))
                this.format.size = int.parse (obj.get_string_member ("size"));

            if (obj.has_member ("bit_rate"))
                this.format.bit_rate = int.parse (obj.get_string_member ("bit_rate"));

            if (obj.has_member ("probe_score"))
                this.format.probe_score = (int) obj.get_int_member ("probe_score");
            
            if (obj.has_member ("tags"))
                this.process_format_tags (obj.get_member ("tags"));
        }

        private void process_format_tags (Json.Node node) throws Error {
            this.validate_node_type_object (node);

            unowned Json.Object obj = node.get_object ();

            if (obj.has_member ("major_brand"))
                this.format.tags.set ("major_brand", obj.get_string_member ("major_brand"));

            if (obj.has_member ("minor_version"))
                this.format.tags.set ("minor_version", obj.get_string_member ("minor_version"));

            if (obj.has_member ("compatible_brands"))
                this.format.tags.set ("compatible_brands", obj.get_string_member ("compatible_brands"));

            if (obj.has_member ("title"))
                this.format.tags.set ("title", obj.get_string_member ("title"));                
        }

        private void validate_node_type_object (Json.Node node) throws Error {
            if (node.get_node_type () != Json.NodeType.OBJECT)
                throw new MyError.INVALID_FORMAT ("Unexpected element type %s", node.type_name ());
        }

        private void validate_node_type_array (Json.Node node) throws Error {
            if (node.get_node_type () != Json.NodeType.ARRAY)
                throw new MyError.INVALID_FORMAT ("Unexpected element type %s", node.type_name ());
        }
    }
}