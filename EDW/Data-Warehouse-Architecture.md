Modern cloud infrastructure offers a compelling opportunity to reimagine demanding data applications.  Large data warehouses, long constrained by prior technology, can be good candidates for migration to the cloud.  Google Cloud Platform offers a suite of fully-managed, elastically-scalable database services suitable for re-platforming large data warehouses for enhanced performance at reduced cost and complexity.

Google Cloud Platform supports several SQL-capable data services: Cloud SQL, Cloud Spanner, and BigQuery, each of which offers capabilities relevant to a data warehousing environment.  BigQuery in particular can be very fast at remarkable scale, though it has architectural features that differ significantly from a conventional RDBMS platform.  

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
Business requirements influence the implementation style of the source data capture layer.  Typical considerations are:
* `required latency` – how quickly changes in sources must be reflected in the data warehouse – and requirements to trace lineage and retain source data.  
* Technical constraints are also important.  On the data capture side, the capture strategy (pull, push, stream) is typically dictated at least in part by the capabilities of the source application.   The choice of landing strategy is typically influenced by the capabilities of the tool or tools that will consume the landed source data.

One of the best ways to avoid unnecessary complication in your data warehouse conversion is to keep most of your current source data capture processes in place.  While a capture strategy (e.g. push) for a specific source of record may not meet the current business need (they want to stream for example), a change to this strategy should be avoided unless it’s implemented on the Snowflake side first.  How would you perform side-by-side conversion validation if the captured source data are not the same?

After you’ve considered data capture, you’ll want to characterize how the captured data are landed, and whether your implementation includes reference data architecture components that support a unified landing model regardless of the capture method and source of record.  For example, MHI uses a unified landing model we typically call “landing zone”, and we persist that model in a relational database and distributed storage.   All data capture activities target the “landing zone”, and control processes manage the accessibility and lifespan of slices of captured data.  

It is important to realize that this initial landing of data is the point where you want the data copied to the Google cloud.  A standardized approach will provide operational benefit.  Note that this standardized approach is essentially a data lake, and thus would provide analytical benefit, particularly if you have an experienced data mining / data analysis / data science team accustomed to accessing a data lake.

The landed data typically anchor the beginning of data lineage – the tracing of data elements from the source through the warehouse’s architectural layers and transformations.  This is frequently a key business requirement and is foundational for effectively validating warehouse data.  A typical MHI “landing zone” table for a batch (ETL) process would satisfy this requirement by appending a number of “ETL” attributes that support process and lineage tracking.  Representative attributes might carry identifiers to track individual rows, session execution, and workflow execution; these values would then propagate to downstream architectural layers.  This allows each data element to be tracked unambiguously through the warehouse.

If you are using a variety of landing methods (work tables, flat files, etc.) without regard to any architectural standardization, your conversion becomes more complicated, and the difficulty of tracing data lineage increases significantly.

At the end of this analysis of your source data capture layer, you will create a catalog for the layer, enumerating source systems, data volumes, latency requirements, architectural patterns, and source capture and landing approaches.  Each variation will require a specific conversion approach.
Central Data Warehouse Layer

The primary business requirement for this architectural layer is integration – preparing and reconciling information from disparate sources in an internally-consistent way to support global access and analysis.  There has been an active conversation in the warehousing community for many years about the “best” way to achieve this goal, with convictions of near-religious fervor evident from prominent voices.  Fortunately, we don’t need to identify a “best” approach; we simply need to understand the common design idioms, and know how to use the Google Cloud Platform toolset to support each.

Among Snowflake implementations, two architectural styles are most common.  In the first, commonly referred to as an `“Operational Data Store” (ODS)`, the data warehouse is modeled after the system of record.  Warehouse tables look like the source system tables – and there are probably as many variations of the representation of each data entity (e.g. a reservation or a travel itinerary) as there are source systems.  The layer may support `versioning (the time series of changes)` through the addition of effective date attributes, a sequence number, and a current-record indicator.  The layer may further support architectural controls through the addition of lineage- and/or process-tracking attributes.  This architectural style typically relies on a robust semantic layer to achieve significant integration of data from separate sources.

In the second common Snowflake architectural pattern, the data warehouse is modeled after a canonical industry model, whether purchased (e.g. a Snowflake industry data model), based on a design pattern (e.g. Silverston) or created in-house.  This style is often referred to as a Snowflake “Active Data Warehouse”.  In this case, the data warehouse tables follow a canonical model designed to support current- and future-state business requirements to the greatest extent possible.  Versioning of data is typically supported robustly.  The schema is typically highly normalized (e.g. 3rd-normal-form), and the consumption model relies on the power of the Snowflake platform to allow downstream applications to directly and efficiently access the data warehouse while preserving a single copy of the data.  Those downstream applications are typically SQL access (SQL Assistant), BI applications or ELT/ETL processes that feed downstream applications.  This is the style of the Inmon “Corporate Information Factory”.

Two additional architectural patterns are encountered rather rarely on Snowflake; we include them here for completeness.  Both would be robustly supported by the Snowflake architecture.  One is the Kimball “Bus Architecture”, in which the data warehouse is modeled as a series of data marts (star schemas) integrated via conformed dimensions.  The other is the “Data Vault”, in which data and relationships are cast into a design pattern based on “hubs”, “satellites” and “links”.  

