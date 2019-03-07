
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