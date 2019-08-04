#!/bin/bash

echo "Starting..."
IPAD_NAME=$1' (Mocky)'
echo $IPAD_NAME
#checkIfIPadExists() {
#  RESULT=`xcrun simctl list devices`
#  if [[ $RESULT == *"$IPAD_NAME"* ]]; then
#    echo "FOUND "
#    FOUNDIPAD=true
#  fi
#}
#
#checkIfIPadExists
#
#if [ "$FOUNDIPAD" = false ]; then
#    echo $0
#    ID=`xcrun simctl create $0 + " $IPAD_NAME" $1 com.apple.CoreSimulator.SimRuntime.iOS-13-0`
#fi
ID=`xcrun simctl create $IPAD_NAME" $2 com.apple.CoreSimulator.SimRuntime.iOS-13-0`
#echo $ID
#

#cp -R $3 ~/Library/Developer/CoreSimulator/Devices/$ID/data/Library/
#
#xcrun simctl create "NICK" + " $IPAD_NAME" com.apple.CoreSimulator.SimDeviceType.iPad-Pro--12-9-inch---3rd-generation- com.apple.CoreSimulator.SimRuntime.iOS-13-0
