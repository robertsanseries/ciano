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

namespace com.github.robertsanseries.FFmpegCliWrapper.Probe {

    public class FFprobeStream {

        public enum CodecType {
            VIDEO,
            AUDIO,
        }
    
        /* Propriedade */
        public string filename                  { get; set; }
        public int index                        { get; set; }
        public string codec_name                { get; set; }
        public string codec_long_name           { get; set; }
        public string profile                   { get; set; }
        public string codec_type                { get; set; }
        public string codec_time_base           { get; set; }
        public string codec_tag_string          { get; set; }
        public string codec_tag                 { get; set; }
        public int width                        { get; set; }
        public int height                       { get; set; }
        public int coded_width                  { get; set; }
        public int coded_height                 { get; set; }
        public int has_b_frames                 { get; set; }
        public string sample_aspect_ratio       { get; set; }
        public string display_aspect_ratio      { get; set; }
        public string pix_fmt                   { get; set; }
        public int level                        { get; set; }
        public string chroma_location           { get; set; }
        public int refs                         { get; set; }
        public string is_avc                    { get; set; }
        public string nal_length_size           { get; set; }
        public string r_frame_rate              { get; set; }
        public string avg_frame_rate            { get; set; }
        public string time_base                 { get; set; }
        public long start_pts                   { get; set; }
        public double start_time                { get; set; }
        public long duration_ts                 { get; set; }
        public double duration                  { get; set; }
        public long bit_rate                    { get; set; }
        public long max_bit_rate                { get; set; }
        public int bits_per_raw_sample          { get; set; }
        public int bits_per_sample              { get; set; }
        public long nb_frames                   { get; set; }
        public string sample_fmt                { get; set; }
        public int sample_rate                  { get; set; }
        public int channels                     { get; set; }
        public string channel_layout            { get; set; }
        public FFprobeDisposition disposition   { get; set; }
        public Gee.HashMap<string, string> tags { get; set; }

        /* Constructor */
        public FFprobeStream () {
            GLib.message ("init class FFprobeStream");
            this.tags = new Gee.HashMap<string, string> ();
            this.disposition = new FFprobeDisposition ();
        }
    }
}
