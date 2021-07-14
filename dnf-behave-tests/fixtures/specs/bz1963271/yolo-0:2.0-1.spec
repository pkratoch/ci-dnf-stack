Name:           yolo
Epoch:          0
Version:        2.0
Release:        1

License:        Public Domain
URL:            None

Summary:        A dummy package.

Recommends:     %{name}-selinux

%package        selinux
Summary:        A dummy package.
Requires:       selinux-policy = 2.0


%description
Dummy.

%files

%description selinux
Dummy.

%files selinux

%changelog
