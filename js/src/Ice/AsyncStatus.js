// **********************************************************************
//
// Copyright (c) 2003-2013 ZeroC, Inc. All rights reserved.
//
// This copy of Ice is licensed to you under the terms described in the
// ICE_LICENSE file included in this distribution.
//
// **********************************************************************

(function(module, name){
    var __m = function(module, exports, require){
        var AsyncStatus = {};

        AsyncStatus.Queued = 0;
        AsyncStatus.Sent = 1;
        AsyncStatus.InvokeSentCallback = 2;

        module.exports.Ice = module.exports.Ice || {};
        module.exports.Ice.AsyncStatus = AsyncStatus;
    };
    return (module === undefined) ? this.Ice.__defineModule(__m, name) : __m(module, module.exports, module.require);
}(typeof module !== "undefined" ? module : undefined, "Ice/AsyncStatus"));
