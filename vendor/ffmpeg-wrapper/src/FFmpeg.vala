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

    public class FFmpeg {

        /* Propriedade */
        private const string FFMPEG = "ffmpeg";
        private string input;
        private string output;
        private string acodec;
        private string vcodec;
        private string format;
        private bool override_output = false;
        private FFprobe ffprobe;
        

        /* Constructor */
        public FFmpeg (string? input = null, string? output = null, bool override_output = false, string? format = null) throws Error {
            GLib.message ("init class FFmpeg");

            if (StringUtil.is_not_empty (input)) {
                this.set_input (input);
            }

            if (StringUtil.is_not_empty (output)) {
                set_output (output);
            }

            if (override_output) {
                set_override_output (override_output);
            }

            if (StringUtil.is_not_empty (format)) {
                set_format (format);
            }
        }

        public FFmpeg set_input (string? input = null) throws Error {
            GLib.message ("setting the input value");
            
            if (StringUtil.is_not_empty (input)) {
                this.input = input;
                this.ffprobe = new FFprobe (this.input);
            } else {
                throw new IllegalArgumentException.MESSAGE ("Input value is null");
            }

            return this;
        }

        public FFmpeg set_output (string? output = null, string? format = null) throws Error {
            GLib.message ("setting the output value");

            if (StringUtil.is_not_empty (output)) {
                this.output = output;
            } else {
                throw new IllegalArgumentException.MESSAGE ("Output value is null");
            }

            if(StringUtil.is_not_empty (format)) {
                this.set_format (format);
            }

            return this;
        }

        // -acodec aac
        public FFmpeg set_acodec (string? acodec = null) throws Error {
            GLib.message ("setting the value of the audio codec");

            if (StringUtil.is_not_empty (acodec)) {
                this.acodec = acodec;
            } else {
                throw new IllegalArgumentException.MESSAGE ("Audio codec value is null");
            }

            return this;
        }

        //-vcodec h264
        public FFmpeg set_vcodec (string? vcodec = null) throws Error {
            GLib.message ("setting the value of the video codec");

            if (StringUtil.is_not_empty (vcodec)) {
                this.vcodec = vcodec;
            } else {
                throw new IllegalArgumentException.MESSAGE ("Video codec value is null");
            }

            return this;
        }

        public FFmpeg set_format (string? format = null) throws Error {
            GLib.message ("forcing Output Format");

            if (StringUtil.is_not_empty (format)) {
                this.format = format;
            } else {
                throw new IllegalArgumentException.MESSAGE ("Force Format value is null");
            }

            return this;
        }

        public FFmpeg set_override_output (bool override_output = false) throws Error {
            GLib.message ("setting whether to overwrite the output files");
            this.override_output = override_output;
            return this;
        }

        public string[] get () throws Error {
            GenericArray<string> array_str = command_mount ();
            GLib.message ("returning the command that will be executed");
            return array_str.data;
        }

        public string get_command () throws Error {
            GenericArray<string> array_str = command_mount ();
            string command = StringUtil.EMPTY;
            
            array_str.foreach ((str) => {
                command += str + StringUtil.SPACE;
            });

            GLib.message ("returning the command that will be executed");
            return command;
        }

        private GenericArray<string> command_mount () throws Error {
            GLib.message ("setting up the command that will be executed");

            GenericArray<string> array_str = new GenericArray<string> ();

            array_str.add (FFMPEG);

            if (this.override_output) {
                array_str.add ("-y");    
            }
            
            array_str.add ("-hide_banner");

            array_str.add ("-i");
            
            if (StringUtil.is_not_empty (this.input)) {
                array_str.add (this.input);
            } else {
                throw new IllegalArgumentException.MESSAGE ("Input can not be null when mounting the command");
            }
            
            if (StringUtil.is_not_empty (this.format)) {
                array_str.add ("-f");
                array_str.add (this.format);
            }
            
            if (StringUtil.is_not_empty (this.output)) {
                array_str.add (this.output);    
            }

            return array_str;
        }      

        public string get_input () {
            return this.input;
        }
        
        public string get_output () {
            return this.output;
        }
        
        public string get_acodec () {
            return this.acodec;
        }
        
        public string get_vcodec () {
            return this.vcodec;
        }
        
        public string get_format () {
            return this.format;
        }
        
        public bool get_override_output () {
            return this.override_output;
        }

        public FFprobe get_ffprobe () {
            return this.ffprobe;
        }
    }
}