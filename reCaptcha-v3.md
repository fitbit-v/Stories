# reCAPTCHA V3
* [reCAPTCHA demo](https://recaptcha-demo.appspot.com/)
* [Am I Unique](https://amiunique.org/)
* [Jira - Card testing through Commerce API](https://jira.fitbit.com/browse/SEC-20004)
* [Introducing reCAPTCHA v3: the new way to stop bots ](https://webmasters.googleblog.com/2018/10/introducing-recaptcha-v3-new-way-to.html)
* [Thoughts on reCAPTCHA v3](https://medium.com/@jsoverson/thoughts-on-recaptcha-v3-e837d4a0a63)
* [Reddit Article](https://www.reddit.com/r/webdev/comments/9sndkv/google_launches_recaptcha_v3/)
#
vukdukic-unql@force.com
 
Given the changes and the coexistence with V2, V3 seems like a new product rather than a new version of reCAPTCHA.  Google docs state that V3 is more suitable for situations where showing a challenge is not desired and claims that V2 will not be going away.  At the same time, V2 is far from a perfect anti-spam and bot prevention solution.  V3 is still to be proven as a tool.  In my opinion, using V3 will require rearchitecting of applications.
 
With V3, Google is no longer claiming that it is differentiating between human and non-human traffic, it is delivering a risk score and the consumer now needs to figure out what to do with it.  Also, as you know, the score varies across browsers and devices.  I had a chance to test the code on multiple browsers and devices and confirm this.  Two of the data points that Google looks at when assessing legitimacy is IP and ASN (Autonomous System Number) reputation. 
 
I feel that it will be worth exploring other solutions for bot detection and prevention.  I am looking at other tools and exploring architecture where v2 and v3 are coexisting in applications. 

Since reCAPTCHA v3 doesn't interrupt users, we recommend adding reCAPTCHA v3 to multiple pages. In this way, the reCAPTCHA adaptive risk analysis engine can identify the pattern of attackers more accurately by looking at the activities across different pages on your website.

reCAPTCHA works best if it can build a profile for each visitor and the more information it can gather from different sources about them the better it can function. They use a third party cookie for that to work across multiple websites which also helps them tune their core business to detect and prevent ad fraud bots.

Google is to create a risk assessment profile based on the user footprint to determine if they are likely to be a bot.  This likely means that anyone who takes steps to protect the anonymity online will likely be identified as a bot.

Google tracks almost everything you do through Analytics, AdSense and reCAPTCHA.

Google recommends adding reCAPTCHA v3 to multiple pages. This way, the reCAPTCHA adaptive risk analysis engine can identify the pattern of attackers more accurately by looking at the activities across different pages on the website.

CloudFlare hasn't created a free JS script to do a captcha and collect attack data.



## Reverse Turing test and CAPTCHA

A modification of the Turing test wherein the objective of one or more of the roles have been reversed between machines and humans is termed a reverse Turing test. 

CAPTCHA is a form of reverse Turing test. Before being allowed to perform some action on a website, the user is presented with alphanumerical characters in a distorted graphic image and asked to type them out. This is intended to prevent automated systems from being used to abuse the site. The rationale is that software sufficiently sophisticated to read and reproduce the distorted image accurately does not exist (or is not available to the average user), so any system able to do so is likely to be a human.

Software that could reverse CAPTCHA with some accuracy by analysing patterns in the generating engine started being developed soon after the creation of CAPTCHA. In 2013, researchers at Vicarious announced that they had developed a system to solve CAPTCHA challenges from Google, Yahoo!, and PayPal up to 90% of the time. In 2014, Google engineers demonstrated a system that could defeat CAPTCHA challenges with 99.8% accuracy. In 2015, Shuman Ghosemajumder, former click fraud czar of Google, stated that there were cybercriminal sites that would defeat CAPTCHA challenges for a fee, to enable various forms of fraud.

##
* reCAPTCHA learns by seeing real traffic on your site.  For this reason, scores in a staging environment or soon after implementing may differ from prod.  
* first run reCAPTCHA without tracking action and then decide on tresholds by looking at your traffic in the admin console.
* by default, you can use a treshold of 0.5
* 8080 Site key: 6Ld3t5QUAAAAAO-QLns35ngthtL7UE4s0VbiBmyO
* 8080 Secret key: 6Ld3t5QUAAAAAD8bpDwGhG2I5YKhGC2fAXBL9b-G

### The reCAPTCHA v3 API provides a confidence score for each request.
1. reCAPTCHA script loading
2. `grecaptcha.ready()` fired, calling
`grecaptcha.execute('6LdyC2cUAAAAACGuDKpXeDorzUDWXmdqeg-xy696', {action: 'examples/v3scores''`
3. Received token from reCAPTCHA service, sending to our backend with:
`fetch('/recaptcha-v3-verify.php?action=examples/v3scores&token='03AOLTBLQTrS37m_x0VF0bdnU0Hg1Gt8wLZe1UWg16jZDs22h4f_oMY7FEmL2ObID_WsULfL3N7cwnJ478UF901CGgabO6Qd883WKHoECalw50bnoIY69tTUOMfxFIhLfJpt_A8ui1e_lr3WEoWTzfJNWPGsRHeMLcD7oKFro6x5winl_kiCoY3TYpHEf0shcXuyjanPB7Mi21QgvqcClsVsmPpvXPs_pVb2eY6F5pYGrJy9psRX1cWl-t3c_Z618FdjOq6kCUre0RwBfHY1gUxblBRO6NzUuFJsc0ZBH5jRKU48WbQL0BBC1_dLa-SJCV4mFynFFbi-XjMhmYyKEsbLafoSuHc4Hsmg`
4. Received response from our backend:
```json
{
  "success": true,
  "hostname": "recaptcha-demo.appspot.com",
  "challenge_ts": "2019-03-08T20:45:48Z",
  "apk_package_name": null,
  "score": 0.9,
  "action": "examples/v3scores",
  "error-codes": []
}
```

Google generates a token for the client when he passes the checks which you have to validate on the serverside. If someone doesn't pass the captcha (a robot), he doesnt have the token.

The previous ReCaptcha (v2) worked because it tracked the user movement (scrolling, clicking) while the user solved the captcha (clicked on "I'm not a robot"). As far as i understand v3 does the same, but there is just no button to click on, google just "watches" the client and determines wether there is a human controlling the mouse etc. on the other side.

* create a composer package which supports score settings
* do score comparison for your own score handler

reCAPTCHA v3 is intended for power users, site owners that want more data about their traffic, and for use cases in which it is not appropriate to show a challenge to the user.

For example, a registration page might still use reCAPTCHA v2 for a higher-friction challenge, whereas more common actions like sign-in, searches, comments, or voting might use reCAPTCHA v3.

it seems tied to cookies and tracking scripts. Clearing cookies and setting the browser to not accept third-party cookies seems to lock it to 0.1. Try logging into gmail in the browser, and visiting a few other sites, some people have reported success with soundcloud. Also, if you solve a legacy captcha (v1) it seems to lock you to 0.1 for a few minutes. It also strongly prefers google chrome and firefox, chromium forks such as ungoogled-chromium and brave seem to hover around the 0.1 to 0.3 range, and edge rarely gets above 0.5.

## Features

    High Test coverage, safe and easy to use
    Score Comparision
    Support invisible, corner and inline badge style
    Support reCAPTCHA to run on every page
    Support multiple actions to be placed on the same page
    Support custom implementation on config interface
    Support custom implementation on request method interface
    Fully supported Vue component
    IP skip list supported

## Browser Fingerprinting
A device fingerprint, machine fingerprint or browser fingerprint is information collected about a remote computing device for the purpose of identification. Fingerprints can be used to fully or partially identify individual users or devices even when cookies are turned off.

Browser fingerprinting is a powerful method that websites use to collect information about your browser type and version, as well as your operating system, active plugins, timezone, language, screen resolution and various other active settings.

Websites bulk-collect a large set of data of visitors in order to later use it to match against browser fingerprints of known users.

Browser fingerprinting is also used to identify the characteristics of botnets, because the connections of botnets are established by a different device every time.
### Canvas Fingerprinting
Within the HTML5, originally `canvas` element was used to draw graphics on a web page.

When a user visits a page, the fingerprinting script first draws text with the font and size of its choice and adds background colors. Next, the script calls Canvas API’s ToDataURL method to get the canvas pixel data in dataURL format, which is basically a Base64 encoded representation of the binary pixel data. Finally, the script takes the hash of the text-encoded pixel data, which serves as the fingerprint.  This information serves as the unique fingerprint of every visitor. 

In contrast to how cookies work, canvas fingerprinting doesn’t load anything onto your computer, so you won’t be able to delete any data, since it’s not stored on your computer or device, but elsewhere. 

rack what other websites you visit, the account you’re logged into and sometimes even your geo-location. 

ReCaptcha v3 will not present a captcha anymore, but rely on browser fingerprinting and other information google can get about you.

VPN IPs or static company IPs seem to be blacklisted and only get a score of 0.1 even when the browser profile itself is fresh and has no adblocker and other privacy tools installed. Using a mobile internet connection, I get up to 0.7.

Logging into a Google account improves the score

## Honeypot Method
Create an extra field in a form and make it invisible to the user with CSS or JavaScript. Bots will detect the field and fill it out, whereas organic users will not, so if the field’s not empty, reject the form. 



