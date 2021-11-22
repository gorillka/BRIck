#!/usr/bin/env sh

# Configuration
XCODE_TEMPLATE_DIR=$HOME'/Library/Developer/Xcode/Templates/File Templates/BRIck'
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Copy BRIcks file templates into the local BRIcks template directory
xcodeTemplate () {
  echo "==> Copying up BRIck Xcode file templates..."

  if [ -d "$XCODE_TEMPLATE_DIR" ]; then
    echo "==> Remove ${XCODE_TEMPLATE_DIR}"
    rm -R "$XCODE_TEMPLATE_DIR"
  fi
  mkdir -p "$XCODE_TEMPLATE_DIR"

  cp -R $SCRIPT_DIR/*.xctemplate "$XCODE_TEMPLATE_DIR"
  cp -R $SCRIPT_DIR/BRIck.xctemplate/ownsViewrootUIKitCode/* "$XCODE_TEMPLATE_DIR/BRIck.xctemplate/ownsViewrootUIKitStoryboard/"
  cp -R $SCRIPT_DIR/BRIck.xctemplate/ownsViewrootUIKitCode/* "$XCODE_TEMPLATE_DIR/BRIck.xctemplate/ownsViewrootUIKitXIB file/"
  cp -R $SCRIPT_DIR/BRIck.xctemplate/ownsViewUIKitCode/* "$XCODE_TEMPLATE_DIR/BRIck.xctemplate/ownsViewUIKitStoryboard/"
  cp -R $SCRIPT_DIR/BRIck.xctemplate/ownsViewUIKitCode/* "$XCODE_TEMPLATE_DIR/BRIck.xctemplate/ownsViewUIKitXIB file/"
}

xcodeTemplate

echo "==> ... success!"
echo "==> BRIck have been set up. In Xcode, select 'New File...' to use BRIck templates."
