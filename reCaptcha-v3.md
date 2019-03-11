# reCAPTCHA V3
[reCAPTCHA demo](https://recaptcha-demo.appspot.com/)
vukdukic-unql@force.com


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

Features

    High Test coverage, safe and easy to use
    Score Comparision
    Support invisible, corner and inline badge style
    Support reCAPTCHA to run on every page
    Support multiple actions to be placed on the same page
    Support custom implementation on config interface
    Support custom implementation on request method interface
    Fully supported Vue component
    IP skip list supported
