// **********************************************************************
//
// Copyright (c) 2003-2009 ZeroC, Inc. All rights reserved.
//
// This copy of Ice is licensed to you under the terms described in the
// ICE_LICENSE file included in this distribution.
//
// **********************************************************************

// IMPORTANT: Do not edit this file -- any edits made here will be lost!

package IceInternal;

public final class PropertyNames
{
    public static final Property IceProps[] = 
    {
        new Property("Ice\\.ACM\\.Client", false, null),
        new Property("Ice\\.ACM\\.Server", false, null),
        new Property("Ice\\.Admin\\.AdapterId", false, null),
        new Property("Ice\\.Admin\\.Endpoints", false, null),
        new Property("Ice\\.Admin\\.Locator", false, null),
        new Property("Ice\\.Admin\\.PublishedEndpoints", false, null),
        new Property("Ice\\.Admin\\.RegisterProcess", true, null),
        new Property("Ice\\.Admin\\.ReplicaGroupId", false, null),
        new Property("Ice\\.Admin\\.Router", false, null),
        new Property("Ice\\.Admin\\.ProxyOptions", false, null),
        new Property("Ice\\.Admin\\.ThreadPool\\.Size", false, null),
        new Property("Ice\\.Admin\\.ThreadPool\\.SizeMax", false, null),
        new Property("Ice\\.Admin\\.ThreadPool\\.SizeWarn", false, null),
        new Property("Ice\\.Admin\\.ThreadPool\\.StackSize", false, null),
        new Property("Ice\\.Admin\\.ThreadPool\\.Serialize", false, null),
        new Property("Ice\\.Admin\\.DelayCreation", false, null),
        new Property("Ice\\.Admin\\.Facets", false, null),
        new Property("Ice\\.Admin\\.InstanceName", false, null),
        new Property("Ice\\.Admin\\.ServerId", false, null),
        new Property("Ice\\.BatchAutoFlush", false, null),
        new Property("Ice\\.ChangeUser", false, null),
        new Property("Ice\\.Compression\\.Level", false, null),
        new Property("Ice\\.Config", false, null),
        new Property("Ice\\.Default\\.CollocationOptimization", true, "Ice.Default.CollocationOptimized"),
        new Property("Ice\\.Default\\.CollocationOptimized", false, null),
        new Property("Ice\\.Default\\.EndpointSelection", false, null),
        new Property("Ice\\.Default\\.Host", false, null),
        new Property("Ice\\.Default\\.Locator\\.EndpointSelection", false, null),
        new Property("Ice\\.Default\\.Locator\\.ConnectionCached", false, null),
        new Property("Ice\\.Default\\.Locator\\.PreferSecure", false, null),
        new Property("Ice\\.Default\\.Locator\\.LocatorCacheTimeout", false, null),
        new Property("Ice\\.Default\\.Locator\\.Locator", false, null),
        new Property("Ice\\.Default\\.Locator\\.Router", false, null),
        new Property("Ice\\.Default\\.Locator\\.CollocationOptimization", true, "Ice.Default.Locator.CollocationOptimized"),
        new Property("Ice\\.Default\\.Locator\\.CollocationOptimized", false, null),
        new Property("Ice\\.Default\\.Locator", false, null),
        new Property("Ice\\.Default\\.LocatorCacheTimeout", false, null),
        new Property("Ice\\.Default\\.Package", false, null),
        new Property("Ice\\.Default\\.PreferSecure", false, null),
        new Property("Ice\\.Default\\.Protocol", false, null),
        new Property("Ice\\.Default\\.Router\\.EndpointSelection", false, null),
        new Property("Ice\\.Default\\.Router\\.ConnectionCached", false, null),
        new Property("Ice\\.Default\\.Router\\.PreferSecure", false, null),
        new Property("Ice\\.Default\\.Router\\.LocatorCacheTimeout", false, null),
        new Property("Ice\\.Default\\.Router\\.Locator", false, null),
        new Property("Ice\\.Default\\.Router\\.Router", false, null),
        new Property("Ice\\.Default\\.Router\\.CollocationOptimization", true, "Ice.Default.Router.CollocationOptimized"),
        new Property("Ice\\.Default\\.Router\\.CollocationOptimized", false, null),
        new Property("Ice\\.Default\\.Router", false, null),
        new Property("Ice\\.IPv4", false, null),
        new Property("Ice\\.IPv6", false, null),
        new Property("Ice\\.EventLog\\.Source", false, null),
        new Property("Ice\\.GC\\.Interval", false, null),
        new Property("Ice\\.ImplicitContext", false, null),
        new Property("Ice\\.InitPlugins", false, null),
        new Property("Ice\\.MessageSizeMax", false, null),
        new Property("Ice\\.MonitorConnections", true, null),
        new Property("Ice\\.Nohup", false, null),
        new Property("Ice\\.NullHandleAbort", false, null),
        new Property("Ice\\.Override\\.Compress", false, null),
        new Property("Ice\\.Override\\.ConnectTimeout", false, null),
        new Property("Ice\\.Override\\.Timeout", false, null),
        new Property("Ice\\.Override\\.Secure", false, null),
        new Property("Ice\\.Package\\.[^\\s]+", false, null),
        new Property("Ice\\.Plugin\\.[^\\s]+", false, null),
        new Property("Ice\\.PluginLoadOrder", false, null),
        new Property("Ice\\.PrintAdapterReady", false, null),
        new Property("Ice\\.PrintProcessId", false, null),
        new Property("Ice\\.ProgramName", false, null),
        new Property("Ice\\.RetryIntervals", false, null),
        new Property("Ice\\.ServerId", true, null),
        new Property("Ice\\.ServerIdleTime", false, null),
        new Property("Ice\\.StdErr", false, null),
        new Property("Ice\\.StdOut", false, null),
        new Property("Ice\\.ThreadPool\\.Client\\.Size", false, null),
        new Property("Ice\\.ThreadPool\\.Client\\.SizeMax", false, null),
        new Property("Ice\\.ThreadPool\\.Client\\.SizeWarn", false, null),
        new Property("Ice\\.ThreadPool\\.Client\\.StackSize", false, null),
        new Property("Ice\\.ThreadPool\\.Client\\.Serialize", false, null),
        new Property("Ice\\.ThreadPool\\.Server\\.Size", false, null),
        new Property("Ice\\.ThreadPool\\.Server\\.SizeMax", false, null),
        new Property("Ice\\.ThreadPool\\.Server\\.SizeWarn", false, null),
        new Property("Ice\\.ThreadPool\\.Server\\.StackSize", false, null),
        new Property("Ice\\.ThreadPool\\.Server\\.Serialize", false, null),
        new Property("Ice\\.Trace\\.GC", false, null),
        new Property("Ice\\.Trace\\.Location", true, "Ice.Trace.Locator"),
        new Property("Ice\\.Trace\\.Locator", false, null),
        new Property("Ice\\.Trace\\.Network", false, null),
        new Property("Ice\\.Trace\\.Protocol", false, null),
        new Property("Ice\\.Trace\\.Retry", false, null),
        new Property("Ice\\.Trace\\.Slicing", false, null),
        new Property("Ice\\.UDP\\.RcvSize", false, null),
        new Property("Ice\\.UDP\\.SndSize", false, null),
        new Property("Ice\\.TCP\\.Backlog", false, null),
        new Property("Ice\\.TCP\\.RcvSize", false, null),
        new Property("Ice\\.TCP\\.SndSize", false, null),
        new Property("Ice\\.UseSyslog", false, null),
        new Property("Ice\\.Warn\\.AMICallback", false, null),
        new Property("Ice\\.Warn\\.Connections", false, null),
        new Property("Ice\\.Warn\\.Datagrams", false, null),
        new Property("Ice\\.Warn\\.Dispatch", false, null),
        new Property("Ice\\.Warn\\.Endpoints", false, null),
        new Property("Ice\\.Warn\\.UnknownProperties", false, null),
        new Property("Ice\\.Warn\\.UnusedProperties", false, null),
        new Property("Ice\\.CacheMessageBuffers", false, null),
        null
    };

