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
using com.github.robertsanseries.FFmpegCliWrapper.Utils;

namespace com.github.robertsanseries.FFmpegCliWrapper {

    public class FFconvert {

        /* Propriedade */
        private FFmpeg ffmpeg;
        public bool error;
        public string msg_error;
        
        /* Constructor */
        public FFconvert (FFmpeg? ffmpeg = null) throws GLib.Error {
            GLib.message ("init class FFconvert");

            if (ffmpeg != null) {
                this.set_ffmpeg (ffmpeg);
            } else {
                throw new IllegalArgumentException.MESSAGE ("value is null");
            }
        }

        public void set_ffmpeg (FFmpeg? ffmpeg = null) throws GLib.Error {
            GLib.message ("set_ffmpeg");

            if (ffmpeg != null) {
                this.ffmpeg = ffmpeg;
            } else {
                throw new IllegalArgumentException.MESSAGE ("FFmpeg value is null");
            }
        }

        public async GLib.Subprocess convert () throws GLib.Error {
            GLib.message ("convert");

            if (this.ffmpeg == null) {
                throw new NullReferenceException.MESSAGE ("Command value is null");
            }
            
            GLib.SubprocessLauncher launcher        = new GLib.SubprocessLauncher (GLib.SubprocessFlags.STDERR_PIPE);
            GLib.Subprocess subprocess              = launcher.spawnv (this.ffmpeg.get ());
            GLib.InputStream input_stream           = subprocess.get_stderr_pipe ();
            GLib.CharsetConverter charset_converter = new GLib.CharsetConverter ("utf-8", "iso-8859-1");
            GLib.ConverterInputStream costream      = new GLib.ConverterInputStream (input_stream, charset_converter);
            GLib.DataInputStream data_input_stream  = new GLib.DataInputStream (costream);
            data_input_stream.set_newline_type (GLib.DataStreamNewlineType.ANY);
          
            while (true) {
                string str_return = data_input_stream.read_line_utf8 ();

                if (str_return == null) {
                    break; 
                } else {
                    GLib.message (str_return);
                    process_line (str_return);
               }
            }

            return subprocess;
        }

        private void process_line (string str_return) throws GLib.Error {
            if (str_return.contains ("No such file or directory")) {
                this.error = true;
                this.msg_error = "No such file or directory";
                throw new FileOrDirectoryNotFoundException.MESSAGE (this.msg_error);
            } else if (str_return.contains ("Invalid argument")) {
                this.error = true;
                this.msg_error = "Invalid argument";
                throw new IllegalArgumentException.MESSAGE (this.msg_error);
            } else if (str_return.contains ("Experimental codecs are not enabled")) {
                this.error = true;
                this.msg_error = "Experimental codecs are not enabled";
                throw new CodecNotEnabledException.MESSAGE (this.msg_error);
            } else if (str_return.contains ("Invalid data found when processing input")) {
                this.error = true;
                this.msg_error = "Invalid data found when processing input";
                throw new IOException.MESSAGE (this.msg_error);
            }
        }
    }
}