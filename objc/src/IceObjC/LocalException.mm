// **********************************************************************
//
// Copyright (c) 2003-2008 ZeroC, Inc. All rights reserved.
//
// This copy of Ice is licensed to you under the terms described in the
// ICE_LICENSE file included in this distribution.
//
// **********************************************************************

#import <IceObjC/LocalException.h>
#import <IceObjC/Util.h>
#import <IceObjC/IdentityI.h>

#include <Ice/LocalException.h>

@implementation ICEInitializationException
-(void)rethrowCxx__
{
    throw Ice::InitializationException([file UTF8String], line, fromNSString(_objc_reason));
}
-(NSString*)ice_name
{
    return @"Ice::InitializationException";
}
@synthesize _objc_reason;
@end

@implementation ICEPluginInitializationException
-(void)rethrowCxx__
{
    throw Ice::PluginInitializationException([file UTF8String], line, fromNSString(_objc_reason));
}
-(NSString*)ice_name
{
    return @"Ice::PluginInitializationException";
}
@synthesize _objc_reason;
@end

@implementation ICECollocationOptimizationException
-(void)rethrowCxx__
{
    throw Ice::CollocationOptimizationException([file UTF8String], line);
}
-(NSString*)ice_name
{
    return @"Ice::CollocationOptimizationException";
}
@end

@implementation ICEAlreadyRegisteredException
-(void)rethrowCxx__
{
    throw Ice::AlreadyRegisteredException([file UTF8String], line, fromNSString(kindOfObject), fromNSString(_objc_id));
}
-(NSString*)ice_name
{
    return @"Ice::AlreadyRegisteredException";
}
@synthesize kindOfObject;
@synthesize _objc_id;
@end

@implementation ICENotRegisteredException
-(void)rethrowCxx__
{
    throw Ice::NotRegisteredException([file UTF8String], line, fromNSString(kindOfObject), fromNSString(_objc_id));
}
-(NSString*)ice_name
{
    return @"Ice::NotRegisteredException";
}
@synthesize kindOfObject;
@synthesize _objc_id;
@end

@implementation ICETwowayOnlyException
-(void)rethrowCxx__
{
    throw Ice::TwowayOnlyException([file UTF8String], line, fromNSString(operation));
}
-(NSString*)ice_name
{
    return @"Ice::TwowayOnlyException";
}
@synthesize operation;
@end

@implementation ICECloneNotImplementedException
-(void)rethrowCxx__
{
    throw Ice::CloneNotImplementedException([file UTF8String], line);
}
-(NSString*)ice_name
{
    return @"Ice::CloneNotImplementedException";
}
@end

@implementation ICEUnknownException
-(void)rethrowCxx__
{
    throw Ice::UnknownException([file UTF8String], line, fromNSString(unknown));
}
-(NSString*)ice_name
{
    return @"Ice::UnknownException";
}
@synthesize unknown;
@end
    
@implementation ICEUnknownLocalException
-(void)rethrowCxx__
{
    throw Ice::UnknownLocalException([file UTF8String], line, fromNSString(unknown));
}
-(NSString*)ice_name
{
    return @"Ice::UnknownLocalException";
}
@end

@implementation ICEUnknownUserException
-(void)rethrowCxx__
{
    throw Ice::UnknownUserException([file UTF8String], line, fromNSString(unknown));
}
-(NSString*)ice_name
{
    return @"Ice::UnknownUserException";
}
@end

@implementation ICEVersionMismatchException
-(void)rethrowCxx__
{
    throw Ice::VersionMismatchException([file UTF8String], line);
}
-(NSString*)ice_name
{
    return @"Ice::VersionMismatchException";
}
@end

@implementation ICECommunicatorDestroyedException
-(void)rethrowCxx__
{
    throw Ice::CommunicatorDestroyedException([file UTF8String], line);
}
-(NSString*)ice_name
{
    return @"Ice::CommunicatorDestroyedException";
}
@end

@implementation ICEObjectAdapterDeactivatedException
-(void)rethrowCxx__
{
    throw Ice::ObjectAdapterDeactivatedException([file UTF8String], line, fromNSString(_objc_name));
}
-(NSString*)ice_name
{
    return @"Ice::ObjectAdapterDeactivatedException";
}
@synthesize _objc_name;
@end

@implementation ICEObjectAdapterIdInUseException
-(void)rethrowCxx__
{
    throw Ice::ObjectAdapterIdInUseException([file UTF8String], line, fromNSString(_objc_id));
}
-(NSString*)ice_name
{
    return @"Ice::ObjectAdapterIdInUseException";
}
@synthesize _objc_id;
@end

