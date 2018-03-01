#!/bin/bash
find $1 -name "*jar" -exec jar tvf {} \; | grep $2
