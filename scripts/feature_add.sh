#!/usr/bin/env bash
set -e

if [ $# -ne 1 ]; then
  echo "Usage: $0 <feature_name_in_snake_case>"
  exit 1
fi

FEATURE=$1

# create the directory tree
cd ..
cd lib/features
mkdir -p "$FEATURE"/data/repository
mkdir -p "$FEATURE"/data/api_services
mkdir -p "$FEATURE"/domain/entities
mkdir -p "$FEATURE"/domain/repository
mkdir -p "$FEATURE"/presentation/store
mkdir -p "$FEATURE"/presentation/screens
mkdir -p "$FEATURE"/presentation/widgets

# create the files
touch "$FEATURE"/data/repository/"${FEATURE}"_repository_impl.dart
touch "$FEATURE"/data/api_services/"${FEATURE}"api_services.dart
touch "$FEATURE"/domain/repository/"${FEATURE}"_repository.dart
touch "$FEATURE"/presentation/screens/"${FEATURE}"_screen.dart

echo "Scaffolded feature ‘$FEATURE’"
