# Lightning Data Service
LDS is the Lightning Components counterpart to the Visualforce standard controller, providing access to the data displayed on a page.

Lightning Data Service:
* identifies and eliminates requests that involve the same record data, 
* sending a single shared data request that updates all relevant components. Not only does this eliminate inconsistent data between components, 
* it also provides a way to cache data to work offline in case the user gets disconnected, intelligently syncing the data once the connection is restored.

Lightning Data Service provides reusable Aura components that:
* Minimize XMLHttpRequests (XHRs)
* Fetch records once, reducing network transfers, app server load, and database server load
* Cache record data on the client, separate from component metadata
* Share record data across components
* Enable progressive record loading, caching, and merging more fields and layouts into the cache
* Enable proactive cache population
* Promote consistency by using only one instance of the record data across multiple components
* Create notifications when record data changes

### XMLHttpRequest
XMLHttpRequest (XHR) is an API in the form of an object whose methods transfer data between a web browser and a web server. The object is provided by the browser's JavaScript environment. Particularly, retrieval of data from XHR for the purpose of continually modifying a loaded web page is the underlying concept of Ajax design. Despite the name, XHR can be used with protocols other than HTTP and data can be in the form of not only XML, but also JSON, HTML or plain text.
## Architecture without LDS
Without LDS, each component within an app makes independent calls to the server to perform CRUD operations on a record, even if all components in the app pull from the same record data. Each server call reduces performance, leaving users twiddling their thumbs instead of working with their data. These independent server calls can also lead to inconsistencies, creating situations where a server call refreshes one component, leaving other components out of date.

## Form-Based Components and force:recordData

| Form Function | |
| --- | --- |
| Display, create, or edit records | `lightning:recordForm` | 