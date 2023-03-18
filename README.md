# ModSecurity Proxy for BT

It's based on the ModSecurity library and is designed to be used with the BT Web Application Firewall.

**Dockerfile**
It uses the latest official OWASP image for ModSecurity-CRS, currently: `3.3.4-nginx-alpine`.

**`src` directory structure:**

```
/src
├── docker-entrypoint.d
│  └── 100_start_php-fpm.sh
├── Dockerfile
├── etc
│  ├── modsecurity.d
│  │  └── modsecurity-override.conf
│  └── nginx
│     └── templates
│        ├── conf.d
│        └── nginx.conf.template
└── html
   └── unexpected_403.php
```

* `docker-entrypoint.d/100_start_php-fpm.sh` - start the php-fpm on port `localhost:9000`
* `etc/modsecurity.d/modsecurity-override.conf` - override for modsecurity configuration
* `etc/nginx/templates/conf.d` - nginx template files
* `html/unexpected_403.php` - custom error page

The **CoreRuleSets (CRS)** rules are in the folder `rules` and mounted in the container at `/opt/owasp-crs/rules` by `docker-compose`


**References:**

* [modsecurity-crs-docker](https://github.com/coreruleset/modsecurity-crs-docker)