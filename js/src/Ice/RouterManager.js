// **********************************************************************
//
// Copyright (c) 2003-2013 ZeroC, Inc. All rights reserved.
//
// This copy of Ice is licensed to you under the terms described in the
// ICE_LICENSE file included in this distribution.
//
// **********************************************************************

(function(module, name){
    var __m = function(global, module, exports, require){
        
        require("Ice/HashMap");
        require("Ice/RouterInfo");
        require("Ice/Router");
        
        var Ice = global.Ice || {};
        
        var HashMap = Ice.HashMap;
        var RouterInfo = Ice.RouterInfo;
        var RouterPrx = Ice.RouterPrx;

        var RouterManager = function()
        {
            this._table = new HashMap(); // Map<Ice.RouterPrx, RouterInfo>
            this._table.keyComparator = HashMap.compareEquals;
        };

        RouterManager.prototype.destroy = function()
        {
            for(var e = this._table.entries; e !== null; e = e.next)
            {
                e.value.destroy();
            }
            this._table.clear();
        };

        //
        // Returns router info for a given router. Automatically creates
        // the router info if it doesn't exist yet.
        //
        RouterManager.prototype.find = function(rtr)
        {
            if(rtr === null)
            {
                return null;
            }

            //
            // The router cannot be routed.
            //
            var router = RouterPrx.uncheckedCast(rtr.ice_router(null));

            var info = this._table.get(router);
            if(info === undefined)
            {
                info = new RouterInfo(router);
                this._table.set(router, info);
            }

            return info;
        };

        RouterManager.prototype.erase = function(rtr)
        {
            var info = null;
            if(rtr !== null)
            {
                // The router cannot be routed.
                var router = RouterPrx.uncheckedCast(rtr.ice_router(null));

                info = this._table.get(router);
                this._table.delete(router);
            }
            return info;
        };

        Ice.RouterManager = RouterManager;
        global.Ice = Ice;
    };
    return (module === undefined) ? this.Ice.__defineModule(__m, name) : 
                                    __m(global, module, module.exports, module.require);
}(typeof module !== "undefined" ? module : undefined, "Ice/RouterManager"));
