#!/bin/sh
. zospmsetenv 

zospmdeploy "$1" zospm-zwebin.bom
exit $? 
