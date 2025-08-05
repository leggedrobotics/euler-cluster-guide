#!/bin/bash

# Create GitHub Actions workflow directory
mkdir -p .github/workflows

# Create the workflow file
cat > .github/workflows/ci.yml << 'EOF'
name: ci
on:
  push:
    branches:
      - main
      - master
permissions:
  contents: write
jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Configure Git Credentials
        run: |
          git config user.name github-actions[bot]
          git config user.email 41898282+github-actions[bot]@users.noreply.github.com
      - uses: actions/setup-python@v5
        with:
          python-version: 3.x
      - run: echo "cache_id=$(date --utc '+%V')" >> $GITHUB_ENV
      - uses: actions/cache@v4
        with:
          key: mkdocs-material-${{ env.cache_id }}
          path: .cache
          restore-keys: |
            mkdocs-material-
      - run: pip install mkdocs-material mkdocs-minify-plugin
      - run: mkdocs gh-deploy --force
EOF

echo "GitHub Actions workflow created!"
echo "Now run:"
echo "  git add .github/"
echo "  git commit -m 'Add MkDocs GitHub Actions workflow'"
echo "  git push"