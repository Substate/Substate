#!/bin/sh

# Reset build dir
rm -rf .build/docs
mkdir -p .build/docs/output

# Build documentation
xcodebuild docbuild \
  -scheme Package \
  -derivedDataPath .build/docs

# Combine all documentation
find .build/docs \
  -name "*Substate*.doccarchive" \
  -exec cp -R {}/ .build/docs/output \;

# Deploy to Netlify
netlify deploy \
  --prod \
  --open \
  --dir ".build/docs/output" \
  --site="a03053af-9075-45f8-b4f5-0d85e01883b3"
