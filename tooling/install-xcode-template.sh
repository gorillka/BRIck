#!/usr/bin/env sh

# Configuration
XCODE_TEMPLATE_DIR=$HOME'/Library/Developer/Xcode/Templates/File Templates/BRIck'
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Copy BRIcks file templates into the local BRIcks template directory
xcodeTemplate () {
  echo "==> Copying up BRIck Xcode file templates..."

  if [ -d "$XCODE_TEMPLATE_DIR" ]; then
    rm -R "$XCODE_TEMPLATE_DIR"
  fi
  mkdir -p "$XCODE_TEMPLATE_DIR"

  cp -R $SCRIPT_DIR/*.xctemplate "$XCODE_TEMPLATE_DIR"
  cp -R $SCRIPT_DIR/BRIck.xctemplate/ownsView/* "$XCODE_TEMPLATE_DIR/BRIck.xctemplate/ownsViewwithXIB/"
  cp -R $SCRIPT_DIR/BRIck.xctemplate/ownsView/* "$XCODE_TEMPLATE_DIR/BRIck.xctemplate/ownsViewwithStoryboard/"
}

xcodeTemplate

echo "==> ... success!"
echo "==> BRIck have been set up. In Xcode, select 'New File...' to use BRIck templates."