    public static final Property IceBoxProps[] = 
    {
        new Property("IceBox\\.InheritProperties", false, null),
        new Property("IceBox\\.InstanceName", false, null),
        new Property("IceBox\\.LoadOrder", false, null),
        new Property("IceBox\\.PrintServicesReady", false, null),
        new Property("IceBox\\.Service\\.[^\\s]+", false, null),
        new Property("IceBox\\.ServiceManager\\.AdapterId", false, null),
        new Property("IceBox\\.ServiceManager\\.Endpoints", false, null),
        new Property("IceBox\\.ServiceManager\\.Locator", false, null),
        new Property("IceBox\\.ServiceManager\\.PublishedEndpoints", false, null),
        new Property("IceBox\\.ServiceManager\\.RegisterProcess", true, null),
        new Property("IceBox\\.ServiceManager\\.ReplicaGroupId", false, null),
        new Property("IceBox\\.ServiceManager\\.Router", false, null),
        new Property("IceBox\\.ServiceManager\\.ProxyOptions", false, null),
        new Property("IceBox\\.ServiceManager\\.ThreadPool\\.Size", false, null),
        new Property("IceBox\\.ServiceManager\\.ThreadPool\\.SizeMax", false, null),
        new Property("IceBox\\.ServiceManager\\.ThreadPool\\.SizeWarn", false, null),
        new Property("IceBox\\.ServiceManager\\.ThreadPool\\.StackSize", false, null),
        new Property("IceBox\\.ServiceManager\\.ThreadPool\\.Serialize", false, null),
        new Property("IceBox\\.Trace\\.ServiceObserver", false, null),
        new Property("IceBox\\.UseSharedCommunicator\\.[^\\s]+", false, null),
        null
    };

    public static final Property IceBoxAdminProps[] = 
    {
        new Property("IceBoxAdmin\\.ServiceManager\\.Proxy\\.EndpointSelection", false, null),
        new Property("IceBoxAdmin\\.ServiceManager\\.Proxy\\.ConnectionCached", false, null),
        new Property("IceBoxAdmin\\.ServiceManager\\.Proxy\\.PreferSecure", false, null),
        new Property("IceBoxAdmin\\.ServiceManager\\.Proxy\\.LocatorCacheTimeout", false, null),
        new Property("IceBoxAdmin\\.ServiceManager\\.Proxy\\.Locator", false, null),
        new Property("IceBoxAdmin\\.ServiceManager\\.Proxy\\.Router", false, null),
        new Property("IceBoxAdmin\\.ServiceManager\\.Proxy\\.CollocationOptimization", true, "IceBoxAdmin.ServiceManager.Proxy.CollocationOptimized"),
        new Property("IceBoxAdmin\\.ServiceManager\\.Proxy\\.CollocationOptimized", false, null),
        new Property("IceBoxAdmin\\.ServiceManager\\.Proxy", false, null),
        null
    };

