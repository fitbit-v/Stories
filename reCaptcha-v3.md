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