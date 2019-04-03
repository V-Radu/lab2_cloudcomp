import boto3


client = boto3.client('rds')

Name='MariaDB'
Identifier = 'mydatabase'
Storage = 8
Class = 'db.t2.micro' 
dbEngine = 'mariadb'
Username = 'radu'
Password = 'radu1990'
Zone = 'eu-west-1'



response = client.create_db_instance(DBName=Name, DBInstanceIdentifier=Identifier, DBInstanceClass=Class, AllocatedStorage=Storage, Engine=dbEngine, MasterUsername=Username, MasterUserPassword=Password )

print(response)
