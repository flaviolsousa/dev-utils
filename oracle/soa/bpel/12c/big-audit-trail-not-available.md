# Error:
To open audit trail:
Error while processing audit information. Failure due to Exception fetching audit xml.

On log:
The size of the requested audit trail for flow id "170,003" is larger than the configured threshold of "1,048,576" characters.

# Solution:

Go to Enterprise Manager:
http://localhost:8001/em

- Expand the Farm and SOA nodes.
- Open soa-infra (AdminServer)
- SOA Infrastructure > SOA Administration > Common Properties
- More SOA Infra Advanced Configuration Properties...
- AuditConfig
- Increase the value of `instanceTrackingAuditTrailThreshold` parameter (In my case 104857600).
