class ArgusClients < Formula
  desc "Audit Record Generation and Utilization System clients"
  homepage "https://openargus.org"
  url "https://github.com/openargus/clients/archive/refs/tags/v5.0.0.tar.gz"
  sha256 "c695e69f8cfffcb6ed978f1f29b1292a2638e4882a66ea8652052ba1e42fe8bc"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "b0587f8a46452c38ec031e8702f2187cbf691da6967f2d9201d26cd20a231b65"
    sha256 cellar: :any,                 arm64_ventura:  "6851559033bb84f190d0e81c9449f69b5ba38c1e0683f4f3811595934334054d"
    sha256 cellar: :any,                 arm64_monterey: "ef5843ccd0c438284b0c21fa0d70ccac9ab8d06f8ee1eba59752027476bf55e9"
    sha256 cellar: :any,                 sonoma:         "ae69489900b4e3f9292a1e1f2f33ac21070b0e7c3f3abf161eae9f0693d4acbd"
    sha256 cellar: :any,                 ventura:        "34584bff62553297be082fc641dc4547ce5078d0d062271a19a5e596fe389883"
    sha256 cellar: :any,                 monterey:       "cd5dd677729938a48bec1da1d3a12ca26269a107a5bdac2b76d47968d453d58a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9810d90c908373e299c23598590268144b3cc35c15ecf5e73fb8dcc300af4411"
  end

  depends_on "perl"
  depends_on "readline"
  depends_on "rrdtool"

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build

  on_linux do
    depends_on "libtirpc"
  end

  resource "Switch" do
    url "https://cpan.metacpan.org/authors/id/C/CH/CHORNY/Switch-2.17.tar.gz"
    sha256 "31354975140fe6235ac130a109496491ad33dd42f9c62189e23f49f75f936d75"
  end

  def install
    ENV.append_to_cflags "-I#{Formula["libtirpc"].opt_include}/tirpc" if OS.linux?

    ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5"
    resources.each do |r|
      r.stage do
        system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
        system "make"
        system "make", "install"
      end
    end

    ENV["PERL_EXT_LIB"] = libexec/"lib/perl5"

    system "./configure", "--prefix=#{prefix}", "--without-examples"
    system "make"
    system "make", "install"
  end

  test do
    ENV["PERL5LIB"] = libexec/"lib/perl5"
    system "perl", "-e", "use qosient::util;"

    assert_match "Ra Version #{version}", shell_output("#{bin}/ra -h", 1)
  end
end
