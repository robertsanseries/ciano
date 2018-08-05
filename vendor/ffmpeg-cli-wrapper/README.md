<div align="center">
    <h1>FFmpeg Cli Wrapper</h1>
    <h3 align="center">Vala wrapper around the FFmpeg command line tool</h3>
    <p align="center">
        <img src="https://api.travis-ci.org/robertsanseries/ffmpeg-cli-wrapper.svg?branch=master">
        <img src="https://img.shields.io/badge/vala-v0.36.12-yellow.svg">
        <img src="https://img.shields.io/badge/stable-v0.1.0-blue.svg">
        <img src="https://img.shields.io/github/license/mashape/apistatus.svg">
    </p>
</div>

<br>

### How this library works:

This library requires a working FFMpeg install. You will need both FFMpeg and FFProbe binaries to use it.

### Installation

You can download FFmpeg Cli Wrapper via Github [Here](https://github.com/robertsanseries/ffmpeg-cli-wrapper/archive/master.zip)

or If you want install via [Vanat](https://vanat.github.io). *recommended


```bash
$ vanat require robertsanseries/ffmpeg-wrapper
```

#### Requirements

* FFmpeg 2.8.14+
* Vala 0.36+

### Documentation

You can find the complete documentation on our [Wiki](""). Or parse the source code.

### Basic exemple

```vala
FFmpeg ffmpeg2 = new FFmpeg ()
.set_input ("/home/robertsanseries/Documentos/doc.mp4")
.set_output ("/home/robertsanseries/Documentos/doc.avi")
.set_format ("avi")
.set_override_output (true);

// output: ffmpeg -y -hide_banner -i /home/robertsanseries/Documentos/doc.mp4 -f avi /home/robertsanseries/Documentos/doc.avi
GLib.message (ffmpeg2.get_command ());

FFconvert ffconvert = new FFconvert (ffmpeg2);
GLib.MainLoop mainloop = new GLib.MainLoop();
ffconvert.convert.begin ((obj, async_res) => {
    try {
        GLib.Subprocess subprocess = ffconvert.convert.end (async_res);

        if (subprocess != null && subprocess.wait_check ()) {
            GLib.message ("Success");
        } else {
            GLib.message ("Error");
        }
    } catch (Error e) {
        GLib.critical (e.message);        
    }

     mainloop.quit();
});
mainloop.run();

FFprobe ffprobe = ffmpeg2.get_ffprobe ();

// output: /home/robertsanseries/Documentos/doc.mp4
stdout.printf(ffprobe.format.filename);
```

#### Basic Usage

To use the FFmpeg Cli Wrapper you need to add the namespace:

```vala
using com.github.robertsanseries.FFmpegCliWrapper;
```

Starting the class:

```vala
FFmpeg ffmpeg = new FFmpeg ();
```

You may already set some optional values when starting the class:

 - Input
 - Output
 - Override Files
 - Force Format

##### Input & Output.

```vala
FFmpeg ffmpeg = new FFmpeg (
    "/home/Vídeos/MarcusMiller.mkv",
    "/home/Vídeos/MarcusMiller.avi"
);
```

##### Input & Output & Override Files .

```vala
FFmpeg ffmpeg = new FFmpeg (
    "/home/Vídeos/MarcusMiller.mkv",
    "/home/Vídeos/MarcusMiller.avi",
    true
);
```

##### Input & Output & Override Files & Force Format.

```vala
FFmpeg ffmpeg = new FFmpeg (
    "/home/Vídeos/MarcusMiller.mkv",
    "/home/Vídeos/MarcusMiller.avi",
    true,
    "avi"
);
```

You can set the values in two other ways:

##### #1:

```vala
FFmpeg ffmpeg = new FFmpeg ();
ffmpeg.set_input ("/home/Vídeos/MarcusMiller.mkv");
ffmpeg.set_output ("/home/Vídeos/MarcusMiller.avi");
ffmpeg.set_format ("avi");
ffmpeg.set_override_output (true);
```


##### #2:

```vala
FFmpeg ffmpeg = new FFmpeg ()
.set_input ("/home/Vídeos/MarcusMiller.mkv")
.set_output ("/home/Vídeos/MarcusMiller.avi")
.set_format ("avi")
.set_override_output (true);
```

Use the `get_cmd ()` function to get the generated command string:

```vala
FFmpeg ffmpeg = new FFmpeg ();
ffmpeg.set_input ("/home/Vídeos/MarcusMiller.mkv");
ffmpeg.set_output ("/home/Vídeos/MarcusMiller.avi");
ffmpeg.set_format ("avi");
ffmpeg.set_override_output (true);

stdout.printf (ffmpeg.get_cmd ());
```

```sh
$ ffmpeg -y -i /home/Vídeos/MarcusMiller.mkv -f avi /home/Vídeos/MarcusMiller.avi
```

### Test

#### compile

```sh
$ valac --pkg json-glib-1.0 --pkg gio-2.0 --pkg gee-0.8 src/FFconvert.vala src/FFmpeg.vala src/FFprobe.vala src/exceptions/CodecNotEnabledException.vala src/exceptions/FileOrDirectoryNotFoundException.vala src/exceptions/NullReferenceException.vala src/utils/StringUtil.vala test/FFmpegTest.vala src/exceptions/IllegalArgumentException.vala src/exceptions/IOException.vala src/probe/FFprobeDisposition.vala src/probe/FFprobeFormat.vala src/probe/FFprobeStream.vala -o ffmpeg-cli-wrapper
```

#### execute

```sh
$ ./ffmpeg-cli-wrapper
```

### License

This project is licensed under the [MIT license](http://opensource.org/licenses/MIT).
