// **********************************************************************
//
// Copyright (c) 2003-2011 ZeroC, Inc. All rights reserved.
//
// This copy of Ice Touch is licensed to you under the terms described in the
// ICE_TOUCH_LICENSE file included in this distribution.
//
// **********************************************************************

#ifndef TEST_ICE
#define TEST_ICE

#include <Ice/BuiltinSequences.ice>

module Test
{

module Dispatcher
{

interface TestIntf
{
    void op();
    void opWithPayload(Ice::ByteSeq seq);
    void shutdown();
};

interface TestIntfController
{
    void holdAdapter();
    void resumeAdapter();
};

};

};

#endif
