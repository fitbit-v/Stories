The right approach here is to use our mobile Service SDK for Chat. We have seen significant adoption of mobile SDK in our customer base.

Disconnects are still possible because iOS can still kill the app when it's backgrounded after a few minutes (that is true of all apps) and Live Agent is session based (synchronous). 

However, our mobile SDK has a number of features that help: 
When are you waiting on a response to an agent or you are in a queue, the user can minimize the window and continue using the app. This keeps the session connected since the app is foregrounded. 
We support in-app notifications. If there's chat activity when the user is not viewing the chat session, you can present that information to them using the iOS notification system. Notifications can be sent to the user when the user isn't viewing the chat session. A notification can appear when the app is in the background, or when the app is in the foreground but the chat session is minimized. The following activities can cause notifications (for more information, see our help docs [developer.salesforce.com])
Agent has connected
Agent sent a message
Agent requested a file transfer
Agent canceled a file transfer
Agent ended a session
Session will timeout soon

As Fitbit mentioned, they should not *embed* Web Snap-ins into a mobile app. Web Snap-ins is excellent for browser-based scenarios. We should point Fitbit to the SDKs. Note that Fitbit has the option of testing the experience using A/B. That is, for some pool of customers, they can display the in-app SDK, and for the other they can not show it and use the current experience. 
In a sense, they are splitting the experience of the app. If version A performs better than version B, then version A becomes the new experience that version B customers see. This can be controlled on the server meaning that applications do not need to be updated. 