@implementation ICENoEndpointException
-(void)rethrowCxx__
{
    throw Ice::NoEndpointException([file UTF8String], line, fromNSString(proxy));
}
-(NSString*)ice_name
{
    return @"Ice::NoEndpointException";
}
@synthesize proxy;
@end

@implementation ICEEndpointParseException
-(void)rethrowCxx__
{
    throw Ice::EndpointParseException([file UTF8String], line, fromNSString(str));
}
-(NSString*)ice_name
{
    return @"Ice::EndpointParseException";
}
@synthesize str;
@end

@implementation ICEEndpointSelectionTypeParseException
-(void)rethrowCxx__
{
    throw Ice::EndpointSelectionTypeParseException([file UTF8String], line, fromNSString(str));
}
-(NSString*)ice_name
{
    return @"Ice::EndpointSelectionTypeParseException";
}
@synthesize str;
@end

@implementation ICEIdentityParseException
-(void)rethrowCxx__
{
    throw Ice::IdentityParseException([file UTF8String], line, fromNSString(str));
}
-(NSString*)ice_name
{
    return @"Ice::IdentityParseException";
}
@synthesize str;
@end

@implementation ICEProxyParseException
-(void)rethrowCxx__
{
    throw Ice::ProxyParseException([file UTF8String], line, fromNSString(str));
}
-(NSString*)ice_name
{
    return @"Ice::ProxyParseException";
}
@synthesize str;
@end

@implementation ICEIllegalIdentityException
-(void)rethrowCxx__
{
    throw Ice::IllegalIdentityException([file UTF8String], line, [_objc_id identity__]);
}
-(NSString*)ice_name
{
    return @"Ice::IllegalIdentityException";
}
@synthesize _objc_id;
@end

@implementation ICERequestFailedException
-(void)rethrowCxx__
{
    throw Ice::RequestFailedException([file UTF8String], line, [_objc_id identity__], fromNSString(facet), fromNSString(operation));
}
-(NSString*)ice_name
{
    return @"Ice::RequestFailedException";
}
@synthesize _objc_id;
@synthesize facet;
@synthesize operation;
@end

@implementation ICEObjectNotExistException
-(void)rethrowCxx__
{
    throw Ice::ObjectNotExistException([file UTF8String], line, [_objc_id identity__], fromNSString(facet), fromNSString(operation));
}
-(NSString*)ice_name
{
    return @"Ice::ObjectNotExistException";
}
@end

@implementation ICEFacetNotExistException
-(void)rethrowCxx__
{
    throw Ice::FacetNotExistException([file UTF8String], line, [_objc_id identity__], fromNSString(facet), fromNSString(operation));
}
-(NSString*)ice_name
{
    return @"Ice::FacetNotExistException";
}
@end

@implementation ICEOperationNotExistException
-(void)rethrowCxx__
{
    throw Ice::OperationNotExistException([file UTF8String], line, [_objc_id identity__], fromNSString(facet), fromNSString(operation));
}
-(NSString*)ice_name
{
    return @"Ice::OperationNotExistException";
}
@end

@implementation ICESyscallException
-(void)rethrowCxx__
{
    throw Ice::SyscallException([file UTF8String], line, error);
}
-(NSString*)ice_name
{
    return @"Ice::SyscallException";
}
@synthesize error;
@end

@implementation ICESocketException
-(void)rethrowCxx__
{
    throw Ice::SocketException([file UTF8String], line, error);
}
-(NSString*)ice_name
{
    return @"Ice::SocketException";
}
@end

@implementation ICEFileException
-(void)rethrowCxx__
{
    throw Ice::FileException([file UTF8String], line, error, fromNSString(path));
}
-(NSString*)ice_name
{
    return @"Ice::FileException";
}
@synthesize path;
@end

@implementation ICEConnectFailedException
-(void)rethrowCxx__
{
    throw Ice::ConnectFailedException([file UTF8String], line, error);
}
-(NSString*)ice_name
{
    return @"Ice::ConnectFailedException";
}
@end

@implementation ICEConnectionRefusedException
-(void)rethrowCxx__
{
    throw Ice::ConnectionRefusedException([file UTF8String], line, error);
}
-(NSString*)ice_name
{
    return @"Ice::ConnectionRefusedException";
}
@end

@implementation ICEConnectionLostException
-(void)rethrowCxx__
{
    throw Ice::ConnectionLostException([file UTF8String], line, error);
}
-(NSString*)ice_name
{
    return @"Ice::ConnectionLostException";
}
@end

