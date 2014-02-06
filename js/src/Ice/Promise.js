// **********************************************************************
//
// Copyright (c) 2003-2013 ZeroC, Inc. All rights reserved.
//
// This copy of Ice is licensed to you under the terms described in the
// ICE_LICENSE file included in this distribution.
//
// **********************************************************************

(function(global){
    require("Ice/Class");
    
    var Ice = global.Ice || {};
    
    //
    // Promise State
    //
    var State = {Pending: 0, Success: 1, Failed: 2};
    
    var resolveImp = function(self, listener)
    {
        var callback = self.__state === State.Success ? listener.onResponse : listener.onException;
        try
        {
            if(!(callback instanceof Function))
            {
                listener.promise.setState(self.__state, self._args);
            }
            else
            {
                var result = callback.apply(null, self._args);

                //
                // Callback can return a new promise.
                //
                if(result && result.then instanceof Function)
                {
                    result.then(
                        function()
                        {
                            var args = arguments;
                            listener.promise.succeed.apply(listener.promise, args);
                        },
                        function()
                        {
                            var args = arguments;
                            listener.promise.fail.apply(listener.promise, args);
                        });
                }
                else
                {
                    listener.promise.succeed(result);
                }
            }
        }
        catch(e)
        {
            listener.promise.fail.call(listener.promise, e);
        }
    };

    var Promise = Ice.Class({
        __init__: function()
        {
            this.__state = State.Pending;
            this.__listeners = [];
        },
        then: function(onResponse, onException)
        {
            var promise = new Promise();
            var self = this;
            //
            // Use setTimeout so the listeners are not resolved until the call stack is empty.
            //
            setTimeout(
                function()
                {
                    self.__listeners.push(
                        {
                            promise:promise,
                            onResponse:onResponse,
                            onException:onException
                        });
                    self.resolve();
                }, 0);
            return promise;
        },
        exception: function(onException)
        {
            return this.then(null, onException);
        },
        finally: function(cb)
        {
            var p = new Promise();
            var self = this;
            
            var finallyHandler = function(method)
            {
                return function()
                {
                    var args = arguments;
                    try
                    {
                        var result = cb.apply(null, args);
                        if(result && result.then instanceof Function)
                        {
                            var handler = function(){ method.apply(p, args); };
                            result.then(handler).exception(handler);
                        }
                        else
                        {
                            method.apply(p, args);
                        }
                    }
                    catch(e)
                    {
                        method.apply(p, args);
                    }
                };
            };
            
            setTimeout(
                function(){
                    self.then(finallyHandler(p.succeed), finallyHandler(p.fail));
                });
            return p;
        },
        resolve: function()
        {
            if(this.__state === State.Pending)
            {
                return;
            }

            var obj;
            while((obj = this.__listeners.pop()))
            {
                //
                // We use a separate function here to capture the listeners
                // in the loop.
                //
                resolveImp(this, obj);
            }
        },
        setState: function(state, args)
        {
            if(this.__state === State.Pending && state !== State.Pending)
            {
                this.__state = state;
                this._args = args;
                //
                // Use setTimeout so the listeners are not resolved until the call stack is empty.
                //
                var self = this;
                setTimeout(function(){ self.resolve(); }, 0);
            }
        },
        succeed: function()
        {
            var args = arguments;
            this.setState(State.Success, args);
            return this;
        },
        fail: function()
        {
            var args = arguments;
            this.setState(State.Failed, args);
            return this;
        },
        succeeded: function()
        {
            return this.__state === State.Success;
        },
        failed: function()
        {
            return this.__state === State.Failed;
        },
        completed: function()
        {
            return this.__state !== State.Pending;
        }
    });

    //
    // Create a new promise object that is fulfilled when all the promise arguments
    // are fulfilled or is rejected when one of the promises is rejected.
    //
    Promise.all = function()
    {
        var promise = new Promise();
        var promises = Array.prototype.slice.call(arguments);
        var results = new Array(arguments.length);

        var pending = promises.length;
        for(var i = 0; i < promises.length; ++i)
        {
            //
            // Create an anonymous function to capture the loop index
            //
            
            /*jshint -W083 */
            (function(j)
            {
                promises[j].then(
                    function()
                    {
                        results[j] = arguments;
                        pending--;
                        if(pending === 0)
                        {
                            promise.succeed.apply(promise, results);
                        }
                    },
                    function()
                    {
                        promise.fail.apply(promise, arguments);
                    });
            }(i));
            /*jshint +W083 */
        }
        return promise;
    };
    
    Promise.try = function(onResponse)
    {
        return new Promise().succeed().then(onResponse);
    };

    Ice.Promise = Promise;
    global.Ice = Ice;
}(typeof (global) === "undefined" ? window : global));
