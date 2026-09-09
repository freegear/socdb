OpenMAX DL Sample Code Release Note
===================================

 Description:      Sample code implementation of the OpenMAX DL API, v1.0.1
 Product revision: OX000-BU-00000-r0p0-00bet0
 Quality status:   Beta release (BET)
 Release date:     15 September 2006
 
 
 
Licensing Notice
----------------

All ARM originated code in this archive is distributed under the following 
notice.

   (c) Copyright 2005-2006 ARM Limited. All Rights Reserved.
  
   THIS SOFTWARE IS PROVIDED "AS IS", ARM EXPRESSLY DISCLAIMS ALL
   REPRESENTATIONS, WARRANTIES, CONDITIONS OR OTHER TERMS, EXPRESS
   OR IMPLIED, INCLUDING WITHOUT LIMITATION THE IMPLIED WARRANTIES
   OF NON-INFRINGEMENT, SATISFACTORY QUALITY, AND FITNESS FOR A
   PARTICULAR PURPOSE.
   
   Your use of this Software may require additional licenses, including
   but not limited to copyright and patent licenses from various entities.
   Should any such additional copyright, patent or other licenses be
   required, ARM expects that you will and you agree to obtain any such
   licenses at your own expense. You are solely responsible for obtaining
   any such licenses and the copyright licenses granted herein are
   conditional on you obtaining such additional licenses.
 

Khronos OpenMAX header files are provided as part of this release with the 
permission of Khronos Group. Consult those files for details on licensing 
and/or distribution restrictions.

Intended audience
-----------------

This document is written for all developers who are using the OpenMAX sample
code software. It assumes that you are an experienced software developer, and 
that you are familiar with the development tools that you are using. It does 
not assume that you are familiar with the OpenMAX sample code software.

This document also assumes that the developer is familiar with the OpenMAX DL 
v1.0.1 API specification available from www.khronos.org


DESCRIPTION
===========

OpenMAX DL
----------

OpenMAX is a royalty-free, cross-platform API standard created and distributed 
by the Khronos Group, the same group responsible for the OpenGL and OpenGL-ES 
specifications.

The OpenMAX DL (Development Layer) standardizes access to a comprehensive set 
of low-level media processing primitives used extensively in audio, video and 
imaging applications.

The OpenMAX DL v1.0.1 standard is available free of charge from the Khronos 
website (www.khronos.org). 

Currently in development, optimized implementation of the functions making up 
the OpenMAX API will be shipped with processors to enable library and codec 
implementers to rapidly and effectively make use of the full acceleration 
potential of new silicon - regardless of the underlying hardware architecture.

As well as general purpose media processing functions, OpenMAX DL also contains 
APIs specifically targeted for the implementation of codecs such as MPEG-4, 
H.264, MP3, AAC and JPEG.


OpenMAX DL Sample Code
----------------------

This product is the ANSI C sample implementation of the functions described in 
the OpenMAX DL v1.0.1 API specification. All of the mandatory DL functions are 
supplied. None of the optional DLx API functions described in Appendix A of the 
specification are supplied.

This implementation attempts to be as mathematically accurate to the OpenMAX 
definition as possible, using floating-point code where necessary. It is not 
intended to reflect the expected performance or code size of an optimised 
(integer only) implementation.

This product is delivered as a source code only release. You will need to build 
the object libraries required to link to any application that makes use of the 
OpenMAX DL API. It is expected that you use the most suitable development tools 
for your hardware architecture in order to build these libraries.

OpenMAX DL is split into five application domains:
  - AC - Audio Codecs (MP3 decoder and AAC decoder components)
  - IC - Image Codecs (JPEG components)
  - IP - Image Processing (Generic image processing functions)
  - SP - Signal Processing (Generic audio processing functions)
  - VC - Video Codecs (H264 and MP4 components)


Khronos OpenMAX header files
----------------------------

