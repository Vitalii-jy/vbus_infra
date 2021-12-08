#!/usr/bin/env bash


if [[ -f ./htpasswd ]];then
    htpasswd -B ./htpasswd $1
else
    htpasswd -Bc ./htpasswd $1
fi

