if [[ "$host_alias" != "$build_alias" ]]
then
  TANGO_OMNIIDL_PATH="${BUILD_PREFIX}/bin"
else
  TANGO_OMNIIDL_PATH="${PREFIX}/bin"
fi

mkdir build
cd build
cmake ${CMAKE_ARGS} \
      -DCMAKE_BUILD_TYPE=RelWithDebInfo \
      -DCMAKE_VERBOSE_MAKEFILE=ON \
      -DTANGO_CPPZMQ_BASE="$PREFIX" \
      -DTANGO_IDL_BASE="$PREFIX" \
      -DTANGO_OMNI_BASE="$PREFIX" \
      -DTANGO_OMNIIDL_PATH="$TANGO_OMNIIDL_PATH" \
      -DTANGO_ZMQ_BASE="$PREFIX" \
      -DTANGO_JPEG_BASE="$PREFIX" \
      -DBUILD_TESTING=OFF \
      ..

make -j $CPU_COUNT
make install

# LIBVERSION can't be set to PKG_VERSION for dev and rc releases
# LIBVERSION=${PKG_VERSION}
LIBVERSION=9.5.0

# Separate debugging symbols on Linux
if [ ! -z "${OBJCOPY}" ]
then
  ${OBJCOPY} --only-keep-debug ${PREFIX}/lib/libtango.so.${LIBVERSION} ${PREFIX}/lib/libtango.so.${LIBVERSION}.dbg
  chmod 664 ${PREFIX}/lib/libtango.so.${LIBVERSION}.dbg
  ${OBJCOPY} --strip-debug ${PREFIX}/lib/libtango.so.${LIBVERSION}
  ${OBJCOPY} --add-gnu-debuglink=${PREFIX}/lib/libtango.so.${LIBVERSION}.dbg ${PREFIX}/lib/libtango.so.${LIBVERSION}
fi
