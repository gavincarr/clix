
Summary: A read-only command-line xmpp client
Name: clix
Version: 0.001
Release: 1%{org_tag}%{dist}
Group: System Environment/Daemons
License: GPL
URL: http://www.openfusion.com.au/labs/
Source: http://www.openfusion.com.au/labs/dist/%{name}-%{version}.tar.gz
BuildRoot: /var/tmp/%{name}-root
BuildRequires: /usr/bin/pod2man

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
install clix $RPM_BUILD_ROOT%{_bindir}

%clean
rm -rf $RPM_BUILD_ROOT

%files
%defattr(-,root,root)
%{_bindir}/*
%doc README

%changelog
* Fri Jan 04 2008 Gavin Carr <gavin@openfusion.com.au> 0.001-1
- Initial package.

