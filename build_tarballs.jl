# Note that this script can accept some limited command-line arguments, run
# `julia build_tarballs.jl --help` to see a usage message.
using BinaryBuilder

# Collection of sources required to build JuliaThriftBuilder
sources = [
    "http://ftp.gnu.org/gnu/m4/m4-1.4.17.tar.gz" =>
    "3ce725133ee552b8b4baca7837fb772940b25e81b2a9dc92537aeaf733538c9e",

    "http://ftp.gnu.org/gnu/bison/bison-2.3.tar.gz" =>
    "52f78aa4761a74ceb7fdf770f3554dd84308c3b93c4255e3a5c17558ecda293e",

    "https://github.com/tanmaykm/thrift.git" =>
    "90fa5ccdc35a32517776ef0143aa62dfc42a19be",

]

# Bash recipe for building across all platforms
script = raw"""
cd $WORKSPACE/srcdir
cd m4-1.4.17/
./configure --prefix=$prefix --host=$target
make install
cd ../bison-2.3/
./configure --prefix=$prefix --host=$target
make install
cd ../thrift/
./bootstrap.sh
./configure --prefix=$prefix --host=$target --without-rs --without-dart --without-dotnetcore --without-erlang --without-ruby --without-qt4 --without-qt5 --without-c_glib --without-csharp --without-java --without-nodejs --without-lua --without-python --without-perl --without-php --without-php_extension --without-haskell --without-go --without-haxe --without-d --enable-tutorial=false --enable-tests=false
set +e
make install
exit

"""

# These are the platforms we will build for by default, unless further
# platforms are passed in on the command line
platforms = [
    Linux(:x86_64, :glibc)
]

# The products that we will ensure are always built
products(prefix) = [
    ExecutableProduct(prefix, "", :m4),
    ExecutableProduct(prefix, "", :thrift),
    ExecutableProduct(prefix, "", :bison)
]

# Dependencies that must be installed before this package can be built
dependencies = [
    
]

# Build the tarballs, and possibly a `build.jl` as well.
build_tarballs(ARGS, "JuliaThriftBuilder", sources, script, platforms, products, dependencies)

