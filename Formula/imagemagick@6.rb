class ImagemagickAT6 < Formula
  desc "Tools and libraries to manipulate images in many formats"
  homepage "https://www.imagemagick.org/"
  # Please always keep the Homebrew mirror as the primary URL as the
  # ImageMagick site removes tarballs regularly which means we get issues
  # unnecessarily and older versions of the formula are broken.
  url "https://dl.bintray.com/homebrew/mirror/imagemagick%406--6.9.10-53.tar.xz"
  mirror "https://www.imagemagick.org/download/ImageMagick-6.9.10-53.tar.xz"
  sha256 "d0df08723369010118f639624a96c3bd3298e058ea23558b8b4cbb869d85fdd9"
  head "https://github.com/imagemagick/imagemagick6.git"

  bottle do
    cellar :any
    root_url "https://jeroen.github.io/bottles"
    sha256 "93a004065bb32b9159aa7156f3f17ed4a4fe305160bfe99d40657fb41203dc8f" => :el_capitan_or_later
  end

  keg_only :versioned_formula

  depends_on "pkg-config" => :build

  depends_on "freetype"
  depends_on "jpeg"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "libtool"
  depends_on "little-cms2"
  depends_on "openjpeg"
  depends_on "webp"
  depends_on "xz"

  depends_on "librsvg"

  skip_clean :la

  def install
    args = %W[
      --disable-osx-universal-binary
      --prefix=#{prefix}
      --disable-dependency-tracking
      --disable-silent-rules
      --disable-opencl
      --disable-openmp
      --disable-shared
      --enable-static
      --with-freetype=yes
      --with-fontconfig=yes
      --with-librsvg=yes
      --without-modules
      --enable-zero-configuration
      --with-webp=yes
      --with-openjp2
      --without-gslib
      --with-gs-font-dir=#{HOMEBREW_PREFIX}/share/ghostscript/fonts
      --without-fftw
      --without-pango
      --without-x
      --without-wmf
    ]

    # versioned stuff in main tree is pointless for us
    inreplace "configure", "${PACKAGE_NAME}-${PACKAGE_VERSION}", "${PACKAGE_NAME}"
    #ENV["PKG_CONFIG_PATH"] = "/usr/local/lib/pkgconfig:/opt/X11/lib/pkgconfig"
    ENV["CPPFLAGS"] = "-I/opt/X11/include/"
    ENV["LIBS"] = "-L/opt/X11/lib"
    system "./configure", *args
    system "make", "install"
  end

  test do
    assert_match "PNG", shell_output("#{bin}/identify #{test_fixtures("test.png")}")
    # Check support for recommended features and delegates.
    features = shell_output("#{bin}/convert -version")
    %w[Modules freetype jpeg png tiff].each do |feature|
      assert_match feature, features
    end
  end
end
