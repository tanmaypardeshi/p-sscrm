#!/usr/bin/env bash
# Smoke tests for the P-SSCRM site build. Run: bash scripts/test_site.sh
set -euo pipefail
cd "$(dirname "$0")/.."

rm -rf _site_test_dev _site_test_prod
echo "== build (dev config) =="
bundle exec jekyll build --quiet --destination _site_test_dev
echo "== build (production config) =="
bundle exec jekyll build --quiet --config _config.yml,_config_production.yml --destination _site_test_prod

fail=0
af()  { [ -f "$1" ] || { echo "MISSING FILE: $1"; fail=1; }; }
anf() { [ ! -e "$1" ] || { echo "SHOULD NOT EXIST: $1"; fail=1; }; }
ag()  { grep -qF -- "$2" "$1" || { echo "MISSING in $1: $2"; fail=1; }; }
ang() { ! grep -qF -- "$2" "$1" || { echo "UNEXPECTED in $1: $2"; fail=1; }; }

# --- Task 2: asset pipeline ---
af  _site_test_dev/static/css/main.css
af  _site_test_dev/static/js/back-to-top.js
af  _site_test_prod/static/css/main.css
af  _site_test_prod/static/js/back-to-top.js
ag  _site_test_dev/index.html  '/static/css/main.css'
ag  _site_test_dev/index.html  '/static/js/back-to-top.js'
ag  _site_test_prod/index.html '/p-sscrm/static/css/main.css'
ag  _site_test_prod/index.html '/p-sscrm/static/js/back-to-top.js'
ang _site_test_dev/index.html  'images/social-share.png'

rm -rf _site_test_dev _site_test_prod
if [ "$fail" -eq 0 ]; then echo "ALL PASS"; else echo "FAILURES ABOVE"; exit 1; fi
