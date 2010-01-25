// **********************************************************************
//
// Copyright (c) 2003-2010 ZeroC, Inc. All rights reserved.
//
// This copy of Ice is licensed to you under the terms described in the
// ICE_LICENSE file included in this distribution.
//
// **********************************************************************

#include <Ice/Ice.h>
#include <IcePatch2/Util.h>
#include <IceGrid/Util.h>
#include <IceGrid/Admin.h>

using namespace std;
using namespace IceGrid;

string 
IceGrid::toString(const vector<string>& v, const string& sep)
{
    ostringstream os;
    Ice::StringSeq::const_iterator p = v.begin();
    while(p != v.end())
    {
        os << *p;
        ++p;
        if(p != v.end())
        {
            os << sep;
        }
    }
    return os.str();
}

string
IceGrid::toString(const Ice::Exception& exception)
{
    std::ostringstream os;
    try
    {
        exception.ice_throw();
    }
    catch(const NodeUnreachableException& ex)
    {
        os << ex << ":";
        os << "\nnode: " << ex.name;
        os << "\nreason: " << ex.reason;
    }
    catch(const DeploymentException& ex)
    {
        os << ex << ":";
        os << "\nreason: " << ex.reason;
    }
    catch(const Ice::Exception& ex)
    {
        os << ex;
    }
    return os.str();
}

string
IceGrid::getProperty(const PropertyDescriptorSeq& properties, const string& name, const string& def)
{    
    string result = def;

    for(PropertyDescriptorSeq::const_iterator q = properties.begin(); q != properties.end(); ++q)
    {
        if(q->name == name)
        {
            result = q->value;
        }
    }
    return result;
}

bool
IceGrid::hasProperty(const PropertyDescriptorSeq& properties, const string& name)
{    
    for(PropertyDescriptorSeq::const_iterator q = properties.begin(); q != properties.end(); ++q)
    {
        if(q->name == name)
        {
            return true;
        }
    }
    return false;
}

PropertyDescriptor
IceGrid::createProperty(const string& name, const string& value)
{
    PropertyDescriptor prop;
    prop.name = name;
    prop.value = value;
    return prop;
}

string
IceGrid::escapeProperty(const string& s)
{
    size_t firstChar = s.find_first_not_of(' ');
    size_t lastChar = s.find_last_not_of(' ');
    string result;
    for(unsigned int i = 0; i < s.size(); ++i)
    {
        char c = s[i];
        switch(c)
        {
          case ' ':
            if(i < firstChar || i > lastChar)
            {
                result.push_back('\\');
            }
            result.push_back(c);
            break;

          case '\\':
          case '#':
          case '=':
            result.push_back('\\');
            result.push_back(c);
            break;

          default:
            result.push_back(c);
            break;
        }
    }
    return result;
}

int
IceGrid::getMMVersion(const string& o)
{
    //
    // Strip the version
    //
    string::size_type beg = o.find_first_not_of(' ');
    string::size_type end = o.find_last_not_of(' ');
    string version = o.substr(beg == string::npos ? 0 : beg, end == string::npos ? o.length() - 1 : end - beg + 1);

    string::size_type minorPos = version.find('.');
    string::size_type patchPos = version.find('.', minorPos + 1);

    if(minorPos != 1 && minorPos != 2)
    {
        return -1;
    }

    if(patchPos != string::npos)
    { 
        if((minorPos == 1 && patchPos != 3 && patchPos != 4) || (minorPos == 2 && patchPos != 4 && patchPos != 5))
        {
            return -1;
        }
        else if((version.size() - patchPos - 1) > 2)
        {
            return -1;
        }
    }
    else if((version.size() - minorPos - 1) > 2)
    {
        return -1;
    }

    int v, ver;

    istringstream major(version.substr(0, minorPos));
    major >> v;
    if(major.fail() || v > 99 || v < 1)
    {
        return -1;
    }
    ver = v;
    ver *= 100;

    istringstream minor(version.substr(minorPos + 1, patchPos != string::npos ? patchPos : version.size()));
    minor >> v;
    if(minor.fail() || v > 99 || v < 0)
    {
        return -1;
    }
    ver += v;
    ver *= 100;

    //
    // No need to get the patch number, we're only interested in
    // MAJOR.MINOR
    //
    //     if(patchPos != string::npos)
    //     {
    //      istringstream patch(version.substr(patchPos + 1));
    //      patch >> v;
    //      if(patch.fail() || v > 99 || v < 0)
    //      {
    //          return -1;
    //      }
    //      ver += v;
    //     }
    
    return ver;
}
