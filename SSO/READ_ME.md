# SSO
* [Authenticated Site Configuration](https://jira.fitbit.com/browse/SFDC-2672?jql=ORDER%20BY%20lastViewed%20DESC)
* [Sync Doctor UX Specification V0 - Confluence Page](https://wiki.fitbit.com/pages/viewpage.action?spaceKey=~Akumar&title=Sync+Doctor+UX+Specification+-+V0)
* [Some users receiving an error after clicking the YGO link](https://jira.fitbit.com/browse/SFDC-4578)
* [Configure SAML Settings for Single Sign-On](https://help.salesforce.com/articleView?id=sso_saml.htm&type=5)
* [Configure SAML for Communities](https://help.salesforce.com/articleView?id=networks_auth_configure_saml.htm&type=5)
* [Customize SAML Start, Error, Login, and Logout Pages](https://developer.salesforce.com/docs/atlas.en-us.sso.meta/sso/sso_saml_start_stop_pages.htm)


So basically we have a myhelp community page that is incorporated in the Mobile app and that myhelp community is behind the accounts.fitbit.com portal. This portal sense the fitbit.com session, if there an active fitbit.com session then it directly takes us this community page and if there is no active fitbit.com session then it asks for the login. 

In case of Mobile apps, customer is already logged in, so there is active session and when we hit the Community page in mobile apps, it sense this session (Somehow this session is being passed from the mobile app to this page ) and shows the page content instead of asking for the login.

But I believe this is not completely in place and some work is pending from the mobile apps team. 

https://accounts.fitbit.com/login?targetUrl=https%3A%2F%2Fwww.fitbit.com%2Flogin%2Ftransferpage%3Fredirect%3Dhttps%25253A%25252F%25252Fwww.fitbit.com%25252Foauth2%25252Fauthorize%25253Fclient_id%25253D227NPM%252526expires_in%252526prompt%25253Dconsent%252526redirect_uri%25253Dhttps%2525253A%2525252F%2525252Ffitbit--c.na57.visual.force.com%2525252Fapex%2525252Fauthohorizetoken%252526response_type%25253Dtoken%252526scope%25253Dactivity%25252Bsettings%25252Bnutrition%25252Bsocial%25252Bheartrate%25252Blocation%25252Bprofile%25252Bsleep%25252Bweight%25252Bmfa_ok%252526state&lcl=en_US

https://www.fitbit.com/signup?redirect=https://www.fitbit.com/login?redirect=https%253A%252F%252Fwww.fitbit.com%252Foauth2%252Fauthorize%253Fclient_id%253D227NPM%2526expires_in%2526prompt%253Dconsent%2526redirect_uri%253Dhttps%25253A%25252F%25252Ffitbit--c.na57.visual.force.com%25252Fapex%25252Fauthohorizetoken%2526response_type%253Dtoken%2526scope%253Dactivity%252Bsettings%252Bnutrition%252Bsocial%252Bheartrate%252Blocation%252Bprofile%252Bsleep%252Bweight%252Bmfa_ok%2526state


* create orderWarranty API
* problem with Sift
* Chat authentication
* Phone fraud
* spoofing - sta znaci?
* RT - sta znaci?
* COM - 13236
    * wightsite tunneling
    * `warranty endpoint`
* change OAuth client
* Fitbit customer token - how is it generated?
* Confluence: Proposal for LTE Support
* SyncDoc project
* Smart API
