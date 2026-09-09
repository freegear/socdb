libmlincludedir = $(includedir)/opencv
INCLUDES = -I. -I$(top_srcdir)/ml/include -I$(top_srcdir)/cxcore/include -I$(top_srcdir)

noinst_HEADERS       = src/_ml.h
noinst_LTLIBRARIES   = lib_ml.la
libmlinclude_HEADERS = include/ml.h
lib_LTLIBRARIES      = libml.la
EXTRA_DIST           = src/ml.dsp src/ml.vcproj src/ml.rc src/resource.h

# convenience library
lib_ml_la_SOURCES     = \
    src/ml.cpp          \
    src/mlann_mlp.cpp   \
    src/mlboost.cpp     \
    src/mlcnn.cpp       \
    src/mlem.cpp        \
    src/mlestimate.cpp  \
    src/mlknearest.cpp  \
    src/mlnbayes.cpp    \
    src/mlrtrees.cpp    \
    src/mlsvm.cpp       \
    src/mltestset.cpp   \
    src/mltree.cpp      \
    src/ml_inner_functions.cpp
lib_ml_la_LDFLAGS = -no-undefined @LDFLAGS@

# real library
libml_la_SOURCES = src/dummy.cpp
libml_la_LDFLAGS = -no-undefined -version-info @LT_VERSION@ @LDFLAGS@
libml_la_LIBADD  = \
    lib_ml.la \
    $(top_builddir)/cxcore/src/libcxcore.la \
    @LT_LIBOBJS@
