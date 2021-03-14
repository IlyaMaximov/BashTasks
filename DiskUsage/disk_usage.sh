#!/bin/bash

echo $(echo $(bash get_size.sh $1) | awk -f nice_view.awk) $1
