# How to disable Auto-Recovery in BPEL

### (Config)

Go to Enterprise Manager:
http://localhost:8001/em

- Expand the Farm and SOA nodes.

- Open **soa-infra (AdminServer)**

- SOA **Infrastructure** > **SOA Administration** > **BPEL Properties**

- **More BPEL Configuration Properties...**

- Change (Apply):

  ```Properties
  MaxRecoverAttempt=0
  ```

- Open **RecoveryConfig**

  - Change following values Folder > **RecurringScheduleConfig**

    ```Properties
    maxMessageRaiseSize=0
    startWindowTime=00:00
    stopWindowTime=00:00
    subsequentTriggerDelay=0
    threshHoldTimeInMinutes=0
    ```

  - Change following values Folder > **StartupScheduleConfig**

    ```Properties
    maxMessageRaiseSize=0
    startupRecoveryDuration=0
    subsequentTriggerDelay=0
    ```

### (Develop) Possible action required

##### Config on Component of Composite:

```xml
<property name="bpel.config.oneWayDeliveryPolicy" type="xs:string" many="false">sync.persist</property>
```

##### Sample:

```xml
<component name="InitializeProcess" version="2.0">
  <implementation.bpel src="BPEL/InitializeProcess.bpel"/>
  <componentType>
    <service name="initializeprocess_client_ep" ui:wsdlLocation="oramds:/apps/domain/pp/wsdl/ProcessOrder.wsdl">
      <interface.wsdl interface="http://api/model/orders#wsdl.interface  (process_ptt)"/>
    </service>
  </componentType>
  <property name="bpel.config.transaction" type="xs:string" many="false">requiresNew</property>
  <property name="bpel.config.oneWayDeliveryPolicy" type="xs:string" many="false">sync.persist</property>
</component>
```
