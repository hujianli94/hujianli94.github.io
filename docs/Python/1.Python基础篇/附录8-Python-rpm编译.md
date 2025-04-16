# 附录 8-Python-rpm 编译

1、编写程序，首先将实现 python 源代码,包括如下目录和文件：

```sh
Filebackup-1.0.0
├── Filebackup
│   ├── backup.py
│   ├── Filebackup.py
│   ├── file_remove.py
│   ├── file_sync.py
│   └── __init__.py
├── MANIFEST.in
├── README.txt
├── requirements.txt
└── setup.py
```

2、查看 setup.py 文件内容

```python
cat setup.py

from setuptools import setup, find_packages

setup(name='Filebackup',
      version='1.0',
      description='File backup for gitlab,redmine and wiki',
      author='Leon Zhang',
      author_email='test@123.com',
      url='http://123.com',
      packages=find_packages(),
      entry_points={
          'console_scripts': [
              'kyscripts = Filebackup.Filebackup:main',
        ],
       },)
```

3、将文件打包：

```sh
tar -zcvf Filebackup-1.0.0.tar.gz Filebackup-1.0.0
```

4、创建 systemd service 文件

```sh
cat Filebackup.service

[Unit]
Description=File backup and synchronize application
After=network-online.target docker.service
Wants=network-online.target

[Service]
Type=simple
ExecStart=/usr/bin/kyscripts
ExecReload=/bin/kill -HUP $MAINPID
KillMode=process
Restart=on-failure
RestartSec=42s

[Install]
WantedBy=multi-user.target
```

5、使用 rpmbuild 打包，首先安装 rpmbuild,并生成打包目录：

```sh
yum install -y rpm-build
yum install -y rpmdevtools pcre-devel gcc make
rpmdev-setuptree

# 此时会生成rpmbuild目录
```

6、编写`*.spec` 文件：

```sh
%define _unpackaged_files_terminate_build 0
%if 0%{?_version:1}
%define         _verstr      %{_version}
%else
%define         _verstr      1.0.0
%endif

Name:           Filebackup
Version:        %{_verstr}
Release:        1%{?dist}
Summary:        consul-template watches a series of templates on the file system, writing new changes when Consul is updated. It runs until an interrupt is received unless the -once flag is specified.

Group:          System Environment/Daemons
License:        MPLv2.0
URL:            http://www.tmp.com.cn
Source0:        %{name}-%{version}.tar.gz
Source1:        %{name}.service
#BuildRoot:      %(mktemp -ud %{_tmppath}/%{name}-%{version}-%{release}-XXXXXX)
BuildRoot:      %_topdir/BUILDROOT


%if 0%{?fedora} >= 14 || 0%{?rhel} >= 7
BuildRequires:  systemd-units
Requires:       systemd
%endif
Requires(pre): docker

%description
Filebackup is a service that bakcup remove and sync gitlab,wiki and redmine data files.

%prep
%setup -q

%install
rm -rf %{buildroot}
mkdir -p %{buildroot}/%{_bindir}/
mkdir -p %{buildroot}/%{_sysconfdir}/%{name}.d
mkdir -p %{buildroot}/%{_sharedstatedir}/%{name}

%if 0%{?fedora} >= 14 || 0%{?rhel} >= 7
mkdir -p %{buildroot}/%{_unitdir}
cp %{SOURCE1} %{buildroot}/%{_unitdir}/
python setup.py install --root=%{buildroot} --record=INSTALLED_FILES
%endif

%pre
getent group Filebackup>/dev/null || groupadd -r Filebackup
getent passwd Filebackup >/dev/null || \
    useradd -r -g Filebackup -d /var/lib/Filebackup -s /sbin/nologin \
    -c "Filebackup user" Filebackup
exit 0

%if 0%{?fedora} >= 14 || 0%{?rhel} >= 7
%post
%systemd_post %{name}.service

%preun
%systemd_preun %{name}.service

%postun
%systemd_postun_with_restart %{name}.service
%else
%post
/sbin/chkconfig --add %{name}

%preun
if [ "$1" = 0 ] ; then
    /sbin/service %{name} stop >/dev/null 2>&1
    /sbin/chkconfig --del %{name}
fi
%endif

%clean
rm -rf %{buildroot}


%files -f INSTALLED_FILES
%defattr(-,root,root,-)
%dir %attr(750, root, Filebackup) %{_sysconfdir}/%{name}.d
%dir %attr(750, Filebackup, Filebackup) %{_sharedstatedir}/%{name}
%if 0%{?fedora} >= 14 || 0%{?rhel} >= 7
%{_unitdir}/%{name}.service
%else
%{_initrddir}/%{name}
%{_sysconfdir}/Filebackup.d/%{name}
%endif
%doc


%changelog
* Tue Aug 22 2017 mh <mh@immerda.ch> - 0.19.0-1
- Bumped version to 0.19.0
* Wed Apr 05 2017 mh <mh@immerda.ch>
- Bumped version to 0.18.2
- remove legacy location /etc/Filebackup/
* Wed Sep 28 2016 Andy Bohne <andy@andrewbohne.com>
- Bumped version to 0.16.0
* Thu Jun 30 2016 Paul Lussier <pllsaph@gmail.com>
- Created new spec file to build Filebackup for rhel7
```

