[Source Data Capture](https://www.myersholum.com/article-2-source-data-capture/)

Things to note when pulling data out of Salesforce:
* Most system dates are in UTC.
* Salesforce IDs are unique in 15 characters if case sensitivity is used in the target database.  If case sensitivity is not used, all 18 characters of the ID must be used to obtain a unique ID.
* Some Salesforce license levels place limits on API access and will therefore throttle your ETL efforts.

Force.com is an operational relational database and not well suited to business intelligence. 

The approach I recommend when developing a business intelligence solution for Salesforce is to start out with a straight replication to a staging area.  Then perform transformations into the appropriate format be that a star schema or something else. This will allow you to query and use data that is identical to that found in Salesforce for your transformations and will allow for easy debugging without the need to cross platforms.

Data is first replicated and placed in a staging area, then transformed to star schema format in a data warehouse and finally to cube format in an OLAP database. 

Organizations have the need to access Salesforce data for in-house applications, provide database level access to these 3 data formats (Replication, Star Schema and OLAP).

Data Warehouse layers:
* source data capture layer
* central (or active) data warehouse layer
* end-user consumption (semantic) layer

Questions for each layer:
* what business and technical requirements influenced the existing implementation?
* how (and how well) does the implementation satisfy the requirements?
* whether the requirements still apply?
* how you should implement that layer going forward to Google Cloud?

#### Source Data Capture Layer
Data capture might occur via:
* Pull – extract data directly from the source of record by accessing its database (or mirror, replica, or database log) on some periodic basis;
* Push – get a periodic set of data from the source of record (e.g. via flat files) and do not access its database; or
* Stream – you get an episodic or real-time (not periodic) feed of data via a streaming interface (message, queue, etc).

Implementation will then land the data into:
* land it in a file system
* stage it in work or temporary tables in a relational database (or NoSQL or Hadoop)
* land it in permanent database tables so that source data is retained close to its original format
* use ETL and don’t land it all, but rather transform it in-flight to its final data warehouse target tables

#### Implementation Style
Business requirements influence the implementation style of the source data capture layer. 
