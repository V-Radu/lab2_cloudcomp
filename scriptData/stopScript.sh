#!/bin/bash

sleep 100

curl -GET "http://$1:8080/status" > webData.txt
curl -GET "http://$1:8080/stop" 
