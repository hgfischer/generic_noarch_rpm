Name: %{name}
Summary: %{summary}
Version: %{version}
Release: %{release}
URL: %{url}
License: %{license}
Group: %{group}
Vendor: %{vendor}
Packager: %{user}
Prefix: %{prefix}
BuildArch: noarch
BuildRoot: %{_tmppath}/%{name}-%{version}-%{release}-root
Source0: %{name}.tar

%description
%{summary}

%prep
%setup -c

%build

%install
%{__rm} -rf %{buildroot}
%{__mkdir} -p %{buildroot}/%{prefix}
%{__cp} -Ra * %{buildroot}/%{prefix}

%clean
rm -rf %{buildroot}

%files
%defattr(0755,root,root)
%{prefix}/bin/%{name}/*
%defattr(0644,root,root)
%{prefix}/log/%{name}
%{prefix}/www/%{name}
%config(noreplace) %{prefix}/etc/%{name}/*

%changelog
* Thu Jan 27 2011 Herbert G. Fischer <herbert.fischer@gmail.com>
- Created sample spec file
