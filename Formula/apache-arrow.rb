class ApacheArrow < Formula
  desc "Columnar in-memory analytics layer designed to accelerate big data"
  homepage "https://arrow.apache.org/"
  url "https://www.apache.org/dyn/closer.cgi?path=arrow/arrow-0.12.0/apache-arrow-0.12.0.tar.gz"
  sha256 "34dae7e4dde9274e9a52610683e78a80f3ca312258ad9e9f2c0973cf44247a98"

  bottle do
    rebuild 3
    cellar :any_skip_relocation
    root_url "https://jeroen.github.io/bottles"
    sha256 "c02a0f99c8d66c40cc6c0791864589fe7696826430db564a9706e4d68db866d2" => :el_capitan_or_later
  end

  patch do
    url "https://github.com/apache/arrow/commit/59c69aa2ec377e03388ff509eb7742e4fd625e01.patch"
    sha256 "d82a266c0f4f800d30db89c2533413a10a8ee599649ffebdb989f06f0d4e13bb"
  end

  depends_on "autoconf" => :build
  depends_on "cmake" => :build
  depends_on "flatbuffers" => :build
  depends_on "double-conversion"
  depends_on "boost"
  depends_on "lz4"
  depends_on "thrift"

  def install
    ENV.cxx11
    args = %W[
      -DARROW_PARQUET=ON
      -DARROW_PLASMA=OFF
      -DARROW_HDFS=OFF
      -DARROW_BUILD_TESTS=OFF
      -DARROW_TEST_LINKAGE="static"
      -DARROW_BUILD_SHARED=OFF
      -DARROW_JEMALLOC=OFF
      -DARROW_WITH_BROTLI=OFF
      -DARROW_USE_GLOG=OFF 
      -DARROW_PYTHON=OFF
      -DARROW_WITH_ZSTD=OFF
      -DARROW_WITH_SNAPPY=OFF
      -DFLATBUFFERS_HOME=#{Formula["flatbuffers"].prefix}
      -DLZ4_HOME=#{Formula["lz4"].prefix}
      -DTHRIFT_HOME=#{Formula["thrift"].prefix}
    ]

    mkdir "build"
    cd "build" do
      system "cmake", "../cpp", *std_cmake_args, *args
      system "make"
      system "make", "install"
    end
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include "arrow/api.h"
      int main(void) {
        arrow::int64();
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-std=c++11", "-I#{include}", "-L#{lib}", "-larrow", "-o", "test"
    system "./test"
  end
end
