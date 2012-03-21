// **********************************************************************
//
// Copyright (c) 2003-2011 ZeroC, Inc. All rights reserved.
//
// This copy of Ice is licensed to you under the terms described in the
// ICE_LICENSE file included in this distribution.
//
// **********************************************************************

using System;

#if SILVERLIGHT
using System.Net;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Documents;
using System.Windows.Ink;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Animation;
using System.Windows.Shapes;
#endif

public class AllTests : TestCommon.TestApp
{
#if SILVERLIGHT
    public AllTests(TextBox output, Button btnRun)
        : base(output, btnRun)
    {
    }

    override
    public void run(Ice.Communicator communicator)
#else
    public static void allTests()
#endif
    {
        Write("testing default values... ");
        Flush();

        {
            Test.Struct1 v = new Test.Struct1();
            test(!v.boolFalse);
            test(v.boolTrue);
            test(v.b == 254);
            test(v.s == 16000);
            test(v.i == 3);
            test(v.l == 4);
            test(v.f == (float)5.1);
            test(v.d == 6.2);
            test(v.str.Equals("foo \\ \"bar\n \r\n\t\u000b\f\u0007\b? \u0007 \u0007"));
            test(v.c1 == Test.Color.red);
            test(v.c2 == Test.Color.green);
            test(v.c3 == Test.Color.blue);
            test(v.nc1 == Test.Nested.Color.red);
            test(v.nc2 == Test.Nested.Color.green);
            test(v.nc3 == Test.Nested.Color.blue);
            test(v.noDefault == null);
        }

        {
            Test.Struct2 v = new Test.Struct2();
            test(v.boolTrue == Test.ConstBool.value);
            test(v.b == Test.ConstByte.value);
            test(v.s == Test.ConstShort.value);
            test(v.i == Test.ConstInt.value);
            test(v.l == Test.ConstLong.value);
            test(v.f == Test.ConstFloat.value);
            test(v.d == Test.ConstDouble.value);
            test(v.str.Equals(Test.ConstString.value));
            test(v.c1 == Test.ConstColor1.value);
            test(v.c2 == Test.ConstColor2.value);
            test(v.c3 == Test.ConstColor3.value);
            test(v.nc1 == Test.ConstNestedColor1.value);
            test(v.nc2 == Test.ConstNestedColor2.value);
            test(v.nc3 == Test.ConstNestedColor3.value);
        }

        {
            Test.Struct3 v = new Test.Struct3();
            test(!v.boolFalse);
            test(v.boolTrue);
            test(v.b == 1);
            test(v.s == 2);
            test(v.i == 3);
            test(v.l == 4);
            test(v.f == 5.1F);
            test(v.d == 6.2);
            //test(v.str.Equals("foo \\ \"bar\n \r\n\t\u000b\f\u0007\b? \u0007 \u0007"));
            //test(v.str.Equals("foo bar"));
            test(v.c1 == Test.Color.red);
            test(v.c2 == Test.Color.green);
            test(v.c3 == Test.Color.blue);
            test(v.nc1 == Test.Nested.Color.red);
            test(v.nc2 == Test.Nested.Color.green);
            test(v.nc3 == Test.Nested.Color.blue);
            //test(v.noDefault == null);
        }

        {
            Test.Base v = new Test.Base();
            test(!v.boolFalse);
            test(v.boolTrue);
            test(v.b == 1);
            test(v.s == 2);
            test(v.i == 3);
            test(v.l == 4);
            test(v.f == 5.1F);
            test(v.d == 6.2);
            test(v.str.Equals("foo \\ \"bar\n \r\n\t\u000b\f\u0007\b? \u0007 \u0007"));
            test(v.noDefault == null);
        }

        {
            Test.Derived v = new Test.Derived();
            test(!v.boolFalse);
            test(v.boolTrue);
            test(v.b == 1);
            test(v.s == 2);
            test(v.i == 3);
            test(v.l == 4);
            test(v.f == 5.1F);
            test(v.d == 6.2);
            test(v.str.Equals("foo \\ \"bar\n \r\n\t\u000b\f\u0007\b? \u0007 \u0007"));
            test(v.c1 == Test.Color.red);
            test(v.c2 == Test.Color.green);
            test(v.c3 == Test.Color.blue);
            test(v.nc1 == Test.Nested.Color.red);
            test(v.nc2 == Test.Nested.Color.green);
            test(v.nc3 == Test.Nested.Color.blue);
            test(v.noDefault == null);
        }

        {
            Test.BaseEx v = new Test.BaseEx();
            test(!v.boolFalse);
            test(v.boolTrue);
            test(v.b == 1);
            test(v.s == 2);
            test(v.i == 3);
            test(v.l == 4);
            test(v.f == 5.1F);
            test(v.d == 6.2);
            test(v.str == "foo \\ \"bar\n \r\n\t\u000b\f\u0007\b? \u0007 \u0007");
            test(v.noDefault == null);
        }

        {
            Test.DerivedEx v = new Test.DerivedEx();
            test(!v.boolFalse);
            test(v.boolTrue);
            test(v.b == 1);
            test(v.s == 2);
            test(v.i == 3);
            test(v.l == 4);
            test(v.f == 5.1F);
            test(v.d == 6.2);
            test(v.str == "foo \\ \"bar\n \r\n\t\u000b\f\u0007\b? \u0007 \u0007");
            test(v.noDefault == null);
            test(v.c1 == Test.Color.red);
            test(v.c2 == Test.Color.green);
            test(v.c3 == Test.Color.blue);
            test(v.nc1 == Test.Nested.Color.red);
            test(v.nc2 == Test.Nested.Color.green);
            test(v.nc3 == Test.Nested.Color.blue);
        }

        {
            Test.ClassProperty v = new Test.ClassProperty();
            test(!v.boolFalse);
            test(v.boolTrue);
            test(v.b == 1);
            test(v.s == 2);
            test(v.i == 3);
            test(v.l == 4);
            test(v.f == 5.1F);
            test(v.d == 6.2);
            test(v.str.Equals("foo bar"));
            test(v.noDefault == null);
        }

        {
            Test.StructProperty v = new Test.StructProperty();
            test(!v.boolFalse);
            test(v.boolTrue);
            test(v.b == 1);
            test(v.s == 2);
            test(v.i == 3);
            test(v.l == 4);
            test(v.f == 5.1F);
            test(v.d == 6.2);
        }

        {
            Test.ExceptionProperty v = new Test.ExceptionProperty();
            test(!v.boolFalse);
            test(v.boolTrue);
            test(v.b == 1);
            test(v.s == 2);
            test(v.i == 3);
            test(v.l == 4);
            test(v.f == 5.1F);
            test(v.d == 6.2);
            test(v.str.Equals("foo bar"));
            test(v.noDefault == null);
        }

        WriteLine("ok");
    }
}
