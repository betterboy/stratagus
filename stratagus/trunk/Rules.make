##   ___________		     _________		      _____  __
##   \_	  _____/______   ____   ____ \_   ___ \____________ _/ ____\/  |_
##    |    __) \_  __ \_/ __ \_/ __ \/    \  \/\_  __ \__  \\   __\\   __\ 
##    |     \   |  | \/\  ___/\  ___/\     \____|  | \// __ \|  |   |  |
##    \___  /   |__|    \___  >\___  >\______  /|__|  (____  /__|   |__|
##	  \/		    \/	   \/	     \/		   \/
##  ______________________                           ______________________
##			  T H E   W A R   B E G I N S
##	   FreeCraft - A free fantasy real time strategy game engine
##
##	Rules.make	-	Make RULES (GNU MAKE) (included from Makefile).
##
##	(c) Copyright 1998-2001 by Lutz Sammer
##
##	FreeCraft is free software; you can redistribute it and/or modify
##	it under the terms of the GNU General Public License as published
##	by the Free Software Foundation; either version 2 of the License,
##	or (at your option) any later version.
##
##	FreeCraft is distributed in the hope that it will be useful,
##	but WITHOUT ANY WARRANTY; without even the implied warranty of
##	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
##	GNU General Public License for more details.
##
##	$Id$
##

############################################################################
#	Configurable:
#			Choose what you want to include and the correct
#			version.  Minimal is now the default.
############################################################################

#------------------------------------------------------------------------------
# Uncomment next to add threaded sound support
#	You should have a thread safe X11 (libc6 or glibc)
#	Any modern linux distribution are thread safe.
#	Don't enable, if you use SDL sound support.

#THREAD		= -D_REENTRANT -DUSE_THREAD
#THREADLIB	= -lpthread

#------------------------------------------------------------------------------
#	Video driver part
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
# SDL - Simple DirectMedia Layer configuration (any >=1.0.0)

SDL_CFLAGS	= $(shell sdl-config --cflags)
SDLLIB		= $(shell sdl-config --static-libs)
#SDLLIB		= $(shell sdl-config --libs)

# Without SDL Sound (only not win32)
#SDL		= -DUSE_SDL $(SDL_CFLAGS)
# With SDL Sound
SDL		= -DUSE_SDL -DUSE_SDLA $(SDL_CFLAGS)

#------------------------------------------------------------------------------
# Uncomment the next for the normal X11 support.

VIDEO		= -DUSE_X11
VIDEOLIB	= -lXext -lX11 -ldl

#------------------------------------------------------------------------------
# Uncomment th next to get svgalib support.

#VIDEO		= -DUSE_SVGALIB
#VIDEOLIB	= -lvga -lm -ldl

#------------------------------------------------------------------------------
# Uncomment one of the next for the SDL support.

# Uncomment the next for the generic SDL support.

#VIDEO		= $(SDL)
#VIDEOLIB	= $(SDLLIB)

# Uncomment the next for the SDL X11/SVGALIB support.
#	(sdl-config --static-libs didn't work correct.)

VIDEO		= $(SDL)
VIDEOLIB	= $(SDLLIB) -lXext -lX11 -lXxf86dga -lXxf86vm -lvga -lvgagl -ldl -lesd -lm -lslang -lgpm

# Uncomment the next for the win32/cygwin support. (not working?)

#VIDEO		= -DUSE_WIN32 $(SDL)
#VIDEOLIB	= $(SDLLIB)

# Uncomment the next for the win32/mingw32 support.

#VIDEO		= -DUSE_WIN32 $(SDL)
#VIDEOLIB	= $(SDLLIB) -lwsock32 -Wl,--stack,33554432

# Uncomment the next for the BeOS SDL support.

#VIDEO		= -DUSE_BEOS $(SDL)
#VIDEOLIB	= $(SDLLIB)

#------------------------------------------------------------------------------
#	Sound driver part
#------------------------------------------------------------------------------

# See above the USE_SDLA option.

# Comment next if you want to remove sound support.

DSOUND		= -DWITH_SOUND

#------------------------------------------------------------------------------
#	File I/O part
#------------------------------------------------------------------------------

# Choose which compress you like
#	The win32 port didn't support BZ2LIB

# None
#ZDEFS		=
#ZLIBS		=
# GZ compression
ZDEFS		= -DUSE_ZLIB
ZLIBS		= -lz
# BZ2 compression
#ZDEFS		= -DUSE_BZ2LIB
#ZLIBS		= -lbz2
# GZ + BZ2 compression
ZDEFS		= -DUSE_ZLIB -DUSE_BZ2LIB
ZLIBS		= -lz -lbz2

#------------------------------------------------------------------------------

# May be required on some distributions for libpng and libz!
# extra linker flags and include directory
# -L/usr/lib

XLDFLAGS	= -L/usr/X11R6/lib -L/usr/local/lib \
		  -L$(TOPDIR)/libpng-1.0.5 -L$(TOPDIR)/zlib-1.1.3
