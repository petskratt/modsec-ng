
# Change Log
All notable changes to this project will be documented in this file.
 
The format is based on [Keep a Changelog](http://keepachangelog.com/)
and this project adheres to [Semantic Versioning](http://semver.org/).
 
## [0.0.1] - 2023-03-18
  
* Forked from [arturluik/modsec-for-bts](https://github.com/arturluik/modsec-for-bts).
 
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