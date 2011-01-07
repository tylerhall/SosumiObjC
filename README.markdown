SosumiObjC
=========

SosumiObjC is an Objective-C library for interacting with Apple's [Find My iPhone](http://www.apple.com/mobileme/features/find-my-iphone.html) web service. This allows you to remotely

 * Determine an iOS device's geographical position
 * Send a custom message and alarm via push notification
 * Remotely lock with a custom four digit passcode
 * Determine the battery level and if the device is currently connected to a power source

Of course, all of this requires the username and password of the Apple ID (or MobileMe) account associated with the device.

This implementation uses the same JSON API as Apple's [official Find My iPhone app](http://itunes.apple.com/us/app/find-my-iphone/id376101648?mt=8), which means it's stable so long as Apple doesn't push out any major updates to the API (which would require updating their own app as well).

Much love to the MobileMe team for a wonderful service :-)

REQUIREMENTS
-------

 * [GTMHTTPFetcher](http://code.google.com/p/gtm-http-fetcher/) by Google
 * [NSData+Base64](http://cocoawithlove.com/2009/06/base64-encoding-options-on-mac-and.html) by Matt Gallagher
 * [json-framework](http://stig.github.com/json-framework/) by Stig Brautaset
 * SosumiObjC uses blocks - so you'll need iOS 4.0+ or Mac OS X 10.6+. Alternatively, you can use [PLBlocks](http://code.google.com/p/plblocks/) for older systems.

USAGE
--------

 1. Add all the files beginning with `SSM` to your project
 2. Add all the 3rd party requirements mentioned above to your project
 3. `#include SSMSosumi.h`
 4. Instantiate a `SSMManager` object with a valid MobileMe username and password. It will automatically fetch the account's devices and continuously update their position every so often - calling the delegate methods defined in the `Sosumi` protocol.

OTHER LANGUAGES / RELATED PROJECTS
----------------------------------

 * PHP - [https://github.com/tylerhall/sosumi](https://github.com/tylerhall/sosumi)
 * Python - [https://github.com/comfuture/recordmylatitude](https://github.com/comfuture/recordmylatitude)
 * Node.js - [http://github.com/drudge/node-sosumi](https://github.com/drudge/node-sosumi)
 * Ruby - [http://github.com/hpop/rosumi](https://github.com/hpop/rosumi)
 * PlayNice - Automatically update your Google Latitude location using Sosumi [http://github.com/ablyler/playnice](http://github.com/ablyler/playnice)
 * MacSosumi - A Mac desktop Find My iPhone client [https://github.com/tylerhall/MacSosumi/](https://github.com/tylerhall/MacSosumi/)

LICENSE
-------

The MIT License

Copyright (c) 2011 Tyler Hall <tylerhall AT gmail DOT com>

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
