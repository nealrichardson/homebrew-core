class MariadbConnectorC < Formula
  desc "MariaDB database connector for C applications"
  homepage "https://downloads.mariadb.org/connector-c/"
  url "https://downloads.mariadb.org/f/connector-c-3.1.6/mariadb-connector-c-3.1.6-src.tar.gz"
  sha256 "2ca368fd79e87e80497a5c9fd18922d8316af8584d87cecb35bd5897cb1efd05"

  bottle do
    cellar :any
    root_url "https://autobrew.github.io/bottles"
    sha256 "18a068055ae41db853264f0272b439b7906f2998c911fb8eec719d9d04a63b57" => :el_capitan_or_later
  end

  depends_on "cmake" => :build
  depends_on "openssl@1.1"

  conflicts_with "mysql", "mariadb", "percona-server",
                 :because => "both install plugins"

  def install
    args = std_cmake_args
    args << "-DWITH_OPENSSL=On"
    args << "-DOPENSSL_INCLUDE_DIR=#{Formula["openssl@1.1"].opt_include}"
    args << "-DCOMPILATION_COMMENT=autobrew"

    system "cmake", ".", *args
    system "make", "install"
  end

  test do
    system "#{bin}/mariadb_config", "--cflags"
  end
end
