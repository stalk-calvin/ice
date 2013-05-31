// **********************************************************************
//
// Copyright (c) 2003-2013 ZeroC, Inc. All rights reserved.
//
// This copy of Ice is licensed to you under the terms described in the
// ICE_LICENSE file included in this distribution.
//
// **********************************************************************

#include <IceSSL/EndpointI.h>
#include <IceSSL/AcceptorI.h>
#include <IceSSL/ConnectorI.h>
#include <IceSSL/TransceiverI.h>
#include <IceSSL/Instance.h>
#include <Ice/BasicStream.h>
#include <Ice/LocalException.h>
#include <Ice/DefaultsAndOverrides.h>
#include <Ice/Object.h>
#include <Ice/HashUtil.h>

using namespace std;
using namespace Ice;
using namespace IceSSL;

IceSSL::EndpointI::EndpointI(const InstancePtr& instance, const string& ho, Int po, Int ti, const string& conId, 
                             bool co) :
    IceInternal::EndpointI(conId),
    _instance(instance),
    _host(ho),
    _port(po),
    _timeout(ti),
    _compress(co)
{
}

IceSSL::EndpointI::EndpointI(const InstancePtr& instance, vector<string>& args, bool oaEndpoint) :
    IceInternal::EndpointI(""),
    _instance(instance),
    _port(0),
    _timeout(-1),
    _compress(false)
{
    vector<string> unknown;

    ostringstream ostr;
    for(vector<string>::iterator p = args.begin(); p != args.end(); ++p)
    {
        if(p->find_first_of(" \t\n\r") != string::npos)
        {
            ostr << " \"" << *p << "\"";
        }
        else
        {
            ostr << " " << *p;
        }
    }
    const string str = ostr.str();

    for(vector<string>::size_type n = 0; n < args.size(); ++n)
    {
        string option = args[n];
        if(option.length() != 2 || option[0] != '-')
        {
            unknown.push_back(option);
            continue;
        }

        string argument;
        if(n + 1 < args.size() && args[n + 1][0] != '-')
        {
            argument = args[++n];
        }

        switch(option[1])
        {
            case 'h':
            {
                if(argument.empty())
                {
                    EndpointParseException ex(__FILE__, __LINE__);
                    ex.str = "no argument provided for -h option in endpoint `ssl" + str + "'";
                    throw ex;
                }
                const_cast<string&>(_host) = argument;
                break;
            }

            case 'p':
            {
                if(argument.empty())
                {
                    EndpointParseException ex(__FILE__, __LINE__);
                    ex.str = "no argument provided for -p option in endpoint `ssl" + str + "'";
                    throw ex;
                }
                istringstream p(argument);
                if(!(p >> const_cast<Int&>(_port)) || !p.eof())
                {
                    EndpointParseException ex(__FILE__, __LINE__);
                    ex.str = "invalid port value `" + argument + "' in endpoint `ssl" + str + "'";
                    throw ex;
                }
                else if(_port < 0 || _port > 65535)
                {
                    EndpointParseException ex(__FILE__, __LINE__);
                    ex.str = "port value `" + argument + "' out of range in endpoint `ssl" + str + "'";
                    throw ex;
                }
                break;
            }

            case 't':
            {
                if(argument.empty())
                {
                    EndpointParseException ex(__FILE__, __LINE__);
                    ex.str = "no argument provided for -t option in endpoint `ssl" + str + "'";
                    throw ex;
                }
                istringstream t(argument);
                if(!(t >> const_cast<Int&>(_timeout)) || !t.eof())
                {
                    EndpointParseException ex(__FILE__, __LINE__);
                    ex.str = "invalid timeout value `" + argument + "' in endpoint `ssl" + str + "'";
                    throw ex;
                }
                break;
            }

            case 'z':
            {
                if(!argument.empty())
                {
                    EndpointParseException ex(__FILE__, __LINE__);
                    ex.str = "unexpected argument `" + argument + "' provided for -z option in `ssl" + str + "'";
                    throw ex;
                }
                const_cast<bool&>(_compress) = true;
                break;
            }

            default:
            {
                unknown.push_back(option);
                if(!argument.empty())
                {
                    unknown.push_back(argument);
                }
                break;
            }
        }
    }

    if(_host.empty())
    {
        const_cast<string&>(_host) = _instance->defaultHost();
    }
    else if(_host == "*")
    {
        if(oaEndpoint)
        {
            const_cast<string&>(_host) = string();
        }
        else
        {
            EndpointParseException ex(__FILE__, __LINE__);
            ex.str = "`-h *' not valid for proxy endpoint `ssl" + str + "'";
            throw ex;
        }
    }

    //
    // Replace argument vector with only those we didn't recognize.
    //
    args = unknown;
}

