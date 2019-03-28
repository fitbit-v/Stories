# Migration

## Classic Service Console
* Contact Detail
* Feed (Social, Email, Post, Log a call, Update Case)
* Cases Section?
* Utility Bar (Fitbit Alerts, Macros, Knowledge, History, Live Agent, Five9 Softphone)
* Return Label Tool
* Replacement Offer Admin
* Find Orders
* Name Change Tool
* 2FA
* Medical Case Reviewer
* Disable Enable Tool
* Switch User
* Delete Fitbit Account
* Replacement Tool
* Fitstar
* Admin
* AU Cart
* NZ Cart
* Fedex
* Account Change Email Tool
* Active Minutes (Raw Data)
* Challenges
* Exercise Viewer
* Refund Check Request
* Kibana
* Sickle
* Badges Management
* AU Orders Doc
* NZ Orders Doc
* Domestic Shipping
#
* Family Account
* Dutch
* Fitbit Orders
* Payments

### Lightning Console feature:
* hot case detail fields at the same time the Feed is shown
* options for showing the Case Tools to advocates in a Lightning console
* how components can get rendered in a Lightning Console
* Feed (major pixel real-estate), hot fields, case tools, Fitbit integrations (Dutch, Orders, etc.), and contact data
## Lightning Service Console
1. Recently Viewed
2. 
3. Omni-Channel 
4. Social Customer Service
    * Social business rules - to define how social cases are handled.

### Custom Panels
 Fitbit Payments Panel: This panel shows the cards linked and the transactions using the Fitbit watch.

    Below are the Jira Stories for the payments Panel:
    1. SFDC-1648
    2. SFDC-1881
    3. SFDC-2029

    Below is the component list for the payment panel:

    VF Page:

    Main VF Page: Fitbit_Payment_Panel [fitbit.my.salesforce.com]
    Helper VF Component 1: PaymentInfoComponent [fitbit.my.salesforce.com]
    Helper VF Component 2: PaymentTokenComponent [fitbit.my.salesforce.com]

    Apex Class:

    Apex Controller: PaymentMainCtrl [fitbit.my.salesforce.com]
    Payment Authorization Controller: PaymentsAuthorize [fitbit.my.salesforce.com]
    API Helper Apex Class: PaymentAPICtrl [fitbit.my.salesforce.com]
    Other Helper Classes: PaymentUtilityClass, PaymentTrackerInfoWrapper, PaymentTransactionWrapper, PaymentActivityWrapper, FitbitUserWrapper, Fitbit_ApiCallout_utility

    Custom Setting: CSFitbitOauth__c

### Service Console
| Benefit | Description |
| --- | --- |
| (1) Split views | From the start, you can see a list of cases alongside your workspace to quickly work through incoming customer issues. |
| (2) Related record and related list components | Right out of the box, you can see information related to a customer to get a well-rounded picture of their issue and who they are. Jump to lists of similar cases, and work off lists to keep your cases organized. | 
| (3) Highlights panel component | Without configuring a thing, spot exactly what you need front and center to respond to customers quickly. | 
| (4) Compact case feed | Understand case progression and case history at a glance with a news-like feed and preconfigured pages. Colorful icons help you distinguish between people and interactions instantly, and you can add a quick comment to help your customers or team. |
| (5) Knowledge component | See suggested articles from your knowledge base to solve cases faster, search articles to find exactly what you need, and attach common solutions from similar cases. (You must enable Lightning Knowledge first.) |
| (6) Preconfigured utility bar | Increase productivity with tools, such as Notes to jot things down, or History to go back to recently viewed records. |