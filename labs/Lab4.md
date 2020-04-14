## Lab 4. Advanced Hands-on with RBAC: Setup real use case

We have seen only user role assignments, now we would like to use groups, to make the live of an Admin easier:
```bash
# add users and one group to openLDAP
docker exec -it openldap bash
ldapadd -x -D "cn=admin,dc=planetexpress,dc=com" -w GoodNewsEveryone -H ldap:// -f /etc/add-user/add-user.ldif
```
Login into MDS as professor
```bash
confluent login --url http://localhost:8090
```
Assign read access to group projecta_projectowner
```bash
# READ Role
confluent iam rolebinding create \
--principal Group:projecta_projectowner \
--role DeveloperRead \
--resource Topic:foo.topic1 \
--prefix \
--kafka-cluster-id $KAFKA_ID
```

Assign role to consumer group
```bash
confluent iam rolebinding create \
--principal Group:projecta_projectowner \
--role DeveloperRead \
--resource Group:console-consumer- \
--prefix \
--kafka-cluster-id $KAFKA_ID
```

List roles for Group projecta_projectowner
```bash
confluent iam rolebinding list --principal Group:projecta_projectowner --kafka-cluster-id $KAFKA_ID
```

Check if now peter can read via group role assigment
```bash
kafka-topics --bootstrap-server localhost:9094 --list  --command-config peter.properties
```

And try to consume as peter
```bash
kafka-console-consumer --bootstrap-server localhost:9094 \
--consumer.config peter.properties --topic foo.topic1 --from-beginning
```

List roles of Peter (list over role, will be derived)
```bash
confluent iam rolebinding list --principal User:peter --kafka-cluster-id $KAFKA_ID
```

you should see
```bash

`     Principal               |     Role      | ResourceType |       Name        | PatternType  
+-----------------------------+---------------+--------------+-------------------+-------------+
  Group:projecta_projectowner | DeveloperRead | Group        | console-consumer- | PREFIXED     
  Group:projecta_projectowner | DeveloperRead | Topic        | foo.topic1        | PREFIXED     '
```

All Labs are finished.

go back to [to Lab Overview](https://github.com/ora0600/confluent-rbac-hands-on#hands-on-agenda-and-labs)