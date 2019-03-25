# Lightning Data Service
LDS is the Lightning Components counterpart to the Visualforce standard controller, providing access to the data displayed on a page.

Lightning Data Service identifies and eliminates requests that involve the same record data, sending a single shared data request that updates all relevant components. Not only does this eliminate inconsistent data between components, it also provides a way to cache data to work offline in case the user gets disconnected, intelligently syncing the data once the connection is restored.
### Architecture without LDS
Without LDS, each component within an app makes independent calls to the server to perform CRUD operations on a record, even if all components in the app pull from the same record data. Each server call reduces performance, leaving users twiddling their thumbs instead of working with their data. These independent server calls can also lead to inconsistencies, creating situations where a server call refreshes one component, leaving other components out of date.
