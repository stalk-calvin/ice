// **********************************************************************
//
// Copyright (c) 2003-2013 ZeroC, Inc. All rights reserved.
//
// This copy of Ice is licensed to you under the terms described in the
// ICE_LICENSE file included in this distribution.
//
// **********************************************************************
//
// Ice version 3.5.0
//
// <auto-generated>
//
// Generated from file `EndpointInfo.ice'
//
// Warning: do not edit this file.
//
// </auto-generated>
//

#ifndef __IceWS_EndpointInfo_h__
#define __IceWS_EndpointInfo_h__

#include <Ice/ProxyF.h>
#include <Ice/ObjectF.h>
#include <Ice/Exception.h>
#include <Ice/LocalObject.h>
#include <Ice/StreamHelpers.h>
#include <IceUtil/ScopedArray.h>
#include <IceUtil/Optional.h>
#include <Ice/Endpoint.h>
#include <Ice/UndefSysMacros.h>

#ifndef ICE_IGNORE_VERSION
#   if ICE_INT_VERSION / 100 != 305
#       error Ice version mismatch!
#   endif
#   if ICE_INT_VERSION % 100 > 50
#       error Beta header file detected
#   endif
#   if ICE_INT_VERSION % 100 < 0
#       error Ice patch level mismatch!
#   endif
#endif

#ifndef ICE_WS_API
#   ifdef ICE_WS_API_EXPORTS
#       define ICE_WS_API ICE_DECLSPEC_EXPORT
#   else
#       define ICE_WS_API ICE_DECLSPEC_IMPORT
#   endif
#endif

namespace IceWS
{

class EndpointInfo;
bool operator==(const EndpointInfo&, const EndpointInfo&);
bool operator<(const EndpointInfo&, const EndpointInfo&);
ICE_WS_API ::Ice::LocalObject* upCast(::IceWS::EndpointInfo*);
typedef ::IceInternal::Handle< ::IceWS::EndpointInfo> EndpointInfoPtr;

}

namespace IceWS
{

const ::Ice::Short EndpointType = 4;

}

namespace IceWS
{

class ICE_WS_API EndpointInfo : public ::Ice::IPEndpointInfo
{
public:

    typedef EndpointInfoPtr PointerType;

    EndpointInfo()
    {
    }

    EndpointInfo(::Ice::Int __ice_timeout, bool __ice_compress, const ::std::string& __ice_host, ::Ice::Int __ice_port, const ::std::string& __ice_resource) :
        ::Ice::IPEndpointInfo(__ice_timeout, __ice_compress, __ice_host, __ice_port)
        ,
        resource(__ice_resource)
    {
    }


public:

    ::std::string resource;
};

inline bool operator==(const EndpointInfo& l, const EndpointInfo& r)
{
    return static_cast<const ::Ice::LocalObject&>(l) == static_cast<const ::Ice::LocalObject&>(r);
}

inline bool operator<(const EndpointInfo& l, const EndpointInfo& r)
{
    return static_cast<const ::Ice::LocalObject&>(l) < static_cast<const ::Ice::LocalObject&>(r);
}

}

#endif
