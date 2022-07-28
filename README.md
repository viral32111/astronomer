# Astronomer

This is a [GTK 4](https://docs.gtk.org/gtk4/index.html) application for Linux that uses [NASA's APIs](https://api.nasa.gov/index.html) to fetch and display real-time data.

The current plan is to implement the Astronomy Picture of the Day, the International Space Station's position, and Landsat imagery.

## Background

This project represents my first time creating GUI applications on Linux, previously all my GUI work has been on Windows in C# using the .NET Framework, or in C++ using various GUI libraries such as SFML. As mentioned, this is made using GTK, but I would like to try out Qt at some point in the future for another project as it is cross-platform.

## Developing

### Dependencies

The following libraries are required to develop and build the application:

* GTK
  * Glib
  * Cairo
  * GDK Pixbuf
  * Harfbuzz
  * Pango
  * Graphene
* cURL

### Building

Use the [`build.bash`](/build.bash) script to build and run the application within an isolated Docker environment.

The image in the [`dockerfile`](/dockerfile) can be built using the same script.

## License

Copyright (C) 2022 [viral32111](https://viral32111.com).

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU Affero General Public License as
published by the Free Software Foundation, either version 3 of the
License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU Affero General Public License for more details.

You should have received a copy of the GNU Affero General Public License
along with this program. If not, see https://www.gnu.org/licenses.
