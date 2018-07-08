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

    public class FFprobeDisposition {

        /* Propriedade */
        public int default_         { get; set; }
        public int dub              { get; set; }
        public int original         { get; set; }
        public int comment          { get; set; }
        public int lyrics           { get; set; }
        public int karaoke          { get; set; }
        public int forced           { get; set; }
        public int hearing_impaired { get; set; }
        public int visual_impaired  { get; set; }
        public int clean_effects    { get; set; }
        public int attached_pic     { get; set; }

        /* Constructor */
        public FFprobeDisposition () {
            GLib.message ("init class FFprobeDisposition");
        }
    }
}