    public static final Property IceGridAdminProps[] = 
    {
        new Property("IceGridAdmin\\.AuthenticateUsingSSL", false, null),
        new Property("IceGridAdmin\\.Username", false, null),
        new Property("IceGridAdmin\\.Password", false, null),
        new Property("IceGridAdmin\\.Replica", false, null),
        new Property("IceGridAdmin\\.Trace\\.Observers", false, null),
        new Property("IceGridAdmin\\.Trace\\.SaveToRegistry", false, null),
        null
    };

    public static final Property IceGridProps[] = 
    {
        new Property("IceGrid\\.InstanceName", false, null),
        new Property("IceGrid\\.Node\\.AdapterId", false, null),
        new Property("IceGrid\\.Node\\.Endpoints", false, null),
        new Property("IceGrid\\.Node\\.Locator", false, null),
        new Property("IceGrid\\.Node\\.PublishedEndpoints", false, null),
        new Property("IceGrid\\.Node\\.RegisterProcess", true, null),
        new Property("IceGrid\\.Node\\.ReplicaGroupId", false, null),
        new Property("IceGrid\\.Node\\.Router", false, null),
        new Property("IceGrid\\.Node\\.ProxyOptions", false, null),
        new Property("IceGrid\\.Node\\.ThreadPool\\.Size", false, null),
        new Property("IceGrid\\.Node\\.ThreadPool\\.SizeMax", false, null),
        new Property("IceGrid\\.Node\\.ThreadPool\\.SizeWarn", false, null),
        new Property("IceGrid\\.Node\\.ThreadPool\\.StackSize", false, null),
        new Property("IceGrid\\.Node\\.ThreadPool\\.Serialize", false, null),
        new Property("IceGrid\\.Node\\.AllowRunningServersAsRoot", false, null),
        new Property("IceGrid\\.Node\\.AllowEndpointsOverride", false, null),
        new Property("IceGrid\\.Node\\.CollocateRegistry", false, null),
        new Property("IceGrid\\.Node\\.Data", false, null),
        new Property("IceGrid\\.Node\\.DisableOnFailure", false, null),
        new Property("IceGrid\\.Node\\.Name", false, null),
        new Property("IceGrid\\.Node\\.Output", false, null),
        new Property("IceGrid\\.Node\\.PrintServersReady", false, null),
        new Property("IceGrid\\.Node\\.PropertiesOverride", false, null),
        new Property("IceGrid\\.Node\\.RedirectErrToOut", false, null),
        new Property("IceGrid\\.Node\\.Trace\\.Activator", false, null),
        new Property("IceGrid\\.Node\\.Trace\\.Adapter", false, null),
        new Property("IceGrid\\.Node\\.Trace\\.Patch", false, null),
        new Property("IceGrid\\.Node\\.Trace\\.Replica", false, null),
        new Property("IceGrid\\.Node\\.Trace\\.Server", false, null),
        new Property("IceGrid\\.Node\\.UserAccounts", false, null),
        new Property("IceGrid\\.Node\\.UserAccountMapper\\.EndpointSelection", false, null),
        new Property("IceGrid\\.Node\\.UserAccountMapper\\.ConnectionCached", false, null),
        new Property("IceGrid\\.Node\\.UserAccountMapper\\.PreferSecure", false, null),
        new Property("IceGrid\\.Node\\.UserAccountMapper\\.LocatorCacheTimeout", false, null),
        new Property("IceGrid\\.Node\\.UserAccountMapper\\.Locator", false, null),
        new Property("IceGrid\\.Node\\.UserAccountMapper\\.Router", false, null),
        new Property("IceGrid\\.Node\\.UserAccountMapper\\.CollocationOptimization", true, "IceGrid.Node.UserAccountMapper.CollocationOptimized"),
        new Property("IceGrid\\.Node\\.UserAccountMapper\\.CollocationOptimized", false, null),
        new Property("IceGrid\\.Node\\.UserAccountMapper", false, null),
        new Property("IceGrid\\.Node\\.WaitTime", false, null),
        new Property("IceGrid\\.Registry\\.AdminCryptPasswords", false, null),
        new Property("IceGrid\\.Registry\\.AdminPermissionsVerifier\\.EndpointSelection", false, null),
        new Property("IceGrid\\.Registry\\.AdminPermissionsVerifier\\.ConnectionCached", false, null),
        new Property("IceGrid\\.Registry\\.AdminPermissionsVerifier\\.PreferSecure", false, null),
        new Property("IceGrid\\.Registry\\.AdminPermissionsVerifier\\.LocatorCacheTimeout", false, null),
        new Property("IceGrid\\.Registry\\.AdminPermissionsVerifier\\.Locator", false, null),
        new Property("IceGrid\\.Registry\\.AdminPermissionsVerifier\\.Router", false, null),
        new Property("IceGrid\\.Registry\\.AdminPermissionsVerifier\\.CollocationOptimization", true, "IceGrid.Registry.AdminPermissionsVerifier.CollocationOptimized"),
        new Property("IceGrid\\.Registry\\.AdminPermissionsVerifier\\.CollocationOptimized", false, null),
        new Property("IceGrid\\.Registry\\.AdminPermissionsVerifier", false, null),
        new Property("IceGrid\\.Registry\\.AdminSessionFilters", false, null),
        new Property("IceGrid\\.Registry\\.AdminSessionManager\\.AdapterId", false, null),
        new Property("IceGrid\\.Registry\\.AdminSessionManager\\.Endpoints", false, null),
        new Property("IceGrid\\.Registry\\.AdminSessionManager\\.Locator", false, null),
        new Property("IceGrid\\.Registry\\.AdminSessionManager\\.PublishedEndpoints", false, null),
        new Property("IceGrid\\.Registry\\.AdminSessionManager\\.RegisterProcess", true, null),
        new Property("IceGrid\\.Registry\\.AdminSessionManager\\.ReplicaGroupId", false, null),
        new Property("IceGrid\\.Registry\\.AdminSessionManager\\.Router", false, null),
        new Property("IceGrid\\.Registry\\.AdminSessionManager\\.ProxyOptions", false, null),
        new Property("IceGrid\\.Registry\\.AdminSessionManager\\.ThreadPool\\.Size", false, null),
        new Property("IceGrid\\.Registry\\.AdminSessionManager\\.ThreadPool\\.SizeMax", false, null),
        new Property("IceGrid\\.Registry\\.AdminSessionManager\\.ThreadPool\\.SizeWarn", false, null),
        new Property("IceGrid\\.Registry\\.AdminSessionManager\\.ThreadPool\\.StackSize", false, null),
        new Property("IceGrid\\.Registry\\.AdminSessionManager\\.ThreadPool\\.Serialize", false, null),
        new Property("IceGrid\\.Registry\\.AdminSSLPermissionsVerifier\\.EndpointSelection", false, null),
        new Property("IceGrid\\.Registry\\.AdminSSLPermissionsVerifier\\.ConnectionCached", false, null),
        new Property("IceGrid\\.Registry\\.AdminSSLPermissionsVerifier\\.PreferSecure", false, null),
        new Property("IceGrid\\.Registry\\.AdminSSLPermissionsVerifier\\.LocatorCacheTimeout", false, null),
        new Property("IceGrid\\.Registry\\.AdminSSLPermissionsVerifier\\.Locator", false, null),
        new Property("IceGrid\\.Registry\\.AdminSSLPermissionsVerifier\\.Router", false, null),
        new Property("IceGrid\\.Registry\\.AdminSSLPermissionsVerifier\\.CollocationOptimization", true, "IceGrid.Registry.AdminSSLPermissionsVerifier.CollocationOptimized"),
        new Property("IceGrid\\.Registry\\.AdminSSLPermissionsVerifier\\.CollocationOptimized", false, null),
        new Property("IceGrid\\.Registry\\.AdminSSLPermissionsVerifier", false, null),
        new Property("IceGrid\\.Registry\\.Client\\.AdapterId", false, null),
        new Property("IceGrid\\.Registry\\.Client\\.Endpoints", false, null),
        new Property("IceGrid\\.Registry\\.Client\\.Locator", false, null),
        new Property("IceGrid\\.Registry\\.Client\\.PublishedEndpoints", false, null),
        new Property("IceGrid\\.Registry\\.Client\\.RegisterProcess", true, null),
        new Property("IceGrid\\.Registry\\.Client\\.ReplicaGroupId", false, null),
        new Property("IceGrid\\.Registry\\.Client\\.Router", false, null),
        new Property("IceGrid\\.Registry\\.Client\\.ProxyOptions", false, null),
        new Property("IceGrid\\.Registry\\.Client\\.ThreadPool\\.Size", false, null),
        new Property("IceGrid\\.Registry\\.Client\\.ThreadPool\\.SizeMax", false, null),
        new Property("IceGrid\\.Registry\\.Client\\.ThreadPool\\.SizeWarn", false, null),
        new Property("IceGrid\\.Registry\\.Client\\.ThreadPool\\.StackSize", false, null),
        new Property("IceGrid\\.Registry\\.Client\\.ThreadPool\\.Serialize", false, null),
        new Property("IceGrid\\.Registry\\.CryptPasswords", false, null),
        new Property("IceGrid\\.Registry\\.Data", false, null),
        new Property("IceGrid\\.Registry\\.DefaultTemplates", false, null),
        new Property("IceGrid\\.Registry\\.DynamicRegistration", false, null),
        new Property("IceGrid\\.Registry\\.Internal\\.AdapterId", false, null),
        new Property("IceGrid\\.Registry\\.Internal\\.Endpoints", false, null),
        new Property("IceGrid\\.Registry\\.Internal\\.Locator", false, null),
        new Property("IceGrid\\.Registry\\.Internal\\.PublishedEndpoints", false, null),
        new Property("IceGrid\\.Registry\\.Internal\\.RegisterProcess", true, null),
        new Property("IceGrid\\.Registry\\.Internal\\.ReplicaGroupId", false, null),
        new Property("IceGrid\\.Registry\\.Internal\\.Router", false, null),
        new Property("IceGrid\\.Registry\\.Internal\\.ProxyOptions", false, null),
        new Property("IceGrid\\.Registry\\.Internal\\.ThreadPool\\.Size", false, null),
        new Property("IceGrid\\.Registry\\.Internal\\.ThreadPool\\.SizeMax", false, null),
        new Property("IceGrid\\.Registry\\.Internal\\.ThreadPool\\.SizeWarn", false, null),
        new Property("IceGrid\\.Registry\\.Internal\\.ThreadPool\\.StackSize", false, null),
        new Property("IceGrid\\.Registry\\.Internal\\.ThreadPool\\.Serialize", false, null),
        new Property("IceGrid\\.Registry\\.NodeSessionTimeout", false, null),
        new Property("IceGrid\\.Registry\\.PermissionsVerifier\\.EndpointSelection", false, null),
        new Property("IceGrid\\.Registry\\.PermissionsVerifier\\.ConnectionCached", false, null),
        new Property("IceGrid\\.Registry\\.PermissionsVerifier\\.PreferSecure", false, null),
        new Property("IceGrid\\.Registry\\.PermissionsVerifier\\.LocatorCacheTimeout", false, null),
        new Property("IceGrid\\.Registry\\.PermissionsVerifier\\.Locator", false, null),
        new Property("IceGrid\\.Registry\\.PermissionsVerifier\\.Router", false, null),
        new Property("IceGrid\\.Registry\\.PermissionsVerifier\\.CollocationOptimization", true, "IceGrid.Registry.PermissionsVerifier.CollocationOptimized"),
        new Property("IceGrid\\.Registry\\.PermissionsVerifier\\.CollocationOptimized", false, null),
        new Property("IceGrid\\.Registry\\.PermissionsVerifier", false, null),
        new Property("IceGrid\\.Registry\\.ReplicaName", false, null),
        new Property("IceGrid\\.Registry\\.ReplicaSessionTimeout", false, null),
        new Property("IceGrid\\.Registry\\.Server\\.AdapterId", false, null),
        new Property("IceGrid\\.Registry\\.Server\\.Endpoints", false, null),
        new Property("IceGrid\\.Registry\\.Server\\.Locator", false, null),
        new Property("IceGrid\\.Registry\\.Server\\.PublishedEndpoints", false, null),
        new Property("IceGrid\\.Registry\\.Server\\.RegisterProcess", true, null),
        new Property("IceGrid\\.Registry\\.Server\\.ReplicaGroupId", false, null),
        new Property("IceGrid\\.Registry\\.Server\\.Router", false, null),
        new Property("IceGrid\\.Registry\\.Server\\.ProxyOptions", false, null),
        new Property("IceGrid\\.Registry\\.Server\\.ThreadPool\\.Size", false, null),
        new Property("IceGrid\\.Registry\\.Server\\.ThreadPool\\.SizeMax", false, null),
        new Property("IceGrid\\.Registry\\.Server\\.ThreadPool\\.SizeWarn", false, null),
        new Property("IceGrid\\.Registry\\.Server\\.ThreadPool\\.StackSize", false, null),
        new Property("IceGrid\\.Registry\\.Server\\.ThreadPool\\.Serialize", false, null),
        new Property("IceGrid\\.Registry\\.SessionFilters", false, null),
        new Property("IceGrid\\.Registry\\.SessionManager\\.AdapterId", false, null),
        new Property("IceGrid\\.Registry\\.SessionManager\\.Endpoints", false, null),
        new Property("IceGrid\\.Registry\\.SessionManager\\.Locator", false, null),
        new Property("IceGrid\\.Registry\\.SessionManager\\.PublishedEndpoints", false, null),
        new Property("IceGrid\\.Registry\\.SessionManager\\.RegisterProcess", true, null),
        new Property("IceGrid\\.Registry\\.SessionManager\\.ReplicaGroupId", false, null),
        new Property("IceGrid\\.Registry\\.SessionManager\\.Router", false, null),
        new Property("IceGrid\\.Registry\\.SessionManager\\.ProxyOptions", false, null),
        new Property("IceGrid\\.Registry\\.SessionManager\\.ThreadPool\\.Size", false, null),
        new Property("IceGrid\\.Registry\\.SessionManager\\.ThreadPool\\.SizeMax", false, null),
        new Property("IceGrid\\.Registry\\.SessionManager\\.ThreadPool\\.SizeWarn", false, null),
        new Property("IceGrid\\.Registry\\.SessionManager\\.ThreadPool\\.StackSize", false, null),
        new Property("IceGrid\\.Registry\\.SessionManager\\.ThreadPool\\.Serialize", false, null),
        new Property("IceGrid\\.Registry\\.SessionTimeout", false, null),
        new Property("IceGrid\\.Registry\\.SSLPermissionsVerifier\\.EndpointSelection", false, null),
        new Property("IceGrid\\.Registry\\.SSLPermissionsVerifier\\.ConnectionCached", false, null),
        new Property("IceGrid\\.Registry\\.SSLPermissionsVerifier\\.PreferSecure", false, null),
        new Property("IceGrid\\.Registry\\.SSLPermissionsVerifier\\.LocatorCacheTimeout", false, null),
        new Property("IceGrid\\.Registry\\.SSLPermissionsVerifier\\.Locator", false, null),
        new Property("IceGrid\\.Registry\\.SSLPermissionsVerifier\\.Router", false, null),
        new Property("IceGrid\\.Registry\\.SSLPermissionsVerifier\\.CollocationOptimization", true, "IceGrid.Registry.SSLPermissionsVerifier.CollocationOptimized"),
        new Property("IceGrid\\.Registry\\.SSLPermissionsVerifier\\.CollocationOptimized", false, null),
        new Property("IceGrid\\.Registry\\.SSLPermissionsVerifier", false, null),
        new Property("IceGrid\\.Registry\\.Trace\\.Application", false, null),
        new Property("IceGrid\\.Registry\\.Trace\\.Adapter", false, null),
        new Property("IceGrid\\.Registry\\.Trace\\.Locator", false, null),
        new Property("IceGrid\\.Registry\\.Trace\\.Node", false, null),
        new Property("IceGrid\\.Registry\\.Trace\\.Object", false, null),
        new Property("IceGrid\\.Registry\\.Trace\\.Patch", false, null),
        new Property("IceGrid\\.Registry\\.Trace\\.Replica", false, null),
        new Property("IceGrid\\.Registry\\.Trace\\.Server", false, null),
        new Property("IceGrid\\.Registry\\.Trace\\.Session", false, null),
        new Property("IceGrid\\.Registry\\.UserAccounts", false, null),
        null
    };

