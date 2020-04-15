## Lab 4. Enable Schema Registry and KSQL for project Eagle 

  In the first part we will start with Schema Registry tests and enablement.
  
Try Schema Registry
  * as unauthoried user (It should fail with authorization failure):
```
curl localhost:8081/subjects
```
  * and now as authorized User (It should work and show empty schema):
```bash
curl -u professor:professor localhost:8081/subjects
```

Create a new topic eagle_topic2 as user peter
```bash
kafka-topics \
--bootstrap-server localhost:9094 \
--command-config peter.properties \
--topic eagle_topic2 \
--create \
--replication-factor 1 \
--partitions 1
```

Check how many topics is peter able to see
```bash
kafka-topics --bootstrap-server localhost:9094 --command-config peter.properties --list
```

Now we will authorize peter to be ResourceOwner for Schema Registry subjects with "eagle_" prefix to be able to create new schema versions and afterwards we will enable eagle_team to read SR subjects and their schema versions with "eagle_" prefix.
OK, lets do it.

We will use at this point confluent cli to create RBAC role bindings (access polices) instead of GUI and REST API.

First login with confluent cli to MDS as professor.
```
confluent login --url http://localhost:8090 # as professor/professor
```

Now create RBAC role binding to authorize peter to be ResourceOwner for SR and subjects with eagle_ prefix.
```
confluent iam rolebinding create \
--principal User:peter \
--role ResourceOwner \
--resource Subject:eagle_ \
--prefix \
--kafka-cluster-id $KAFKA_ID \
--schema-registry-cluster-id schema-registry
```

Now lets login as peter
```
confluent login --url http://localhost:8090 # as peter/peter
```

And finally lets create RBAC role binding for eagle_team to be able to read subjects and schema versions with eagle_ prefix
```
confluent iam rolebinding create \
--principal Group:eagle_team \
--role DeveloperRead \
--resource Subject:eagle_ \
--prefix \
--kafka-cluster-id $KAFKA_ID \
--schema-registry-cluster-id schema-registry
```

OK, now lets login to Control Center as user peter to see if he and his team hs access to Schema Registry.

Great, now lets do some SR actions:
  * lets create a schema as user peter for topic eagle_topic2
```
curl -u peter:peter -X POST -H "Content-Type: application/vnd.schemaregistry.v1+json" --data '{"schema": "{\"type\":\"record\",\"name\":\"myrecord\",\"namespace\":\"io.confluent.examples.clients.basicavro\",\"fields\":[{\"name\":\"f1\",\"type\":\"string\"}]}"}' http://localhost:8081/subjects/eagle_topic2-value/versions
```

  * lets check now if user peter and carsten are able to see it
  ```
  curl -u peter:peter localhost:8081/subjects
  curl -u carsten:carsten localhost:8081/subject
  ```

Try an unauthorized user like user bender (it should show empty)
  ```
  curl -u bender:bender localhost:8081/subjects
  ```

Try to get the schema version the latest as user suvad
```
curl -u suvad:suvad http://localhost:8081/subjects/eagle_topic2-value/versions/latest
```

Lets write some data to topic as user carsten
```
kafka-console-producer --broker-list localhost:9094 \
--producer.config carsten.properties --topic eagle_topic2 
# Enter
{"f1": "001"}
{"f1": "002"}
{"f1": "003"}
{"f1": "004"}
CTRL+c
```

Now:
 * go to Control Center and login as peter.
 * go to the topics area and click on eagle_topic2
 * go to topics and choose eagle_topic2 and then click on "Messages"
 * and choose jump to offset and set it to 0 (zero). 
 * click on "columns" and deselect everything except "topic" and "value" to see only relevant data
 
Now:
 * click on "Schema" and then on "Edit schema" button
 * change the name from "Payment" to "Payment2" and click on save
 * then click on "Version history" and enable "Turn on verrsion diff" to see if there are now 2 schema versions

 
Try now what is the output from command prompt (we should see 1,2 as output)
 ```
curl -u suvad:suvad http://localhost:8081/subjects/eagle_topic2-value/versions
```

OK, lets go now to the 2nd part of this lab and this is to enable eagle_team to work with KSQL.

Use KSQL cli and try with peter (not allowed):
```
ksql -u peter -p peter http://localhost:8088
ksql> show topics;
ksql> print 'eagle_topic1' from beginning;
ksql> exit
```

Now login as professor
```
ksql -u professor -p professor http://localhost:8088
ksql> show topics;
ksql> print 'eagle_topic1' from beginning;
ksql> exit
```

OK, then lets authorize eagle_team to work with KSQL.

Now login as professor
```
confluent login --url http://localhost:8090 # as professor/professor
```
And now create the RBAC role bindings
```
confluent iam rolebinding create \
    --principal Group:eagle_team \
    --role DeveloperWrite \
    --kafka-cluster-id $KAFKA_ID \
    --ksql-cluster-id $KSQL_ID \
    --resource KsqlCluster:ksql-cluster

confluent iam rolebinding create \
    --principal Group:eagle_team \
    --role DeveloperRead \
    --kafka-cluster-id $KAFKA_ID \
    --resource Group:_confluent-ksql- \
    --prefix 
```

Use KSQL cli and try with peter again (it should work now):
```bash
ksql -u peter -p peter http://localhost:8088
ksql> show topics;
ksql> print 'eagle_topic1' from beginning;
ksql> exit
```

Login now as carsten
```bash
ksql -u carsten -p carsten http://localhost:8088
ksql> show streams;
ksql> CREATE STREAM EAGLE_TOPIC2_STREAM (NAME STRING) WITH (VALUE_FORMAT='JSON', KAFKA_TOPIC='eagle_topic2', PARTITIONS=1, REPLICAS=1);
ksql> describe extended EAGLE_TOPIC2_STREAM;
ksql> SET 'auto.offset.reset'='earliest';
ksql> select rowtime from EAGLE_TOPIC2_STREAM emit changes;
```

All Labs are finished.

go back to [to Lab Overview](https://github.com/ora0600/confluent-rbac-hands-on#hands-on-agenda-and-labs)