7、将文件放入 rpmbuild 打包目录：

```sh
[root@leon ~]# tree rpmbuild/
rpmbuild/
├── BUILD
├── BUILDROOT
├── RPMS
├── SOURCES
│   ├── Filebackup-1.0.0
│   │   ├── Filebackup
│   │   │   ├── backup.py
│   │   │   ├── Filebackup.py
│   │   │   ├── file_remove.py
│   │   │   ├── file_sync.py
│   │   │   └── __init__.py
│   │   ├── MANIFEST.in
│   │   ├── README.txt
│   │   ├── requirements.txt
│   │   └── setup.py
│   ├── Filebackup-1.0.0.tar.gz
│   └── Filebackup.service
├── SPECS
│   └── Filebackup.spec
└── SRPMS
```

8、进入 SPECS 目录，并执行打包命令：

```sh
cd /root/rpmbuild/SPECS
rpmbuild -bb Filebackup.spec
# 执行完成以上命令以后，rpm生成并存放在/root/rpmbuild/RPMS目录下面。
```

9、其他 specs 文件

```sh
[root@delta SPECS]# cat grafana.spec
%global debug_package   %{nil}

Name:             grafana
Version:          5.1.3
Release:          7%{?dist}
Summary:          Grafana is an open source, feature rich metrics dashboard and graph editor
License:          ASL 2.0
URL:              https://github.com/grafana/grafana
Source0:          grafana-5.1.3.tar.gz
ExclusiveArch:    x86_64

BuildRequires:    golang
BuildRequires:    systemd
BuildRequires:    phantomjs

Requires(post):   systemd
Requires(preun):  systemd
Requires(postun): systemd

%description
Grafana is an open source, feature rich metrics dashboard and graph editor for
Graphite, InfluxDB & OpenTSDB.

%prep
%setup -n grafana-5.1.3

%build
export GOPATH=%{_builddir}
mkdir -p %{_builddir}/src/github.com/grafana/grafana
#cp -rf /root/rpmbuild/gopath/src/* %{_builddir}/src/
#cp -rf /root/rpmbuild/gopath/pkg/* %{_builddir}/pkg/
cd %{_builddir}/src/github.com/grafana/grafana

go run build.go setup
go run build.go build
npm install -g yarn
yarn install --pure-lockfile
npm run dev

%install
cd %{_builddir}/src/github.com/grafana/grafana
install -d -p %{buildroot}%{_datadir}/%{name}
cp -pav *.md %{buildroot}%{_datadir}/%{name}
cp -rpav docs %{buildroot}%{_datadir}/%{name}
cp -rpav public %{buildroot}%{_datadir}/%{name}
cp -rpav scripts %{buildroot}%{_datadir}/%{name}
install -d -p %{buildroot}%{_sbindir}
cp bin/%{name}-server %{buildroot}%{_sbindir}/
cp bin/%{name}-cli %{buildroot}%{_sbindir}/
install -d -p %{buildroot}%{_sysconfdir}/%{name}
cp conf/defaults.ini %{buildroot}%{_sysconfdir}/%{name}/defaults.ini
cp conf/sample.ini %{buildroot}%{_sysconfdir}/%{name}/sample.ini
cp conf/ldap.toml %{buildroot}%{_sysconfdir}/%{name}/ldap.toml
cp -rpav conf %{buildroot}%{_datadir}/%{name}
mkdir -p %{buildroot}%{_unitdir}
install -p -m 0644 packaging/rpm/systemd/grafana-server.service %{buildroot}%{_unitdir}/
mkdir -p %{buildroot}%{_sysconfdir}/sysconfig
install -p -m 0644 packaging/rpm/sysconfig/grafana-server %{buildroot}%{_sysconfdir}/sysconfig
install -d -p %{buildroot}%{_sharedstatedir}/%{name}
install -d -p %{buildroot}/var/log/%{name}
mkdir -p %{buildroot}%{_datadir}/%{name}/vendor/phantomjs
install -p tools/phantomjs/render.js %{buildroot}%{_datadir}/%{name}/vendor/phantomjs
ln -s /usr/bin/phantomjs %{buildroot}%{_datadir}/%{name}/vendor/phantomjs/phantomjs


%files
%attr(0755, root, root) %{_sbindir}/%{name}-server
%attr(0755, root, root) %{_sbindir}/%{name}-cli
%attr(0755, root, grafana) %dir %{_sysconfdir}/%{name}
%attr(0640, root, grafana) %{_sysconfdir}/%{name}/defaults.ini
%attr(0640, root, grafana) %{_sysconfdir}/%{name}/sample.ini
%attr(0640, root, grafana) %{_sysconfdir}/%{name}/ldap.toml
%attr(0755, grafana, grafana) %dir %{_sharedstatedir}/%{name}
%attr(0755, grafana, grafana) %dir /var/log/%{name}
%attr(-, root, root) %{_unitdir}/grafana-server.service
%attr(-, root, root) %{_sysconfdir}/sysconfig/grafana-server
%attr(-, root, root) %{_datadir}/%{name}
%exclude %{_datadir}/%{name}/*.md
%exclude %{_datadir}/%{name}/docs
%attr(-, root, root) %doc %{_datadir}/%{name}/CHANGELOG.md
%attr(-, root, root) %doc %{_datadir}/%{name}/LICENSE.md
%attr(-, root, root) %doc %{_datadir}/%{name}/NOTICE.md
%attr(-, root, root) %doc %{_datadir}/%{name}/README.md
%attr(-, root, root) %doc %{_datadir}/%{name}/ROADMAP.md
%attr(-, root, root) %doc %{_datadir}/%{name}/docs

%pre
getent group grafana >/dev/null || groupadd -r grafana
getent passwd grafana >/dev/null || \
    useradd -r -g grafana -d /etc/grafana -s /sbin/nologin \
    -c "Grafana Dashboard" grafana
exit 0

%post
%systemd_post grafana.service

%preun
%systemd_preun grafana.service

%postun
%systemd_postun grafana.service

%changelog
* Wed May 24 2018 hl <helei@tmp.com> 5.1.3-7
- Bump 5.1.3-7
- change build step

* Wed May 24 2018 hl <helei@tmp.com> 5.1.3-6
- Bump 5.1.3-6
- fix defaults.ini
- add sample.ini

* Wed May 23 2018 hl <helei@tmp.com> 5.1.3-5
- Bump 5.1.3-4
```

