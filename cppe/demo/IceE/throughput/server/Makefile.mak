# **********************************************************************
#
# Copyright (c) 2003-2008 ZeroC, Inc. All rights reserved.
#
# This copy of Ice-E is licensed to you under the terms described in the
# ICEE_LICENSE file included in this distribution.
#
# **********************************************************************

top_srcdir	= ..\..\..\..

SERVER		= server.exe

TARGETS		= $(SERVER)

OBJS		= Throughput.obj \
		  ThroughputI.obj

!include $(top_srcdir)/config/Make.rules.mak

!if "$(WINDOWS_MOBILE_SDK)" != ""
SOBJS           = WinCEServer.obj
!else
SOBJS           = Server.obj
!endif

SRCS		= $(OBJS:.obj=.cpp) \
		  $(SOBJS:.obj=.cpp)

CPPFLAGS	= -I. $(CPPFLAGS) -WX -DWIN32_LEAN_AND_MEAN

!if "$(OPTIMIZE_SPEED)" != "yes" && "$(OPTIMIZE_SIZE)" != "yes"
PDBFLAGS        = /pdb:$(SERVER:.exe=.pdb)
!endif

$(SERVER): $(OBJS) $(SOBJS)
	$(LINK) $(LDFLAGS) $(PDBFLAGS) $(OBJS) $(SOBJS) /out:$@ $(LIBS)
	@if exist $@.manifest echo ^ ^ ^ Embedding manifest using $(MT) && \
	    $(MT) -nologo -manifest $@.manifest -outputresource:$@;#2 && del /q $@.manifest

clean::
	del /q Throughput.cpp Throughput.h

!include .depend
