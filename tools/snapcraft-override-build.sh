#!/bin/sh -e

# Restore patched files
PYTHON_PACKAGE_PATH="$SNAPCRAFT_PART_INSTALL/usr/lib/python3.5/"
[ -f "patched/ctypes/__init__.py.orig" ] && mv "patched/ctypes/__init__.py.orig" "$PYTHON_PACKAGE_PATH/ctypes/__init__.py"

# Apply patches
echo "Patching ctypes..."
patch -s -b "$PYTHON_PACKAGE_PATH/ctypes/__init__.py" patches/ctypes_init.diff

# Save patches to allow rebuilding
mkdir -p patched/ctypes
[ -f "$PYTHON_PACKAGE_PATH/ctypes/__init__.py.orig" ] && mv "$PYTHON_PACKAGE_PATH/ctypes/__init__.py.orig" patched/ctypes

# Now that everything is built, let's disable user site-packages
# as stated in PEP-0370
echo "Compiling pyc files..."
sed -i "$SNAPCRAFT_PART_INSTALL/usr/lib/python3.5/site.py" -e 's/^ENABLE_USER_SITE = None$/ENABLE_USER_SITE = False/'
# This is the last step, let's now compile all our pyc files.
"$SNAPCRAFT_PART_INSTALL/usr/bin/python3" -m compileall -q .