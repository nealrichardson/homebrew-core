class ApacheArrow < Formula
  desc "Columnar in-memory analytics layer designed to accelerate big data"
  homepage "https://arrow.apache.org/"
  url "https://www.apache.org/dyn/closer.cgi?path=arrow/arrow-0.12.0/apache-arrow-0.12.0.tar.gz"
  sha256 "34dae7e4dde9274e9a52610683e78a80f3ca312258ad9e9f2c0973cf44247a98"

  bottle do
    cellar :any
    rebuild 2
    root_url "https://jeroen.github.io/bottles"
    sha256 "4b6cbf95f93b647d4d4e201176aab90b778f84c4b255438337706fc13768c97c" => :el_capitan
  end

  depends_on "autoconf" => :build
  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "flatbuffers"
  depends_on "lz4"
  depends_on "protobuf"
  depends_on "snappy"
  depends_on "thrift"
  depends_on "zstd"

  def install
    ENV.cxx11
    args = %W[
      -DARROW_PARQUET=ON
      -DARROW_PLASMA=OFF
      -DARROW_PROTOBUF_USE_SHARED=ON
      -DARROW_PYTHON=OFF
      -DFLATBUFFERS_HOME=#{Formula["flatbuffers"].prefix}
      -DLZ4_HOME=#{Formula["lz4"].prefix}
      -DPROTOBUF_HOME=#{Formula["protobuf"].prefix}
      -DSNAPPY_HOME=#{Formula["snappy"].prefix}
      -DTHRIFT_HOME=#{Formula["thrift"].prefix}
      -DZSTD_HOME=#{Formula["zstd"].prefix}
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
