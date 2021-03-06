class Libnids < Formula
  desc "Implements E-component of network intrusion detection system"
  homepage "https://libnids.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/libnids/libnids/1.24/libnids-1.24.tar.gz"
  sha256 "314b4793e0902fbf1fdb7fb659af37a3c1306ed1aad5d1c84de6c931b351d359"

  bottle do
    cellar :any
    rebuild 1
    sha256 "bbbec23c0bd3f33933c06611e7c2f1cc5a233286dfbda3066c35318539374145" => :mojave
    sha256 "07675f5eebae5b27ff1b632a927e456c2c4b26435fd01c9556860973652caf1d" => :high_sierra
    sha256 "5803aac7ddece4e3a430d16d5557721d540f73e23e7a33a67f2ac2f6449a862e" => :sierra
    sha256 "75494ad58d4718de0ba012866ccde060e494293a93f575d42e95b57f7bbe9cc7" => :el_capitan
    sha256 "a0375ba5851ffc54b89948d05d843102dbf33dbe8f8d77e46673a985df40ca4f" => :yosemite
    sha256 "4ad0be7662127faff0e9103f678f9d3f277278de4cdc801e2ecdc40ad81e448a" => :mavericks
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "libnet"

  # Patch fixes -soname and .so shared library issues. Unreported.
  patch :DATA

  def install
    # autoreconf the old 2005 era code for sanity.
    system "autoreconf", "-ivf"
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}",
                          "--enable-shared"
    system "make", "install"
  end
end

__END__
--- a/src/Makefile.in	2010-03-01 13:13:17.000000000 -0800
+++ b/src/Makefile.in	2012-09-19 09:48:23.000000000 -0700
@@ -13,7 +13,7 @@
 libdir		= @libdir@
 mandir		= @mandir@
 LIBSTATIC      = libnids.a
-LIBSHARED      = libnids.so.1.24
+LIBSHARED      = libnids.1.24.dylib

 CC		= @CC@
 CFLAGS		= @CFLAGS@ -DLIBNET_VER=@LIBNET_VER@ -DHAVE_ICMPHDR=@ICMPHEADER@ -DHAVE_TCP_STATES=@TCPSTATES@ -DHAVE_BSD_UDPHDR=@HAVE_BSD_UDPHDR@
@@ -65,7 +65,7 @@
 	ar -cr $@ $(OBJS)
 	$(RANLIB) $@
 $(LIBSHARED): $(OBJS_SHARED)
-	$(CC) -shared -Wl,-soname,$(LIBSHARED) -o $(LIBSHARED) $(OBJS_SHARED) $(LIBS) $(LNETLIB) $(PCAPLIB)
+	$(CC) -dynamiclib -Wl,-dylib -Wl,-install_name,$(LIBSHARED) -Wl,-headerpad_max_install_names -o $(LIBSHARED) $(OBJS_SHARED) $(LIBS) $(LNETLIB) $(PCAPLIB)

 _install install: $(LIBSTATIC)
 	../mkinstalldirs $(install_prefix)$(libdir)
@@ -76,7 +76,7 @@
 	$(INSTALL) -c -m 644 libnids.3 $(install_prefix)$(mandir)/man3
 _installshared installshared: install $(LIBSHARED)
 	$(INSTALL) -c -m 755 $(LIBSHARED) $(install_prefix)$(libdir)
-	ln -s -f $(LIBSHARED) $(install_prefix)$(libdir)/libnids.so
+	ln -s -f $(LIBSHARED) $(install_prefix)$(libdir)/libnids.dylib

 clean:
 	rm -f *.o *~ $(LIBSTATIC) $(LIBSHARED)
