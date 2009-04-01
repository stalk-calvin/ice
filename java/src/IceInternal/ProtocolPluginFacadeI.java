// **********************************************************************
//
// Copyright (c) 2003-2009 ZeroC, Inc. All rights reserved.
//
// This copy of Ice is licensed to you under the terms described in the
// ICE_LICENSE file included in this distribution.
//
// **********************************************************************

package IceInternal;

public class ProtocolPluginFacadeI implements ProtocolPluginFacade
{
    public
    ProtocolPluginFacadeI(Ice.Communicator communicator)
    {
        _communicator = communicator;
        _instance = Ice.Util.getInstance(communicator);
    }

    //
    // Get the Communicator instance with which this facade is
    // associated.
    //
    public Ice.Communicator
    getCommunicator()
    {
        return _communicator;
    }

    //
    // Get the endpoint host resolver.
    //
    public EndpointHostResolver
    getEndpointHostResolver()
    {
        return _instance.endpointHostResolver();
    }    

    //
    // Get the protocol support.
    //
    public int
    getProtocolSupport()
    {
        return _instance.protocolSupport();
    }    
    //
    // Get the default hostname to be used in endpoints.
    //
    public String
    getDefaultHost()
    {
        return _instance.defaultsAndOverrides().defaultHost;
    }

    //
    // Register an EndpointFactory.
    //
    public void
    addEndpointFactory(EndpointFactory factory)
    {
        _instance.endpointFactoryManager().add(factory);
    }

    //
    // Register an EndpointFactory.
    //
    public EndpointFactory
    getEndpointFactory(short type)
    {
        return _instance.endpointFactoryManager().get(type);
    }

    private Instance _instance;
    private Ice.Communicator _communicator;
}
