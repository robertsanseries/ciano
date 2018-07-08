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

    public class FFprobeFormat {
    
        /* Propriedade */
        public string filename                  { get; set; }
        public int nb_streams                   { get; set; }
        public int nb_programs                  { get; set; }
        public string format_name               { get; set; }
        public string format_long_name          { get; set; }
        public double start_time                { get; set; }
        public double duration                  { get; set; }
        public long size                        { get; set; }
        public long bit_rate                    { get; set; }
        public int probe_score                  { get; set; }
        public Gee.HashMap<string, string> tags { get; set; }

        /* Constructor */
        public FFprobeFormat () {
            GLib.message ("init class FFprobeFormat");
            this.tags = new Gee.HashMap<string, string> ();
        }
    }
}