```sh
[root@delta SPECS]# cat openstack-kolla.spec
%global milestone .0rc1
%{!?upstream_version: %global upstream_version %{version}%{?milestone}}

%global common_desc \
Templates and tools from the Kolla project to build OpenStack container images.

Name:       openstack-kolla
Version:    6.0.0
Release:    0.1%{?milestone}%{?dist}
Summary:    Build OpenStack container images

License:    ASL 2.0
URL:        http://pypi.python.org/pypi/kolla
Source0:    https://tarballs.openstack.org/kolla/kolla-%{upstream_version}.tar.gz

#
# patches_base=6.0.0.0rc1
#

BuildArch:  noarch
BuildRequires:  python2-setuptools
BuildRequires:  python2-devel
BuildRequires:  python2-pbr
BuildRequires:  python2-oslo-config
BuildRequires:  crudini

Requires:   python-gitdb
Requires:   python2-pbr >= 2.0.0
Requires:   GitPython
Requires:   python2-jinja2 >= 2.8
Requires:   python2-docker >= 2.4.2
Requires:   python2-six >= 1.10.0
Requires:   python2-oslo-config >= 2:5.1.0
Requires:   python2-oslo-utils >= 3.33.0
Requires:   python2-cryptography >= 1.7.2
Requires:   python2-netaddr

%description
%{common_desc}

%prep
%setup -q -n kolla-%{upstream_version}

%build
PYTHONPATH=. oslo-config-generator --config-file=etc/oslo-config-generator/kolla-build.conf

%py2_build

%install
%py2_install

mkdir -p %{buildroot}%{_datadir}/kolla/docker
cp -vr docker/ %{buildroot}%{_datadir}/kolla

# setup.cfg required for kolla-build to discover the version
install -p -D -m 644 setup.cfg %{buildroot}%{_datadir}/kolla/setup.cfg

# remove tests
rm -fr %{buildroot}%{python2_sitelib}/kolla/tests

# remove tools
rm -fr %{buildroot}%{_datadir}/kolla/tools

install -d -m 755 %{buildroot}%{_sysconfdir}/kolla
crudini --set %{buildroot}%{_datadir}/kolla/etc_examples/kolla/kolla-build.conf DEFAULT tag %{version}-%{release}
cp -v %{buildroot}%{_datadir}/kolla/etc_examples/kolla/kolla-build.conf %{buildroot}%{_sysconfdir}/kolla
rm -fr %{buildroot}%{_datadir}/kolla/etc_examples

%files
%doc README.rst
%doc %{_datadir}/kolla/doc
%license LICENSE
%{_bindir}/kolla-build
%{python2_sitelib}/kolla*
%{_datadir}/kolla
%{_sysconfdir}/kolla

%changelog
* Thu Mar 01 2018 RDO <dev@lists.rdoproject.org> 6.0.0-0.1.0rc1
- Update to 6.0.0.0rc1
```

