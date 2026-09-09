Ch OpenCV package is Ch binding to OpenCV.
With Ch OpenCV package, C (or C++) programs using OpenCV C functions 
can readily run in Ch without compilation.

The latest Ch OpenCV package can be obtained from
    http://www.softintegration.com/products/thirdparty/opencv/
    or
    http://openvc.sourceforge.net/

Ch is an embeddable C/C++ interpreter for cross platform scripting,
2D/3D plotting, numerical computing and embedded scripting.
Ch is freely available from SoftIntegration, Inc.
    http://www.softintegration.com/


Release Notes
--------------------------
Ch OpenCV 2.3, July 31, 2005
1) updated cvSetMouseCallback() to support OpenCV beta 5.
Ch OpenCV 2.2, June 11, 2005
1) Use system default pkginstall.ch
2) support Ch LinuxPPC
Ch OpenCV 2.1, April 25, 2005
1) This updated Ch OpenCV supports OpenCV beta4 for both Windows and Linux
Ch OpenCV 2.0, March 15, 2005
1) This updated Ch OpenCV supports OpenCV beta4 and Ch 5.0.
2) ALL functions in OpenCV beta4 are supported.
3) ALL demo programs in OpenCV beta4 are readily to
run interpretively in Ch without compilation.
4) Ch SDK is now bundled with Ch 5.0 for easy interface
binary C/C++ library. Ch OpenCV in this release
can be updated automatically using Ch 5.0 or above
when OpenCV is updated by running the script./pkgcreate.ch.
using command 
    make 
----
Ch OpenCV 1.2, January 16, 2004
   Support Ch 4.5
----
Ch OpenCV 1.1, August 15, 2003


Contents
--------------------------
Ch OpenCV package contains the following directories

(1) chopencv - Ch OpenCV package
chopencv/demos       ---  OpenCV demo programs in C readily to run in Ch
chopencv/bin         ---  OpenCV dynamical library and commands
chopencv/dl          ---  dynamically loaded library
chopencv/include     ---  header files
chopencv/lib         ---  function files

(2) 
pkginstall.ch ---  A Ch program to install Ch OpenCV package


System Requirement 
--------------------------
(1) Ch Standard or Professional Edition version 5.0.3.12351 or higher.
    It can be downloaded from http://www.softintegration.com.


Installation Instructions:
--------------------------
      make install


Uninstallation Instructions:
-------------------------
(1) Run command
      make uninstall


Support
-------------------------
Questions related to Ch OpenCV can be posted in
either OpenCV discussion group at
        http://groups.yahoo.com/group/opencv/ 
    or Ch discussion group at
        http://groups.yahoo.com/group/ch_language/ .
