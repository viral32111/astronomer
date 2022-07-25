#!/bin/sh

# docker cp astronomer:/usr/include/gtk-4.0 include/gtk
# docker cp astronomer:/usr/include/glib-2.0 include/glib
# docker cp astronomer:/usr/lib/x86_64-linux-gnu/glib-2.0/include/glibconfig.h include/glibconfig.h
# docker cp astronomer:/usr/include/cairo include/cairo
# docker cp astronomer:/usr/include/pango-1.0 include/pango
# docker cp astronomer:/usr/include/harfbuzz include/harfbuzz
# docker cp astronomer:/usr/include/gdk-pixbuf-2.0 include/gdk-pixbuf
# docker cp astronomer:/usr/include/graphene-1.0 include/graphene
# docker cp astronomer:/usr/lib/x86_64-linux-gnu/graphene-1.0/include/graphene-config.h include/graphene-config.h

docker run \
	--name astronomer \
	--mount type=bind,source=/tmp/.X11-unix,target=/tmp/.X11-unix \
	--mount type=bind,source=$HOME/.Xauthority,target=/home/user/.Xauthority \
	--mount type=bind,source=$PWD/source,target=/home/user/source,readonly \
	--network host \
	--env XAUTHORITY=/home/user/.Xauthority \
	--env DISPLAY=$DISPLAY \
	--device /dev/dri/renderD128 \
	--device /dev/dri/card0 \
	--interactive \
	--tty \
	--rm \
	--entrypoint bash \
	viral32111/astronomer:latest -c 'gcc $( pkg-config --cflags gtk4 ) -o /tmp/astronomer source/main.c $( pkg-config --libs gtk4 ) && /tmp/astronomer'
