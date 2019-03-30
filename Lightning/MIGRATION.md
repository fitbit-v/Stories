# Migration
## Resources
* [Compare Lightning Experience and Salesforce Classic](https://help.salesforce.com/articleView?id=lex_aloha_comparison.htm&type=5)
* [Octane test](https://fitbit.my.salesforce.com/speedtest.jsp)
* [Evaluate and Roll Out Lightning Experience for Your Org](https://help.salesforce.com/articleView?id=lex_welcome_to_lex.htm&type=5)
* [Fitbit Integrations Review](https://docs.google.com/document/d/1RD36S96KuU1ygn-mJm7-OG-JWsGwNFvex6PwCz_F3so/edit)
* [Lightning LockerService](https://medium.com/@mohitkumarsrivastav/lightning-lockerservice-is-coming-are-you-ready-4de798c7a1d9)
* [Lightning Data Service](https://developer.salesforce.com/docs/atlas.en-us.218.0.lightning.meta/lightning/data_service.htm)
* [Salesforce Lightning Component LockerService](https://medium.com/@mohitkumarsrivastav/salesforce-lightning-component-lockerservice-demystified-7e596e04a01f)
* [Implement and Use Lightning Service Components](https://developer.salesforce.com/blogs/2018/08/implement-and-use-lightning-service-components.html)
* [DOM](https://dom.spec.whatwg.org/#concept-event)
* [Lightning Web Components Dev Guide](https://developer.salesforce.com/docs/component-library/documentation/lwc/lwc.interop_aura_composition)
* [Working with Aura and Lightning Web Components: Interoperability and Migration](https://developer.salesforce.com/blogs/2019/02/working-with-aura-and-lightning-web-components-interoperability-and-migration.html)

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

## Custom Panels
 ### Fitbit Payments Panel: This panel shows the cards linked and the transactions using the Fitbit watch

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

### Order Panel: This panel shows the orders for the customers
Below is the component list for the Order panel: 
Vf page: Orders_Console_Panel
We are using Orders_Console_Panel Vf page to show the order details on the basis of Email address. There are two different tabs for CAT orders and AU/NZ Orders.
a) If the case country is Not equal to AU/NZ, We are hiding the AU/NZ Orders Tab.
b) If case Country is AU/NZ, We are showing the orders under the AU/NZ Orders tab else orders are showing under the CAT Order Tab.

We are using Contact.FitbitOrderEmail from the case in order panel. If there are no Orders associated with FitbitOrderEmail then we will go with Contact Email. And if there are no orders for Contact email as well then we are showing the message in the panel "No orders with that email". 
If API Returns any error or there is an exception in code, we are showing the generic error message to the agent.

Apex class:
a) OrderController :
Methods: fetchValidAccessToken (to get the access token for CAT Orders)
fetchauNZToken (to get the access token for AU/NZ Orders)
getPrimaryEmailAddress (Used to get the email address from the case). 
getOrders (Used to hit the Order lookup API). When Country is AU/NZ we are using the AU/NZ Order URL otherwise we are using the CAT Order URL.
 
b) OrderWrapper: This is the Wrapper class.

Custom setting: CSFitbitOauth(Authorization Endpoint), API_END_POINTS(Order API Endpoint for CAT and AU/NZ), Global Features(Turn off or Turn on Switch to show the orders in order panel)

### Service Console
| Benefit | Description |
| --- | --- |
| (1) Split views | From the start, you can see a list of cases alongside your workspace to quickly work through incoming customer issues. |
| (2) Related record and related list components | Right out of the box, you can see information related to a customer to get a well-rounded picture of their issue and who they are. Jump to lists of similar cases, and work off lists to keep your cases organized. | 
| (3) Highlights panel component | Without configuring a thing, spot exactly what you need front and center to respond to customers quickly. | 
| (4) Compact case feed | Understand case progression and case history at a glance with a news-like feed and preconfigured pages. Colorful icons help you distinguish between people and interactions instantly, and you can add a quick comment to help your customers or team. |
| (5) Knowledge component | See suggested articles from your knowledge base to solve cases faster, search articles to find exactly what you need, and attach common solutions from similar cases. (You must enable Lightning Knowledge first.) |
| (6) Preconfigured utility bar | Increase productivity with tools, such as Notes to jot things down, or History to go back to recently viewed records. |

| Salesforce Classic | Lightning Experience |
| --- | --- |
| Salesforce Console for Service | Lightning Service Console |
| Navigation Tab | Navigation Bar |
| Pinned Lists | Split View |
| Choose How Lists and Records Display | Navigation Rules |
| Console Components for Page Layouts | Lightning Components |
| Console Components for Apps (Footer) | Utilities |
| Console Footer | Utility Bar |
| History Component | History Utility |
| Macros Browser Footer Component | Macros Utility |
| Salesforce Console Integration Toolkit | Lightning Console Javascript API |


## Proposed Implementation
#### New Lightning App [Fitbit Customer Service](https://fitbit--lightning.lightning.force.com/lightning/r/Case/5000t000005JT3QAAW/view)
| Feature | |
| --- | --- |
| Navigation Style | Console Navigation | 
| Utility Items | quick access to productivity tools and add background utility| 
| Navigation Items | Choose the items to include in the app |
| Navigation Rules | Navigation rules determine whether to open a related record in addition to the primary record. |

#### 
#### Service Console Feed
Determine which fields from the Contact object to add to Feed tracking

https://fitbit.lightning.force.com/speedtest.jsp


