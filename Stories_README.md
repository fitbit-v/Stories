<<<<<<< HEAD
Grax - Salesforce plugin
* architecture and security
* prod org is moving to S3
* 3rd party archiving - storing and not as much accessing
* Salesforce object sizes
* CS15513 - Keith and Greg
* protect secrets and credentials
* CS Tools Scrum - data for this sprint
* SFDC-4625, 4532, 3886, 4571, 4578
* CS-14915
* Rules engine
* look at open cases in Salesforce Help
* CS Tools
* Fitbit Protectin Plan, Tiered Support, Trade-in Program - Aegis?
* Fitbit Health Solutions - health alliances with insurance and payers
* United Healthcare motion program
* Agent experience needs to move to lightning
* Cypress MCU
* 15% of 3000 replacements are fraud related
* help.fitbit.com - Salesforce site on force.com - 4 Mil views
* community.fitbit.com - built on Lithium - 2.7 Mil views
Grax - Salesforce plugin
* attachments object - soql query
* lightning object
* visualforce access metrics - which pages I am using
* LE configuration converter
#### Tech Stack
[Salesforce Sites](https://help.salesforce.com/articleView?id=sites_overview.htm&type=5)
[Site.com](https://help.salesforce.com/articleView?id=siteforce_overview.htm&type=5)
* HelpSite - force.com site
* 


## Lightning Migration
* attachments object - soql query
* lightning object
* visualforce access metrics - which pages I am using
* LE configuration converter

## Amazon S3 Storage Classes
[Monthly Calculator](https://calculator.s3.amazonaws.com/index.html)
* [Amazon S3 Storage Classes](https://aws.amazon.com/s3/storage-classes/)
* `S3 Standard` for general-purpose storage of frequently accessed data; 
* `S3 Intelligent-Tiering` for data with unknown or changing access patterns; 
* `S3 Standard-Infrequent Access` (S3 Standard-IA) and 
* `S3 One Zone-Infrequent Access` (S3 One Zone-IA) for long-lived, but less frequently accessed data; and 
* `Amazon S3 Glacier (S3 Glacier)` and 
* `Amazon S3 Glacier Deep Archive` (S3 Glacier Deep Archive) for long-term archive and digital preservation. Amazon S3 also offers capabilities to manage your data throughout its lifecycle. Once an S3 Lifecycle policy is set, your data will automatically transfer to a different storage class without any changes to your application.  
=======

>>>>>>> 3d1b44807fc269a600b283f95ddacccdff1d06d5

* own the security approach
* how to keep safe the accounts in SFDC
* how are we managing Fitbit's identities
* how do we know we are hacked
* how do we know identities are passed
* `how sso for android is working - and get it fixed`
* on ios it is not working
* how are we storing account information in Saleforce, we copy fitbit token to Salesforce
* Subaru's team is in their
* what happens when we merged cont2acts with the fitbit ids
* ids are stored in the intersection object between contacts and community
* YGO Claims and Community Users
* move PKB from help.com to myHelp.com
* check on what has been done so far on this 
* have to be off of the site platform at the end of May
* forms need to be running on myhelp
* move all of the chat to an authenticated site


### Current Stories
* reCAPTCHA implementation - pages:
    * pre-Chat page
    * Corporate Programs page
    * Female Health page
    * SSC
    * Email form
* reCAPTCHA V2 and V3 architecture overview with John Meyer (3/26/2019)
* Help site migration: pkbController refactoring
* Lightning migration
    * Planning stage 
    * List of features to be migrated
    * Feature architecture (LWC vs Aura, LDS vs Apex)
    * Identify feature which cannot be migrated to Lightning stack
* Technical architecture for Help site migration
* Preventing Account Takeover (PTA)
* Salesforce Live Agent architecture design (Petr Prisyazhniuk request)
    * Human coaching chat vision
* [DNS Security (DNSSEC) Update for Salesforce Domains](https://help.salesforce.com/articleView?id=000274941&language=en_US&type=1)
    * Salesforce domains that are part of Salesforce applications will have a new security feature (DNS Security, or DNSSEC) enabled. This is a DNS based trust validation when connecting to Salesforce application entry points (i.e. Salesforce Communities and MyDomain).
* SalesforceDX (DevOps for Salesforce) implementation
* Chat concurrency issue
    * Next step: onsite meeting with Salesforce support team
* GRAX implementation
    * Next step: AWS Elasticsearch implementation, AWS S3 account provisioning
