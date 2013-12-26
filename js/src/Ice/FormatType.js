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
        var EnumBase = require("Ice/EnumBase").Ice.EnumBase;

        var FormatType = function(_n, _v)
        {
            EnumBase.call(this, _n, _v);
        };

        FormatType.prototype = new EnumBase();
        FormatType.prototype.constructor = FormatType;

        EnumBase.defineEnum(FormatType, {'DefaultFormat':0, 'CompactFormat':1, 'SlicedFormat':2});

        module.exports.Ice = module.exports.Ice || {};
        module.exports.Ice.FormatType = FormatType;
    };
    return (module === undefined) ? this.Ice.__defineModule(__m, name) : __m(module, module.exports, module.require);
}(typeof module !== "undefined" ? module : undefined, "Ice/FormatType"));
