# Oracle 18c XE with ORDS and Reverse Proxies

A Vagrant that demonstrates how to configure caching reverse proxies in front of Oracle ORDS

## Required Software

* [Vagrant](https://www.vagrantup.com/downloads.html)
* [VirtualBox](https://www.virtualbox.org/wiki/Downloads)
* [Oracle Database 18c XE](https://www.oracle.com/database/technologies/appdev/xe.html)
* [Oracle REST Data Services (ORDS)](https://www.oracle.com/technetwork/developer-tools/rest-data-services/downloads/index.html) 

Place the Oracle Express Edition (XE) RPM and ORDS software in the "software" directory before calling the `vagrant up` command.

Directory contents when software is included.

```
$ tree
.
├── README.md
├── Vagrantfile
├── scripts
│   ├── database.sh
│   ├── general.sh
│   ├── hitch.sh
│   ├── httpd.sh
│   ├── nginx.sh
│   ├── ords.sh
│   ├── siege.sh
│   ├── tls.sh
│   ├── tomcat.sh
│   └── varnish.sh
├── software
│   ├── oracle-database-xe-18c-1.0-1.x86_64.rpm
│   ├── ords-19.1.0.092.1545.zip
│   ├── ords-19.2.0.199.1647.zip
│   └── put_software_here.txt
└── testsuite
    ├── ords-auto-manual
    ├── ords-connections
    ├── ords-demo
    ├── ords-lib
    ├── ords-max-threads
    ├── ords-protocols
    ├── ords-reset
    ├── ords-reverse-proxies
    ├── ords-upgrade
    ├── ords-urls.py
    ├── ords-versions
    └── ords-warmup
```