@implementation ICEDNSException
-(void)rethrowCxx__
{
    throw Ice::DNSException([file UTF8String], line, error, fromNSString(host));
}
-(NSString*)ice_name
{
    return @"Ice::DNSException";
}
@synthesize error;
@synthesize host;
@end

@implementation ICETimeoutException
-(void)rethrowCxx__
{
    throw Ice::TimeoutException([file UTF8String], line);
}
-(NSString*)ice_name
{
    return @"Ice::TimeoutException";
}
@end

@implementation ICEConnectTimeoutException
-(void)rethrowCxx__
{
    throw Ice::ConnectTimeoutException([file UTF8String], line);
}
-(NSString*)ice_name
{
    return @"Ice::ConnectTimeoutException";
}
@end

@implementation ICECloseTimeoutException
-(void)rethrowCxx__
{
    throw Ice::CloseTimeoutException([file UTF8String], line);
}
-(NSString*)ice_name
{
    return @"Ice::CloseTimeoutException";
}
@end

@implementation ICEConnectionTimeoutException
-(void)rethrowCxx__
{
    throw Ice::ConnectionTimeoutException([file UTF8String], line);
}
-(NSString*)ice_name
{
    return @"Ice::ConnectionTimeoutException";
}
@end

@implementation ICEProtocolException
-(void)rethrowCxx__
{
    throw Ice::ProtocolException([file UTF8String], line, fromNSString(_objc_reason));
}
-(NSString*)ice_name
{
    return @"Ice::ProtocolException";
}
@synthesize _objc_reason;
@end

@implementation ICEBadMagicException
-(void)rethrowCxx__
{
    Ice::ByteSeq s;
    throw Ice::BadMagicException([file UTF8String], line, fromNSString(_objc_reason), fromNSArray(badMagic, s));
}
-(NSString*)ice_name
{
    return @"Ice::BadMagicException";
}
@synthesize badMagic;
@end

@implementation ICEUnsupportedProtocolException
-(void)rethrowCxx__
{
    throw Ice::UnsupportedProtocolException([file UTF8String], line, fromNSString(_objc_reason), badMajor, badMinor, major, minor);
}
-(NSString*)ice_name
{
    return @"Ice::UnsupportedProtocolException";
}
@synthesize badMajor;
@synthesize badMinor;
@synthesize major;
@synthesize minor;
@end

@implementation ICEUnsupportedEncodingException
-(void)rethrowCxx__
{
    throw Ice::UnsupportedEncodingException([file UTF8String], line, fromNSString(_objc_reason), badMajor, badMinor, major, minor);
}
-(NSString*)ice_name
{
    return @"Ice::UnsupportedEncodingException";
}
@synthesize badMajor;
@synthesize badMinor;
@synthesize major;
@synthesize minor;
@end

@implementation ICEUnknownMessageException
-(void)rethrowCxx__
{
    throw Ice::UnknownMessageException([file UTF8String], line, fromNSString(_objc_reason));
}
-(NSString*)ice_name
{
    return @"Ice::UnknownMessageException";
}
@end

@implementation ICEConnectionNotValidatedException
-(void)rethrowCxx__
{
    throw Ice::ConnectionNotValidatedException([file UTF8String], line, fromNSString(_objc_reason));
}
-(NSString*)ice_name
{
    return @"Ice::ConnectionNotValidatedException";
}
@end

@implementation ICEUnknownRequestIdException
-(void)rethrowCxx__
{
    throw Ice::UnknownRequestIdException([file UTF8String], line, fromNSString(_objc_reason));
}
-(NSString*)ice_name
{
    return @"Ice::UnknownRequestIdException";
}
@end

@implementation ICEUnknownReplyStatusException
-(void)rethrowCxx__
{
    throw Ice::UnknownReplyStatusException([file UTF8String], line, fromNSString(_objc_reason));
}
-(NSString*)ice_name
{
    return @"Ice::UnknownReplyStatusException";
}
@end

@implementation ICECloseConnectionException
-(void)rethrowCxx__
{
    throw Ice::CloseConnectionException([file UTF8String], line, fromNSString(_objc_reason));
}
-(NSString*)ice_name
{
    return @"Ice::CloseConnectionException";
}
@end

@implementation ICEForcedCloseConnectionException
-(void)rethrowCxx__
{
    throw Ice::ForcedCloseConnectionException([file UTF8String], line, fromNSString(_objc_reason));
}
-(NSString*)ice_name
{
    return @"Ice::ForcedCloseConnectionException";
}
@end

@implementation ICEIllegalMessageSizeException
-(void)rethrowCxx__
{
    throw Ice::IllegalMessageSizeException([file UTF8String], line, fromNSString(_objc_reason));
}
-(NSString*)ice_name
{
    return @"Ice::IllegalMessageSizeException";
}
@end

