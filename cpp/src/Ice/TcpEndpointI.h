// **********************************************************************
//
// Copyright (c) 2003-2013 ZeroC, Inc. All rights reserved.
//
// This copy of Ice is licensed to you under the terms described in the
// ICE_LICENSE file included in this distribution.
//
// **********************************************************************

#ifndef ICE_TCP_ENDPOINT_I_H
#define ICE_TCP_ENDPOINT_I_H

#include <IceUtil/Config.h>
#include <Ice/EndpointI.h>
#include <Ice/EndpointFactory.h>
#include <Ice/Network.h> // for IceIternal::Address

namespace IceInternal
{

class TcpEndpointI : public EndpointI
{
public:

    TcpEndpointI(const InstancePtr&, const std::string&, Ice::Int, Ice::Int, const std::string&, bool);
    TcpEndpointI(const InstancePtr&, std::vector<std::string>&, bool);
    TcpEndpointI(BasicStream*);

    virtual void streamWrite(BasicStream*) const;
    virtual Ice::EndpointInfoPtr getInfo() const;
    virtual Ice::Short type() const;
    virtual std::string protocol() const;
    virtual Ice::Int timeout() const;
    virtual EndpointIPtr timeout(Ice::Int) const;
    virtual EndpointIPtr connectionId(const ::std::string&) const;
    virtual bool compress() const;
    virtual EndpointIPtr compress(bool) const;
    virtual bool datagram() const;
    virtual bool secure() const;
    virtual TransceiverPtr transceiver(EndpointIPtr&) const;
    virtual std::vector<ConnectorPtr> connectors(Ice::EndpointSelectionType) const;
    virtual void connectors_async(Ice::EndpointSelectionType, const EndpointI_connectorsPtr&) const;
    virtual AcceptorPtr acceptor(EndpointIPtr&, const std::string&) const;
    virtual std::vector<EndpointIPtr> expand() const;
    virtual bool equivalent(const EndpointIPtr&) const;
    virtual std::vector<ConnectorPtr> connectors(const std::vector<Address>&, const NetworkProxyPtr&) const;

    virtual bool operator==(const Ice::LocalObject&) const;
    virtual bool operator<(const Ice::LocalObject&) const;

    virtual void hashInit(Ice::Int&) const;
    virtual std::string options() const;

#ifdef __SUNPRO_CC
    using EndpointI::connectionId;
#endif

private:

    //
    // All members are const, because endpoints are immutable.
    //
    const InstancePtr _instance;
    const std::string _host;
    const Ice::Int _port;
    const Ice::Int _timeout;
    const bool _compress;
};

class TcpEndpointFactory : public EndpointFactory
{
public:

    virtual ~TcpEndpointFactory();

    virtual Ice::Short type() const;
    virtual std::string protocol() const;
    virtual EndpointIPtr create(std::vector<std::string>&, bool) const;
    virtual EndpointIPtr read(BasicStream*) const;
    virtual void destroy();

private:

    TcpEndpointFactory(const InstancePtr&);
    friend class Instance;

    InstancePtr _instance;
};

}

#endif