XIFLAGS		= -I/usr/X11R6/include -I/usr/local/include \
		  -I$(TOPDIR)/libpng-1.0.5 -I$(TOPDIR)/zlib-1.1.3

#------------------------------------------------------------------------------
#	Support for SIOD (scheme interpreter)
#	C C L	-	Craft Configuration Language

CCL	= -DUSE_CCL
CCLLIB	= -lm

#------------------------------------------------------------------------------

# Uncomment next to profile
#PROFILE=	-pg

# Compile Version
VERSION=	'-DVERSION="1.17pre1-build14"'

############################################################################
# below this, nothing should be changed!

# Libraries needed to build tools
TOOLLIBS=$(XLDFLAGS) -lpng -lz -lm $(THREADLIB)

# Libraries needed to build freecraft
CLONELIBS=$(XLDFLAGS) -lpng -lz -lm \
	$(THREADLIB) $(CCLLIB) $(VIDEOLIB) $(ZLIBS)

DISTLIST=$(TOPDIR)/distlist
TAGS=$(TOPDIR)/src/tags

# LINUX
OUTFILE=$(TOPDIR)/freecraft
ARCH=linux
OE=o
EXE=

# WIN32
#OUTFILE=$(TOPDIR)/freecraft$(EXE)
#ARCH=win32
#OE=o
#EXE=.exe

## architecture-dependant objects
#ARCHOBJS=stdmman.$(OE) svgalib.$(OE) unix_lib.$(OE) bitm_lnx.$(OE)

## include flags
IFLAGS=	-I$(TOPDIR)/src/include $(XIFLAGS)
## define flags
DEBUG=	-DDEBUG -DREFS_DEBUG # -DFLAG_DEBUG
##
## There are some still not well tested code parts or branches.
## UNITS_ON_MAP:	Faster lookup of units
## NEW_MAPDRAW:		Stephans new map draw code
## NEW_NAMES:		New unit names without copyleft problems
## NEW_AI:		New better improved AI code
## This aren't working:
## NEW_FOW:		New fog of war code, should work correct
## NEW_SHIPS:		New correct ship movement.
## NEW_NETMENUS:	Include new network menues.
DFLAGS=	$(THREAD) $(CCL) $(VERSION) $(VIDEO) $(ZDEFS) $(DSOUND) $(DEBUG) \
	-DHAVE_EXPANSION -DUNIT_ON_MAP -DNEW_AI -DNEW_NAMES -D_NEW_NETMENUS -DBPP8_IRGB # -DNEW_MAPDRAW=1 -DNEW_FOW -DNEW_SHIPS

## choose optimise level
#CFLAGS=-g -O0 $(PROFILE) -pipe -Wcast-align -Wall -Werror $(IFLAGS) $(DFLAGS)
#CFLAGS=-g -O1 $(PROFILE) -pipe -Wcast-align -Wall -Werror $(IFLAGS) $(DFLAGS)
#CFLAGS=-g -O2 $(PROFILE) -pipe -Wcast-align -Wall -Werror $(IFLAGS)  $(DFLAGS)
CFLAGS=-g -O3 $(PROFILE) -pipe -Wcast-align -Wall -Werror $(IFLAGS)  $(DFLAGS)
#CFLAGS=-g -O3 $(PROFILE) -pipe -Wcast-align -Wall $(IFLAGS)  $(DFLAGS)
#CFLAGS=-g -O6 -pipe -fconserve-space -fexpensive-optimizations -ffast-math  $(IFLAGS) $(DFLAGS)
#-- Production
#CFLAGS=-O6 -pipe -fomit-frame-pointer -fconserve-space -fexpensive-optimizations -ffast-math  $(IFLAGS) $(DFLAGS)
#CFLAGS=-O6 -pipe -fomit-frame-pointer -fconserve-space -fexpensive-optimizations -ffast-math  $(IFLAGS) $(DFLAGS) -static

CC=cc
RM=rm -f
MAKE=make

# TAGS 5.0
CTAGSFLAGS=--c-types=defmpstuvx -a -f
#CTAGSFLAGS=-i defmpstuvFS -a -f
#CTAGSFLAGS=-i defptvS -a -f

#
#	Locks versions with symbolic name
#
LOCKVER=	rcs -q -n$(NAME)

%.o: %.c
	$(CC) -c $(CFLAGS) $< -o $@
	@ar cru $(TOPDIR)/src/libclone.a $@

#------------
#	Source code documentation
#
DOXYGEN=	doxygen
DOCIFY=		docify
DOCPP=		doc++
# Still didn't work
#DOCIFY=		/root/doc++-3.4.2/src/docify
#DOCPP=		/root/doc++-3.4.2/src/doc++

%.doc: %.c
	@$(TOPDIR)/tools/aledoc $< | $(DOCIFY) > $*-c.doc 2>/dev/null

%.doc: %.h
	@$(TOPDIR)/tools/aledoc $< | $(DOCIFY) > $*-h.doc 2>/dev/null
