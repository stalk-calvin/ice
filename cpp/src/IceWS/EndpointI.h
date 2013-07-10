// **********************************************************************
//
// Copyright (c) 2003-2013 ZeroC, Inc. All rights reserved.
//
// This copy of Ice is licensed to you under the terms described in the
// ICE_LICENSE file included in this distribution.
//
// **********************************************************************

#ifndef ICE_WS_ENDPOINT_I_H
#define ICE_WS_ENDPOINT_I_H

#include <Ice/EndpointI.h>
#include <Ice/EndpointFactory.h>
#include <IceWS/InstanceF.h>
#include <IceWS/EndpointInfo.h>
#include <Ice/Network.h>

namespace IceWS
{

class EndpointI : public IceInternal::EndpointI
{
public:

    EndpointI(const InstancePtr&, Ice::Short, const IceInternal::EndpointIPtr&, const std::string&);
    EndpointI(const InstancePtr&, Ice::Short, const IceInternal::EndpointIPtr&, std::vector<std::string>&, bool);
    EndpointI(const InstancePtr&, Ice::Short, const IceInternal::EndpointIPtr&, IceInternal::BasicStream*);

    virtual void startStreamWrite(IceInternal::BasicStream*) const;
    virtual void streamWrite(IceInternal::BasicStream*) const;
    virtual void endStreamWrite(IceInternal::BasicStream*) const;
    virtual Ice::EndpointInfoPtr getInfo() const;
    virtual Ice::Short type() const;
    virtual std::string protocol() const;
    virtual Ice::Int timeout() const;
    virtual IceInternal::EndpointIPtr timeout(Ice::Int) const;
    virtual IceInternal::EndpointIPtr connectionId(const ::std::string&) const;
    virtual bool compress() const;
    virtual IceInternal::EndpointIPtr compress(bool) const;
    virtual bool datagram() const;
    virtual bool secure() const;
    virtual IceInternal::TransceiverPtr transceiver(IceInternal::EndpointIPtr&) const;
    virtual std::vector<IceInternal::ConnectorPtr> connectors(Ice::EndpointSelectionType) const;
    virtual void connectors_async(Ice::EndpointSelectionType, const IceInternal::EndpointI_connectorsPtr&) const;
    virtual IceInternal::AcceptorPtr acceptor(IceInternal::EndpointIPtr&, const std::string&) const;
    virtual std::vector<IceInternal::EndpointIPtr> expand() const;
    virtual bool equivalent(const IceInternal::EndpointIPtr&) const;
    virtual std::vector<IceInternal::ConnectorPtr> connectors(const std::vector<IceInternal::Address>&,
                                                              const IceInternal::NetworkProxyPtr&) const;

    virtual bool operator==(const Ice::LocalObject&) const;
    virtual bool operator<(const Ice::LocalObject&) const;

    virtual void hashInit(Ice::Int&) const;
    virtual std::string options() const;

#ifdef __SUNPRO_CC
    using IceInternal::EndpointI::connectionId;
#endif

private:

    //
    // All members are const, because endpoints are immutable.
    //
    const InstancePtr _instance;
    const Ice::Short _type;
    const IceInternal::EndpointIPtr _delegate;
    const std::string _resource;
    const Ice::IPEndpointInfoPtr _info;
};

class EndpointFactoryI : public IceInternal::EndpointFactory
{
public:

    virtual ~EndpointFactoryI();

    virtual Ice::Short type() const;
    virtual std::string protocol() const;
    virtual IceInternal::EndpointIPtr create(std::vector<std::string>&, bool) const;
    virtual IceInternal::EndpointIPtr read(IceInternal::BasicStream*) const;
    virtual void destroy();

private:

    EndpointFactoryI(const InstancePtr&, const IceInternal::EndpointFactoryPtr&, int, const std::string&);
    friend class Instance;

    const InstancePtr _instance;
    const IceInternal::EndpointFactoryPtr _delegate;
    const int _type;
    const std::string _protocol;
};

}

#endif
