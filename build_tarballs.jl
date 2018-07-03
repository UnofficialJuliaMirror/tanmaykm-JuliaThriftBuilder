# Note that this script can accept some limited command-line arguments, run
# `julia build_tarballs.jl --help` to see a usage message.
using BinaryBuilder

# Collection of sources required to build JuliaThriftBuilder
sources = [
    "https://github.com/tanmaykm/thrift.git" =>
    "90fa5ccdc35a32517776ef0143aa62dfc42a19be",

]

# Bash recipe for building across all platforms
script = raw"""
cd $WORKSPACE/srcdir
cd thrift/
./bootstrap.sh
LDFLAGS="-static-libgcc -static-libstdc++"
export LDFLAGS
./configure --prefix=$prefix --host=$target --enable-tutorial=no --enable-tests=no --enable-libs=no
make install

"""

# These are the platforms we will build for by default, unless further
# platforms are passed in on the command line
platforms = [
    Linux(:i686, :glibc),
    Linux(:x86_64, :glibc),
    Linux(:aarch64, :glibc),
    Linux(:armv7l, :glibc, :eabihf),
    Linux(:powerpc64le, :glibc),
    Linux(:i686, :musl),
    Linux(:x86_64, :musl),
    Linux(:aarch64, :musl),
    Linux(:armv7l, :musl, :eabihf),
    MacOS(:x86_64),
    FreeBSD(:x86_64)
]

# The products that we will ensure are always built
products(prefix) = [
    ExecutableProduct(prefix, "", :thrift)
]

# Dependencies that must be installed before this package can be built
dependencies = [
    "https://github.com/tanmaykm/BisonBuilder/releases/download/v3.0.5/build_BisonBuilder.v1.0.0.jl"
]

# Build the tarballs, and possibly a `build.jl` as well.
build_tarballs(ARGS, "JuliaThriftBuilder", sources, script, platforms, products, dependencies)
