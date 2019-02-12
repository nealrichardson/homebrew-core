class MariadbConnectorC < Formula
  desc "MariaDB database connector for C applications"
  homepage "https://downloads.mariadb.org/connector-c/"
  url "https://downloads.mariadb.org/f/connector-c-3.0.8/mariadb-connector-c-3.0.8-src.tar.gz"
  sha256 "2ca368fd79e87e80497a5c9fd18922d8316af8584d87cecb35bd5897cb1efd05"

  bottle do
    cellar :any
    rebuild 1
    root_url "https://jeroen.github.io/bottles"
    sha256 "bf296351cf8d538c60dfc0a966edbc06144982d121972d7788accb85aa0e2930" => :el_capitan_or_later
  end

  depends_on "cmake" => :build
  depends_on "openssl"

  conflicts_with "mysql", "mariadb", "percona-server",
                 :because => "both install plugins"

  def install
    args = std_cmake_args
    args << "-DWITH_OPENSSL=On"
    args << "-DOPENSSL_INCLUDE_DIR=#{Formula["openssl"].opt_include}"
    args << "-DCOMPILATION_COMMENT=Homebrew"

    system "cmake", ".", *args
    system "make", "install"
  end

  test do
    system "#{bin}/mariadb_config", "--cflags"
  end
end
