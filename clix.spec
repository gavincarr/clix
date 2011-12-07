%define perl_sitelib    %(eval "`perl -V:installsitelib`"; echo $installsitelib)

Summary: A read-only command-line xmpp client
Name: clix
Version: 0.5.1
Release: 1%{org_tag}%{dist}
Group: Applications/Internet
License: GPL
URL: http://www.openfusion.com.au/labs/
Source: http://www.openfusion.com.au/labs/dist/%{name}-%{version}.tar.gz
BuildRoot: /var/tmp/%{name}-root
BuildRequires: /usr/bin/pod2man
BuildArch: noarch

%description
clix is a read-only command-line xmpp client, typically used for jabber stream
merging and monitoring.

%prep
%setup

%build
pod2man clix > README

%install
rm -rf %{buildroot}
mkdir -p %{buildroot}%{_bindir} 
mkdir -p %{buildroot}%{perl_sitelib}/Clix
mkdir -p %{buildroot}%{_mandir}/man1
install clix %{buildroot}%{_bindir}
install -m644 lib/Clix/*.pm %{buildroot}%{perl_sitelib}/Clix
install -m644 README %{buildroot}%{_mandir}/man1/clix.1

%clean
rm -rf %{buildroot}

%files
%defattr(-,root,root)
%{_bindir}/%{name}
%{perl_sitelib}/Clix/*.pm
%{_mandir}/man1/%{name}.1*
%doc README

%changelog
* Wed Dec 07 2011 Gavin Carr <gavin@openfusion.com.au> 0.5-1
- Debug/fix tokenising issues.
- Refactor Clix::Colour into cleaner Colour and Utils modules.

* Sun Jul 24 2011 Gavin Carr <gavin@openfusion.com.au> 0.4-1
- Update to use new Regexp::Common::microsyntax.

* Thu Jan 13 2011 Gavin Carr <gavin@openfusion.com.au> 0.3.5-1
- Tweak perl_sitelib setting to work in {RHEL,CentOS}-6.

* Tue Feb 02 2010 Gavin Carr <gavin@openfusion.com.au> 0.3.4-1
- Tweaks to newline stripping.

* Fri Jan 29 2010 Gavin Carr <gavin@openfusion.com.au> 0.3.1-1
- Tweak colourising to handle twitter-style <usernames>.
- Strip newlines from microblog messages.

* Wed Jan 13 2010 Gavin Carr <gavin@openfusion.com.au> 0.3-1
- Merge config [COLOURS] section before colourising messages.
- Rename Clix module to Clix::Colours.

* Mon Dec 01 2008 Gavin Carr <gavin@openfusion.com.au> 0.002-1
- Make colourisation more sophisticated, esp. with microblogging messages.
- Split colourisation functions into separate Clix module.
- Add some initial unit tests.

* Fri Jan 04 2008 Gavin Carr <gavin@openfusion.com.au> 0.001-1
- Initial package.

