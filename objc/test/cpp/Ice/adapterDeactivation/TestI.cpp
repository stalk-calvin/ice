// **********************************************************************
//
// Copyright (c) 2003-2011 ZeroC, Inc. All rights reserved.
//
// This copy of Ice is licensed to you under the terms described in the
// ICE_TOUCH_LICENSE file included in this distribution.
//
// **********************************************************************

#include <IceUtil/IceUtil.h>
#include <Ice/Ice.h>
#include <adapterDeactivation/TestI.h>

using namespace std;
using namespace Ice;
using namespace Test::AdapterDeactivation;

void
TestI::transient(const Current& current)
{
    CommunicatorPtr communicator = current.adapter->getCommunicator();
    ObjectAdapterPtr adapter =
    communicator->createObjectAdapterWithEndpoints("TransientTestAdapter", "default -p 9999");
    adapter->activate();
    adapter->destroy();
}

void
TestI::deactivate(const Current& current)
{
    current.adapter->deactivate();
    IceUtil::ThreadControl::sleep(IceUtil::Time::seconds(1));
}

string
CookieI::message() const
{
    return "blahblah";
}