IceSSL::EndpointI::EndpointI(const InstancePtr& instance, IceInternal::BasicStream* s) :
    _instance(instance),
    _port(0),
    _timeout(-1),
    _compress(false)
{
    s->read(const_cast<string&>(_host), false);
    s->read(const_cast<Int&>(_port));
    s->read(const_cast<Int&>(_timeout));
    s->read(const_cast<bool&>(_compress));
}

void
IceSSL::EndpointI::startStreamWrite(IceInternal::BasicStream* s) const
{
    s->startWriteEncaps();
}

void
IceSSL::EndpointI::streamWrite(IceInternal::BasicStream* s) const
{
    s->write(_host, false);
    s->write(_port);
    s->write(_timeout);
    s->write(_compress);
}

void
IceSSL::EndpointI::endStreamWrite(IceInternal::BasicStream* s) const
{
    s->endWriteEncaps();
}

string
IceSSL::EndpointI::toString() const
{
    //
    // WARNING: Certain features, such as proxy validation in Glacier2,
    // depend on the format of proxy strings. Changes to toString() and
    // methods called to generate parts of the reference string could break
    // these features. Please review for all features that depend on the
    // format of proxyToString() before changing this and related code.
    //
    return protocol() + options();
}

Ice::EndpointInfoPtr
IceSSL::EndpointI::getInfo() const
{
    class InfoI : public IceSSL::EndpointInfo
    {
    public:

        InfoI(Int to, bool comp, const string& host, Int port) : IceSSL::EndpointInfo(to, comp, host, port)
        {
        }

        virtual Short
        type() const
        {
            return EndpointType;
        }
        
        virtual bool
        datagram() const
        {
            return false;
        }

        virtual bool
        secure() const
        {
            return true;
        }
    };
    return new InfoI(_timeout, _compress, _host, _port);
}

Short
IceSSL::EndpointI::type() const
{
    return EndpointType;
}

std::string
IceSSL::EndpointI::protocol() const
{
    return "ssl";
}

Int
IceSSL::EndpointI::timeout() const
{
    return _timeout;
}

IceInternal::EndpointIPtr
IceSSL::EndpointI::timeout(Int timeout) const
{
    if(timeout == _timeout)
    {
        return const_cast<EndpointI*>(this);
    }
    else
    {
        return new EndpointI(_instance, _host, _port, timeout, _connectionId, _compress);
    }
}

IceInternal::EndpointIPtr
IceSSL::EndpointI::connectionId(const string& connectionId) const
{
    if(connectionId == _connectionId)
    {
        return const_cast<EndpointI*>(this);
    }
    else
    {
        return new EndpointI(_instance, _host, _port, _timeout, connectionId, _compress);
    }
}

bool
IceSSL::EndpointI::compress() const
{
    return _compress;
}

IceInternal::EndpointIPtr
IceSSL::EndpointI::compress(bool compress) const
{
    if(compress == _compress)
    {
        return const_cast<EndpointI*>(this);
    }
    else
    {
        return new EndpointI(_instance, _host, _port, _timeout, _connectionId, compress);
    }
}

bool
IceSSL::EndpointI::datagram() const
{
    return false;
}

bool
IceSSL::EndpointI::secure() const
{
    return true;
}

IceInternal::TransceiverPtr
IceSSL::EndpointI::transceiver(IceInternal::EndpointIPtr& endp) const
{
    endp = const_cast<EndpointI*>(this);
    return 0;
}

vector<IceInternal::ConnectorPtr>
IceSSL::EndpointI::connectors(Ice::EndpointSelectionType selType) const
{
    return _instance->endpointHostResolver()->resolve(_host, _port, selType, const_cast<EndpointI*>(this));
}

void
IceSSL::EndpointI::connectors_async(Ice::EndpointSelectionType selType, 
                                    const IceInternal::EndpointI_connectorsPtr& callback) const
{
    _instance->endpointHostResolver()->resolve(_host, _port, selType, const_cast<EndpointI*>(this), callback);
}

IceInternal::AcceptorPtr
IceSSL::EndpointI::acceptor(IceInternal::EndpointIPtr& endp, const string& adapterName) const
{
    AcceptorI* p = new AcceptorI(_instance, adapterName, _host, _port);
    endp = new EndpointI(_instance, _host, p->effectivePort(), _timeout, _connectionId, _compress);
    return p;
}

vector<IceInternal::EndpointIPtr>
IceSSL::EndpointI::expand() const
{
    vector<IceInternal::EndpointIPtr> endps;
    vector<string> hosts = IceInternal::getHostsForEndpointExpand(_host, _instance->protocolSupport(), false);
    if(hosts.empty())
    {
        endps.push_back(const_cast<EndpointI*>(this));
    }
    else
    {
        for(vector<string>::const_iterator p = hosts.begin(); p != hosts.end(); ++p)
        {
            endps.push_back(new EndpointI(_instance, *p, _port, _timeout, _connectionId, _compress));
        }
    }
    return endps;
}

