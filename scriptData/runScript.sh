#!/usr/bin/env bash

# Move to the lab2 directory
cd ~/Desktop/College/InformationSystemsStage3/Cloud_Computing/lab2
pwd

# no space when assigning variable value
# Tag name to search for VM instance
myTag="newVM"

# Create a VM on my Amazon account with the myTag value  and to my security group




# Details of the instances available in my ec2,  the Tags and instanceId
aws ec2 describe-instances --query 			\
	"Reservations[*].Instances[*].[Tags, InstanceId]" | jq -r 'flatten'> temp.json

# Display the temp.json
echo "JSON file returned from EC2, describing instances"
echo 
cat temp.json


 # Ask user to continue if temp.json looks OK
read -p "Continue script (y/n)?" -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then


#	Below awk function explained :)
# get the instance id of the VM that is Taged with myTag
# 1. if "Value" faund, remove "" and check if lable matches
# 2. if label matched, set lock to 1, to get instance id
# 3. if lock is 1 and word beggins with "i-
# 4. remove "" and comma, and set to instance, change lock to 0
# 5. return instance and assign to instanceId variable 


instanceId=`awk -v awk_Tag=$myTag 				\
		'BEGIN{tempInst=""; lock=0; instance="" }	\
		{if(match($0, /"Value"*/))			\
			{gsub(/"/ ,"",$2);			\
			if($2==awk_Tag)				\
				{lock=1;}			\
			}					\
		else if(lock && match($0, /"i-*/))		\
			{gsub(/"/, "", $0);			\
			gsub(/,/, "", $0);			\
			instance=$0;				\
			lock=0; 				\
			}					\
		}						\
		END{print instance}' temp.json`

# Remove the temporary json file
rm temp.json

printf "Tag: %s\nVM InstanceId: %s\n" $myTag $instanceId
fi
