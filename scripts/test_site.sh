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

# --- Task 3: framework page ---
af  _site_test_dev/framework/index.html
ag  _site_test_dev/framework/index.html 'id="self-assessment"'
ag  _site_test_dev/framework/index.html 'id="g"'
ag  _site_test_dev/framework/index.html 'id="g-1"'
ag  _site_test_dev/framework/index.html 'id="g-1-1"'
ag  _site_test_dev/framework/index.html 'id="e-3-10"'
ag  _site_test_dev/framework/index.html 'class="sidebar-groups"'
ag  _site_test_dev/framework/index.html 'href="#g-1-1"'
anf _site_test_dev/controls
anf _site_test_dev/practices
# per-item group pages gone (groups.md root page still emits /groups/ until Task 10)
anf _site_test_dev/groups/g
ag  _site_test_prod/framework/index.html 'href="/p-sscrm/roles/#'

# --- Task 4: diagram ---
ag _site_test_dev/framework/index.html 'class="fw-diagram"'
ag _site_test_dev/framework/index.html 'fw-col-g'
ag _site_test_dev/framework/index.html 'fw-col-d'
ag _site_test_dev/framework/index.html 'class="fw-cell-count"'
ag _site_test_prod/framework/index.html 'href="/p-sscrm/framework/#g-1"'

rm -rf _site_test_dev _site_test_prod
if [ "$fail" -eq 0 ]; then echo "ALL PASS"; else echo "FAILURES ABOVE"; exit 1; fi
