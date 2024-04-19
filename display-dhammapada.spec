Name: display-dhammapada
Version: 1.0
Release: 1%{?dist}
Summary: Displays a verse from the Dhammapada
License: Public Domain
URL: https://launchpad.net/~display-dhammapada
Source0: http://bodhizazen.net/display-dhammapada/%{name}-%{version}.tar.gz
#Requires: libnotify

%description

		This program displays a random verse from the 
		English or Polish translations of the 
		Dhammapada, a "versified Buddhist scripture 
		traditionally ascribed to the Buddha himself"
		(from http://en.wikipedia.org/wiki/Dhammapada).

		As this program works similarly to fortune, 
		one may use it in shell profiles or 
		signature generators, among others. 

%define _hardened_build 1

%prep
%setup -q

%build
make %{?_smp_mflags} CFLAGS="%{optflags}" LDFLAGS="-Wl,-z,relro"

%install

make GZIPDOCS=yes DESTDIR=%{buildroot} \
	install


%files
%defattr(-,root,root,-)
%{_datadir}/doc/display-dhammapada/
%{_bindir}/display-dhammapada
%{_bindir}/dhamma
%{_bindir}/xdhamma
%{_datadir}/icons/display-dhammapada/
%{_datadir}/display-dhammapada
%{_mandir}/man1/display-dhammapada.1.gz
%{_mandir}/man1/dhamma.1.gz
%{_mandir}/man1/xdhamma.1.gz

%changelog
* Mon Jun 25 2012 bodhi.zazen <bodhizazen@fedoraproject.org> - 1.0-1
- New upstream version.
- New upstream maintainer
   - bodhi.zazen <bodhizazen at fedoraproject.org>
   -http://bodhizazen.net/display-dhammapada
- display-dhammapada.c
   -Changed copyright from Public License  to GPL v3
- Patched display-dhammapada.c
   -Fixed warnings
   -Paul Tagliamonte <paultag@ubuntu.com>
   -Path changed from /usr/local to /usr
- contrib/gtk-dhammapada.c removed, it no longer compiles
- short version renamed to dhamma
- graphical wrapper renamed to xdhamma
- xdhamma was re-written
   -Uses notify-send rather the xmessage
   -Added icon set for notify-send
   -Able to select translation
   -License GPL V3
- Makefile re-written
   -Removed script to gpg sign packages
   -Removed script to upload source code
   -Set default prefix to /usr
   -Documents moved to /usr/share/doc/display-dhammapada
   -Translations moved to //usr/share/display-dhammapada
   -configured make to run as a user rather then root
   -set permissions (dir 755 files 644)
   -check if CFLAGS were passed on the command line
   -test and if needed create target (install) directories
   -cleaned dist, clean, and uninstall targets
- Verse 50 of dhammapada-english-transl.txt
   - "no the shortcomings" changed to
   - "not the shortcomings"
- Verse 127 in dhammapada-alternate.txt corrected - it was duplicate to 128
   -http://forum.soft32.com/linux2/Bug-169539-Missing-verse-Max-Mueller-\
    translation-ftopict67280.html
- Information from examples/* added to man page
   -examples/* removed
- Updated man pages
   -(Closes: #677832)
   -(Closes: LP: #1014195)
   -fixed macros
   -updated reference URL
- Updated README to include more information
- Organized the files into sub-directories
- Added icons for xdhamma (notify-send)
- copyright file updated

* Sat Jun 16 2012 bodhi.zazen <bodhizazen@fedoraproject.org> - 0.23-1
- Patched Makefile - packages are not built as root
- Patched man pages - updated infromation
- Patched xsession
- Updated .spec
