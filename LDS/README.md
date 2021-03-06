# Lightning Data Service
* [Working with Salesforce Data](https://developer.salesforce.com/docs/atlas.en-us.218.0.lightning.meta/lightning/data.htm)
LDS is the Lightning Components counterpart to the Visualforce standard controller, providing access to the data displayed on a page.  The magic of LDS is when you have multiple components in a Lightning application that pull from the same record data.
LDS sends the request to the server and automatically updating both records.
WIth `form-based components`  you get the field mapping out-of-the-box, along with layout, validation, CRUD changes, and error handling. With `force:recordData`, you must wire up your component to the Salesforce fields you want.
### Asynchronous Record Saving
 In the event of a connection problem, LDS stores record changes in a local cache.  This is indicated by a `DRAFT` state in the `SaveRecordResult` object. A record’s `DRAFT` state is resolved when the connection is restored. When saving a record through LDS, the local cache isn’t updated until the save is complete. When the save is successfully completed on the server, the cache is updated to the latest version of the record from the server, and all components with a reference to that record are notified. 

Saves that occur when a device is offline result in a DRAFT state if you enable asynchronous save permissions, or if all of the following are true:
* The client can’t reach the server.
* The org has enabled offline drafts.
* You have version 9.0 or newer of the Salesforce app.

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
`force:recordData` tag is the logic used to communicate with the server and manage the local cache.  For users to view and modify the data fetched by LDS, you have to include UI elements. The `force:recordData` tag uses the UI API to provide data to UI components.


| Form Function | |
| --- | --- |
| Display, create, or edit records | `lightning:recordForm` | 
| Display records only | `lightning:recordViewForm` (with `lightning:outputField`)
| Create or edit records only | `lightning:recordEditForm` (with `lightning:inputField`)
| Display, create, edit, or delete records with granular customization | `force:recordData` |

The form-based components take care of:
* layout, 
* validation, 
* CRUD changes, and 
* error handling. 

On its own, force:recordData doesn’t include any UI elements; it’s simply logic and a way to communicate to the server.
Use it to create highly customizable user interfaces beyond what the form-based components provide. 

To load a record on the client side, you have to add the `force:recordData` tag to your component, and set your `recordId`, `mode`, and `layoutType` or `fields` attributes.
* `recordId` specifies the record to load. Records can’t be loaded without a recordId.
* mode can be set to either `EDIT` or `VIEW`, which determines the behavior of notifications and what operations are available to perform with the record. If you’re using `force:recordData` to change the record in any way, set the mode to `EDIT`.
* `layoutType` specifies the layout (`FULL` or `COMPACT`) used to display the record, which determines what fields are included. Using `layoutType` allows your component to adapt to layout definitions.
* `fields` specifies which fields in the record to query.

Additional attributes:
* `targetRecord` is populated with the loaded record
* `targetFields` is populated with the simplified view of the loaded record
* `targetError` is populated with any errors

```xml
<force:recordData aura:id="forceRecordCmp" 
  <!-- aura:id is required to reference the component in your Javascript controller -->
    recordId="{!v.recordId}"
    layoutType="{!v.layout}"
    fields="{!v.fieldsToQuery}"
    mode="VIEW"
    targetRecord="{!v.record}"
    targetFields="{!v.simpleRecord}" 
    targetError="{!v.error}"
/>


<aura:component>
    <aura:attribute name="recordId" type="String" />
    <aura:attribute name="record" type="Object" />
    <aura:attribute name="simpleRecord" type="Object" />
     <force:recordData recordId="{!v.recordId}"
          targetRecord ="{!v.record}"
          targetFields ="{!v.simpleRecord}"
          fields="Id, Name" />
    <div class="recordName">
        <p class="slds-text-heading--medium">
            <lightning:formattedtext title="Record Name" value="{!v.simpleRecord.Name}" /></p>
    </div>
</aura:component>
```

Several Aura methods to modify records are available.  Overview of methods in JavaScript component controllers:
* `saveRecord()` inserts or updates the record loaded into the `force:recordData` component.
* `deleteRecord()` deletes the loaded record.
* `getNewRecord()` loads a new record template that performs an insert when saved.
* `reloadRecord()` reruns the loading code to overwrite the current `targetRecord` with the current attribute values.\

### Loading Records
Load the record by including `force:recordData` in your component while specifying the `recordId`, `mode`, and `layoutType` or `fields` attributes.



