// **********************************************************************
//
// Copyright (c) 2002
// Mutable Realms, Inc.
// Huntsville, AL, USA
//
// All Rights Reserved
//
// **********************************************************************

#ifndef ICESSL_CLIENT_CONTEXT_H
#define ICESSL_CLIENT_CONTEXT_H

#include <IceSSL/ContextOpenSSL.h>

namespace IceSSL
{

class ClientContext : public Context
{
public:

    virtual void configure(const GeneralConfig&,
                           const CertificateAuthority&,
                           const BaseCertificates&);

    // Takes a socket fd as the first parameter.
    virtual SslTransceiverPtr createTransceiver(int, const PluginBaseIPtr&);

protected:

    ClientContext(const TraceLevelsPtr&, const Ice::LoggerPtr&, const Ice::PropertiesPtr&);

    friend class OpenSSL::PluginI;
};

}

#endif