```sh
[root@delta SPECS]# cat deltaclient.spec
%define     userpath /etc/deltaclient
%define     binpath /usr/bin

Name:         deltaclient
Version:        1.0.0
Release:    1%{?dist}
Summary:    deltaclient

Group:        tmp
License:    GPL
URL:        http://www.tmp.com
Source0:    %{name}-%{version}.tar.gz

BuildRoot:      %{_tmppath}/%{name}-%{version}-%{release}-root


%description
deltaclient


%prep
%setup -c


%install
install  -d $RPM_BUILD_ROOT%{userpath}
install  -d $RPM_BUILD_ROOT%{binpath}

cp -r %{name}-%{version}/resources/*   $RPM_BUILD_ROOT%{userpath}
cp  %{name}-%{version}/bin/*   $RPM_BUILD_ROOT%{binpath}


%files
%defattr(-,root,root)
%{userpath}
%{binpath}


%changelog
* Tue May 8  2018 hl <helei@tmp.com> -1.0.0
- init

```

```sh
%define        userpath /usr/share/

Name:        tmp
Version:    1.0.0
Release:    1%{?dist}
Summary:    kystack tools
BuildArch:     noarch

Group:        tmp
License:    MIT
URL:        tmp.com
Source0:    kystack.tar.gz

BuildRoot:     %{_tmppath}/%{name}-%{version}-%{release}-root

%description


%prep
%setup -c


%install
install -d $RPM_BUILD_ROOT%{userpath}
cp -a kystack $RPM_BUILD_ROOT%{userpath}


%clean
rm -rf $RPM_BUILD_ROOT
rm -rf $RPM_BUILD_DIR/%{name}-%{version}


%files
%defattr(-,root,root)
%{userpath}


%changelog
```

```sh
Name:           deltaclient
Version:        1.1.1.0
Release:        1%{?dist}
Summary:        deltaclient

Group:          tmp
License:        GPL
URL:            http://www.tmp.com
Source0:        %{name}-%{version}.tar.gz

BuildRoot:      %{_tmppath}/%{name}-%{version}-%{release}-root


%description
deltaclient


%prep
%setup -c


%install
mkdir -p %{buildroot}/etc/deltaclient/
mkdir -p %{buildroot}/usr/bin
mkdir -p %{buildroot}/usr/share
mkdir -p %{buildroot}/usr/share/applications/
mkdir -p %{buildroot}/var/log/

cp -ar %{name}-%{version}/resources/*   %{buildroot}/etc/deltaclient/
cp -ar %{name}-%{version}/bin/deltaclient   %{buildroot}/usr/bin/
cp -ar %{name}-%{version}/bin/tmp-remote-viewer   %{buildroot}/usr/bin/
cp -ar %{name}-%{version}/virt-viewer   %{buildroot}/usr/share/
cp -ar %{name}-%{version}/deltaclient.desktop   %{buildroot}/usr/share/applications/
cp -ar %{name}-%{version}/deltaclient.log   %{buildroot}/var/log/deltaclient.log

chmod -R 777 %{buildroot}/etc/deltaclient/
chmod -R 777 %{buildroot}/var/log/deltaclient.log


%files
%defattr(-,root,root)
/etc/deltaclient/
/usr/bin/deltaclient
/usr/bin/tmp-remote-viewer
/usr/share/virt-viewer
/usr/share/applications/deltaclient.desktop
/var/log/deltaclient.log


%changelog
* Tue May 8  2018 hl <helei@tmp.com> -1.1.1.0
- build for kylin 4
```


## 整理工作中常用的RPM构建spec

- https://github.com/eryajf/rpmbuild/tree/main

## OpenStack rpm-packaging 介绍使用

- https://www.xiexianbin.cn/linux/rpm/2017-03-25-openstack-rpm-packaging/index.html


## 使用 setup.py 制作 Python 安装包

- https://www.xiexianbin.cn/python/pypi/python-setup_py-demo/index.html

## Python setup.py 安装包详解

- https://www.xiexianbin.cn/python/pypi/python-setup_py/index.html




## 参考文献

- https://hlyani.github.io/notes/linux/rpm_build.html


Linux rpmbuild 使用介绍及 OpenStack rpm 打包示例

- https://www.xiexianbin.cn/linux/rpm/2015-08-04-linux-rpmbuild/index.html?to_index=1

常用 Linux RPM 下载地址和 RPM 下载方法

- https://www.xiexianbin.cn/linux/rpm/2015-01-03-linux-packages-download/index.html