    public static final Property IcePatch2Props[] = 
    {
        new Property("IcePatch2\\.AdapterId", false, null),
        new Property("IcePatch2\\.Endpoints", false, null),
        new Property("IcePatch2\\.Locator", false, null),
        new Property("IcePatch2\\.PublishedEndpoints", false, null),
        new Property("IcePatch2\\.RegisterProcess", true, null),
        new Property("IcePatch2\\.ReplicaGroupId", false, null),
        new Property("IcePatch2\\.Router", false, null),
        new Property("IcePatch2\\.ProxyOptions", false, null),
        new Property("IcePatch2\\.ThreadPool\\.Size", false, null),
        new Property("IcePatch2\\.ThreadPool\\.SizeMax", false, null),
        new Property("IcePatch2\\.ThreadPool\\.SizeWarn", false, null),
        new Property("IcePatch2\\.ThreadPool\\.StackSize", false, null),
        new Property("IcePatch2\\.ThreadPool\\.Serialize", false, null),
        new Property("IcePatch2\\.Admin\\.AdapterId", true, null),
        new Property("IcePatch2\\.Admin\\.Endpoints", true, null),
        new Property("IcePatch2\\.Admin\\.Locator", true, null),
        new Property("IcePatch2\\.Admin\\.PublishedEndpoints", true, null),
        new Property("IcePatch2\\.Admin\\.RegisterProcess", true, null),
        new Property("IcePatch2\\.Admin\\.ReplicaGroupId", true, null),
        new Property("IcePatch2\\.Admin\\.Router", true, null),
        new Property("IcePatch2\\.Admin\\.ThreadPool\\.Size", true, null),
        new Property("IcePatch2\\.Admin\\.ThreadPool\\.SizeMax", true, null),
        new Property("IcePatch2\\.Admin\\.ThreadPool\\.SizeWarn", true, null),
        new Property("IcePatch2\\.Admin\\.ThreadPool\\.StackSize", true, null),
        new Property("IcePatch2\\.ChunkSize", false, null),
        new Property("IcePatch2\\.Directory", false, null),
        new Property("IcePatch2\\.InstanceName", false, null),
        new Property("IcePatch2\\.Remove", false, null),
        new Property("IcePatch2\\.Thorough", false, null),
        null
    };

