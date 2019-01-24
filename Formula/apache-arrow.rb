class ApacheArrow < Formula
  desc "Columnar in-memory analytics layer designed to accelerate big data"
  homepage "https://arrow.apache.org/"
  url "https://www.apache.org/dist/arrow/arrow-0.12.0/apache-arrow-0.12.0.tar.gz"
  sha256 "34dae7e4dde9274e9a52610683e78a80f3ca312258ad9e9f2c0973cf44247a98"
  head "https://github.com/apache/arrow.git"

  bottle do
    cellar :any_skip_relocation
    root_url "https://jeroen.github.io/bottles"
    sha256 "69599ed990e30bd231af794957d0b6ae6f003cc11b4accea4cf830c2205f988b" => :el_capitan_or_later
  end

  depends_on "cmake" => :build
  depends_on "boost"

  needs :cxx11

  def install
    ENV.cxx11

    args = std_cmake_args + %w[
    -DARROW_BUILD_STATIC=ON
    -DARROW_BUILD_TESTS=OFF
    -DARROW_PYTHON=OFF
    -DARROW_BOOST_USE_SHARED=OFF
    -DARROW_WITH_SNAPPY=OFF
    -DARROW_WITH_ZSTD=OFF
    -DARROW_WITH_LZ4=OFF
    -DARROW_JEMALLOC=OFF
    -DARROW_BUILD_SHARED=OFF
    -DARROW_BOOST_VENDORED=OFF
    -DARROW_WITH_ZLIB=OFF
    -DARROW_WITH_BROTLI=OFF
    -DARROW_USE_GLOG=OFF
    -DPTHREAD_LIBRARY=OFF
    -DARROW_BUILD_UTILITIES=ON
    -DARROW_TEST_LINKAGE="static"
    -DARROW_HDFS=OFF
    ]

    cd "cpp" do
      system "cmake", ".", *args
      system "make", "install"
    end
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include "arrow/api.h"
      int main(void)
      {
        arrow::int64();
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-std=c++11", "-I#{include}", "-L#{lib}", "-larrow", "-o", "test"
    system "./test"
  end
end
