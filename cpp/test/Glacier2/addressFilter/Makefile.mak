# **********************************************************************
#
# Copyright (c) 2003-2006 ZeroC, Inc. All rights reserved.
#
# This copy of Ice is licensed to you under the terms described in the
# ICE_LICENSE file included in this distribution.
#
# **********************************************************************

top_srcdir	= ..\..\..

CLIENT		= client.exe
SERVER		= server.exe

TARGETS		= $(CLIENT) $(SERVER)

OBJS		= Backend.o \
		  BackendI.o

COBJS		= Client.o

SOBJS		= Server.o

SRCS		= $(OBJS:.o=.cpp) \
		  $(COBJS:.o=.cpp) \
		  $(SOBJS:.o=.cpp)

!include $(top_srcdir)/config/Make.rules.mak

CPPFLAGS	= -I. -I../../include $(CPPFLAGS)

$(CLIENT): $(OBJS) $(COBJS)
	del /q $@
	$(LINK) $(LD_EXEFLAGS) $(OBJS) $(COBJS), $@,, $(LIBS) glacier2$(LIBSUFFIX).lib

$(SERVER): $(OBJS) $(SOBJS)
	del /q $@
	$(LINK) $(LD_EXEFLAGS) $(OBJS) $(SOBJS), $@,, $(LIBS)

Backend.cpp Backend.h: Backend.ice $(SLICE2CPP) $(SLICEPARSERLIB)
	$(SLICE2CPP) $(SLICE2CPPFLAGS) Backend.ice

clean::
	del /q Backend.cpp Backend.h

!include .depend