    public static final Property IceSSLProps[] = 
    {
        new Property("IceSSL\\.Alias", false, null),
        new Property("IceSSL\\.CertAuthDir", false, null),
        new Property("IceSSL\\.CertAuthFile", false, null),
        new Property("IceSSL\\.CertFile", false, null),
        new Property("IceSSL\\.CertVerifier", false, null),
        new Property("IceSSL\\.CheckCertName", false, null),
        new Property("IceSSL\\.CheckCRL", false, null),
        new Property("IceSSL\\.Ciphers", false, null),
        new Property("IceSSL\\.DefaultDir", false, null),
        new Property("IceSSL\\.DH\\.[^\\s]+", false, null),
        new Property("IceSSL\\.EntropyDaemon", false, null),
        new Property("IceSSL\\.FindCert\\.[^\\s]+", false, null),
        new Property("IceSSL\\.ImportCert\\.[^\\s]+", false, null),
        new Property("IceSSL\\.KeyFile", false, null),
        new Property("IceSSL\\.Keystore", false, null),
        new Property("IceSSL\\.KeystorePassword", false, null),
        new Property("IceSSL\\.KeystoreType", false, null),
        new Property("IceSSL\\.Password", false, null),
        new Property("IceSSL\\.PasswordCallback", false, null),
        new Property("IceSSL\\.PasswordRetryMax", false, null),
        new Property("IceSSL\\.Protocols", false, null),
        new Property("IceSSL\\.Random", false, null),
        new Property("IceSSL\\.Trace\\.Security", false, null),
        new Property("IceSSL\\.Truststore", false, null),
        new Property("IceSSL\\.TruststorePassword", false, null),
        new Property("IceSSL\\.TruststoreType", false, null),
        new Property("IceSSL\\.VerifyDepthMax", false, null),
        new Property("IceSSL\\.VerifyPeer", false, null),
        new Property("IceSSL\\.TrustOnly", false, null),
        new Property("IceSSL\\.TrustOnly\\.Client", false, null),
        new Property("IceSSL\\.TrustOnly\\.Server", false, null),
        new Property("IceSSL\\.TrustOnly\\.Server\\.[^\\s]+", false, null),
        null
    };

