# Migration

* Determine steps to have Feed on the contact level
* Determine what can be migrated
* Plan on how to rework features which cannot be migrated
* List of hot case detail fields.  What Lightning options exist for having a component?
* List of toolkit features - showing the Case Tools to advocates in a Lightning console. 
* Five9 softphone utility - get the Five9 Lightning-enable softphone working in the Lighning Service Console
* Determine which functionality blocks will be migrated:
    * Feed - Standard Feed Filters for: Use custom feed filters
    * hot fields - 
    * case tools - 
    * Fitbit integrations 
        * Fitbit Payments Panel - Aura Component embedded inside of the Accordion Standard Component, annotate Apex classes
        * Order Panel - Aura Component embedded inside of the Accordion Standard Component, annotate Apex classes
        * Dutch Panel - Aura Component embedded inside of the Accordion Standard Component, annotate Apex classes
        * Family Account Panel - Aura Component embedded inside of the Accordion Standard Component, annotate Apex classes
    * Contact data - Aura component with Lightning Data Service
* POC: Lightning Service Cloud V1.0
### Salesforce Classic Service Console Features
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
3. Omni-Channel 
4. Social Customer Service
    * Social business rules - to define how social cases are handled.

## Custom Panels
 ### Fitbit Payments Panel 
 This panel shows the cards linked and the transactions using the Fitbit watch

    Below are the Jira Stories for the payments Panel:
    1. SFDC-1648
    2. SFDC-1881
    3. SFDC-2029

    Component list for the payment panel:

    VF Page:

    Main VF Page: Fitbit_Payment_Panel [fitbit.my.salesforce.com]
    Helper VF Component 1: PaymentInfoComponent [fitbit.my.salesforce.com]
    Helper VF Component 2: PaymentTokenComponent [fitbit.my.salesforce.com]

    Apex Class:

    Apex Controller: PaymentMainCtrl [fitbit.my.salesforce.com]
    Payment Authorization Controller: PaymentsAuthorize [fitbit.my.salesforce.com]
    API Helper Apex Class: PaymentAPICtrl [fitbit.my.salesforce.com]
    Other Helper Classes: PaymentUtilityClass, PaymentTrackerInfoWrapper, PaymentTransactionWrapper, PaymentActivityWrapper, FitbitUserWrapper, Fitbit_ApiCallout_utility

    Custom Setting: 
    
    CSFitbitOauth__c

    Migration:

    * Replace JavaScript buttons with Quick Actions
        * For the component to know its page context, it must implement the `force:hasRecordId` interface.
        * 

### Order Panel: This panel shows the orders for the customers
Component list for the Order panel: 
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

### Dutch panel
This panel shows the devices linked to the customer email.  This is a very old project so it has many Jira Stories, so we are not listing it here. 

Below is the component list for the Dutch panel:   
VF page: DutchConsole
We are using DutchConsole Vf page to show the details of devices associated with case.fitbitEmail.
When there are no devices associated with fitbitEmail, we are showing the message in the panel "No email addresses available to lookup in Dutch". If API Returns any error or there is an exception in code, we are showing the generic error message to the agent.

Apex classes: 
a) DutchDataController: This is the main Controller of Vf page. We have written the API Callout for Dutch API to get the details of the devices for email. (Method = getUserDevicesForEmail)
Method used for Authorization : DutchDataController.fetchValidAccessToken
b) DutchDeviceTreeJS: This class is used to deserialize the Dutch response and we filter out the fields which are needed to show on Dutch panel.
c) DeviceWarrantyCtrl = This class is used to get the warranty start date based on device serial number.
d) DutchDeviceData, DeviceWarrantyWrapper: These are the two Wrapper classes we are using.

Custom setting: CSFitbitOauth (AUTHORIZE_URL__c, USER_DEVICES_URL__c)

### Family Account Panel 
This panel shows the family members linked to the account in the case.fitbit_email__C.

Jira EPIC: SFDC-2748
Vf Page: FamilyAccountPanel
Apex Controller: FamilyAccountPanelCtrl
Wrapper Class: FamilyAccountWrapper
Custom Setting: API_End_Points__c, CSFitbitOauth__c 

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
### Service Console
#### Lightning Experience Console Limitations
##### Visualforce
Visualforce is available in Lightning console apps as beta, which means it’s a high-quality feature with known limitations. 

Lightning console apps’ Visualforce support includes:
* Lightning pages containing Visualforce Lightning components
* Visualforce mass actions
* Custom tabs that display a Visualforce page
* Opening Visualforce pages as new workspace tabs or subtabs using the openTab() and openSubtab() JS APIs
* Visualforce overrides for new, edit, view, tab, list, and clone actions
* Visualforce components in the utility bar

##### Lightning console apps don’t currently support:
* Visualforce overrides for delete and custom actions
* Visualforce buttons and links
* Overrides aren’t supported on the Case object when using the default service console app. To use overrides on cases, create a custom console app.
* Region presentation—size 
    * In Salesforce Classic, you can adjust the size of a component. In Lightning Experience, the page template for your record page determines the size of the component region. For example, the three columns page template provides a main column width of 50%, and the side columns widths are each 25%. To view the available page templates, create a page in Lightning App Builder.
* Multi-monitor—pop-out workspaces - In Salesforce Classic, this feature is called multi-monitor components.
* The utility bar doesn’t support Visualforce pages or components.
* The utility bar doesn’t fully support the Chatter Publisher and Feed components.
* 


#### New Lightning App: [Fitbit Customer Service](https://fitbit--lightning.lightning.force.com/lightning/r/Case/5000t000005JT3QAAW/view)
| Feature | |
| --- | --- |
| Navigation Style | Console Navigation | 
| Utility Items | quick access to productivity tools and add background utility| 
| Navigation Items | Choose the items to include in the app |
| Navigation Rules | Navigation rules determine whether to open a related record in addition to the primary record. |

