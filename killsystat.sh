#!/bin/sh

ps -ef | grep 720 | grep -v grep | awk -F" " '{print $2}' | xargs kill -9