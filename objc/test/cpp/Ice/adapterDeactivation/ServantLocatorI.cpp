// **********************************************************************
//
// Copyright (c) 2003-2011 ZeroC, Inc. All rights reserved.
//
// This copy of Ice is licensed to you under the terms described in the
// ICE_TOUCH_LICENSE file included in this distribution.
//
// **********************************************************************

#include <adapterDeactivation/ServantLocatorI.h>
#include <TestCommon.h>
#include <adapterDeactivation/TestI.h>

using namespace std;
using namespace Ice;
using namespace Test::AdapterDeactivation;

ServantLocatorI::ServantLocatorI() :
_deactivated(false)
{
}

ServantLocatorI::~ServantLocatorI()
{
    test(_deactivated);
}

Ice::ObjectPtr
ServantLocatorI::locate(const Ice::Current& current, Ice::LocalObjectPtr& cookie)
{
    test(!_deactivated);
    
    test(current.id.category == "");
    test(current.id.name == "test");
    
    cookie = new CookieI;
    
    return new TestI;
}

void
ServantLocatorI::finished(const Ice::Current& current, const Ice::ObjectPtr& servant,
                          const Ice::LocalObjectPtr& cookie)
{
    test(!_deactivated);
    
    CookiePtr co = CookiePtr::dynamicCast(cookie);
    test(co);
    test(co->message() == "blahblah");
}

void
ServantLocatorI::deactivate(const string&)
{
    test(!_deactivated);
    
    _deactivated = true;
}
