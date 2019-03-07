
In response to last week’s fraud bot, Commerce is implementing Google’s reCAPTCHA functionality in the purchase process, as Stripe recommended. This feature is being released this morning, will be invisible to cart users, and does not impact the UI in any way. 
 
A big thank-you to the Fraud Squad, Security, and Commerce engineering teams 

Kate Roberts
Technical Program Manager
Fitbit, Inc. | Boston, MA
kate.roberts@fitbit.com
##
* Scott Paxton and Curt Ege implemented reCAPTCHA for the commerce team


## reCAPTCHA V3
* With V3 Google is no longer claiming that it is differentiating between human and non-human traffic, it is delivering a risk score and the consumer now needs to figure out what to do with it.
* Two of the data points that we know Google looks at when assessing legitimacy is your IP and ASN reputation (an ASN is, effectively, an identifier for the service provider you are using). 
* Autonomous System Number - Autonomous Systems are routable networks within the public Internet, administered by the local RIRs and assigned to owners of networks. The ASN Information tool displays information about an IP address's Autonomous System Number (ASN) such as: IP owner, registration date, issuing registrar and the max range of the AS with total IPs.
* [neustar ASN Lookup](https://www.ultratools.com/tools/asnInfo)
### 
I spun up a quick instance of Amazon Workspaces, a useful remote desktop solution that runs on Amazon’s cloud, and tested my score against Firefox and Chrome. I used Amazon because it is, typically, not a consumer ASN and consumer-website traffic typically does not originate from Amazon’s servers. Amazon workspaces, though, is a legitimate way of using sandboxed operating systems from a variety of devices and represents a good example of why this reCAPTCHA is fundamentally different than the previous.

* docs state that v3 is more suitable for situations where showing a challenge is not desired and claims that v2 will not be going away. 

* Using the new reCAPTCHA will be some work and will take some rearchitecting of applications but that’s probably necessary at this point regardless.

* Given the changes and the coexistence with v2, v3 seems like a new product line rather than a version bump and we’ll have to see where it goes from here.

### Articles
* [Thoughts on reCAPTCHA v3](https://medium.com/@jsoverson/thoughts-on-recaptcha-v3-e837d4a0a63)
* [Bypassing CAPTCHAs with Headless Chrome](https://medium.com/@jsoverson/bypassing-captchas-with-headless-chrome-93f294518337)
* [How To Style for Google reCAPTCHA (Change Position, Resize reCAPTCHA Badge)](https://medium.com/@ohiwill/how-to-style-for-google-recaptcha-change-position-resize-recaptcha-badge-bc1c1b4fbd6d)
* 