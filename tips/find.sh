#!/bin/bash
grep -e "$@" -ri `dirname "$0"`/snippets

