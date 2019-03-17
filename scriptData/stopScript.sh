#!/bin/bash

sleep 45

curl -GET "http://$1:8080/status" > webData.txt
curl -GET "http://$1:8080/stop" 