For all their differences, a common feature of these various architectural patterns is the need to handle CRUD (create-read-update-delete) data and manage versioning of information, to satisfy the common business requirement to faithfully represent historical data.  This will be a key consideration for any conversion of a data warehouse to Google Cloud Platform. 

Key reasons businesses model their data warehouse like the source of record:

    It is a more agile (bottom-up) approach, easiest to model and develop.
    The organization is frequently changing operational systems (hyper-growth mode).
    The organization has compartmentalized and/or reactive focus on data with little focus on uniform data governance.  End-user departments just want the source data.

Key reasons businesses model their data warehouse using an industry (canonical) model:

    Perhaps because of acquisitions, there are multiple sources of record (operational systems) for the same data entities, for example, data must be integrated from multiple active ERP systems.
    The principal source of record is very de-normalized but supplies many data entities (e.g. mainframe files like VSAM or IMS).
    In both cases above, a canonical model is needed to provide a consistent interpretation of the source data for consumption.
    The organization has more of a data governance focus (maturity), and is using the canonical model to implement standardized data definitions.

There is an intrinsic design relationship between your central data warehouse and your semantic layer; you need to understand this relationship.  If you want integrated data, data discipline has to be imposed at some stage – typically either entering or exiting the central layer.  Thus, the more your central data warehouse is modeled after the system of record, the more sophisticated your semantic layer should be.  Since there has been little transformation of source data up front, the burden of deciphering, cleansing and standardizing source data values occurs as it is consumed from the data warehouse.  Hopefully, that transformation has been standardized in either a series of semantic database views implemented on top of the data warehouse tables or in the BI tool’s semantic layer.  Otherwise, each end user of the data warehouse probably has specific (and probably different) methods for accomplishing that transformation, using various end-user oriented tool sets, which will all need to be evaluated for the conversion.  Conversely, the more your central data warehouse is modeled using a canonical model, the less sophisticated your semantic layer needs to be.  While there may be database views that are used for access control, row level security or multi-tenancy requirements, it would be expected that the database tables in a canonical model essentially meet the consumption requirements.  The transformation of source data – deciphering, cleansing and standardizing – should occur as data is loaded into the canonical model.  You may still have a semantic layer that focuses on ease and consistency of use, perhaps projecting the canonical model as a star or snowflake schema and resolving typical effective-date filters.  Look for this layer to be implemented either as database views or within your BI tool.

A semantic data model (SDM) captures the business view of information for a specific knowledge-worker community or analytic application.  It provides a consistent, governed, intentional view of the data for a group of consumers, typically masking the complexity of the physical representation of the data to make it easier and less error-prone to consume.  There may be a different semantic data model for each department/application that uses the data warehouse.  One way to look at your semantic layer is as a formal representation of the metadata that gives defined, consistent meaning to the data elements that populate your warehouse.

Semantic data modeling is a logical data modeling technique.  The prevalence and intuitive nature of dimensional modeling makes it particularly well-suited to, and commonly encountered for, the semantic data model for an analytic application.  In Snowflake implementations, the semantic data model will typically be physicalized using either database views or the semantic capabilities of the BI tool; the platform’s data-retrieval engine typically supports efficient access to the central layer without physicalizing an intermediate star schema.  In contrast, in a full semantic layer implementation, the data warehouse itself is never directly accessed by downstream applications.

The semantic layer can provide data cleansing, and apply business rules, de-normalizations, transformations, and/or calculations before exposing data for downstream applications.

When considering conversion to the Google cloud, it is important to understand how the semantic layer has been implemented, and the extent to which it is used:

    How much end user access is performed without the semantic layer?
    Has the semantic layer data model been maintained?

At the end of this analysis of your semantic layer, you should know whether the semantic layer or the central data warehouse layer is carrying the bulk of the burden of integrating and standardizing your data.  You should also have a good idea how much of the consumption of data from the warehouse goes through governed channels, and how much makes an end-run around your best efforts to standardize.

##
Three types of source capture processes:
* pull
* push 
* stream

#
Implementation strategies for landing the data into the data warehouse for each type of process?

* We recommended conversion rather than re-implementation of your current source data capture processes as a very important aid to facilitate side-by-side validation of your converted data warehouse. 

* creation of a unified landing model, as an architectural component we called the “Landing Zone”
## Implementation of the Enterprise Landing Zone
Creation of a unified landing model, as an architectural component called the “Landing Zone”
* expense reduction/capital spend avoidance ROI model
* cost of the conversion must be constrained to fit within this cost reduction model
* forms of staging (flat files, relational tables or XML formats) 
### Nuances of landing data
* All relational databases enforce data integrity through the use of pre-defined schemas and data definitions that include type, length, and nullability. 

* ETL (Informatica PowerCenter) – Generates a flat file store (BAD files) of any source records rejected by the target.  
* Teradata Utilities – Populate error tables if any source records are rejected because of source format, data conversion, or constraint violations.
* Knowing which source capture processes rely on the data integrity provided by the relational database is needed to best understand which Google Cloud Platform product can supply similar capabilities.
#### Checklist for evaluating your source data capture processes

