
# Change Log
All notable changes to this project will be documented in this file.
 
The format is based on [Keep a Changelog](http://keepachangelog.com/)
and this project adheres to [Semantic Versioning](http://semver.org/).
 
## [0.0.2] - 2023-03-19
  
* Forked from [arturluik/modsec-for-bts](https://github.com/arturluik/modsec-for-bts).
 
### Added
- Add supervisord + [supervisor_stdout-plugin](https://github.com/coderanger/supervisor-stdout). Application configuration can be placesd in `/etc/supervisor/conf.d/*.conf`
- [WIP] Add script to sync CRS rules from `repos` with the master branch. TO-DO: Set env var to enable/disable this feature and configure cronjobb to run every 'x' minutes.

### Changed
- Replaced default entrypoint, now supervisord is the default entrypoint.
- php-fpm and nginx are now managed by supervisord

### Fixed

## [0.0.1] - 2023-03-18
  
- Forked from [arturluik/modsec-for-bts](https://github.com/arturluik/modsec-for-bts).
 
### Added
 
### Changed
  
- Bump modsecurity-crs to `3.3.4`
- Bump php-fpm version to `php8-fpm`
- Redesign the `Dockerfile` to keep as simple as possible - removed default ENV vars.
- CRS rules are now in the folder `rules` and mounted in the container at `/opt/owasp-crs/rules` by `docker-compose`
- Add `docker-entrypoint.d/100_start_php-fpm.sh` to start the php-fpm on port `localhost:9000` - to avoid errors during nginx startup with `envsubst` on template files.
- Add a `src` folder with structured files
- Converted the `nginx.conf` as template
- The `docker-compose.yaml` now mount the rules files in the container

### Fixed