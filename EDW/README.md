Things to note when pulling data out of Salesforce:
* Most system dates are in UTC.
* Salesforce IDs are unique in 15 characters if case sensitivity is used in the target database.  If case sensitivity is not used, all 18 characters of the ID must be used to obtain a unique ID.
* Some Salesforce license levels place limits on API access and will therefore throttle your ETL efforts.