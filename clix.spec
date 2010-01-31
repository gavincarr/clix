
%define perl_sitelib /usr/lib/perl5/site_perl

Summary: A read-only command-line xmpp client
Name: clix
Version: 0.3.3
Release: 1%{org_tag}
Group: System Environment/Daemons
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
rm -rf $RPM_BUILD_ROOT
mkdir -p $RPM_BUILD_ROOT%{_bindir} 
mkdir -p $RPM_BUILD_ROOT%{perl_sitelib}/Clix
mkdir -p $RPM_BUILD_ROOT%{_mandir}/man1
install clix $RPM_BUILD_ROOT%{_bindir}
install -m644 lib/Clix/Colours.pm $RPM_BUILD_ROOT%{perl_sitelib}/Clix
install -m644 README $RPM_BUILD_ROOT%{_mandir}/man1/clix.1

%clean
rm -rf $RPM_BUILD_ROOT

%files
%defattr(-,root,root)
%{_bindir}/%{name}
%{perl_sitelib}/Clix/Colours.pm
%{_mandir}/man1/%{name}.1*
%doc README

%changelog
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

