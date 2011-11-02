// **********************************************************************
//
// Copyright (c) 2003-2011 ZeroC, Inc. All rights reserved.
//
// This copy of Ice is licensed to you under the terms described in the
// ICE_TOUCH_LICENSE file included in this distribution.
//
// **********************************************************************

#include <Ice/Application.h>
#include <TestCommon.h>
#include <DefaultValueTest.h>

using namespace std;
using namespace Ice;
using namespace Test::DefaultValue;

#if TARGET_OS_IPHONE
#define main runDefaultValueClient
#endif

int
main(int argc, char* argv[])
{
    int status;
    
    try
    {
        void defaultValueAllTests();
        defaultValueAllTests();
        status = EXIT_SUCCESS;
    }
    catch(const Ice::Exception& ex)
    {
        ostringstream os;
        os << ex << endl;
        tprintf(os.str().c_str());
        status = EXIT_FAILURE;
    }
    catch(const TestFailedException&)
    {
        status = EXIT_FAILURE;
    }
    return status;
}
