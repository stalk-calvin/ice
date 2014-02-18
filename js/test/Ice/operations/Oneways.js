// **********************************************************************
//
// Copyright (c) 2003-2014 ZeroC, Inc. All rights reserved.
//
// This copy of Ice is licensed to you under the terms described in the
// ICE_LICENSE file included in this distribution.
//
// **********************************************************************

(function(global){
    var Ice = global.Ice;
    
    var run = function(communicator, prx, Test, bidir)
    {
        var p = new Ice.Promise();
        var test = function(b)
        {
            if(!b)
            {
                try
                {
                    throw new Error("test failed");
                }
                catch(err)
                {
                    p.fail(err);
                    throw err;
                }
            }
        };
        
        Ice.Promise.try(
            function()
            {
                prx = prx.ice_oneway();
                return prx.ice_ping();
            }
        ).then(
            function()
            {
                try
                {
                    prx.ice_isA(Test.MyClass.ice_staticId());
                    test(false);
                }
                catch(ex)
                {
                    // Expected: twoway proxy required
                }
                try
                {
                    prx.ice_id();
                    test(false);
                }
                catch(ex)
                {
                    // Expected: twoway proxy required
                }
                try
                {
                    prx.ice_ids();
                    test(false);
                }
                catch(ex)
                {
                    // Expected: twoway proxy required
                }
                
                return prx.opVoid();
            }
        ).then(
            function()
            {
                return prx.opIdempotent();
            }
        ).then(
            function()
            {
                return prx.opNonmutating();
            }
        ).then(
            function()
            {
                try
                {
                    prx.opByte(0xff, 0x0f);
                    test(false);
                }
                catch(ex)
                {
                    // Expected: twoway proxy required
                }
            }
        ).then(
            function()
            {
                p.succeed();
            },
            function(ex)
            {
                p.fail(ex);
            });
        return p;
    };

    global.Oneways = { run: run };
}(typeof (global) === "undefined" ? window : global));