    public static final Property IceStormAdminProps[] = 
    {
        new Property("IceStormAdmin\\.TopicManager\\.[^\\s]+", false, null),
        null
    };

    public static final Property Glacier2Props[] = 
    {
        new Property("Glacier2\\.AddSSLContext", false, null),
        new Property("Glacier2\\.AddUserToAllowCategories", true, "Glacier2.Filter.Category.AcceptUser"),
        new Property("Glacier2\\.Admin\\.AdapterId", true, null),
        new Property("Glacier2\\.Admin\\.Endpoints", true, null),
        new Property("Glacier2\\.Admin\\.Locator", true, null),
        new Property("Glacier2\\.Admin\\.PublishedEndpoints", true, null),
        new Property("Glacier2\\.Admin\\.RegisterProcess", true, null),
        new Property("Glacier2\\.Admin\\.ReplicaGroupId", true, null),
        new Property("Glacier2\\.Admin\\.Router", true, null),
        new Property("Glacier2\\.Admin\\.ThreadPool\\.Size", true, null),
        new Property("Glacier2\\.Admin\\.ThreadPool\\.SizeMax", true, null),
        new Property("Glacier2\\.Admin\\.ThreadPool\\.SizeWarn", true, null),
        new Property("Glacier2\\.Admin\\.ThreadPool\\.StackSize", true, null),
        new Property("Glacier2\\.AllowCategories", true, "Glacier2.Filter.Category.Accept"),
        new Property("Glacier2\\.Client\\.AdapterId", false, null),
        new Property("Glacier2\\.Client\\.Endpoints", false, null),
        new Property("Glacier2\\.Client\\.Locator", false, null),
        new Property("Glacier2\\.Client\\.PublishedEndpoints", false, null),
        new Property("Glacier2\\.Client\\.RegisterProcess", true, null),
        new Property("Glacier2\\.Client\\.ReplicaGroupId", false, null),
        new Property("Glacier2\\.Client\\.Router", false, null),
        new Property("Glacier2\\.Client\\.ProxyOptions", false, null),
        new Property("Glacier2\\.Client\\.ThreadPool\\.Size", false, null),
        new Property("Glacier2\\.Client\\.ThreadPool\\.SizeMax", false, null),
        new Property("Glacier2\\.Client\\.ThreadPool\\.SizeWarn", false, null),
        new Property("Glacier2\\.Client\\.ThreadPool\\.StackSize", false, null),
        new Property("Glacier2\\.Client\\.ThreadPool\\.Serialize", false, null),
        new Property("Glacier2\\.Client\\.AlwaysBatch", false, null),
        new Property("Glacier2\\.Client\\.Buffered", false, null),
        new Property("Glacier2\\.Client\\.ForwardContext", false, null),
        new Property("Glacier2\\.Client\\.SleepTime", false, null),
        new Property("Glacier2\\.Client\\.Trace\\.Override", false, null),
        new Property("Glacier2\\.Client\\.Trace\\.Reject", false, null),
        new Property("Glacier2\\.Client\\.Trace\\.Request", false, null),
        new Property("Glacier2\\.Filter\\.Address\\.Reject", false, null),
        new Property("Glacier2\\.Filter\\.Address\\.Accept", false, null),
        new Property("Glacier2\\.Filter\\.ProxySizeMax", false, null),
        new Property("Glacier2\\.Filter\\.Category\\.Accept", false, null),
        new Property("Glacier2\\.Filter\\.Category\\.AcceptUser", false, null),
        new Property("Glacier2\\.Filter\\.AdapterId\\.Accept", false, null),
        new Property("Glacier2\\.Filter\\.Identity\\.Accept", false, null),
        new Property("Glacier2\\.CryptPasswords", false, null),
        new Property("Glacier2\\.InstanceName", false, null),
        new Property("Glacier2\\.PermissionsVerifier\\.EndpointSelection", false, null),
        new Property("Glacier2\\.PermissionsVerifier\\.ConnectionCached", false, null),
        new Property("Glacier2\\.PermissionsVerifier\\.PreferSecure", false, null),
        new Property("Glacier2\\.PermissionsVerifier\\.LocatorCacheTimeout", false, null),
        new Property("Glacier2\\.PermissionsVerifier\\.Locator", false, null),
        new Property("Glacier2\\.PermissionsVerifier\\.Router", false, null),
        new Property("Glacier2\\.PermissionsVerifier\\.CollocationOptimization", true, "Glacier2.PermissionsVerifier.CollocationOptimized"),
        new Property("Glacier2\\.PermissionsVerifier\\.CollocationOptimized", false, null),
        new Property("Glacier2\\.PermissionsVerifier", false, null),
        new Property("Glacier2\\.ReturnClientProxy", false, null),
        new Property("Glacier2\\.SSLPermissionsVerifier\\.EndpointSelection", false, null),
        new Property("Glacier2\\.SSLPermissionsVerifier\\.ConnectionCached", false, null),
        new Property("Glacier2\\.SSLPermissionsVerifier\\.PreferSecure", false, null),
        new Property("Glacier2\\.SSLPermissionsVerifier\\.LocatorCacheTimeout", false, null),
        new Property("Glacier2\\.SSLPermissionsVerifier\\.Locator", false, null),
        new Property("Glacier2\\.SSLPermissionsVerifier\\.Router", false, null),
        new Property("Glacier2\\.SSLPermissionsVerifier\\.CollocationOptimization", true, "Glacier2.SSLPermissionsVerifier.CollocationOptimized"),
        new Property("Glacier2\\.SSLPermissionsVerifier\\.CollocationOptimized", false, null),
        new Property("Glacier2\\.SSLPermissionsVerifier", false, null),
        new Property("Glacier2\\.RoutingTable\\.MaxSize", false, null),
        new Property("Glacier2\\.Server\\.AdapterId", false, null),
        new Property("Glacier2\\.Server\\.Endpoints", false, null),
        new Property("Glacier2\\.Server\\.Locator", false, null),
        new Property("Glacier2\\.Server\\.PublishedEndpoints", false, null),
        new Property("Glacier2\\.Server\\.RegisterProcess", true, null),
        new Property("Glacier2\\.Server\\.ReplicaGroupId", false, null),
        new Property("Glacier2\\.Server\\.Router", false, null),
        new Property("Glacier2\\.Server\\.ProxyOptions", false, null),
        new Property("Glacier2\\.Server\\.ThreadPool\\.Size", false, null),
        new Property("Glacier2\\.Server\\.ThreadPool\\.SizeMax", false, null),
        new Property("Glacier2\\.Server\\.ThreadPool\\.SizeWarn", false, null),
        new Property("Glacier2\\.Server\\.ThreadPool\\.StackSize", false, null),
        new Property("Glacier2\\.Server\\.ThreadPool\\.Serialize", false, null),
        new Property("Glacier2\\.Server\\.AlwaysBatch", false, null),
        new Property("Glacier2\\.Server\\.Buffered", false, null),
        new Property("Glacier2\\.Server\\.ForwardContext", false, null),
        new Property("Glacier2\\.Server\\.SleepTime", false, null),
        new Property("Glacier2\\.Server\\.Trace\\.Override", false, null),
        new Property("Glacier2\\.Server\\.Trace\\.Request", false, null),
        new Property("Glacier2\\.SessionManager\\.EndpointSelection", false, null),
        new Property("Glacier2\\.SessionManager\\.ConnectionCached", false, null),
        new Property("Glacier2\\.SessionManager\\.PreferSecure", false, null),
        new Property("Glacier2\\.SessionManager\\.LocatorCacheTimeout", false, null),
        new Property("Glacier2\\.SessionManager\\.Locator", false, null),
        new Property("Glacier2\\.SessionManager\\.Router", false, null),
        new Property("Glacier2\\.SessionManager\\.CollocationOptimization", true, "Glacier2.SessionManager.CollocationOptimized"),
        new Property("Glacier2\\.SessionManager\\.CollocationOptimized", false, null),
        new Property("Glacier2\\.SessionManager", false, null),
        new Property("Glacier2\\.SSLSessionManager\\.EndpointSelection", false, null),
        new Property("Glacier2\\.SSLSessionManager\\.ConnectionCached", false, null),
        new Property("Glacier2\\.SSLSessionManager\\.PreferSecure", false, null),
        new Property("Glacier2\\.SSLSessionManager\\.LocatorCacheTimeout", false, null),
        new Property("Glacier2\\.SSLSessionManager\\.Locator", false, null),
        new Property("Glacier2\\.SSLSessionManager\\.Router", false, null),
        new Property("Glacier2\\.SSLSessionManager\\.CollocationOptimization", true, "Glacier2.SSLSessionManager.CollocationOptimized"),
        new Property("Glacier2\\.SSLSessionManager\\.CollocationOptimized", false, null),
        new Property("Glacier2\\.SSLSessionManager", false, null),
        new Property("Glacier2\\.SessionTimeout", false, null),
        new Property("Glacier2\\.Trace\\.RoutingTable", false, null),
        new Property("Glacier2\\.Trace\\.Session", false, null),
        null
    };

