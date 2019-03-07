# Batch Data Synchronization
## Context
Extract customer activity information from Salesforce and import it into an on-premises data warehouse on an ongoing basis.
## Problem
How do you import data into Salesforce and export data out of Salesforce, taking into consideration that these imports and exports can interfere with end-user operations during business hours, and involve large amounts of data?
## Forces
There are various forces to consider when applying solutions based on this pattern:
Should the data be stored in Salesforce? If not, there are other integration options an architect can and should consider (mashups, for example).
If the data should be stored in Salesforce, should the data be refreshed in response to an event in the remote system?
Should the data be refreshed on a scheduled basis?
Does the data support primary business processes?
Are there analytics (reporting) requirements that are impacted by the availability of this data in Salesforce?

## Solution
| Solution | Fit | Data master | Comments |
| --- | --- | --- | --- |
| Change data capture | Best | Remote System | Leverage a third-party ETL tool that allows you to run change data capture against source data.  The tool reacts to changes in the source data set, transforms the data, and then calls Salesforce Bulk API to issue DML statements. This can also be implemented using the Salesforce SOAP API. |