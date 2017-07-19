require 'formula'

# Documentation: https://github.com/mxcl/homebrew/wiki/Formula-Cookbook
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!

class Upprint < Formula
  homepage 'http://www.mathstat.dal.ca/~selinger/upprint/'
  url 'http://www.mathstat.dal.ca/~selinger/upprint/download/upprint-1.7.tar.gz'
  version '1.7'
  sha256 '70dd3e38316601d09872ed88995ef8ea906dedc16a28f21ab2533111eb6310f3'

  option 'enable-a4', 'Use A4 as default page size'
  option 'enable-metric', 'Use metric units'

  depends_on 'mpage'

  env :userpaths # To find gs if not installed by brew

  def install
    # ENV.j1  # if your formula's build system can't parallelize
    args = ["--disable-dependency-tracking",
            "--prefix=#{prefix}"]

    if build.include? 'enable-a4'
      args << "--enable-a4"
    end
    if build.include? 'enable-metric'
      args << "--enable-metric"
    end

    # The getopt provided by OS X is not the enhanced version; lprwrap
    # thus should use its "dumb" option parsing rather than getopt.
    inreplace 'lprwrap/lprwrap.in', '[ "$HAVE_getopt" ]', '[ "$HAVE_getopt" ] &&  [ "${OSTYPE//[0-9.]/}" != "darwin" ]'

    system "./configure", *args
    system "make install"
  end


  def test
    # Print a 2-up version of the mpage man page on the default printer.
    # This assumes the printer can handle PostScript.
    system "man -t lprwrap | lprwrap -o 2up -o hduplex"
  end

  def caveats
      <<-EOS
The lprwrap man page lists some options using the shorthand format allowed
by the enhanced version of the getopt option parser.  OS X provides an
older version that does not properly parse the shorthand.  Where the
man page shortens an option with an argument by eliminating the space
separating the argument, be sure to include the space.  E.g., use:

  lprwrap -o 2up -o hduplex

rather than:

  lprwrap -o2up -ohduplex
EOS
  end

end
