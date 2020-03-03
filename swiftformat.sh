#! /usr/bin/env bash

if ! which swiftformat &> /dev/null; then
  printf "\e[1;31mYou don't have SwiftFormat installed.  Please install swift format by visiting https://github.com/nicklockwood/SwiftFormat.\e[0m\n"
  exit 1
fi

HEADER="
//
// Copyright © {year}. Orynko Artem
//
// MIT license, see LICENSE file for details
//
"

OUTPUT=$(swiftformat \
  --cache ignore \
  --allman false \
  --elseposition same-line \
  --header "$HEADER" \
  --patternlet hoist \
  --indent tabs \
  --linebreaks lf \
  --hexliteralcase lowercase \
  --ranges no-space \
  --semicolons inline \
  --importgrouping alphabetized \
  --operatorfunc spaced \
  --commas always \
  --trimwhitespace always \
  --stripunusedargs closure-only \
  --empty void \
  --wraparguments after-first \
  --wrapcollections before-first \
  --enable andOperator,blankLinesAtEndOfScope,blankLinesBetweenScopes,consecutiveBlankLines,consecutiveSpaces,duplicateImports,emptyBraces,isEmpty,leadingDelimiters,redundantBreak,redundantExtensionACL,linebreakAtEndOfFile,redundantGet,redundantInit,redundantLetError,redundantNilInit,redundantObjc,redundantParens,redundantPattern,redundantReturn,redundantVoidReturnType,spaceAroundBraces,spaceAroundBrackets,spaceAroundComments,spaceInsideBraces,spaceInsideBrackets,spaceInsideComments,spaceInsideGenerics,spaceInsideParens,specifiers,strongOutlets,strongifiedSelf,todos,trailingClosures,typeSugar \
  --disable redundantBackticks,linebreakAtEndOfFile,redundantLet,redundantRawValues,redundantSelf,spaceAroundGenerics,spaceAroundParens \
  --exclude Pods,Carthage,Package.swift \
  .)

if [ "$OUTPUT" ]; then
  echo "$OUTPUT" >&2
  exit 1
fi

