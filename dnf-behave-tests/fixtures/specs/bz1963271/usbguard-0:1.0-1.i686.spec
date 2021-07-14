Name:           usbguard
Epoch:          0
Version:        1.0
Release:        1

License:        Public Domain
URL:            None

Summary:        A dummy package.

Recommends:     %{name}-selinux

%package        selinux
Summary:        A dummy package.
Requires:       %{name} = %{version}-%{release}
Requires:       selinux-policy = 1.0


%description
Dummy.

%files

%description selinux
Dummy.

%files selinux

%changelog
