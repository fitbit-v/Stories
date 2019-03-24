## Communities Implementation
* TLS handshake??
### Community's Login Experience
1. Customize default login page (choose which login page to use)
2. Allow internal users to log in directly to community
3. set up support for authentication provider and SSO
4. 

### Salesforce for iOS and Android Single Sign-On overview(https://help.salesforce.com/articleView?id=000213609&type=1)
1. Salesforce for iOS and Android will only work with Service Provider Initiated setups.  If you are using Identity Provider Initiated authentication, you will need to change to Service Provider Initiated.
2. Enable the My Domain feature
3. Add your SAML Configuration to the Authentication Service within the Authentication Configuration section of My Domain using the steps in Add Identity Providers on a Login Page.  This domain URL will be the one you add as a connection to Salesforce for iOS and Android when logging in to start the SP-initiated Single Sign-On Process.
4. After your My Domain is entered, you should land on a web page that has a form for the User to input their network username and password.
5. 