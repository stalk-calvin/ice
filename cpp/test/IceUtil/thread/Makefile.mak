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

TARGETS		= $(CLIENT)

OBJS		= TestBase.o \
		  CreateTest.o \
		  AliveTest.o \
		  StartTest.o \
		  RWRecMutexTest.o \
		  RecMutexTest.o \
		  StaticMutexTest.o \
		  MutexTest.o \
		  MonitorMutexTest.o \
		  MonitorRecMutexTest.o \
                  CountDownLatchTest.o \
		  TestSuite.o \
		  Client.o


SRCS		= $(OBJS:.o=.cpp)

!include $(top_srcdir)/config/Make.rules.mak

CPPFLAGS	= -I. -I../../include $(CPPFLAGS)

$(CLIENT): $(OBJS)
	del /q $@
	$(LINK) $(LD_EXEFLAGS) $(OBJS), $@,, $(BASELIBS)

!include .depend