The following Khronos OpenMAX header files are provided as part of this release 
with the permission of the Khronos Group:

  - ac/omxAC.h – Audio coding API
  - ic/omxIC.h – Image Coding API
  - ip/omxIP.h – Image Processing API
  - sp/omxSP.h – Signal Processing API
  - vc/omxVC.h – Video Coding API
  - api/omxtypes.h – Definitions of OpenMAX DL basic data-types, structures, and error codes.

Consult the copyright notice in the above files for details on licensing and/or 
distribution restrictions.

Support
-------

This product is supplied “as is”, and as such ARM offers no support for this 
product or its use. However, ARM does welcome any feedback on any functional 
issues with this product so that future releases may be improved. Please send 
email to errata@arm.com giving the product code (OX000-BU-00000-r0p0-00bet0) 
and your comments.

Note: this is not intended to be an optimised implementation, it designed to 
be portable, simple to understand and accurate to the specification.

ARM will be releasing supported products containing optimised implementations 
of OpenMAX DL targeted at specific ARM architectures. Contact ARM for further 
details.




INSTALLATION
============

Files
-----

The deliverables are collectively delivered as a single UNIX compressed tar file which has been gzipped. The
download filename will be of the form:

    <download_name>.tgz
    
Relocate the <download_name>.tgz file to an appropriate temporary location. Unpack the *.tgz file as follows:

    gunzip <download_name>.tgz
    gtar –xvf <download_name>.tar
    
Note: GNU tar version 1.13 or later should be used to untar the deliverables as many versions of tar have
problems dealing with very long path names. To find the version of gtar being used type gtar –-
version.

Note: Under Windows, a GUI based application such as Winzip can be used to unpack the deliverables.
This will extract the deliverables into a directory with the same name as the bundle OX000-BU-00000-r0p0-00bet0

The source code tree is structured to reflect the organisation of the DL
API specification. The higher level directory structures are as follows:

OX000-BU-00000-r0p0-00bet0/
    ac/      - Audio coding domain
        aac/   - AAC sub-domain
        mp3/   - MP3 sub-domain

    ic/      - Image coding domain
        jp/    - JPEG sub-domain

    ip/      - Image processing domain
        bm/    - Bitmap manipulation sub-domain
        cs/    - Color space conversion sub-domain
        pp/    - Post processing sub-domain

    sp/      - Signal processing domain

    vc/      - Video coding domain
        m4p2/  - MPEG-4 part 2 sub-domain
        m4p10/ - MPEG-4 part 10 (H.264) sub-domain
   
    api/     - Header files common to all domains
    src/     - Source files common to multiple domains
    obj/     - Empty, used by the build scripts to store the intermediate object files
    lib/     - Empty, used by the build script to store the final linked libraries
 
 

BUILD INSTRUCTIONS
==================

The OpenMAX DL sample code has been written using ANSI standard C in order to be as portable across as
many toolkits and target systems as possible.

This section goes through the steps required to build an object library for each of the five DL domains using the
supplied example scripts which have been written to use the freely available GCC (GNU) toolkit.


Build instructions for GCC
--------------------------

A simple build script is provided for each of the domains. It requires:
  
  - a Perl installation, version 5 or higher
  - a GCC (GNU) tool chain

The build script is at the root of the source code tree. Invoke it using:
    perl build_<domain-abbreviation>.pl
    
Where <domain-abbreviation> can be one of "AC", "IC", "IP", "SP", or "VC".

For example:
    perl build_VC.pl

This will build a library archive called "omx<domain-abbreviation>.a". For example:
    omxVC.a
    
It can be found in the “lib/” directory in the root of the source code tree.


Build instructions for other toolkits
-------------------------------------

If you have another tool chain then it is easy to modify the Perl build script to call that tool chain instead by
editing the script to change the initialised values of the following Perl variables:
  - $CC – the Compiler command name
  - $CC_OPTS - the compiler options
  - $LIB – the Librarian command name
  - $LIB_OPTS - the librarian options
  - $LIB_TYPE - the file-type to be used for the output library
  
Once you have saved the Perl scripts then follow the instructions for the GCC build above.



DIFFERENCES FROM PREVIOUS RELEASES
==================================

This is the first release of the OpenMAX sample code



KNOWN ISSUES
============

There are no known issues with this release.