@implementation ICECompressionException
-(void)rethrowCxx__
{
    throw Ice::CompressionException([file UTF8String], line, fromNSString(_objc_reason));
}
-(NSString*)ice_name
{
    return @"Ice::CompressionException";
}
@end

@implementation ICEDatagramLimitException
-(void)rethrowCxx__
{
    throw Ice::DatagramLimitException([file UTF8String], line, fromNSString(_objc_reason));
}
-(NSString*)ice_name
{
    return @"Ice::DatagramLimitException";
}
@end

@implementation ICEMarshalException
-(void)rethrowCxx__
{
    throw Ice::MarshalException([file UTF8String], line, fromNSString(_objc_reason));
}
-(NSString*)ice_name
{
    return @"Ice::MarshalException";
}
@end

@implementation ICEProxyUnmarshalException
-(void)rethrowCxx__
{
    throw Ice::ProxyUnmarshalException([file UTF8String], line, fromNSString(_objc_reason));
}
-(NSString*)ice_name
{
    return @"Ice::ProxyUnmarshalException";
}
@end

@implementation ICEUnmarshalOutOfBoundsException
-(void)rethrowCxx__
{
    throw Ice::UnmarshalOutOfBoundsException([file UTF8String], line, fromNSString(_objc_reason));
}
-(NSString*)ice_name
{
    return @"Ice::UnmarshalOutOfBoundsException";
}
@end

@implementation ICEIllegalIndirectionException
-(void)rethrowCxx__
{
    throw Ice::IllegalIndirectionException([file UTF8String], line, fromNSString(_objc_reason));
}
-(NSString*)ice_name
{
    return @"Ice::IllegalIndirectionException";
}
@end

@implementation ICENoObjectFactoryException
-(void)rethrowCxx__
{
    throw Ice::NoObjectFactoryException([file UTF8String], line, fromNSString(_objc_reason), fromNSString(type));
}
-(NSString*)ice_name
{
    return @"Ice::NoObjectFactoryException";
}
@synthesize type;
@end

@implementation ICEUnexpectedObjectException
-(void)rethrowCxx__
{
    throw Ice::UnexpectedObjectException([file UTF8String], line, fromNSString(_objc_reason), fromNSString(type), fromNSString(expectedType));
}
-(NSString*)ice_name
{
    return @"Ice::UnexpectedObjectException";
}
@synthesize type;
@synthesize expectedType;
@end

@implementation ICEMemoryLimitException
-(void)rethrowCxx__
{
    throw Ice::MemoryLimitException([file UTF8String], line, fromNSString(_objc_reason));
}
-(NSString*)ice_name
{
    return @"Ice::MemoryLimitException";
}
@end

@implementation ICEStringConversionException
-(void)rethrowCxx__
{
    throw Ice::StringConversionException([file UTF8String], line, fromNSString(_objc_reason));
}
-(NSString*)ice_name
{
    return @"Ice::StringConversionException";
}
@end

@implementation ICEEncapsulationException
-(void)rethrowCxx__
{
    throw Ice::EncapsulationException([file UTF8String], line, fromNSString(_objc_reason));
}
-(NSString*)ice_name
{
    return @"Ice::EncapsulationException";
}
@end

@implementation ICENegativeSizeException
-(void)rethrowCxx__
{
    throw Ice::NegativeSizeException([file UTF8String], line, fromNSString(_objc_reason));
}
-(NSString*)ice_name
{
    return @"Ice::NegativeSizeException";
}
@end

@implementation ICEFeatureNotSupportedException
-(void)rethrowCxx__
{
    throw Ice::FeatureNotSupportedException([file UTF8String], line, fromNSString(unsupportedFeature));
}
-(NSString*)ice_name
{
    return @"Ice::FeatureNotSupportedException";
}
@synthesize unsupportedFeature;
@end

@implementation ICESecurityException
-(void)rethrowCxx__
{
    throw Ice::SecurityException([file UTF8String], line, fromNSString(_objc_reason));
}
-(NSString*)ice_name
{
    return @"Ice::SecurityException";
}
@synthesize _objc_reason;
@end

@implementation ICEFixedProxyException
-(void)rethrowCxx__
{
    throw Ice::FixedProxyException([file UTF8String], line);
}
-(NSString*)ice_name
{
    return @"Ice::FixedProxyException";
}
@end

@implementation ICEResponseSentException
-(void)rethrowCxx__
{
    throw Ice::ResponseSentException([file UTF8String], line);
}
-(NSString*)ice_name
{
    return @"Ice::ResponseSentException";
}
@end
