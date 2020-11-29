---
title: Software
---

Below are some links to downloads or separate pages for software that I've developed. The source code for some of my software projects can also be found on [GitHub](https://github.com/joshb).

- [Eagle Framework](https://github.com/joshb/EagleFramework)

  Eagle Framework is a framework for creating network servers and web applications written in Swift. It has been developed and tested on macOS and Ubuntu. Some of its features include efficient handling of multiple connections (using kernel queues on macOS and epoll on Linux), serving static content, a simple template engine, and an Object-Relational Mapping (ORM) system that can be used to access SQLite databases.

- [CocoaOpenGL-Swift](https://github.com/joshb/CocoaOpenGL-Swift)

  An example of using Swift and Cocoa to create an OpenGL application for macOS.

- [Drome Engine](drome_engine/)

  Drome Engine is a 3D game engine that's written in C++ and uses OpenGL for graphics rendering.

- [DromeAudio](https://github.com/joshb/dromeaudio)

  DromeAudio is an audio manipulation and playback library that's written in C++. It supports ALSA on Linux, Core Audio on macOS, and SDL on other platforms.

- [DromeXml](https://github.com/joshb/DromeXml)

  DromeXml is a library for parsing simple XML data. It is written in C++ and designed so that it can be easily included with and incorporated into other projects.

- [CocoaOpenGL](https://github.com/joshb/CocoaOpenGL)

  A simple example of using Cocoa to create an OpenGL application for Mac OS X, including full screen support on OS X 10.7 (Lion). The application demonstrates normal mapping using the OpenGL 3.2 Core Profile and GLSL 1.50. A screenshot of the application can be seen [here](screenshots/CocoaOpenGL.png).

- [prtunnel](prtunnel/)

  prtunnel is a program that tunnels TCP/IP connections in a variety of ways, including through HTTP and SOCKS5 proxy servers.

- [jsrasterizer](../jsrasterizer/)

  A simple triangle rasterizer implemented with HTML, CSS, and JavaScript.

- [glsl_lighting](https://github.com/joshb/glsl_lighting)

  An OpenGL application written in C that demonstrates lighting implemented with GLSL shaders. This demo was written for the [Getting Started with the OpenGL Shading Language](/articles/getting_started_with_glsl/) article.

- [triangleraster](https://github.com/joshb/triangleraster)

  A graphics demo written in C++ that demonstrates triangle rasterization. This demo was written for the [Introduction to Software-based Rendering: Triangle Rasterization](/articles/triangle_rasterization/) article.

- [linedrawing](https://github.com/joshb/linedrawing)

  A graphics demo written in C++ that demonstrates a simple line drawing algorithm. This demo was written for the [Introduction to Software-based Rendering: Simple Line Drawing](/articles/simple_line_drawing/) article.

- [shadowvolumes](https://github.com/joshb/shadowvolumes)

  An OpenGL application written in C that demonstrates stenciled shadow volumes. This demo was written for the [Stenciled Shadow Volumes in OpenGL](/articles/stenciled_shadow_volumes_in_opengl/) article.

- [jab_normalmap](https://github.com/joshb/jab_normalmap)

  A small OpenGL application that demonstrates normal mapping, a lighting technique that can cause flat surfaces appear to have depth. The normal mapping is accomplished with a fragment program written in Cg and compiled into the ARB_fragment_program shader language. The application is written in C and also requires SDL. It has been tested on Slackware Linux. A screenshot can be seen [here](screenshots/jab_normalmap.png).

- [cglighting](https://github.com/joshb/cglighting)

  An OpenGL application written in C that demonstrates the use of pixel shaders written in Cg. This demo was written for the [Cg Pixel Shaders in OpenGL](/articles/cg_pixel_shaders_in_opengl/) article.

- [dynamiclightmaps](https://github.com/joshb/dynamiclightmaps)

  An OpenGL application written in C that demonstrates dynamic lightmaps. This demo was written for the [Dynamic Lightmaps in OpenGL](/articles/dynamic_lightmaps_in_opengl/) article.

- [jab_lighting](https://github.com/joshb/jab_lighting)

  An OpenGL demo featuring dynamic lighting and shadows. The lighting is achieved by multitexturing surfaces with dynamic lightmaps. The shadows are created with stenciled shadow volumes, projected from a model in the middle of the scene. Models can be loaded from md2 files, which are used by Quake II (this demo doesn't include any md2 files, but it can run without any and will just display dynamic lighting). This program requires GLUT. It has been tested on Slackware Linux and OpenBSD. A screenshot with one of the standard Quake II models can be seen [here](screenshots/jab_lighting.jpg).

- [jabheightmap](https://github.com/joshb/jabheightmap)

  A small OpenGL demo featuring a world created with a PNG heightmap. Requires X11/GLX, libGLU, and libpng in addition to OpenGL. A screenshot can be seen [here](screenshots/jabheightmap.jpg).

- [mbox2eml.pl](mbox2eml.pl) (July 14, 2009)

  A small Perl script that creates individual .eml files for each email message stored in an mbox file.
