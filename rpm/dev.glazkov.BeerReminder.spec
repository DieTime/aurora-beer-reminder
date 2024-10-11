Name: dev.glazkov.BeerReminder
Summary: Beer Reminder
Version: 0.1.0
Release: 1
License: MIT
Source0: %{name}-%{version}.tar.zst
BuildRequires: meson
BuildRequires: pkgconfig(Qt5Core)
BuildRequires: pkgconfig(Qt5DBus)
BuildRequires: pkgconfig(auroraapp)
BuildRequires: pkgconfig(runtime-manager-qt5)

%description
%{summary}

%prep
%autosetup

%build
%meson
%meson_build

%install
%meson_install

%files
%{_bindir}/%{name}
%{_datadir}/applications/%{name}.desktop
%{_datadir}/icons/hicolor/*/apps/%{name}.png
%{_datadir}/%{name}/qml/*
