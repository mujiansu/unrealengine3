#!/binb/wmake.exe
#
# File:		makefile.wat
# Author:	Julian Smart
# Created:	1998
#
# Makefile : Builds JPEG library for Watcom C++, WIN32

WXDIR = ..\..
EXTRACPPFLAGS=-i=..\zlib

!include $(WXDIR)\src\makewat.env

WXLIB = $(WXDIR)\lib

LIBTARGET   = $(WXLIB)\jpeg.lib

SYSDEPMEM= jmemnobs.obj

# source files: JPEG library proper
LIBSOURCES= jcapimin.c jcapistd.c jccoefct.c jccolor.c jcdctmgr.c jchuff.c &
        jcinit.c jcmainct.c jcmarker.c jcmaster.c jcomapi.c jcparam.c &
        jcphuff.c jcprepct.c jcsample.c jctrans.c jdapimin.c jdapistd.c &
        jdatadst.c jdatasrc.c jdcoefct.c jdcolor.c jddctmgr.c jdhuff.c &
        jdinput.c jdmainct.c jdmarker.c jdmaster.c jdmerge.c jdphuff.c &
        jdpostct.c jdsample.c jdtrans.c jerror.c jfdctflt.c jfdctfst.c &
        jfdctint.c jidctflt.c jidctfst.c jidctint.c jidctred.c jquant1.c &
        jquant2.c jutils.c jmemmgr.c
# memmgr back ends: compile only one of these into a working library
SYSDEPSOURCES= jmemansi.c jmemname.c jmemnobs.c jmemdos.c jmemmac.c
# source files: cjpeg/djpeg/jpegtran applications, also rdjpgcom/wrjpgcom
APPSOURCES= cjpeg.c djpeg.c jpegtran.c rdjpgcom.c wrjpgcom.c cdjpeg.c &
        rdcolmap.c rdswitch.c transupp.c rdppm.c wrppm.c rdgif.c wrgif.c &
        rdtarga.c wrtarga.c rdbmp.c wrbmp.c rdrle.c wrrle.c
SOURCES= $(LIBSOURCES) $(SYSDEPSOURCES) $(APPSOURCES)
# files included by source files
INCLUDES= jchuff.h jdhuff.h jdct.h jerror.h jinclude.h jmemsys.h jmorecfg.h &
        jpegint.h jpeglib.h jversion.h cdjpeg.h cderror.h transupp.h
# documentation, test, and support files
DOCS= README install.doc usage.doc cjpeg.1 djpeg.1 jpegtran.1 rdjpgcom.1 &
        wrjpgcom.1 wizard.doc example.c libjpeg.doc structure.doc &
        coderules.doc filelist.doc change.log
MKFILES= configure makefile.cfg makefile.ansi makefile.unix makefile.bcc &
        makefile.mc6 makefile.dj makefile.wat makefile.vc makelib.ds &
        makeapps.ds makeproj.mac makcjpeg.st makdjpeg.st makljpeg.st &
        maktjpeg.st makefile.manx makefile.sas makefile.mms makefile.vms &
        makvms.opt
CONFIGFILES= jconfig.cfg jconfig.bcc jconfig.mc6 jconfig.dj jconfig.wat &
        jconfig.vc jconfig.mac jconfig.st jconfig.manx jconfig.sas &
        jconfig.vms
CONFIGUREFILES= config.guess config.sub install-sh ltconfig ltmain.sh
OTHERFILES= jconfig.doc ckconfig.c ansi2knr.c ansi2knr.1 jmemdosa.asm
TESTFILES= testorig.jpg testimg.ppm testimg.bmp testimg.jpg testprog.jpg &
        testimgp.jpg
DISTFILES= $(DOCS) $(MKFILES) $(CONFIGFILES) $(SOURCES) $(INCLUDES) &
        $(CONFIGUREFILES) $(OTHERFILES) $(TESTFILES)
# library object files common to compression and decompression
COMOBJECTS= jcomapi.obj jutils.obj jerror.obj jmemmgr.obj $(SYSDEPMEM)
# compression library object files
CLIBOBJECTS= jcapimin.obj jcapistd.obj jctrans.obj jcparam.obj jdatadst.obj &
        jcinit.obj jcmaster.obj jcmarker.obj jcmainct.obj jcprepct.obj &
        jccoefct.obj jccolor.obj jcsample.obj jchuff.obj jcphuff.obj &
        jcdctmgr.obj jfdctfst.obj jfdctflt.obj jfdctint.obj
# decompression library object files
DLIBOBJECTS= jdapimin.obj jdapistd.obj jdtrans.obj jdatasrc.obj &
        jdmaster.obj jdinput.obj jdmarker.obj jdhuff.obj jdphuff.obj &
        jdmainct.obj jdcoefct.obj jdpostct.obj jddctmgr.obj jidctfst.obj &
        jidctflt.obj jidctint.obj jidctred.obj jdsample.obj jdcolor.obj &
        jquant1.obj jquant2.obj jdmerge.obj
# These objectfiles are included in libjpeg.lib
OBJECTS= $(CLIBOBJECTS) $(DLIBOBJECTS) $(COMOBJECTS)
# object files for sample applications (excluding library files)
COBJECTS= cjpeg.obj rdppm.obj rdgif.obj rdtarga.obj rdrle.obj rdbmp.obj &
        rdswitch.obj cdjpeg.obj
DOBJECTS= djpeg.obj wrppm.obj wrgif.obj wrtarga.obj wrrle.obj wrbmp.obj &
        rdcolmap.obj cdjpeg.obj
TROBJECTS= jpegtran.obj rdswitch.obj cdjpeg.obj transupp.obj
all:        $(OBJECTS) $(LIBTARGET)

$(LIBTARGET) : $(OBJECTS)
    %create tmp.lbc
    @for %i in ( $(OBJECTS) ) do @%append tmp.lbc +%i
    wlib /b /c /n /p=512 $^@ @tmp.lbc

clean:   .SYMBOLIC
    -erase *.obj
    -erase $(LIBTARGET)
    -erase *.pch
    -erase *.err
    -erase *.lbc

cleanall:   clean

