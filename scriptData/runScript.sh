#!/usr/bin/env bash

# Move to the lab2 directory
cd ~/Desktop/College/InformationSystemsStage3/Cloud_Computing/lab2/serverApp/scriptData
pwd

# no space when assigning variable value
# Tag name to search for VM instance
myTag="newVM1"

# Create a VM on my Amazon account with the myTag value  and add to my security group

aws ec2 run-instances --image-id "ami-09f0b8b3e41191524" --instance-type "t2.micro" --security-group-ids "sg-026b7617f05cf8cb6" --security-groups "launch-wizard-1" --key-name "RaduAmazoneKey"  --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value='$myTag'}]' 


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

printf "Tag: %s\nVM InstanceId: %s\n" $myTag $instanceId
#Check if VM is ready and running
VMstate="blank"
while [ $VMstate != "running" ]; do
	aws ec2 describe-instances --instance-id $instanceId --query "Reservations[*].Instances[*].[State.Name]" |jq -r 'flatten'>temp.json
	VMstate=$(awk '{gsub(/"/,"", $0);        gsub(/\[/, "", $0);     gsub(/" "/, "", $0);    gsub(/\]/, "", $0);     printf "%s",$0;}' temp.json)
	echo $VMstate
	sleep 3
done

# Get the public IP of the corrensponding VM instance

aws ec2 describe-instances --instance-id $instanceId --query "Reservations[*].Instances[*].[NetworkInterfaces[*].Association.PublicIp]"| jq -r 'flatten'> temp.json

#convert the json file to one line
awk -v ORS= -v OFS= '{$1-$1}1' temp.json > temp2.json
#tempIP was not working when passed as a variable to ssh, have to echo and save to a new variable VMPublicIp, then works OK  :(
tempIP=$(awk '{gsub(/"/,"", $0); 	gsub(/\[/, "", $0);	gsub(/" "/, "", $0);	gsub(/\]/, "", $0); 	printf "%s",$0;}' temp2.json)	
VMpublicIP=$(echo $tempIP)

#VMpublicIP="54.194.91.150"
#VMpublicIP=${ipString:4:13}
printf "VM public IP: |%s|" $VMpublicIP

fi


# Remove the temporary json file
rm temp.json
rm temp2.json


# connect to VM via ssh
printf "\nStart to conect to VM\n\n****************************\n**********  AMAZON CLOUD   *****\n***************************\n"
printf "Passing scriped to VM\n"
# wait 5 seconds to make sure the vm is completed and ready to accept comnection
sleep 15
cat vm_commands.sh | ssh -t -i "RaduAmazoneKey.pem" ubuntu@$VMpublicIP
printf "script executed succesfully\n"
printf "\nVM connection END\n\n****************************\n**********  LOCAL HOST   *****\n*********    ******************\n"
