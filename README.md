NetworkTimeoutSample
====================

DESCRIPTION
--------------------

Test code for checking timeout value effects in NSURLConnection/NSURLSession.


PLATFORM
--------------------

iOS 7 and above.  You have to enable ARC.


CLIENT USAGE
--------------------

1. Enter URL in 'url' field you'd like to connect.
   e.g. : http://www.google.com/

2. For NSURLConnection + NSURLRequest timeout test, enter
   timeout value in 'URLReq' field, then click
   'NSURLConnection' button.

3. For NSURLSession + NSURLSessionConfiguration timeout
   test, enter timeout value in 'Request' field for
   'timeoutIntervalForRequest' property, and 'Response'
   field for 'timeoutIntervalForResource' property, then
   click 'NSURLConnection' button.

4. For NSURLSession + NSURLSessionConfiguration +
   NSURLRequest timeout test, you can also specify 'URLReq'
   field in addition to 3, then click 'NSURLConnection With
   URLRequest' button.

If you keep blank any field, the timeout property related to
the field remains as default.


SERVER USAGE
--------------------

There are sample server in 'server' directory.  This server
just sends simple HTTP 1.0 response with two body lines, but
you can insert sleep before accepting connection, sending
header, sending 1st body line, and/or sending 2nd body line.

See server/s.rb code.


AUTHOR
--------------------

MIYOKAWA, Nobuyoshi

* E-Mail: n-miyo@tempus.org
* Twitter: nmiyo
* Blog: http://blogger.tempus.org/


COPYRIGHT
--------------------

MIT LICENSE

Copyright (c) 2013 MIYOKAWA, Nobuyoshi (http://www.tempus.org/)

Permission is hereby granted, free of charge, to any person obtaining a
copy of this software and associated documentation files (the "Software"),
to deal in the Software without restriction, including without limitation
the rights to use, copy, modify, merge, publish, distribute, sublicense,
and/or sell copies of the Software, and to permit persons to whom the
Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
DEALINGS IN THE SOFTWARE.
