// **********************************************************************
//
// Copyright (c) 2003-2013 ZeroC, Inc. All rights reserved.
//
// This copy of Ice is licensed to you under the terms described in the
// ICE_LICENSE file included in this distribution.
//
// **********************************************************************

//
// Ice.EnumBase
//
var EnumBase = function(name, value)
{
    this._name = name;
    this._value = value;
}

Object.defineProperty(EnumBase.prototype, 'name', {
    enumerable: true,
    get: function() { return this._name; }
});

Object.defineProperty(EnumBase.prototype, 'value', {
    enumerable: true,
    get: function() { return this._value; }
});

EnumBase.prototype.equals = function(rhs)
{
    if(this === rhs)
    {
        return true;
    }

    var proto = Object.getPrototypeOf(this);
    if(!(rhs instanceof proto.constructor))
    {
        return false;
    }

    return this._value == rhs._value;
}

EnumBase.prototype.hashCode = function()
{
    return this._value;
}

EnumBase.prototype.toString = function()
{
    return this._name;
}

module.exports = EnumBase;
