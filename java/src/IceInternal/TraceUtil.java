// **********************************************************************
//
// Copyright (c) 2001
// MutableRealms, Inc.
// Huntsville, AL, USA
//
// All Rights Reserved
//
// **********************************************************************

package IceInternal;

final class TraceUtil
{
    static void
    traceHeader(String heading, BasicStream stream, Ice.Logger logger,
                TraceLevels tl)
    {
        if (tl.protocol >= 1)
        {
            int pos = stream.pos();
            stream.pos(0);
            java.io.StringWriter s = new java.io.StringWriter();
            s.write(heading);
            printHeader(s, stream);
            logger.trace(tl.protocolCat, s.toString());
            stream.pos(pos);
        }
    }

    static void
    traceRequest(String heading, BasicStream stream, Ice.Logger logger,
                 TraceLevels tl)
    {
        if (tl.protocol >= 1)
        {
            int pos = stream.pos();
            stream.pos(0);
            java.io.StringWriter s = new java.io.StringWriter();
            s.write(heading);
            printHeader(s, stream);
            int requestId = stream.readInt();
            s.write("\nrequest id = " + requestId);
            if (requestId == 0)
            {
                s.write(" (oneway)");
            }
            String identity = stream.readString();
            s.write("\nidentity = " + identity);
            String facet = stream.readString();
            s.write("\nfacet = " + facet);
            String operation = stream.readString();
            s.write("\noperation name = " + operation);
            logger.trace(tl.protocolCat, s.toString());
            stream.pos(pos);
        }
    }

    static void
    traceBatchRequest(String heading, BasicStream stream, Ice.Logger logger,
                      TraceLevels tl)
    {
        if (tl.protocol >= 1)
        {
            int pos = stream.pos();
            stream.pos(0);
            java.io.StringWriter s = new java.io.StringWriter();
            s.write(heading);
            printHeader(s, stream);
            int cnt = 0;
            while (stream.pos() != pos)
            {
                s.write("\nrequest #" + cnt + ':');
                cnt++;
                int pos2 = stream.pos();
                stream.startReadEncaps();
                String identity = stream.readString();
                s.write("\nidentity = " + identity);
                String facet = stream.readString();
                s.write("\nfacet = " + facet);
                String operation = stream.readString();
                s.write("\noperation name = " + operation);
                stream.pos(pos2);
                stream.skipEncaps();
            }
            logger.trace(tl.protocolCat, s.toString());
            stream.pos(pos);
        }
    }

    static void
    traceReply(String heading, BasicStream stream, Ice.Logger logger,
               TraceLevels tl)
    {
        if (tl.protocol >= 1)
        {
            int pos = stream.pos();
            stream.pos(0);
            java.io.StringWriter s = new java.io.StringWriter();
            s.write(heading);
            printHeader(s, stream);
            int requestId = stream.readInt();
            s.write("\nrequest id = " + requestId);
            byte status = stream.readByte();
            s.write("\nreply status = " + (int)status + ' ');
            switch (status)
            {
                case DispatchStatus._DispatchOK:
                {
                    s.write("(ok)");
                    break;
                }
                case DispatchStatus._DispatchUserException:
                {
                    s.write("(user exception)");
                    break;
                }
                case DispatchStatus._DispatchLocationForward:
                {
                    s.write("(location forward)");
                    break;
                }
                case DispatchStatus._DispatchObjectNotExist:
                {
                    s.write("(object not exist)");
                    break;
                }
                case DispatchStatus._DispatchOperationNotExist:
                {
                    s.write("(operation not exist)");
                    break;
                }
                case DispatchStatus._DispatchUnknownLocalException:
                {
                    s.write("(unknown local exception)");
                    break;
                }
                case DispatchStatus._DispatchUnknownException:
                {
                    s.write("(unknown exception)");
                    break;
                }
                default:
                {
                    s.write("(unknown)");
                    break;
                }
            }
            logger.trace(tl.protocolCat, s.toString());
            stream.pos(pos);
        }
    }

    private static void
    printHeader(java.io.Writer out, BasicStream stream)
    {
        try
        {
            byte protVer = stream.readByte();
            out.write("\nprotocol version = " + (int)protVer);
            byte encVer = stream.readByte();
            out.write("\nencoding version = " + (int)encVer);
            byte type = stream.readByte();
            out.write("\nmessage type = " + (int)type + ' ');
            switch (type)
            {
                case Protocol.requestMsg:
                {
                    out.write("(request)");
                    break;
                }
                case Protocol.requestBatchMsg:
                {
                    out.write("(batch request)");
                    break;
                }
                case Protocol.replyMsg:
                {
                    out.write("(reply)");
                    break;
                }
                case Protocol.closeConnectionMsg:
                {
                    out.write("(close connection)");
                    break;
                }
                default:
                {
                    out.write("(unknown)");
                    break;
                }
            }
            int size = stream.readInt();
            out.write("\nmessage size = " + size);
        }
        catch (java.io.IOException ex)
        {
            assert(false);
        }
    }
}