#### 
#### Service Console Feed
Determine which fields from the Contact object to add to Feed tracking

### JavaScript Buttons
Create a Lightning component. Then give users access by either invoking access from a Lightning component action or using Lightning App Builder to add the Lightning component to a Lightning page.
This button contains code for a conditional URL. Consider this customizable sample component as a replacement: redirectConditionalUrl.

##
### Productivity 
* Use web standards like ES6+, classes, modules, custom elements, and templates.
* Access, cache, and synchronize data and meta-data with `@wire` decorator
* Get 70+ meta-data aware base Lightining Components
* Aura and LWC components communicate via Events Public API
Performance 
* more code executing natively in the browser and less code executing in the javascript framework
* (cacheable=true)
Interoperatibilty



* Apex methods have to be annotated with `@AuraEnabled(cacheable=true)`
* to import Apex method use this script: `import findContacts from '@salesforce/apex/ContactController.findContacts';`
* LWC are meta-data aware - native metadata bindings
* Referential integrity - development error and user runtime error in place

### SalesforceDX Setup

## Create Support Processes

### Create a New User Using Lightning Setup Flow  
### Configure Case Status Picklist Values 
### Create a product support process to support product-related cases.
### Create an inquiry support process for customer inquiries.
### Create Case Page Layouts
* Highlights Panel
* Quick Actions in the Salesforce Classic Publisher
* Case Detail
### Create Record Types 
### Create a Case to Test Your Support Processes 





## Resources
* [Compare Lightning Experience and Salesforce Classic](https://help.salesforce.com/articleView?id=lex_aloha_comparison.htm&type=5)
* [Evaluate and Roll Out Lightning Experience for Your Org](https://help.salesforce.com/articleView?id=lex_welcome_to_lex.htm&type=5)
* [Fitbit Console Migration Document](https://docs.google.com/document/d/1RD36S96KuU1ygn-mJm7-OG-JWsGwNFvex6PwCz_F3so/edit)
* [Lightning LockerService](https://medium.com/@mohitkumarsrivastav/lightning-lockerservice-is-coming-are-you-ready-4de798c7a1d9)
* [Lightning Data Service](https://developer.salesforce.com/docs/atlas.en-us.218.0.lightning.meta/lightning/data_service.htm)
* [Lightning Experience Pro Tip Series](https://admin.salesforce.com/lightning-experience-pro-tip-series)
* [Salesforce Lightning Component LockerService](https://medium.com/@mohitkumarsrivastav/salesforce-lightning-component-lockerservice-demystified-7e596e04a01f)
* [Implement and Use Lightning Service Components](https://developer.salesforce.com/blogs/2018/08/implement-and-use-lightning-service-components.html)
* [DOM](https://dom.spec.whatwg.org/#concept-event)
* [Lightning Experience Configuration Converter](https://lightning-configuration.salesforce.com/visualforce-pages.xhtml)
* [Lightning Web Components Dev Guide](https://developer.salesforce.com/docs/component-library/documentation/lwc/lwc.interop_aura_composition)
* [Magic Mover for Notes And Attachments to Lightning Experience](https://appexchange.salesforce.com/appxListingDetail?listingId=a0N3A00000EHAmyUAH)
* [Octane test](https://fitbit.my.salesforce.com/speedtest.jsp)
* [Working with Aura and Lightning Web Components: Interoperability and Migration](https://developer.salesforce.com/blogs/2019/02/working-with-aura-and-lightning-web-components-interoperability-and-migration.html)
* [Classic Console API Methods Supported in the Lightning Console API](https://developer.salesforce.com/docs/atlas.en-us.218.0.api_console.meta/api_console/sforce_api_console_lightning_classic_bridge_methods.htm)
* [Sample Components for Lightning Component Actions](https://github.com/fitbit-v/LEXComponentsBundle)
* [Softphones for Lightning Console Apps](https://help.salesforce.com/articleView?id=console_lex_custom_utilities_softphone.htm&type=5)
* [Lightning Console JavaScript API for Lightning Experience](https://developer.salesforce.com/docs/atlas.en-us.api_console.meta/api_console/sforce_api_console_js_getting_started.htm)
* [Create Publisher Actions ](https://trailhead.salesforce.com/content/learn/modules/chatter/chatter_actions)
* [Feed Filters to Manage Your Feed ](https://trailhead.salesforce.com/en/content/learn/modules/service_casefeed_basics/service_casefeed_basics_filters)
* [Lightning Console Migration](https://trailhead.salesforce.com/en/content/learn/modules/service_casefeed_basics/service_casefeed_basics_filters)
* [Five9 Console](https://app.five9.com/?role=DomainSupervisor)
* [Supported Salesforce Experiences and Tools](https://developer.salesforce.com/docs/component-library/documentation/lwc/lwc.get_started_supported_experiences)
* [LWC APP Sample Gallery](https://trailhead.salesforce.com/sample-gallery)
* [Features Available in Lightning Console Apps](https://help.salesforce.com/articleView?id=console_lex_feature_parity.htm&type=5)
* [Component Reference](https://developer.salesforce.com/docs/component-library/overview/components)
* [Lightning Web Components Recipes, Patterns and Best Practices](https://developer.salesforce.com/blogs/2018/12/introducing-lightning-web-components-recipes-patterns-and-best-practices.html)
* [Introducing Lightning Web Components Trailmix](https://trailhead.salesforce.com/en/users/strailhead/trailmixes/introducing-lightning-web-components)
* [`forceChatter:feed`](https://developer.salesforce.com/docs/component-library/bundle/forceChatter:feed/documentation)
* 