    public static final Property FreezeProps[] = 
    {
        new Property("Freeze\\.DbEnv\\.[^\\s]+\\.CheckpointPeriod", false, null),
        new Property("Freeze\\.DbEnv\\.[^\\s]+\\.DbHome", false, null),
        new Property("Freeze\\.DbEnv\\.[^\\s]+\\.DbPrivate", false, null),
        new Property("Freeze\\.DbEnv\\.[^\\s]+\\.DbRecoverFatal", false, null),
        new Property("Freeze\\.DbEnv\\.[^\\s]+\\.OldLogsAutoDelete", false, null),
        new Property("Freeze\\.DbEnv\\.[^\\s]+\\.PeriodicCheckpointMinSize", false, null),
        new Property("Freeze\\.Evictor\\.[^\\s]+\\.BtreeMinKey", false, null),
        new Property("Freeze\\.Evictor\\.[^\\s]+\\.Checksum", false, null),
        new Property("Freeze\\.Evictor\\.[^\\s]+\\.MaxTxSize", false, null),
        new Property("Freeze\\.Evictor\\.[^\\s]+\\.PageSize", false, null),
        new Property("Freeze\\.Evictor\\.[^\\s]+\\.PopulateEmptyIndices", false, null),
        new Property("Freeze\\.Evictor\\.[^\\s]+\\.RollbackOnUserException", false, null),
        new Property("Freeze\\.Evictor\\.[^\\s]+\\.SavePeriod", false, null),
        new Property("Freeze\\.Evictor\\.[^\\s]+\\.SaveSizeTrigger", false, null),
        new Property("Freeze\\.Evictor\\.[^\\s]+\\.StreamTimeout", false, null),
        new Property("Freeze\\.Evictor\\.UseNonmutating", false, null),
        new Property("Freeze\\.Map\\.[^\\s]+\\.BtreeMinKey", false, null),
        new Property("Freeze\\.Map\\.[^\\s]+\\.Checksum", false, null),
        new Property("Freeze\\.Map\\.[^\\s]+\\.PageSize", false, null),
        new Property("Freeze\\.Trace\\.DbEnv", false, null),
        new Property("Freeze\\.Trace\\.Evictor", false, null),
        new Property("Freeze\\.Trace\\.Map", false, null),
        new Property("Freeze\\.Trace\\.Transaction", false, null),
        new Property("Freeze\\.Warn\\.CloseInFinalize", false, null),
        new Property("Freeze\\.Warn\\.Deadlocks", false, null),
        new Property("Freeze\\.Warn\\.Rollback", false, null),
        null
    };


    public static final Property[] validProps[] =
    {
        IceProps,
        IceBoxProps,
        IceBoxAdminProps,
        IceGridAdminProps,
        IceGridProps,
        IcePatch2Props,
        IceSSLProps,
        IceStormAdminProps,
        Glacier2Props,
        FreezeProps,
        null
    };

    public static final String clPropNames[] =
    {
        "Ice",
        "IceBox",
        "IceBoxAdmin",
        "IceGridAdmin",
        "IceGrid",
        "IcePatch2",
        "IceSSL",
        "IceStormAdmin",
        "Glacier2",
        "Freeze",
        null
    };
}
