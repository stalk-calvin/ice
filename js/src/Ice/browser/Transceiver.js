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
    require("Ice/Debug");
    require("Ice/ExUtil");
    require("Ice/Network");
    require("Ice/SocketOperation");
    require("Ice/Connection");
    require("Ice/Exception");
    require("Ice/LocalException");
    
    require("Ice/browser/ConnectionInfo");
    
    var Ice = global.Ice || {};
    var IceWS = global.IceWS || {};
    
    var Debug = Ice.Debug;
    var ExUtil = Ice.ExUtil;
    var Network = Ice.Network;
    var SocketOperation = Ice.SocketOperation;
    var Conn = Ice.Connection;
    var LocalException = Ice.LocalException;
    var SocketException = Ice.SocketException;

    var StateNeedConnect = 0;
    var StateConnectPending = 1;
    var StateConnected = 2;
    var StateClosed = 3;
    var StateError = 4;

    var Transceiver = Ice.Class({
        __init__: function(instance)
        {
            this._traceLevels = instance.traceLevels();
            this._logger = instance.initializationData().logger;
            this._readBuffers = [];
            this._readPosition = 0;
        },
        setCallbacks: function(
            connectedCallback,      // function(event)
            bytesAvailableCallback, // function(event)
            bytesWrittenCallback,   // function(event)
            closedCallback,         // function(event)
            errorCallback           // function(event)
        )
        {
            this._connectedCallback = connectedCallback;
            this._bytesAvailableCallback = bytesAvailableCallback;
            this._bytesWrittenCallback = bytesWrittenCallback;
            this._closedCallback = closedCallback;
            this._errorCallback = errorCallback;
        },
        //
        // Returns SocketOperation.None when initialization is complete.
        //
        initialize: function(readBuffer, writeBuffer)
        {
            try
            {
                if(this._state === StateNeedConnect)
                {
                    this._state = StateConnectPending;
                    this._fd = new WebSocket(this._url, "ice.zeroc.com");
                    this._fd.binaryType = "arraybuffer";
                    var self = this;
                    this._fd.onopen = function(e){ 
                        self.socketConnected(e); };
                    this._fd.onmessage = function(e) { 
                        self.socketBytesAvailable(e.data); 
                    };
                    this._fd.onclose = function(e){
                        self.socketClosed(e); };
                    return SocketOperation.Connect; // Waiting for connect to complete.
                }
                else if(this._state === StateConnectPending)
                {
                    //
                    // Socket is connected.
                    //
                    this._desc = fdToString(this._addr);
                    this._state = StateConnected;
                }
            }
            catch(err)
            {
                var ex = translateError(this._state, err);
                this._state = StateError;
                if(ex instanceof LocalException)
                {
                    if(this._traceLevels.network >= 2)
                    {
                        var s = [];
                        s.push("failed to establish " + this.type() + " connection\n");
                        s.push(fdToString(this._addr));
                        this._logger.trace(this._traceLevels.networkCat, s.join(""));
                    }
                }
                throw ex;
            }

            Debug.assert(this._state === StateConnected);
            if(this._traceLevels.network >= 1)
            {
                var s = this.type() + " connection established\n" + this._desc;
                this._logger.trace(this._traceLevels.networkCat, s);
            }

            return SocketOperation.None;
        },
        register: function()
        {
            //
            // Register the socket data listener.
            //
            this._registered = true;
            if(this._hasBytesAvailable)
            {
                this._bytesAvailableCallback();
                this._hasBytesAvailable = false;
            }
        },
        unregister: function()
        {
            //
            // Unregister the socket data listener.
            //
            this._registered = false;
        },
        close: function()
        {
            if(this._state < StateClosed)
            {
                if(this._connected && this._traceLevels.network >= 1)
                {
                    this._logger.trace(this._traceLevels.networkCat, "closing " + this.type() + " connection\n" + this._desc);
                }
                Debug.assert(this._fd !== null);
                try
                {
                    if(this._fd.readyState <= WebSocket.OPEN)
                    {
                        this._fd.close();
                    }
                }
                catch(ex)
                {
                    throw translateError(ex);
                }
                finally
                {
                    this._fd = null;
                }
            }
        },
        //
        // Returns true if all of the data was flushed to the kernel buffer.
        //
        write: function(byteBuffer)
        {
            var remaining = byteBuffer.remaining;
            Debug.assert(remaining > 0);

            //
            // Create a slice of the source buffer representing the remaining data to be written.
            //
            var slice = byteBuffer.b.slice(byteBuffer.position, byteBuffer.position + remaining);

            //
            // The socket will accept all of the data.
            //
            byteBuffer.position = byteBuffer.position + remaining;

            if(this._fd.bufferedAmount === 0)
            {
                this._fd.send(slice);
                return true;
            }
            else
            {
                var self = this;
                var writtenCB = function()
                {
                    setTimeout(
                        function()
                        {
                            if(self._fd.bufferedAmount === 0)
                            {
                                self._bytesWrittenCallback();
                            }
                            else
                            {
                                writtenCB();
                            }
                        }, 50);
                };
                return false;
            }
        },
        read: function(byteBuffer, moreData)
        {
            moreData.value = false;

            if(this._readBuffers.length === 0)
            {
                return false; // No data available.
            }

            var avail = this._readBuffers[0].byteLength - this._readPosition;
            Debug.assert(avail > 0);
            var remaining = byteBuffer.remaining;

            while(byteBuffer.remaining > 0)
            {
                if(avail > byteBuffer.remaining)
                {
                    avail = byteBuffer.remaining;
                }
                
                new Uint8Array(byteBuffer.b).set(new Uint8Array(this._readBuffers[0], this._readPosition, avail), byteBuffer.position);
                
                byteBuffer.position += avail;
                this._readPosition += avail;
                if(this._readPosition === this._readBuffers[0].byteLength)
                {
                    //
                    // We've exhausted the current read buffer.
                    //
                    this._readPosition = 0;
                    this._readBuffers.shift();
                    if(this._readBuffers.length === 0)
                    {
                        break; // No more data - we're done.
                    }
                    else
                    {
                        avail = this._readBuffers[0].byteLength;
                    }
                }
            }

            var n = remaining - byteBuffer.remaining;
            if(n > 0 && this._traceLevels.network >= 3)
            {
                var msg = "received " + n + " of " + remaining + " bytes via " + this.type() + "\n" + this._desc;
                this._logger.trace(this._traceLevels.networkCat, msg);
            }

            moreData.value = this._readBuffers.byteLength > 0;

            return byteBuffer.remaining === 0;
        },
        type: function()
        {
            return this._secure ? "wss" : "ws";
        },
        getInfo: function()
        {
            Debug.assert(this._fd !== null);
            var info = this.createInfo();
            
            //
            // The WebSocket API doens't provide this info
            //
            info.localAddress = "";
            info.localPort = -1;
            info.remoteAddress = this._addr.host;
            info.remotePort = this._addr.port;
            return info;
        },
        createInfo: function()
        {
            return new IceWS.ConnectionInfo();
        },
        checkSendSize: function(stream, messageSizeMax)
        {
            if(stream.size > messageSizeMax)
            {
                ExUtil.throwMemoryLimitException(stream.size, messageSizeMax);
            }
        },
        toString: function()
        {
            return this._desc;
        },
        socketConnected: function(e)
        {
            this._connected = true;
            this._desc = fdToString(this._addr);

            if(this._traceLevels.network >= 1)
            {
                this._logger.trace(this._traceLevels.networkCat, this.type() + " connection established\n" + this._desc);
            }

            Debug.assert(this._connectedCallback !== null);
            this._connectedCallback();
        },
        socketBytesAvailable: function(buf)
        {
            Debug.assert(this._bytesAvailableCallback !== null);
            if(buf.byteLength > 0)
            {
                this._readBuffers.push(buf);
                if(this._registered)
                {
                    this._bytesAvailableCallback();
                }
                else if(!this._hasBytesAvailable)
                {
                    this._hasBytesAvailable = true;
                }
            }
        },
        socketClosed: function(err)
        {
            if(err.code === 1000) // CLOSE_NORMAL
            {
                Debug.assert(this._closedCallback !== null);
                this._closedCallback();
            }
            else
            {
                this._errorCallback(translateError(this._state, err));
            }
        },
        socketError: function(err)
        {
            Debug.assert(this._errorCallback !== null);
            this._errorCallback(translateError(err));
        }
    });
    
    function fdToString(address)
    {
        var s = "local address = <not available>\n";
        s += "remote address = " + address.host + ":" + address.port;
        return s;
    }

    function translateError(state, err)
    {
        if(state < StateConnected)
        {
            return new Ice.ConnectFailedException(err.code, err);
        }
        else
        {
            return new Ice.SocketException(err.code, err);
        }
    }
    
    Transceiver.createOutgoing = function(instance, secure, addr, resource)
    {
        var transceiver = new Transceiver(instance);

        var url = secure ? "wss" : "ws";
        url += "://" + addr.host;
        if(addr.port !== 80)
        {
            url += ":" + addr.port;
        }
        url += resource ? resource : "/";
        transceiver._url = url;
        transceiver._fd = null;
        transceiver._addr = addr;
        transceiver._connected = false;
        transceiver._desc = "remote address: " + Network.addrToString(addr.host, addr.port) + " <not connected>";
        transceiver._state = StateNeedConnect;
        transceiver._secure = secure;
        
        return transceiver;
    };

    IceWS.Transceiver = Transceiver;
    global.IceWS = IceWS;
}(typeof (global) === "undefined" ? window : global));