bool
IceSSL::EndpointI::equivalent(const IceInternal::EndpointIPtr& endpoint) const
{
    const EndpointI* sslEndpointI = dynamic_cast<const EndpointI*>(endpoint.get());
    if(!sslEndpointI)
    {
        return false;
    }
    return sslEndpointI->_host == _host && sslEndpointI->_port == _port;
}

vector<IceInternal::ConnectorPtr>
IceSSL::EndpointI::connectors(const vector<IceInternal::Address>& addresses,
                              const IceInternal::NetworkProxyPtr& proxy) const
{
    vector<IceInternal::ConnectorPtr> connectors;
    for(unsigned int i = 0; i < addresses.size(); ++i)
    {
        connectors.push_back(new ConnectorI(_instance, _host, addresses[i], proxy, _timeout, _connectionId));
    }
    return connectors;
}

bool
IceSSL::EndpointI::operator==(const Ice::LocalObject& r) const
{
    const EndpointI* p = dynamic_cast<const EndpointI*>(&r);
    if(!p)
    {
        return false;
    }

    if(this == p)
    {
        return true;
    }

    if(_host != p->_host)
    {
        return false;
    }

    if(_port != p->_port)
    {
        return false;
    }

    if(_timeout != p->_timeout)
    {
        return false;
    }

    if(_connectionId != p->_connectionId)
    {
        return false;
    }

    if(_compress != p->_compress)
    {
        return false;
    }

    return true;
}

bool
IceSSL::EndpointI::operator<(const Ice::LocalObject& r) const
{
    const EndpointI* p = dynamic_cast<const EndpointI*>(&r);
    if(!p)
    {
        const IceInternal::EndpointI* e = dynamic_cast<const IceInternal::EndpointI*>(&r);
        if(!e)
        {
            return false;
        }
        return type() < e->type();
    }

    if(this == p)
    {
        return false;
    }

    if(_host < p->_host)
    {
        return true;
    }
    else if (p->_host < _host)
    {
        return false;
    }

    if(_port < p->_port)
    {
        return true;
    }
    else if(p->_port < _port)
    {
        return false;
    }

    if(_timeout < p->_timeout)
    {
        return true;
    }
    else if(p->_timeout < _timeout)
    {
        return false;
    }

    if(_connectionId < p->_connectionId)
    {
        return true;
    }
    else if(p->_connectionId < _connectionId)
    {
        return false;
    }

    if(!_compress && p->_compress)
    {
        return true;
    }
    else if(p->_compress < _compress)
    {
        return false;
    }

    return false;
}

void
IceSSL::EndpointI::hashInit(Ice::Int& h) const
{
    IceInternal::hashAdd(h, _host);
    IceInternal::hashAdd(h, _port);
    IceInternal::hashAdd(h, _timeout);
    IceInternal::hashAdd(h, _connectionId);
    IceInternal::hashAdd(h, _compress);
}

string
IceSSL::EndpointI::options() const
{
    //
    // WARNING: Certain features, such as proxy validation in Glacier2,
    // depend on the format of proxy strings. Changes to toString() and
    // methods called to generate parts of the reference string could break
    // these features. Please review for all features that depend on the
    // format of proxyToString() before changing this and related code.
    //
    ostringstream s;

    if(!_host.empty())
    {
        s << " -h ";
        bool addQuote = _host.find(':') != string::npos;
        if(addQuote)
        {
            s << "\"";
        }
        s << _host;
        if(addQuote)
        {
            s << "\"";
        }
    }

    s << " -p " << _port;

    if(_timeout != -1)
    {
        s << " -t " << _timeout;
    }

    if(_compress)
    {
        s << " -z";
    }

    return s.str();
}

IceSSL::EndpointFactoryI::EndpointFactoryI(const InstancePtr& instance)
    : _instance(instance)
{
}

IceSSL::EndpointFactoryI::~EndpointFactoryI()
{
}

Short
IceSSL::EndpointFactoryI::type() const
{
    return EndpointType;
}

string
IceSSL::EndpointFactoryI::protocol() const
{
    return "ssl";
}

IceInternal::EndpointIPtr
IceSSL::EndpointFactoryI::create(vector<string>& args, bool oaEndpoint) const
{
    return new EndpointI(_instance, args, oaEndpoint);
}

IceInternal::EndpointIPtr
IceSSL::EndpointFactoryI::read(IceInternal::BasicStream* s) const
{
    return new EndpointI(_instance, s);
}

void
IceSSL::EndpointFactoryI::destroy()
{
    _instance = 0;
}
