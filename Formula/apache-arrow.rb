class ApacheArrow < Formula
  desc "Columnar in-memory analytics layer designed to accelerate big data"
  homepage "https://arrow.apache.org/"
  url "https://archive.apache.org/dist/arrow/arrow-0.15.0/apache-arrow-0.15.0.tar.gz"
  mirror "https://www-eu.apache.org/dist/arrow/arrow-0.15.0/apache-arrow-0.15.0.tar.gz"
  sha256 "d1072d8c4bf9166949f4b722a89350a88b7c8912f51642a5d52283448acdfd58"

  bottle do
    cellar :any
    sha256 "a55211ba6f464681b7ca1b48defdad9cfbe1cf6fad8ff9ec875dc5a3c8f3c5ed" => :el_capitan_or_later
    root_url "https://autobrew.github.io/bottles"
  end

  depends_on "cmake" => :build
  depends_on "flatbuffers" => :build
  depends_on "double-conversion"
  depends_on "boost"
  depends_on "lz4"
  depends_on "thrift"
  depends_on "snappy"

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
      -DARROW_WITH_SNAPPY=ON
      -DARROW_BUILD_UTILITIES=ON
      -DPARQUET_BUILD_EXECUTABLES=ON
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
