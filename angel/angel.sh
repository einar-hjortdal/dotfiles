#!/bin/bash
bar="lazybar top"
pgrep -fx "lazybar top" || lazybar top &
