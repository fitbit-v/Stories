public without sharing class pkb_Controller
//ensure that the sharing rules for the current user are not enforced
{
    /* ***** SEARCH DEFAULTS ***** */
    private final static String SEARCH_PROMPT = System.Label.PKB2_Search_Prompt;
    private final static String CONTACT_US_BUTTON_PROMPT = System.Label.PKB2_Ask_Button;
    private final static String SEARCH_BUTTON_PROMPT = System.Label.PKB2_Search_Button;
    private final static Integer CASE_SUBJECT_LENGTH = 250;
    private final static String WITH_DATA_CATEGORY = 'WITH DATA CATEGORY ';
    private final static String DATA_CATEGORY_OPERATOR = ' ABOVE_OR_BELOW ';
    private final static String QUERY_AND = ' AND ';
    private final static Integer SOSL_MAX_RESULTS = 2000;

    // this needs to be public and not final so that it can be overridden during unit tests, since
    // kav records created in apex cannot be set to 'online', and can only stay at 'draft'
    public static String DEFAULT_PUBLISH_STATUS = 'online';

    // this also needs to be public to allow setting during unit tests
    public static String DEFAULT_SITE_NAME = Site.getName();

    public String searchPrompt { get { return (SEARCH_PROMPT); } }
    public String buttonPrompt { get { return (displayContactUs ? CONTACT_US_BUTTON_PROMPT : SEARCH_BUTTON_PROMPT); } }

    /* ***** URL PARAM CONSTANTS AND GETTERS ***** */
    public final static String QUERY_PARAM = 'q';
    public final static String LANGUAGE_PARAM = 'l';
    public final static String COUNTRY_PARAM = 'co';
    public final static String CATEGORY_PARAM = 'c';
    public final static String SESSION_PARAM = 's';
    public final static String FEEDBACK_PARAM = 'f';
    public final static String CONTACT_US_PARAM = 'cu';
    public final static String FEEDBACK_SOURCE_PARAM = 'fs';
    public final static String PAGE_NUM_PARAM = 'pn';
    public final static String PRODUCT_PARAM = 'p';
    public final static String VIDEOS_PARAM = 'v';
    public final static String THANKYOU_PARAM = 't';
    public final static String POSTCHAT_PARAM = 'pc';
    public final static String MOBILE_WRAPPED_PARAM = 'm';
    public final static String SPECIAL_INQUIRY_PARAM = 'i';
    public final static String CWCASE_PARAM = 'cw';
    public final static String ORG_ID         =  UserInfo.getOrganizationId();

    public String queryParam            { get { return QUERY_PARAM; } }
    public String languageParam         { get { return LANGUAGE_PARAM; } }
    public String countryParam          { get { return COUNTRY_PARAM; } }
    public String categoryParam         { get { return CATEGORY_PARAM; } }
    public String sessionParam          { get { return SESSION_PARAM; } }
    public String feedbackParam         { get { return FEEDBACK_PARAM; } }
    public String feedbackSourceParam   { get { return FEEDBACK_SOURCE_PARAM; } }
    public String contactUsParam        { get { return CONTACT_US_PARAM; } }
    public String pageNumParam          { get { return PAGE_NUM_PARAM; } }
    public String productParam          { get { return PRODUCT_PARAM; } }
    public String videosParam           { get { return VIDEOS_PARAM; } }
    public String thankYouParam         { get { return THANKYOU_PARAM; } }
    public String postChatParam         { get { return POSTCHAT_PARAM; } }
    public String mobileWrappedParam    { get { return MOBILE_WRAPPED_PARAM; } }
    public String specialInquiryParam   { get { return SPECIAL_INQUIRY_PARAM; } }
    public String cwCaseParam           { get { return CWCASE_PARAM; } }
    public String orgId                 { get { return ORG_ID; } }


    /* ***** KAV EXTENSION, used in VF pages when need to derive article type name from whole object name ***** */
    private final static String KAV_EXTENSION = '__kav';
    public String kavExtension          { get { return KAV_EXTENSION; } }

    /* ***** DATA CATEGORY SELECTION EXTENSION, used in VF pages when need to derive article type name from whole object name ***** */
    private final static String DCS_EXTENSION = '__DataCategorySelection';
    public String dcsExtension          { get { return DCS_EXTENSION; } }

    // value for the contact us param
    private final static String CONTACT_US_VALUE = '1';
    public String contactUsValue        { get { return CONTACT_US_VALUE; } }

    // values for the feedback params, informs conditionals about which panel to display on the pkb_Feedback page
    private final static String FEEDBACK_SHOW_YESNO = 'yesno';
    private final static String FEEDBACK_SHOW_DIALOG = 'dialog';
    public String feedbackShowYesNo     { get { return FEEDBACK_SHOW_YESNO; } }
    public String feedbackShowDialog    { get { return FEEDBACK_SHOW_DIALOG; } }

    // values for the feedback source param; these *MUST* match the picklist values for the Feedback_Source__c field of the deflection object
    private final static String FEEDBACK_CONTACT_US = 'ContactUs';
    private final static String FEEDBACK_SEARCH = 'Search';
    private final static String FEEDBACK_RELATED = 'RelatedArticle';
    public String feedbackContactUs     { get { return FEEDBACK_CONTACT_US; } }
    public String feedbackSearch        { get { return FEEDBACK_SEARCH; } }
    public String feedbackRelated       { get { return FEEDBACK_RELATED; } }
    public String upDowVote             { get; set; }
    public List<postVoteOption> postVoteOptions { get; set; }

    /* ***** STANDARD CONTROLLER AND RECORD PROPS AND COLLECTIONS ***** */
    public ApexPages.StandardController theSC { get; set; }
    public KnowledgeArticle theArticle { get; set; }
    public KnowledgeArticleVersion theAV { get; set; }
    public KnowledgeArticleData theKad { get; set; }
    public List<KnowledgeArticleData> rssKads { get; set; }
    public List<KnowledgeArticleData> featuredKads { get; set; }
    public List<KnowledgeArticleData> recommendedKads { get; set; }

    public String publishStatus { get { return DEFAULT_PUBLISH_STATUS; } }

    public Boolean facebook { get {return Site.getTemplate().getUrl().endsWith('pkb_Template_fb');} }
    
    //Addition by Grazitti on 11 november 2015 , to replace the custom labels with custom object records.
    public Map<string , string> mapLabel2Value {
        get{
            if(mapLabel2Value == null){
                mapLabel2Value = new Map<string , string>();
                mapLabel2Value = FetchAdminPanelData.GetLabelValue();
                return mapLabel2Value;
            }
            else{
                return mapLabel2Value;
            }
        }
        set;
    }
    //upto here-Addition by Grazitti on 11 november 2015 , to replace the custom labels with custom object records.
    
    
    
    public pkb_Controller()
    {
        System.debug('\n\npkb_Controller() entered.' +
            '\n===== Site Name: ' + siteName +
            '\n===== Current Page: ' + ApexPages.currentPage().getUrl() +
            '\n===== Viewing Error: ' + viewingError +
            '\n===== Page Parameters: ' + ApexPages.currentPage().getParameters() + '\n\n');

        // mainly for testing
        if (isBlank(DEFAULT_SITE_NAME))
        {
            System.debug(LoggingLevel.WARN, 'DEFAULT_SITE_NAME is empty! Defaulting to \'Help_Site\'.');
            DEFAULT_SITE_NAME = 'Help_Site';
        }

        // handle language first since I need it on the error page
        selectedLanguage = resolveLanguage();
        System.debug('Resolved language: ' + selectedLanguage);

        // handle country first, too, since I need it on the error page
        selectedCountry = resolveCountry();
        System.debug('Resolved country: ' + selectedCountry);

        // now check if we are on an error page
        if (viewingError)
        {
            System.debug('Viewing an error, return from here without doing anything else!');
            return;
        }

        // check if a country url parameter exists, if yes, set country code variable for site, to append to custom labels
        if (viewingHome)
        {
            System.debug('Home page living');
        }

        // populate the props with ural param values as needed
        String q = ApexPages.currentPage().getParameters().get(QUERY_PARAM);
        String c = ApexPages.currentPage().getParameters().get(CATEGORY_PARAM);
        String fs = ApexPages.currentPage().getParameters().get(FEEDBACK_SOURCE_PARAM);
        String p = ApexPages.currentPage().getParameters().get(PRODUCT_PARAM);

        if (!isBlank(c))
        {
            // define a set that I will join later
            Set<String> uniqueCategories = new Set<String>();

            // check selected categories for validity
            for (String s : String.escapeSingleQuotes(c).split(','))
            {
                List<String> temp = s.trim().split(':');

                // check if the category group or data category exists
                // this will prevent an error from occuring when a user requests a URL like this:
                // http://fitbitdev-fitbit.cs15.force.com/?c=null:null
                if (!DataCategoryGroupInfos.containsKey(temp[0]) ||
                    !DataCategoryGroupInfos.get(temp[0]).CategoryMap.containsKey(temp[1]))
                {
                    // doesn't exist, skip
                    System.debug(LoggingLevel.ERROR, 'An invalid data category group or category was specified: ' + temp);
                    continue;
                }

                // check if this category is already in the list
                if (!uniqueCategories.contains(s.trim()))
                {
                    // add it to the unique list
                    uniqueCategories.add(s.trim());
                }
            }

            // see if there are categories to add
            if (uniqueCategories.size() > 0)
            {
                // add the categories
                selectedCategory = join(uniqueCategories, ',');
            }
        }
        if (!isBlank(fs))
        {
            feedbackSource = fs; // need to validate this value is in the picklist when inserting
        }
        if (!isBlank(p))
        {
            selectedProduct = String.escapeSingleQuotes(p);
        }

        Cookie sessionCookie = ApexPages.currentPage().getCookies().get('PKB2SessionId');

        if (sessionCookie == null)
        {
            sessionId = randomUUID();
            sessionCookie = new Cookie('PKB2SessionId', sessionId, '/', -1, false);
            ApexPages.currentPage().setCookies(new Cookie[] {sessionCookie});
        }
        else
        {
            sessionId = sessionCookie.getValue();
        }
        enteredSearchQuery = searchPrompt;

        if (!isBlank(q))
        {
            if (q.length() >= 2)
            {
                urlSearchQuery = q;
                enteredSearchQuery = q;
            }
            else
            {
                String errorMsg  = System.Label.PKB2_js_search_string_length;
                errorMsg = errorMsg.replace('NNN', '3');
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING, errorMsg));
            }
        }

        // null out the data category group info's so they can be pulled later
        DataCategoryGroupInfos = null;

        // Copied this from the below "public pkb_Controller(ApexPages.StandardController sc)", since it wasn't running.
        if (!viewingArticle)
        {
            // buildFeaturedKads() powers the component pkb_featured, which outputs records from pkb_Featured__c.
            buildFeaturedKads();
        }


        System.debug('pkb_Controller() returning');
    }

    /* ***** CONTROLLER EXTENSION CONSTRUCTOR ***** */
    public pkb_Controller(ApexPages.StandardController sc)
    {
        // call base constructor, must be first statement in constructor block
        this();

        System.debug('pkb_Controller(StandardController sc) entered\n===== Controller: ' + sc +
            '\n===== viewingError: ' + viewingError);

        // if we are viewing an error, return before building recommended articles and such
        if (viewingError)
        {
            System.debug('Viewing an error, return from here without doing anything else!');
            return;
        }
        
        // Note that when an article is being viewed via its "url name" url (and not via a url that has the article ID in it),
        // the standard controller record will only have the Id field populated, and not any other field. This is true even if
        // other article fields are placed on the VF page; they will still not be populated.
        //
        // It is for this reason that to get basic information
        // about the article (such as title) when an article is being viewed, the KnowledgeArticleVersion object must be queried
        // using the Id of the article. To assist with this, there is a wrapper class in this controller called KnowledgeArticleData
        // that pulls together KAV data and combines it with the article type data from describe calls.

        theArticle = (KnowledgeArticle) sc.getRecord();

        if (!viewingArticle)
        {
            buildFeaturedKads();
        }

        theKad = new KnowledgeArticleData();
        if (viewingArticle)
        {
            theKad = new KnowledgeArticleData(theArticle.Id, selectedLanguage);
            theAV = theKad.theAV;
            List<PKB_Article_Feedback_Deflection__c> afds = [
                        select
                        Id
                        from PKB_Article_Feedback_Deflection__c
                        where
                        Session_ID__c = :sessionId and
                                        Article_Number__c = :theKad.articleNumber
                    ];
            feedbackRecorded = !afds.isEmpty();
        }

        if (searchExecuted)
        {
            buildRecommendedKads();
        }
        System.debug('\n\n[DEBUG-PKB CONTROLLER] cONSTRUCTOR\n=========\nselectedCategory=' + selectedCategory);
        if (displayContactUs)
        {
            theCud = new ContactUsData();
        }

        // null out the data category group info's so they can be pulled later
        DataCategoryGroupInfos = null;

        System.debug('pkb_Controller(StandardController sc) returning');
    }
    
    //Addition added by Grazitti for Automatic Toggle System(SFDC-2036) Start
    public String ruleNames {get; set;}
    public String countryString{get;set;}
    public Map<string,Boolean> widgetname2Status{get; set;}
    public Boolean isValidCountry{get;set;}
    public List<String> countryList{
        set;
        get{
            if (countryList == null){
                countryList = new List<String>();
                Schema.DescribeFieldResult fieldResult = ATSRules__c.Country__c.getDescribe();
                List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
                for( Schema.PicklistEntry pickListVal : ple){
                    countryList.add(pickListVal.getValue());
                } 
            }
            return countryList;
        }
    }
    public Map<String, String> countryMap{
        set;
        get{
            if (CountryMap == null){
                countryMap = new Map<String, String>();
                countryList = new List<String>();
                Schema.DescribeFieldResult fieldResult = ATSRules__c.Country__c.getDescribe();
                List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
                for( Schema.PicklistEntry pickListVal : ple){
                    countryMap.put(pickListVal.getValue(), pickListVal.getLabel());
                    countryList.add(pickListVal.getValue());
                } 
            }
            return CountryMap;
        }
    }

    public void actionMethod(){
        System.debug('in action method');
        isValidCountry = true;
        String countRec = 'US';
        String langRec = 'en_US';
        ruleNames = '';
        Cookie countryCookie = ApexPages.currentPage().getCookies().get('country');
        Cookie languageCookie = ApexPages.currentPage().getCookies().get('language');
        if(countryCookie != null){
            countRec = ApexPages.currentPage().getCookies().get('country').getValue();
            if(!countryMap.containskey(countRec)){
                countRec = 'US';
                isValidCountry = false;
            }
        } else{
            countRec = pkb_Helper.getUserCountry();
            if(countRec != null){
                Cookie country = new Cookie('country', countRec , null, (60 * 60 * 24 * 365 * 5), false);
                ApexPages.currentPage().setCookies(new Cookie[]{country});
            }
        }
        countryString = countRec;
        if(languageCookie != null){
            langRec = ApexPages.currentPage().getCookies().get('language').getValue();

        }
        pkb_Helper.ATSWrapper paw = pkb_Helper.getAtsRulesList(countRec,langRec,null);
        ruleNames = paw.ruleNames;
        widgetname2Status = paw.widgetname2Status;
        
        //Addition for SFDC - 2468 by Grazitti start
        if(ApexPages.currentPage().getParameters().get('pc') != null && ApexPages.currentPage().getParameters().get('error') == null){
            String attRec = ApexPages.currentPage().getParameters().get('attachedRecords');
            if(attRec != null){
                Map<String, Object> rec = (Map<String, Object>)JSON.deserializeUntyped(attRec);
                if(rec != null && rec.containsKey('CaseId') && rec.get('CaseId') != null){
                    String chatCaseId = (String) rec.get('CaseId');
                    update (new case(Id=chatCaseId,CSAT_Sent_Time__c=system.now()));
                }
            }     
        }
        //Addition for SFDC - 2468 by Grazitti end  
        
         //Addition for SFDC - 2470 by Grazitti start
         String paramDataVal = ApexPages.currentPage().getParameters().get('paramData');
         if(paramDataVal != null && paramDataVal.toLowerCase() == 'true'){
            Map<String,String> urlParam = new map<String,String>(ApexPages.currentPage().getParameters());
            Map<String,String> paramDataMap = new Map<String,String>();
            if(urlParam != null && !urlParam.isEmpty()){
                for(String s : urlParam.keySet()){
                    paramDataMap.put(s.toLowerCase(),urlParam.get(s));
                }
                paramDataMap.remove('paramdata');
                String paramDataString = JSON.serialize(paramDataMap);
                Cookie paramdata = new Cookie('paramData', paramDataString , null, -1, false);
                ApexPages.currentPage().setCookies(new Cookie[]{paramdata});
            }
         }
         
        //Addition for SFDC - 2470 by Grazitti end
    }
    
    //Addition added by Grazitti for Automatic Toggle System(SFDC-2036) End 
    
    public String randomUUID()
    {
        String kHexChars = '0123456789abcdefABCDEF';
        String returnValue = '';
        Integer nextByte = 0;
        for (Integer i = 0; i < 16; i++)
        {
            if (i == 4 || i == 6 || i == 8 || i == 10)
            {
                returnValue += '-';
            }
            //generate a "byte"; i.e., number in range [-2^7,2^7-1]
            nextByte = (Math.round(Math.random() * 255) - 128) & 255;

            if (i == 6)
            {
                nextByte = nextByte & 15;
                nextByte = nextByte | (4 << 4);
            }
            if (i == 8)
            {
                nextByte = nextByte & 63;
                nextByte = nextByte | 128;
            }

            returnValue += charAt(kHexChars, nextByte >> 4);
            returnValue += charAt(kHexChars, nextByte & 15);
        }
        return returnValue;
    }

    private String charAt(String str, Integer index)
    {
        return ((str == null || index < 0 || index >= str.length()) ? null : (str.length() <= 0 ? str : str.substring(index, index + 1)));
    }

    /* ***** SOSL QUERY TO ENABLE SEARCH RSS ***** */
    // method is called from action parameter of RSS page and builds the KAD wrapper collection that will enable
    // the RSS feed for a single search query (via SOSL)
    public void prepareSearchRSS()
    {
        System.debug('prepareSearchRSS() entered');
        if (viewingArticle || isBlank(urlSearchQuery))
        {
            return;
        }

        rssKads = new List<KnowledgeArticleData>();
        List<KnowledgeArticleVersion> kavs = (List<KnowledgeArticleVersion>) this.search(20);

        // convert the KAV records into a list of the wrapper class records for easier handling
        for (KnowledgeArticleVersion k : kavs)
        {
            rssKads.add(new KnowledgeArticleData(k));
        }
    }

    private List<KnowledgeArticleVersion> searchByCategory(Integer resultLimit)
    {
        return searchByCategory(resultLimit, false);
    }

    private List<KnowledgeArticleVersion> searchByCategory(Integer resultLimit, Boolean SkipProductCategory)
    {
        System.debug('searchByCategory() entered\n===== resultLimit: ' + resultLimit +
            '\n===== SkipProductCategory: ' + SkipProductCategory);

        // get the article id's for the product
        // this has to be done with dynamic SOQL since bind variables in the WITH DATA CATEGORY clause are not
        // supported at this time, see: https://developer.salesforce.com/forums?id=906F00000008xVDIAY
        // This is also helpful: https://www.salesforce.com/us/developer/docs/soql_sosl/Content/sforce_api_calls_sosl_with_data_category.htm
        String categoryQuery = buildCategoryQuery(SkipProductCategory);

        String qry = 'SELECT ' + join(kavFields, ',') + ' FROM KnowledgeArticleVersion ' +
            'WHERE PublishStatus = \'' + DEFAULT_PUBLISH_STATUS + '\' ' +
            'AND Language = \'' + this.selectedLanguage + '\' ' +
            (categoryQuery != null ? categoryQuery : '') +
            (resultLimit > 0 ? ' LIMIT ' + resultLimit : '');

        System.debug('Got here Search 7');

        System.debug('\n\n[DEBUG-PKB CONTROLLER] searchByCategory query\n====' + qry + '=====\n');
        List<KnowledgeArticleVersion> articleVersions = (List<KnowledgeArticleVersion>)Database.query(qry);

        //System.debug('Article Ids: ' + articleVersions);
        return articleVersions;
    }

    private List<KnowledgeArticleVersion> search(Integer resultLimit)
    {
        return search(resultLimit, false);
    }

    private List<KnowledgeArticleVersion> search(Integer resultLimit, Boolean SkipProductCategory)
    {
        System.debug('search() entered\n===== resultLimit: ' + resultLimit +
            '\n===== SkipProductCategory: ' + SkipProductCategory);
        String escapedQ = String.escapeSingleQuotes(urlSearchQuery);

        // return if query is less than 2 chars long, page will render with an empty list
        if (isBlank(escapedQ) || urlSearchQuery.length() < 2)
        {
            return null;
        }

        // begin: Hacky Hack
        // proudly hacked by Alan 10/28/15 during Fitstar site buildout
        // goal: prevent search from being constrained by Category or Product
        // how: this only runs during a search, so to easily un-do filtering of search results by Category, or product,
        // we will blank them out here
        System.debug('viewingSearch:' + viewingSearch);
        System.debug('referrer:' + ApexPages.currentPage().getHeaders().get('Referer'));
        System.debug(URL.getSalesforceBaseUrl().toExternalForm());


        // Get current site base URL
        String baseUrl = URL.getSalesforceBaseUrl().toExternalForm();
        // if on a search page, don't blank out the selected values, so that the filters will work. Otherwise, do it.
        // check if referer URL is from this site, just in case
        String referer = ApexPages.currentPage().getHeaders().get('Referer');
        if(referer != null){
            if((!referer.contains('q=')) && referer.contains(baseUrl)){
                selectedProduct = '';
                selectedCategory = '';
            }
        }
        // end: Hacky Hack

        // build the query string and execute the query
        String q = '';
        q += 'FIND \'' + escapedQ + '*\' IN ALL FIELDS RETURNING KnowledgeArticleVersion(' + join(kavFields, ',') +
            ' WHERE PublishStatus = :publishStatus AND Language = :selectedLanguage ORDER BY LastPublishedDate DESC LIMIT :resultLimit) ';

        System.debug('Got here Search 1');

        // append category filter
        System.debug('\n===== selectedCategory: ' + selectedCategory +
            '\n===== SkipProductCategory: ' + SkipProductCategory +
            '\n===== selectedProductCategory: ' + selectedProductCategory);

        if (!isBlank(selectedCategory) || (!SkipProductCategory && !isBlank(selectedProductCategory)))
        {
            // build the WITH DATA CATEGORY clause if any categories were selected
            q += buildCategoryQuery(SkipProductCategory);
            System.debug('Got here Search 2');
            System.debug('skip product category:' + SkipProductCategory);
            // I think it's only going here to exclude categories, 
        }

        System.debug('\n\n==[publishStatus: ' + publishStatus + ', selectedLanguage: ' + selectedLanguage + ']=== ' + q);

        // execute the query
        List<List<SObject>> searchList = Search.query(q);
        return searchList[0];
    }

    public String buildCategoryQuery()
    {
        return buildCategoryQuery(false);
    }
    public String buildCategoryQuery(Boolean SkipProductCategory)
    {
        System.debug('buildCategoryQuery() entered\n===== selectedCategory: ' + selectedCategory +
            '\n===== selectedProductCategory: ' + selectedProductCategory +
            '\n===== SkipProductCategory: ' + SkipProductCategory);

        // check if we can return now
        if (isBlank(selectedCategory) && (SkipProductCategory || isBlank(selectedProductCategory)))
        {
            return null;
        }

        Set<String> uniqueCategoryGroups = new Set<String>();
        Set<String> selectedCategorySOSL = new Set<String>();
        List<String> selectedCategoryTokens = new List<String>();

        // add the selected categories
        if (!isBlank(selectedCategory))
        {
            selectedCategoryTokens.addAll(selectedCategory.split(','));
        }

        // add the selected product
        if (!SkipProductCategory && !isBlank(selectedProductCategory))
        {
            selectedCategoryTokens.add(selectedProductCategory);
        }

        // if you want to query for multiple categories in a group, you need to do it like this:
        // WITH DATA CATEGORY Geography__c AT (usa__c, uk__c)
        // see https://www.salesforce.com/us/developer/docs/soql_sosl/Content/sforce_api_calls_soql_select_with_datacategory_catselection.htm
        // TODO: when a group is specified twice, meaning there are 2 categories in the group we want to filter by,
        // then use a map to join them into the special format above

        List<String> temp;
        for (String s : selectedCategoryTokens)
        {
            // split into group & category name
            temp = s.trim().split(':');
            temp[0] = temp[0] + '__c';
            temp[1] = temp[1] + '__c';

            // check if this group has already been added once
            if (!uniqueCategoryGroups.contains(temp[0]))
            {
                uniqueCategoryGroups.add(temp[0]);
                // create the data category filter
                String selectedCategoryFilter = join(temp, DATA_CATEGORY_OPERATOR);
                if (!selectedCategorySOSL.contains(selectedCategoryFilter))
                {
                    selectedCategorySOSL.add(join(temp, DATA_CATEGORY_OPERATOR));//AT
                }
            }
            else
            {
                System.debug(LoggingLevel.ERROR,
                    'Attempted to filter on more than one category in a group! Omitting: ' + s);
            }
        }
        return WITH_DATA_CATEGORY + (join(selectedCategorySOSL, QUERY_AND));
    }

    public Boolean foundRecommended { get; set; }
    public void buildRecommendedKads()
    {
        System.debug('buildRecommendedKads() entered');
        if (viewingArticle && !displayContactUs)
        {
            return;
        }

        List<PKB_Featured__c> pkbfs;
        Set<String> anums = new Set<String>();
        String escapedQ = String.escapeSingleQuotes(urlSearchQuery);
        String orQuery;

        // split the escapedQ by spaces, trim by commas, periods, etc
        orQuery = buildOrQuery(escapedQ);

        // gather recommended article numbers based on keyword search from the PKB Featured object and put into set
        // recommended articles are records of the PKB_Feedback__c object that:
        // 1. have a keyword value
        // 2. have the Is_Keyword_Article__c box is checked
        // 3. the record Name field matches the name of the Site being viewed
        String q = '';
        q += 'FIND \'' + orQuery + '\' IN ALL FIELDS RETURNING ';
        q += 'PKB_Featured__c(Keyword__c, Article_Number__c WHERE Is_Keyword_Article__c = true';
        if (isSite)
        {
            q += ' AND PKB_Name__c = :siteName';
        }
        q += ' ORDER BY Order__c ASC NULLS last)';

        System.debug('\n\n==[siteName=' + siteName + ']=== ' + q);
        System.debug('Got here Search 3');


        List<List<SObject>> searchList = Search.query(q);
        pkbfs = (List<PKB_Featured__c>)searchList[0];

        for (PKB_Featured__c p : pkbfs)
        {
            anums.add(p.Article_Number__c);
        }

        // return if no recommended articles were found
        if (anums.isEmpty())
        {
            return;
        }

        // get the KADS from the list of article IDs and set foundRecommended based on that
        recommendedKads = initFromListOfArticleNumbers(new List<String>(anums), selectedLanguage);
        foundRecommended = !recommendedKads.isEmpty();
    }

    public static String buildOrQuery(String keywords)
    {
        System.debug('buildOrQuery() entered. Keywords: ' + keywords);
        if (isBlank(keywords))
        {
            return null;
        }

        System.debug('\n\n[DEBUG-PKB CONTROLLER] buildOrQuery\n=========\n' + keywords);

        String temp;
        //keywords = keywords.replaceAll('"' ,'\\"');
        List<String> tokens = String.escapeSingleQuotes(keywords).replaceAll('[!.,?<>;:{}@#$%^&*()]', '').split(' ');
        List<String> newTokens = new List<String>();

        for (String s : tokens)
        {
            temp = s.trim();
            if (!excludedSoslWords.contains(temp))
            {
                newTokens.add(temp + '*');
            }
        }
        tokens = newTokens;

        String orQuery = null;
        if (tokens.isEmpty())
        {
            orQuery = null;
        }
        else if (tokens.size() == 1)
        {
            orQuery = tokens[0];
        }
        else
        {
            orQuery = join(tokens, ' OR ');
        }

        System.debug('buildOrQuery() returning: ' + orQuery);
        return orQuery;
    }

    /* ***** GENERAL DISPLAY AND PROCESSING CONDITIONALS ***** */
    public Boolean searchExecuted           { get { return (!isBlank(allSearchParams) && enteredSearchQuery != searchPrompt); } }
    public Boolean displaySearchResultsLink { get { return (!isBlank(allSearchParams)); } }
    public Boolean isSite                   { get { return !isBlank(Site.getName()); } }

    public Boolean isFitstarSite            { get { 
        if(Site.getName() != null){
            if(Site.getName().contains('Fitstar')){
                return true;
            } else {
                return false;
            }
          } else {
            return false;
          }
    } }

    public Boolean isLoggedIn               { get { return (UserInfo.getUserType() != 'Guest'); } }
    public Boolean singleColumnLayout       { get { return !(viewingArticle || viewingCategory || viewingSearch); } }
    public Boolean isCWCase                 { get { return (!isBlank(ApexPages.currentPage().getParameters().get(CWCASE_PARAM))); } }

    /* ***** CUSTOM SETTINGS TOGGLES * *****/
    //Help_Site_Features__c gf = Help_Site_Features__c.getOrgDefaults();
    //public Boolean HelpSiteFeatures_RouteOrderChatsToPresales { get { return (gf.Route_Order_Chats_to_Presales__c);} }

    /* ***** VIEW STATE ***** */
    public Boolean viewingHome              { get {
        System.debug('\n' +
            'viewingVideos=' + viewingVideos + '\n' +
            'viewingProduct=' + viewingProduct + '\n' +
            'viewingCategory=' + viewingCategory + '\n' +
            'viewingArticle=' + viewingArticle + '\n' +
            'viewingSearch=' + viewingSearch + '\n' +
            'displayContactUs=' + displayContactUs + '\n' +
            'viewingThankYou=' + viewingThankYou + '\n' +
            'viewingPostChat=' + viewingPostChat + '\n' +
            'viewingMobileWrapped=' + viewingMobileWrapped + '\n' +
            'viewing401=' + viewing401 + '\n' +
            'viewing509=' + viewing509 + '\n' +
            'viewing500=' + viewing500 + '\n' +
            'viewing404=' + viewing404 + '\n' +
            'viewingException=' + viewingException + '\n' +
            'viewingError=' + viewingError);
        return !(viewingThankYou || viewingVideos || viewingProduct || viewingCategory || viewingArticle || viewingPostChat || viewingMobileWrapped ||
            viewingSearch || displayContactUs || viewingError); } }
    public Boolean viewingSearch            { get { return (!isBlank(urlSearchQuery) && !viewingError && !viewingArticle); } }
    public Boolean viewingArticle           { get { return (theArticle != null && !isBlank(theArticle.Id) && !viewingError); } }
    public Boolean viewingProduct           { get { return (!isBlank(ApexPages.currentPage().getParameters().get(PRODUCT_PARAM)) && !viewingError && !viewingSearch && !viewingArticle); } }
    public Boolean viewingCategory          { get { return (!isBlank(selectedCategory) && !viewingError && !viewingSearch && !viewingArticle); } }
    public Boolean viewingVideos            { get { return (!isBlank(ApexPages.currentPage().getParameters().get(VIDEOS_PARAM)) && !viewingError); } }
    public Boolean viewingThankYou          { get { return (!isBlank(ApexPages.currentPage().getParameters().get(THANKYOU_PARAM)) && !viewingError); } }
    public Boolean viewingPostChat          { get { return (!isBlank(ApexPages.currentPage().getParameters().get(POSTCHAT_PARAM)) && !viewingError); } }
    public Boolean viewingMobileWrapped     { get { return (!isBlank(ApexPages.currentPage().getParameters().get(MOBILE_WRAPPED_PARAM))); } }
    public Boolean viewingSpecialInquiry    { get { return (!isBlank(ApexPages.currentPage().getParameters().get(SPECIAL_INQUIRY_PARAM))); } }
    public Boolean viewing401               { get { return (!isBlank(ApexPages.currentPage().getUrl()) && ApexPages.currentPage().getUrl().toUpperCase().contains(Page.Unauthorized.getUrl().toUpperCase())); } }
    public Boolean viewing509               { get { return (!isBlank(ApexPages.currentPage().getUrl()) && ApexPages.currentPage().getUrl().toUpperCase().contains(Page.BandwidthExceeded.getUrl().toUpperCase())); } }
    public Boolean viewing500               { get { return (!isBlank(ApexPages.currentPage().getUrl()) && ApexPages.currentPage().getUrl().toUpperCase().contains(Page.InMaintenance.getUrl().toUpperCase())); } }
    public Boolean viewing404               { get { return (!isBlank(ApexPages.currentPage().getUrl()) && ApexPages.currentPage().getUrl().toUpperCase().contains(Page.FileNotFound.getUrl().toUpperCase())); } }
    public Boolean viewingException         { get { return (!isBlank(ApexPages.currentPage().getUrl()) && ApexPages.currentPage().getUrl().toUpperCase().contains(Page.Exception.getUrl().toUpperCase())); } }
    public Boolean viewingError             { get { return (viewing401 || viewing509 || viewing500 || viewing404 || viewingException); }}

    /* ***** HANDLE TO CURRENT INSTANCE OF CONTROLLER (to be passed to rendered VF components, avoids re-instantiation of controller) ***** */
    public pkb_Controller pkbCon { get { return this; } }


    /* ***** SEARCH RELATED PROPS AND METHODS ***** */

    public String selectedCategory { get; set; }
    public String selectedCategoryClass { get { return (selectedCategory != null ? selectedCategory.replaceAll('[^A-Za-z0-9_-]', '') : ''); } }
    public String selectedProduct
    {
        get
        {
            if (this.selectedProduct == null)
            {
                // check if the product is available via cookie
                Cookie productCookie = ApexPages.currentPage().getCookies().get('product');
                System.debug('\n\nProduct Cookie: ' + productCookie);
                if (productCookie != null)
                {
                    this.selectedProduct = productCookie.getValue().replace('Products:', '');
                }
            }
            return this.selectedProduct;
        }
        set
        {
            // create the product cookie, expires in 5 years
            ApexPages.currentPage().setCookies(new Cookie[] {
                new Cookie('product', value, null, (60 * 60 * 24 * 365 * 5), false) });
            this.selectedProduct = value;
        }
    }
    public String selectedProductCategory
    {
        get
        {
            System.debug('selectedProductCategory::get() entered\nselectedProduct=' + selectedProduct);
            String CategoryGroupName = null;
            // categoryGroup2 should be the Product category, for Fitbit, Fitstar, etc.
            if (this.selectedProduct != null && DataCategoryGroupInfos.containsKey(categoryGroup2))
            {
                for (DataCategoryInfo dci : DataCategoryGroupInfos.get(categoryGroup2).Categories)
                {
                    if (dci.Name.equalsIgnoreCase(this.selectedProduct))
                    {
                        CategoryGroupName = dci.Url;
                        break;
                    }
                }
            }
            return CategoryGroupName;
        }
    }
    public String selectedProductAndCategoryFilter
    {
        get
        {
            return (!isBlank(selectedCategory) ? selectedCategory : '') +
                (!isBlank(selectedCategory) && !isBlank(selectedProductCategory) ? ',' : '') +
                (!isBlank(selectedProductCategory) ? selectedProductCategory : '');
        }
    }
    public String urlSearchQuery { get; set; }
    public String feedbackSource { get; set; }
    public String enteredSearchQuery
    {
        set;
        get
        {
            if (enteredSearchQuery == null)
            {
                enteredSearchQuery = searchPrompt;
            }
            return enteredSearchQuery;
        }
    }

    private List<DataCategoryInfo> selectedCategoryInfos
    {
        set;
        get
        {
            if (this.selectedCategoryInfos == null)
            {
                // null check
                if (selectedCategory != null)
                {
                    // avoid a null reference in the VF
                    this.selectedCategoryInfos = new List<DataCategoryInfo>();

                    // break up each category selection
                    String[] catSelections = selectedCategory.split(',');
                    System.debug('Category Selections: ' + catSelections);

                    for (String catSelection : catSelections)
                    {
                        // avoid a null reference in the VF
                        DataCategoryInfo categoryInfo = new DataCategoryInfo(null, null, null);

                        // split the selectedCategory so we have the group & category names
                        String[] groupAndCategory = catSelection.split(':');
                        System.debug('Group and Category Pieces: ' + groupAndCategory);

                        // make sure we have enough pieces
                        if (groupAndCategory.size() >= 2)
                        {
                            System.debug('Data Category Group Keys: ' + DataCategoryGroupInfos.keySet());
                            // check that the group & then category name exists
                            if (DataCategoryGroupInfos.containsKey(groupAndCategory[0]))
                            {
                                System.debug('Data Category Keys: ' + DataCategoryGroupInfos.get(groupAndCategory[0]).CategoryMap.keySet());
                                if (DataCategoryGroupInfos.get(groupAndCategory[0]).CategoryMap.containsKey(groupAndCategory[1]))
                                {
                                    // return the category info
                                    categoryInfo = DataCategoryGroupInfos.get(groupAndCategory[0]).CategoryMap.get(groupAndCategory[1]);
                                }
                            }
                        }
                        this.selectedCategoryInfos.add(categoryInfo);
                    }
                }
            }
            return this.selectedCategoryInfos;
        }
    }

    //public DataCategoryInfo getSelectedTopicCategoryInfo { get { return this.getSelectedCategoryInfoByGroup('Topics'); } }
    public DataCategoryInfo getSelectedTopicCategoryInfo { get {
        System.debug('categoryGroup1: ' + categoryGroup1);
        System.debug('categoryGroup2: ' + categoryGroup2);
        System.debug('categoryGroup3: ' + categoryGroup3);
        System.debug('getSelectedTopicCategoryInfo:' + categoryGroup1);
        return this.getSelectedCategoryInfoByGroup(categoryGroup1);
    } }

    public DataCategoryInfo getSelectedCategoryInfoByGroup(String GroupName)
    {
        System.debug('getSelectedCategoryInfoByGroup: Inside!');
        // avoid a null reference in the VF
        DataCategoryInfo selectCategoryInfo = new DataCategoryInfo(null, null, null);

        // loop through the selected categories and find the topics category
        for (DataCategoryInfo dci : this.selectedCategoryInfos)
        {
            // check if the current category is the topics category
            if (dci.GroupName == GroupName)
            {
                // return this one
                selectCategoryInfo = dci;
            }
        }
        return selectCategoryInfo;
    }

    public void ProductPageCategorySelected()
    {
        System.debug('ProductPageCategorySelected() Selected Category: ' + this.selectedCategory);
    }

    public void ProductPageCategoryCleared()
    {
        this.selectedCategory = null;
        this.selectedCategoryLabel = null;
        System.debug('ProductPageCategoryCleared() Selected Category: ' + this.selectedCategory);
    }

    // url-formatted (e.g. key1=value1&key2=value2) string containing the params related to a search
    public String allSearchParams
    {
        get
        {
            String s;
            List<String> keyValues = new List<String>();
            if (!isBlank(urlSearchQuery))
            {
                keyValues.add(QUERY_PARAM + '=' + EncodingUtil.urlEncode(urlSearchQuery, 'UTF-8'));
            }
            if (!isBlank(selectedLanguage))
            {
                keyValues.add(LANGUAGE_PARAM + '=' + EncodingUtil.urlEncode(selectedLanguage, 'UTF-8'));
            }
            if (!isBlank(selectedCategory))
            {
                keyValues.add(CATEGORY_PARAM + '=' + EncodingUtil.urlEncode(selectedCategory, 'UTF-8'));
            }
            if (!isBlank(ApexPages.currentPage().getParameters().get(PRODUCT_PARAM)))
            {
                keyValues.add(PRODUCT_PARAM + '=' + EncodingUtil.urlEncode(selectedProduct, 'UTF-8'));
            }
            if (displayContactUs)
            {
                keyValues.add(CONTACT_US_PARAM + '=' + CONTACT_US_VALUE);
            }
            s = join(keyValues, '&');
            return s;
        }
    }

    // note that siteName will be null when accessing page internally
    public String siteBaseTitle
    {
        get
        {
            String s = siteName;
            if (isBlank(s))
            {
                s = 'Public Knowledge Base';
            }
            return s;
        }
    }

    public String selectedLanguageURL { get { return '/' + (multiLanguage ? selectedLanguage + '/' : ''); } }

    public String selectedCategoriesLabels { get { return (isBlank(selectedCategory) ? '' :
        selectedCategory.replace(',', ', ').replace(':', ': ').replace('_', ' ')); }}

    public String selectedCategoryLabel { get; set; }

    public String userLanguage { get { return UserInfo.getLanguage(); } }

    // map 4 letter values to 2 letter values
    public Map<String, String> languageCodeMap = new Map<String, String>{
        'en_US'  => 'en_US',
        'de_DE'  => 'de',
         'fr_FR'  => 'fr',
         'es_ES'  => 'es',
         'it_IT'  => 'it',
         'ja_JP'  => 'ja',
         'ko_KR'  => 'ko',
         'zh_CN'  => 'zh_CN',
         'zh_TW'  => 'zh_TW',
         'sv_SE'  => 'sv',
         'nl_NL'  => 'nl_NL'
         //'pt_BR' => 'pt_BR', // Commented for SFDC-4061 by Kartik
         //'es_MX' => 'es_MX'  // Commented for SFDC-4061 by Kartik
     };

    private String resolveLanguage()
    {
        // initialize if blank ('' or null) to ensure that this will always return a valid value
        String result = '';

        // move checking for the 'l' URL parameter here so I can catch pages that need language before the ctor is called
        String lang = ApexPages.currentPage().getParameters().get(LANGUAGE_PARAM);
        String aux_lang = ApexPages.currentPage().getParameters().get('lang');

        // System.debug('language map value:' + languageCodeMap.get(lang));
       
         //if receiving a 4 letter value, translate to SFDC language value
         if(languageCodeMap.get(lang)!= null){
             lang = languageCodeMap.get(lang);
             System.debug('new lang value: ' + lang);
         }

         // do the same for aux lang
         if(languageCodeMap.get(aux_lang)!= null){
             aux_lang = languageCodeMap.get(aux_lang);
             System.debug('new lang value: ' + lang);
         }

        System.debug('\n\n[resolveLanguage] l :' + lang +
                     '\n aux_lang :' + aux_lang);

        // if we are here and the URL parameter is not blank, it means we are on a page that didn't hit the right
        // constructor, make sure the url parameter is used if possible
        if (!isBlank(lang))
        {
            return String.escapeSingleQuotes(lang);
        }

        // check if the auxiliary language param was specified
        if (!isBlank(aux_lang))
        {
            return String.escapeSingleQuotes(aux_lang);
        }

        // check if the language is available via cookie
        Cookie languageCookie = ApexPages.currentPage().getCookies().get('language');
        System.debug('\n\n[resolveLanguage] Cookie Language: ' + languageCookie);
        if (languageCookie != null)
        {
            return languageCookie.getValue();
        }

        String headerLanguage = this.getHeaderAcceptableLanguage();
        System.debug('\n\n[resolveLanguage] Header Language: ' + headerLanguage);
        if (headerLanguage != null)
        {
            return headerLanguage;
        }

        System.debug('\n\n[resolveLanguage] PKB Settings Default Language: ' + defaultLanguage);
        if (!isBlank(defaultLanguage))
        {
            return defaultLanguage;
        }

        // if we get here, we have exhausted all means of determining language, use the default defined in the controller
        return pkb_SettingsController.DEFAULT_LANGUAGE;
    }

    private String resolveCountry()
    {
        System.debug('got here 1');
        // initialize if blank ('' or null) to ensure that this will always return a valid value
        String result = '';

        // move checking for the 'co' URL parameter here so I can catch pages that need language before the ctor is called
        String country = ApexPages.currentPage().getParameters().get(COUNTRY_PARAM);

        if (!isBlank(country) && country != null)
        {
            System.debug('got here 2');
             System.debug('Country :' + country);
            // set countryCookie
    ApexPages.currentPage().setCookies(new Cookie[] {
                new Cookie('country', country, null, (60 * 60 * 24 * 365 * 5), false) });

            System.debug('country cookie : ' + ApexPages.currentPage().getCookies().get('country').getValue());

            // return country
            return String.escapeSingleQuotes(country);
        }
        
        System.debug('got here 3');
        // check if the country is available via cookieCookie theCookie;
        Cookie countryCookie;
        countryCookie = ApexPages.currentPage().getCookies().get('country');
        //System.debug('\n\n[resolveCountry] Cookie Country: ' + countryCookie.getValue());
        if (countryCookie != null)
        {
            // return countryCookie value
            System.debug('got here 4');
            System.debug('Country Cookie: ' + countryCookie.getValue());
            return countryCookie.getValue();

        }

        // if we get here, we have exhausted all means of determining country, use the default
         System.debug('got here 5');
        return 'US_default';
    }

    private String getHeaderAcceptableLanguage()
    {
        // determine language from browser
        // see http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.4
        // EXAMPLE: Accept-Language:en-US,en;q=0.8
        // EXAMPLE: Accept-Language: da, en-gb;q=0.8, en;q=0.7
        String AcceptLanguageHeader = ApexPages.currentPage().getHeaders().get('Accept-Language');
        System.debug('Accept-Language Header: ' + AcceptLanguageHeader);

        // you apparently can't sort a set of Double's, so I am going to assume that the browser sends the acceptable
        // languages ordered by preference

        // null check
        if (AcceptLanguageHeader == null) return null;

        // split the header by comma if multiple languages were provided
        String[] AcceptLanguages = AcceptLanguageHeader.split(',');

        // null check
        if (AcceptLanguages == null) return null;

        // loop through the acceptable languages
        for (String AcceptLanguage : AcceptLanguages)
        {
            // split the acceptable language by semi-colon in case it contains a quality
            String[] LangAndQuality = AcceptLanguage.trim().split(';', 2);

            // loop through each piece
            for (String piece : LangAndQuality)
            {
                System.debug('Language Piece: ' + piece);
                piece = piece.trim();

                // make sure this piece does not contain the quality
                if (piece.indexOf('q=') < 0)
                {
                    // change en-US to en_US
                    if (piece.indexOf('-') >= 0)
                    {
                        piece = piece.substring(0, piece.indexOf('-')) + '_' + piece.substring(piece.indexOf('-') + 1);
                        System.debug('Modified Language Piece: ' + piece);
                    }

                    // loop through the available languages so I can do a non-case comparison
                    for (String availableLanguage : availableLanguagesSet)
                    {
                        // check if the provided language is in the list of available languages as-is
                        if (availableLanguage.equalsIgnoreCase(piece) ||
                            // check if the beggining of the acceptable language is present
                            availableLanguage.split('_').get(0).equalsIgnoreCase(piece.split('_').get(0)))
                        {
                            return availableLanguage;
                        }
                    }
                }
            }
        }

        // if we get here, it likely means we couldn't find an acceptable language
        return null;
    }

    public String selectedLanguage
    {
        set
        {
            // check if the value you are trying to assign is valid (as defined in the PKB settings)
            if (!availableLanguagesSet.contains(value))
            {
                // value is not in the available languages! use default (defined in PKB settings)
                // or use the settings controller default
                this.selectedLanguage = (!isBlank(defaultLanguage) ? defaultLanguage :
                    pkb_SettingsController.DEFAULT_LANGUAGE);
            }
            else
            {
                // value is valid, save the value
                this.selectedLanguage = value;
            }

            // create the language cookie, expires in 5 years
            ApexPages.currentPage().setCookies(new Cookie[] {
                new Cookie('language', this.selectedLanguage, null, (60 * 60 * 24 * 365 * 5), false) });
        }
        get
        {
            // check if we got here without calling a constructor
            if (isBlank(this.selectedLanguage))
            {
                System.debug('selectedLanguage called before it was set!');
                // resolve the language
                this.selectedLanguage = resolveLanguage();
            }

            System.debug('selectedLanguage::get() returning: ' + this.selectedLanguage);
            return this.selectedLanguage;
        }
    }

    public void buildFeaturedKads()
    {
        Set<String> anums = new Set<String>();
        List<PKB_Featured__c> pkbfs = [
                                          select
                                          Id
                                          , Article_Number__c
                                          , LastModifiedDate
                                          from PKB_Featured__c
                                          where
                                          Is_Keyword_Article__c = false and
                                                  PKB_Name__c = :siteName and
                                                          (Expiration__c >= :Date.today() or
                                                                  Expiration__c = null)
                                                          order by
                                                          Order__c desc NULLS last,
                                          LastModifiedDate desc
                                      ];

        for (PKB_Featured__c p : pkbfs)
        {
            anums.add(p.Article_Number__c);
        }
        System.debug('\n\n[DEBUG-PKB CONTROLLER] buildFeaturedKads \n====' + anums + '=====\n');
        featuredKads = initFromListOfArticleNumbers(new List<String>(anums), selectedLanguage);
        System.debug('\n\n[DEBUG-PKB CONTROLLER] featuredKads \n====' + featuredKads + '=====\n');
    }

    /* ***** NARROW SEARCH DISPLAY CONDITIONALS ***** */

    public Boolean displayCategory1 { get { return (!isBlank(categoryGroup1) && !isBlank(rootCategory1)); } }
    public Boolean displayCategory2 { get { return (!isBlank(categoryGroup2) && !isBlank(rootCategory2)); } }
    public Boolean displayCategory3 { get { return (!isBlank(categoryGroup3) && !isBlank(rootCategory3)); } }
    public Boolean displayNarrow    { get { return (displayCategory1 || displayCategory2 || displayCategory3); } }


    /* ***** FEEDBACK AND CASE DEFERRAL CONDITIONALS AND PROCESSING ***** */

    public Boolean displayFeedbackYesNo   { get { return ApexPages.currentPage().getParameters().get(FEEDBACK_PARAM) == FEEDBACK_SHOW_YESNO; } }
    public Boolean displayFeedbackDialog  { get { return ApexPages.currentPage().getParameters().get(FEEDBACK_PARAM) == FEEDBACK_SHOW_DIALOG; } }
    public String sessionId { get; set; }
    public String feedbackComments { get; set; }
    public String createCaseErrorMsg { get; set; }
    public String selectedCountry { get; set; }

    public Boolean caseCreateError
    {
        set;
        get
        {
            if (caseCreateError == null)
            {
                caseCreateError = false;
            }
            return caseCreateError;
        }
    }

    public Boolean caseCreated
    {
        set;
        get
        {
            if (caseCreated == null)
            {
                caseCreated = false;
            }
            return caseCreated;
        }
    }

    public Boolean feedbackRecorded
    {
        set;
        get
        {
            if (feedbackRecorded == null)
            {
                feedbackRecorded = false;
            }
            return feedbackRecorded;
        }
    }

    public void deferred()
    {
        String afdId;
        afdId = createDeferral((upDowVote == 'up'));
        feedbackRecorded = true;

        // Based on the whether the user selected Up or Down, show the relevant post voting options
        postVoteOptions = new List<postVoteOption>();
        for (Post_Feedback_Options__c postOption : [SELECT Custom_Label__c, Save_Text__c
                FROM Post_Feedback_Options__c
                WHERE Vote__c = : upDowVote ORDER BY Sort_Order__c]){
            postVoteOptions.add(new postVoteOption(afdId, postOption.Custom_Label__c, postOption.Save_Text__c));
        }
    }

    public void recordArticleFeedback()
    {
        if (!isBlank(feedbackComments))
        {
            createDeferral(false);
            feedbackRecorded = true;
        }
    }

    public String createDeferral(Boolean isDeferred)
    {
        // validate that the feedback source option is a valid option
        String fs = (feedbackSourceOptions.contains(feedbackSource) ? feedbackSource : null);

        PKB_Article_Feedback_Deflection__c afd = new PKB_Article_Feedback_Deflection__c(
            Article_ID__c = theKad.id,
            Article_Number__c = theKad.articleNumber,
            Article_Title__c = theKad.title,
            Feedback_Source__c = fs,
            Comments__c = feedbackComments,
            Session_ID__c = sessionId,
            Deflection__c = isDeferred,
            Keyword_Searched__c = urlSearchQuery
        );
        insert afd;
        return afd.Id;
    }

    public Set<String> feedbackSourceOptions
    {
        set;
        get
        {
            if (feedbackSourceOptions == null)
            {
                feedbackSourceOptions = getActivePicklistOptions('PKB_Article_Feedback_Deflection__c', 'Feedback_Source__c').keySet();
            }
            return feedbackSourceOptions;
        }
    }

    /* ***** CONTACT US CONDITIONALS AND PROCESSING ***** */
    public Boolean displayContactUs   { get { return (!viewingError && !viewingArticle &&
        ApexPages.currentPage().getParameters().get(CONTACT_US_PARAM) == CONTACT_US_VALUE); } }
    public ContactUsData theCud       { get; set; }
    public Case theCase               { get; set; }

    public PageReference contactUsDeferral()
    {
        feedbackComments = urlSearchQuery;
        feedbackSource = 'ContactUs';
        deferred();
        PageReference p = new PageReference(currentSiteUrl);
        p.setRedirect(true);
        return p;
    }

    public void createCase()
    {

        createCaseErrorMsg = null;
        caseCreateError = false;

        // check for blanks
        if ((isBlank(theCud.firstName) || isBlank(theCud.lastName) || isBlank(theCud.email) || isBlank(theCud.reqType)))
        {
            createCaseErrorMsg = System.Label.PKB2_All_Fields_Required;
            caseCreateError = true;
            return;
        }

        // check for valid email
        if (!isEmail(theCud.email))
        {
            createCaseErrorMsg = System.Label.PKB2_Email_Invalid;
            caseCreateError = true;
            return;
        }

        String d = '';
        d += '\n' + System.Label.PKB2_First_Name +      ': ' + theCud.firstName;
        d += '\n' + System.Label.PKB2_Last_Name +       ': ' + theCud.lastName;
        d += '\n' + System.Label.PKB2_Email +           ': ' + theCud.email;
        //d += '\n' + System.Label.PKB2_Email +           ': ' + theCud.phone;
        d += '\n' + System.Label.PKB2_Request_Type +    ': ' + theCud.reqType + '\n';
        d += '\n' + System.Label.PKB2_Search_Button +   ':\n' + urlSearchQuery;

        theCud.query = urlSearchQuery;
        String subject = '<no search provided>';
        if (!isBlank(urlSearchQuery))
        {
            subject = (urlSearchQuery.length() < CASE_SUBJECT_LENGTH ? urlSearchQuery : urlSearchQuery.substring(0, CASE_SUBJECT_LENGTH));
        }

        // populate the case data
        theCase = new Case();
        theCase.Subject = subject;
        theCase.Type = theCud.reqType;
        theCase.Origin = defaultCaseOrigin;
        if (caseOrigins.containsKey('Web'))
        {
            theCase.Origin = 'Web';
        }
        theCase.Description = d;
        /** fields for the mobile app **/
        theCase.Customer_emoticon_value__c = theCud.User_Experience;
        theCase.pkbgeolocalization__Latitude__s = theCud.location_Latitude;
        theCase.pkbgeolocalization__Longitude__s = theCud.location_Longitude;


        insertRecords();
    }

    public void insertRecords()
    {
        createCaseErrorMsg = null;
        caseCreateError = false;

        // attempt to create the account and contact if configured to do so
        System.Savepoint sp = Database.setSavepoint();
        if (createAcctCon)
        {
            try
            {
                Account a;
                Contact c;
                List<Contact> cons = [select Id, Account.Id from Contact where Email = :theCud.email and Email != null limit 2];

                if (!cons.isEmpty())
                {
                    a = cons[0].Account;
                    c = cons[0];
                }
                else
                {

                    a = new Account(Name = theCud.lastName + ', ' + theCud.firstName);
                    insert a;

                    c = new Contact(
                        AccountId = a.Id
                                    , FirstName = theCud.firstName
                                                  , LastName = theCud.lastName
                                                          , Email = theCud.email
                                                                //, Phone = theCud.phone
                    );
                    insert c;
                }

                theCase.AccountId = a.Id;
                theCase.ContactId = c.Id;
                //relate Contact to article feedback
                relateContactToFeedback(sessionId, c.Id);

            }
            catch (System.DmlException de)
            {
                setErrorAndRollback(sp);
                notifyAdminAndChangeSettings(de, null);

            }
            catch (Exception e)
            {
                setErrorAndRollback(sp);
                notifyAdminAndChangeSettings(null, e);
            }
        }

        // try to insert the case regardless if the account or contact succeeded or not
        try
        {
            insert theCase;
            caseCreated = true;
        }
        catch (DmlException de)
        {
            setErrorAndRollback(sp);
            notifyAdmin(de, null, System.Label.PKB2_Case_Error_Admin_Notification);
        }
        catch (Exception e)
        {
            setErrorAndRollback(sp);
            notifyAdmin(null, e, System.Label.PKB2_Case_Error_Admin_Notification);
        }
    }


    public void relateContactToFeedback(String sessionId, Id contactId)
    {

        System.debug('\n\n===== sessionId :' + sessionId + '  contactId :' + contactId);
        //Update Article Feedback with Contact
        List <PKB_Article_Feedback_Deflection__c>  articleFeedbacks;
        articleFeedbacks = [ select Id
                             from PKB_Article_Feedback_Deflection__c
                             where Session_ID__c = :sessionId and Contact__c = null];

        if (!articleFeedbacks.isEmpty())
        {
            for (PKB_Article_Feedback_Deflection__c articleFeedback : articleFeedbacks)
            {
                articleFeedback.Contact__c = contactId;
            }
            update articleFeedbacks;
        }
    }

    public void setErrorAndRollback(System.Savepoint sp)
    {
        createCaseErrorMsg = System.Label.PKB2_Case_Submit_Error;
        caseCreateError = true;
        Database.rollback(sp);
    }

    public void notifyAdminAndChangeSettings(System.DmlException de, Exception e)
    {
        notifyAdmin(de, e, System.Label.PKB2_Error_Admin_Notification_Email);

        // flip the site settings to not create contact/account in future
        kbSettings.Create_Contact_and_Account__c = false;
        update kbSettings;
    }

    public void notifyAdmin(System.DmlException de, Exception e, String introMessage)
    {
        String body;
        Messaging.SingleEmailMessage msg;

        String debug;

        if (de != null)
        {
            debug = debugDmlException(de);
        }
        else if (e != null)
        {
            debug = debugException(e);
        }

        // send email only if siteAdmin isn't null
        if (siteAdmin != null)
        {
            msg = new Messaging.SingleEmailMessage();
            msg.setSubject('Public Knowledge Base 2 - Package Exception Notification');
            msg.setToAddresses(new List<String> {siteAdmin.Email});

            body = introMessage;
            body += '\n\nAPEX TRANSACTION DEBUG INFORMATION:\n' + debug;
            body += '\n\nSUBMITTED CASE INFORMATION:';
            body += '\n\nSubject: ' + theCase.Subject;
            body += '\n\nCase Type: ' + theCase.Type;
            body += '\n\nCase Origin: ' + theCase.Origin;
            body += '\n\nDescription: ' + theCase.Description;
            body += '\n\n';
            msg.setPlainTextBody(body);
            Messaging.sendEmail(new List<Messaging.SingleEmailMessage> {msg});
        }
    }

    public static String debugDmlException(System.DmlException de)
    {
        String s = '';
        s += 'Cause: ' + de.getCause();
        s += '\nLineNumber: ' + de.getLineNumber();
        s += '\nMessage: ' + de.getMessage();
        s += '\nStackTraceString: ' + de.getStackTraceString();
        s += '\nTypeName: ' + de.getTypeName();
        s += '\nDmlFieldNames: ' + de.getDmlFieldNames(0);
        s += '\nDmlFields: ' + de.getDmlFields(0);
        s += '\nDmlIndex: ' + de.getDmlIndex(0);
        s += '\nDmlMessage: ' + de.getDmlMessage(0);
        s += '\nDmlStatusCode: ' + de.getDmlStatusCode(0);
        s += '\nDmlType: ' + de.getDmlType(0);
        s += '\nNumDml: ' + de.getNumDml();
        return s;
    }

    public static String debugException(Exception e)
    {
        String s = '';
        s += 'Cause: ' + e.getCause();
        s += '\nLineNumber: ' + e.getLineNumber();
        s += '\nMessage: ' + e.getMessage();
        s += '\nStackTraceString: ' + e.getStackTraceString();
        s += '\nTypeName: ' + e.getTypeName();
        return s;
    }

    public String defaultCaseOrigin
    {
        set;
        get
        {
            if (defaultCaseOrigin == null)
            {
                defaultCaseOrigin = getPicklistDefault('Case', 'Origin');
            }
            return defaultCaseOrigin;
        }
    }

    public Map<String, String> caseOrigins
    {
        set;
        get
        {
            if (caseOrigins == null)
            {
                caseOrigins = getActivePicklistOptions('Case', 'Origin');
            }
            return caseOrigins;
        }
    }

    public List<SelectOption> caseTypeOptions
    {
        set;
        get
        {
            if (caseTypeOptions == null)
            {
                List<SelectOption> opts = new List<SelectOption>();
                Map<String, String> optionsMap = getActivePicklistOptions('Case', 'Type');
                for (String s : optionsMap.keySet())
                {
                    opts.add(new SelectOption(s, optionsMap.get(s)));
                }
                caseTypeOptions = new List<SelectOption>();
                caseTypeOptions.add(new SelectOption('', '--' + System.Label.PKB2_None + '--'));
                caseTypeOptions.addAll(sortOptionList(opts));
            }
            return caseTypeOptions;
        }
    }

    /* ***** SITE-SPECIFIC VALUES THAT CAN BE OVERRIDDEN IF NOT VIEWING IN A SITE ***** */

    public String currentSiteUrl
    {
        set;
        get
        {
            if (currentSiteUrl == null)
            {
                currentSiteUrl = Site.getCurrentSiteUrl();
                if (!isSite)
                {
                    if (facebook)
                    {
                        currentSiteUrl = Page.pkb_Home_fb.getUrl();
                    }
                    else
                    {
                        currentSiteUrl = Page.pkb_Home.getUrl();
                    }
                }
            }
            return currentSiteUrl;
        }
    }

    public String homeUrl
    {
        private set;
        get
        {
            return (facebook ? Page.pkb_Home_fb.getUrl() : (isSite ? '/' : Page.pkb_Home.getUrl()));
        }
    }

    public String siteName { get { return DEFAULT_SITE_NAME; } }

    // translated, user-facing site name
    public String siteNameUserFacing { get {
        if(isFitstarSite == true){
            return System.Label.fb_general_Fitstar_help;
        } else {
            return System.Label.fb_general_Fitbit_help;
        }
    } }

    public String pageTitle
        {
            get
            {
                String t = siteNameUserFacing;
                if (viewing401)
                {
                    t += ' - ' + Label.site.authorization_required;
                }
                else if (viewing509)
                {
                    t += ' - ' + Label.site.bandwidth_limit_exceeded;
                }
                else if (viewing500)
                {
                    t += ' - ' + Label.site.in_maintenance;
                }
                else if (viewing404)
                {
                    t += ' - ' + Label.site.file_not_found;
                }
                else if (viewingException)
                {
                    t += ' - ' + Label.site.error2;
                }
                else if (viewingArticle)
                {
                    t += ' - ' + theKad.title;
                }
                else if (viewingProduct)
                {
                    t += ' - ' + selectedProduct.substring(0,1).toUpperCase() + selectedProduct.substring(1).replaceAll('_', ' ');
                }
                else if (viewingCategory)
                {
                    //t += ' - ' + selectedCategory.split(':', -1)[selectedCategory.split(':', -1).size()-1];
                    t += ' - ' + getSelectedTopicCategoryInfo.Label;
                }
                else if (viewingVideos)
                {
                    t += ' - ' + System.Label.pageTitle_aria_help_videos;
                }
                else if (viewingSearch)
                {
                    t += ' - ' + System.Label.PKB2_Search_Results + ' for \'' + enteredSearchQuery + '\'';
                }
                else if (viewingHome)
                {
                    //t += System.Label.pageTitle_home;
                }
                else
                {
                    // t += '';
                }
                return t;
            }
        }

    /* ***** CUSTOM SETTINGS (note that defaults are retrieved from the pkb_SettingsController) ***** */

    private PKB__c kbSettings         { get { return PKB__c.getValues(siteName); }  }
    public Boolean showArticleSummary { get { return (kbSettings == null ? pkb_SettingsController.DEFAULT_DISPLAY_SUMMARY : kbSettings.Display_Article_Summary__c); } }
    public Integer popularArticles    { get { return (kbSettings == null ? pkb_SettingsController.DEFAULT_POPULAR_SIZE : Integer.valueOf(kbSettings.Popular_Articles_Size__c)); } }
    public Integer relatedArticles    { get { return (kbSettings == null ? pkb_SettingsController.DEFAULT_RELATED_SIZE : Integer.valueOf(kbSettings.Related_Articles_Size__c)); } }
    public Integer articlesPerPage    { get { return (kbSettings == null ? pkb_SettingsController.DEFAULT_RESULTS_SIZE : Integer.valueOf(kbSettings.Results_Page_Size__c)); } }
    public Boolean multiLanguage      { get { return (kbSettings == null ? pkb_SettingsController.DEFAULT_MULTI_LANGUAGE : kbSettings.Multi_Language_Enabled__c); } }
    public Boolean createAcctCon      { get { return (kbSettings == null ? pkb_SettingsController.DEFAULT_CREATE_ACCOUNT_CONTACT : kbSettings.Create_Contact_and_Account__c); } }
    public String availableLanguages  { get { return (kbSettings == null ? pkb_SettingsController.DEFAULT_LANGUAGE : kbSettings.Selected_Languages__c); } }
    public String defaultLanguage     { get { return (kbSettings == null ? pkb_SettingsController.DEFAULT_LANGUAGE : kbSettings.Default_Language__c); } }
    public String categoryGroup1      { get { return (kbSettings == null ? null : kbSettings.Category_Group_1__c); } }
    public String categoryGroup2      { get { return (kbSettings == null ? null : kbSettings.Category_Group_2__c); } }
    public String categoryGroup3      { get { return (kbSettings == null ? null : kbSettings.Category_Group_3__c); } }
    public String categoryLabel1      { get { return (kbSettings == null ? null : System.Label.PKB2_Category_Group_Label_1); } }
    public String categoryLabel2      { get { return (kbSettings == null ? null : System.Label.PKB2_Category_Group_Label_2); } }
    public String categoryLabel3      { get { return (kbSettings == null ? null : System.Label.PKB2_Category_Group_Label_3); } }
    public String rootCategory1       { get { return (kbSettings == null ? null : kbSettings.Root_Category_1__c); } }
    public String rootCategory2       { get { return (kbSettings == null ? null : kbSettings.Root_Category_2__c); } }
    public String rootCategory3       { get { return (kbSettings == null ? null : kbSettings.Root_Category_3__c); } }
    public String fbAppId             { get { return (kbSettings == null ? null : kbSettings.FBAppId__c); } }
    public Set<String> relatedDataCategories    { get { return (kbSettings == null || isBlank(kbSettings.Related_Categories__c) ? null : new Set<String>(kbSettings.Related_Categories__c.split(','))); } }
    public Set<String> categoryGroup1Ignore     { get { return (kbSettings == null || isBlank(kbSettings.Category_Group_1_Ignore__c) ? null : new Set<String>(kbSettings.Category_Group_1_Ignore__c.split(','))); } }
    public Set<String> categoryGroup2Ignore     { get { return (kbSettings == null || isBlank(kbSettings.Category_Group_2_Ignore__c) ? null : new Set<String>(kbSettings.Category_Group_2_Ignore__c.split(','))); } }
    public Set<String> categoryGroup3Ignore     { get { return (kbSettings == null || isBlank(kbSettings.Category_Group_3_Ignore__c) ? null : new Set<String>(kbSettings.Category_Group_3_Ignore__c.split(','))); } }

    private ProductPageSettings__c ppSettings   { get { return ProductPageSettings__c.getValues(selectedProduct + '@' + selectedLanguage); } }
    public String ppTitle           { get { return (ppSettings == null ? null : ppSettings.Product_Title__c); } }
    public String ppResourcesLabel  { get { return (ppSettings == null ? null : ppSettings.Resources_Label__c); } }
    public String pp101Label        { get { return (ppSettings == null ? null : ppSettings.Product_101_Label__c); } }
    public String pp101URL          { get { return (ppSettings == null ? null : ppSettings.Product_101_URL__c); } }
    public String ppCommunityLabel  { get { return (ppSettings == null ? null : ppSettings.Community_Label__c); } }
    public String ppCommunityURL    { get { return (ppSettings == null ? null : ppSettings.Community_URL__c); } }
    public String ppManualLabel     { get { return (ppSettings == null ? null : ppSettings.Manual_Label__c); } }
    public String ppManualURL       { get { return (ppSettings == null ? null : ppSettings.Manual_URL__c); } }
    public String ppSetupLabel      { get { return (ppSettings == null ? null : ppSettings.Setup_Label__c); } }
    public String ppSetupURL        { get { return (ppSettings == null ? null : ppSettings.Setup_URL__c); } }

    /* ***** SEARCH RESULTS PAGINATION NAVIGATION ***** */

    public Integer currPage
    {
        set;
        get
        {
            if (currPage == null)
            {
                currPage = 1;
                String p = ApexPages.currentPage().getParameters().get(PAGE_NUM_PARAM);
                if (!isBlank(p))
                {
                    currPage = Integer.valueOf(p);
                }
            }
            return currPage;
        }
    }
    public void nextPage()
    {
        currPage++;
    }
    public void prevPage()
    {
        currPage--;
    }

    /* ***** RETRIEVE LANGUAGE LABELS AND VALUES AND CONSTRUCT SELECT OPTIONS ***** */

    public Set<String> availableLanguagesSet
    {
        set;
        get
        {
            if (availableLanguagesSet == null)
            {
                availableLanguagesSet = new Set<String>();
                List<String> langs = (isBlank(availableLanguages) ? new List<String> {pkb_SettingsController.DEFAULT_LANGUAGE} : availableLanguages.split(';'));
                for (String s : langs)
                {
                    availableLanguagesSet.add(s);
                }
            }
            return availableLanguagesSet;
        }
    }

    public List<SelectOption> languageOptions
    {
        set;
        get
        {
            if (languageOptions == null)
            {
                languageOptions = new List<SelectOption>();
                for (SelectOption so : allLanguageOptions)
                {
                    if (availableLanguagesSet.contains(so.getValue()))
                    {
                        languageOptions.add(so);
                    }
                }
                languageOptions = sortOptionList(languageOptions);
            }
            return languageOptions;
        }
    }

    public static List<SelectOption> allLanguageOptions
    {
        set;
        get
        {
            if (allLanguageOptions == null)
            {
                Map<String, String> optionsMap = getActivePicklistOptions('User', 'LanguageLocaleKey');
                allLanguageOptions = new List<SelectOption>();
                for (String s : optionsMap.keySet())
                {

                // IMPORTANT READ THIS IF YOU ARE ADDING A NEW LANGUAGE
                // Need to add custom label in the format pkb2_lang_* with the language code
                // If you don't, it will error out here   
                // Adding a list of language codes here so that this code section is easy to find when adding a new language
                // en_US, es, zh_CN, zh_TW, ja, de, fr, it, ko, pt_BR, es_MX

                    allLanguageOptions.add(new SelectOption(s, 'pkb2_lang_' + s));
                }
                allLanguageOptions = sortOptionList(allLanguageOptions);
            }
            return allLanguageOptions;
        }
    }

    public String BreadcrumbLabel { private set; get { if (BreadcrumbLabel == null) { getBreadcrumbNavigation(); } return BreadcrumbLabel; } }
    public String BreadcrumbUrl { private set; get { if (BreadcrumbUrl == null) { getBreadcrumbNavigation(); } return BreadcrumbUrl; } }

    private void getBreadcrumbNavigation()
    {
        System.debug('getBreadcrumbNavigation() entered');
        BreadcrumbUrl = homeUrl + '?' + languageParam + '=' + selectedLanguage;
        BreadcrumbLabel = '';
        String searchUrlParam = ApexPages.currentPage().getParameters().get(QUERY_PARAM);
        String productUrlParam = ApexPages.currentPage().getParameters().get(PRODUCT_PARAM);
        String categoryUrlParam = ApexPages.currentPage().getParameters().get(CATEGORY_PARAM);
        String contactUrlParam = ApexPages.currentPage().getParameters().get(CONTACT_US_PARAM);
        Integer navigationPage = (viewingArticle ?
            // article page
            (!isBlank(searchUrlParam) ? 1 :
            (!isBlank(contactUrlParam) ? 2 :
            (!isBlank(productUrlParam) ? 3 :
            (!isBlank(categoryUrlParam) ? 4 :0)))):
            // not article page
            (viewingSearch ? 1 :
            (displayContactUs ? 2 :
            (viewingProduct ? 3 :
            (viewingCategory ? 4 : 0)))));

        System.debug('Breadcrumb Navigation Page: ' + navigationPage + ' (1 = search, 2 = product, 3 = category, 4 = contact us)');

        // search page
        if (navigationPage == 1)
        {
            // assign the label
            //BreadcrumbLabel = urlSearchQuery;
            BreadcrumbLabel = Label.PKB2_Search_Results;

            // return the URL
            BreadcrumbUrl += '&' + queryParam + '=' + EncodingUtil.urlEncode(urlSearchQuery, 'UTF-8') +
                (!isBlank(categoryUrlParam) ? '&' + categoryParam + '=' + EncodingUtil.urlEncode(categoryUrlParam, 'UTF-8') : '') +
                (!isBlank(productUrlParam) ? '&' + productParam + '=' + EncodingUtil.urlEncode(productUrlParam, 'UTF-8') : '');
        }
        // contact page
        else if (navigationPage == 2)
        {
            // assign the label
            BreadcrumbLabel = pkbCon.ContactPage.getFormLabel();

            // return the URL
            BreadcrumbUrl += '&' + contactUsParam + '=' + EncodingUtil.urlEncode(CONTACT_US_VALUE, 'UTF-8') +
                '&' + pkbCon.ContactPage.formParam + '=' + EncodingUtil.urlEncode(pkbCon.ContactPage.Origin, 'UTF-8');
        }
        // product page
        else if (navigationPage == 3)
        {
            // assign the label
            BreadcrumbLabel = selectedProduct;

            // return the URL
            BreadcrumbUrl += '&' + productParam + '=' + EncodingUtil.urlEncode(selectedProduct, 'UTF-8');
        }
        // category page
        else if (navigationPage == 4)
        {
            // assign the label
            BreadcrumbLabel = (selectedCategoryInfos != null && selectedCategoryInfos.size() > 0 ? selectedCategoryInfos[0].Label :
                (!isBlank(selectedCategoriesLabels) ? selectedCategoriesLabels : selectedCategory));

            // return the URL
            BreadcrumbUrl += '&' + categoryParam + '=' + EncodingUtil.urlEncode(selectedCategory, 'UTF-8');
        }

        System.debug('BreadcrumbUrl: ' + BreadcrumbUrl);
        System.debug('BreadcrumbLabel: ' + BreadcrumbLabel);
    }

    /* ***** DYNAMIC RETRIEVAL OF ARTICLE TYPES VIA DESCRIBES AND OBJECT ID PREFIXES ***** */

    public static Set<String> kavNames
    {
        set;
        get
        {
            if (kavNames == null)
            {
                kavNames = new Set<String>();
                Map<String, Schema.SOBjectType> gd = Schema.getGlobalDescribe();

                for (String s : gd.keySet())
                {
                    if (s.contains(KAV_EXTENSION))
                    {
                        kavNames.add(s);
                    }
                }
            }
            return kavNames;
        }
    }

    public static Map<String, Schema.DescribeSObjectResult> kavObjPrefixMap
    {
        get
        {
            if (kavObjPrefixMap == null)
            {
                kavObjPrefixMap = new Map<String, Schema.DescribeSObjectResult>();
                Map<String, Schema.SOBjectType> gd = Schema.getGlobalDescribe();
                Schema.DescribeSObjectResult sor;
                for (String s : kavNames)
                {
                    sor = gd.get(s).getDescribe();
                    kavObjPrefixMap.put(sor.getKeyPrefix().toLowerCase(), sor);
                }
            }
            return kavObjPrefixMap;
        }
    }

    public static Schema.DescribeSObjectResult getKAVDescribeById(String i)
    {
        if (isBlank(i) || i.length() < 15)
        {
            return null;
        }
        return kavObjPrefixMap.get(i.substring(0, 3).toLowerCase());
    }


    /* ***** CONTACT US FORM WRAPPER CLASS ***** */
    public class ContactUsData
    {
        public String firstName { get; set; }
        public String lastName  { get; set; }
        public String email     { get; set; }
        //public String phone     { get; set; }
        public String reqType   { get; set; }
        public String query     { get; set; }
        /** fields added to covert new fields on Mobile app**/
        public Decimal  location_Latitude   { get; set; }
        public Decimal  location_Longitude { get; set; }
        public String User_Experience       { get; set; }


        public ContactUsData() { }
    }

    public String IgnoredDataCategoryStr
    {
        private set;
        get
        {
            if (this.IgnoredDataCategoryStr == null)
            {
                this.IgnoredDataCategoryStr = '';

                // build a map I can loop through
                Map<String, Set<String>> categoryGroupIgnoreMap = new Map<String, Set<String>>();
                if (categoryGroup1 != null)
                {
                    categoryGroupIgnoreMap.put(categoryGroup1, categoryGroup1Ignore);
                }
                if (categoryGroup2 != null)
                {
                    categoryGroupIgnoreMap.put(categoryGroup2, categoryGroup2Ignore);
                }
                if (categoryGroup3 != null)
                {
                    categoryGroupIgnoreMap.put(categoryGroup3, categoryGroup3Ignore);
                }

                // loop through the category groups and build the ignore string
                for (String categoryGroup : categoryGroupIgnoreMap.keySet())
                {
                    System.debug('Building Ignore String for category group: ' + categoryGroup);
                    if (categoryGroupIgnoreMap.get(categoryGroup) != null)
                    {
                        for (String categoryIgnore : categoryGroupIgnoreMap.get(categoryGroup))
                        {
                            System.debug('Ignoring category: ' + categoryGroup + ':' + categoryIgnore);
                            this.IgnoredDataCategoryStr += categoryGroup + ':' + categoryIgnore + ',';
                        }
                    }
                }
            }
            System.debug('IgnoredDataCategoryStr: ' + this.IgnoredDataCategoryStr);
            return this.IgnoredDataCategoryStr;
        }
    }
    public List<DataCategoryGroupInfo> RelatedCategories
    {
        get
        {
            List<DataCategoryGroupInfo> ret = new List<DataCategoryGroupInfo>();

            // null out the DataCategoryGroupInfos so it refreshes with language applied
            DataCategoryGroupInfos = null;

            for (String dcgiName : DataCategoryGroupInfos.keySet())
            {
                // use a local var for easier reference
                DataCategoryGroupInfo dcgi = DataCategoryGroupInfos.get(dcgiName);

                System.debug('[RelatedCategories] DataCategoryGroupInfo.Label: ' + dcgi.Label);

                // check if this is a data category group that should show up in the 'related' list
                if (relatedDataCategories == null || relatedDataCategories.contains(dcgi.Name))
                {
                    //System.debug('\n\n===== RelatedCategories:' +
                    //    '\n===== Related Data Categories: ' + relatedDataCategories);

                    //// create a temp var because APEX passes stuff by reference and otherwise the source list is changed
                    //DataCategoryGroupInfo tmpDCGI = new DataCategoryGroupInfo(dcgi.Name, dcgi.Label, dcgi.Description, null);

                    //// loop through the categories and add them to the temp var
                    //for (DataCategoryInfo dci : dcgi.Categories)
                    //{
                    //    // filter out ignored category items
                    //    if (// Category Group 1
                    //        (!isBlank(categoryGroup1) && dcgi.Name.equalsIgnoreCase(categoryGroup1) &&
                    //        (categoryGroup1Ignore == null || !categoryGroup1Ignore.contains(dci.Name))) ||
                    //        // Category Group 2
                    //        (!isBlank(categoryGroup2) && dcgi.Name.equalsIgnoreCase(categoryGroup2) &&
                    //        (categoryGroup2Ignore == null || !categoryGroup2Ignore.contains(dci.Name))) ||
                    //        // Category Group 3
                    //        (!isBlank(categoryGroup3) && dcgi.Name.equalsIgnoreCase(categoryGroup3) &&
                    //        (categoryGroup3Ignore == null || !categoryGroup3Ignore.contains(dci.Name))))
                    //    {
                    //        tmpDCGI.addCategory(new DataCategoryInfo(dci.Name, dci.Label, dci.GroupName));
                    //    }
                    //    else
                    //    {
                    //        System.debug('\n\n===== RelatedCategories: Omitting ' + dcgi.Name);
                    //    }
                    //}
                    //ret.add(tmpDCGI);
                    ret.add(dcgi);
                }
            }
            return ret;
        }
    }

    // Map of data category groups; Key is the API name of the group
    private static Map<String, DataCategoryGroupInfo> DataCategoryGroupInfos
    {
        private set;
        get
        {
            
            // check if this has already been generated
            if (DataCategoryGroupInfos == null)
            {
                // init the map
                DataCategoryGroupInfos = new Map<String, DataCategoryGroupInfo>();

                // retrieve all the data category groups (with their data categories)
                List<DataCategoryGroupInfo> dcgis = DataCategoryUtil.getInstance().getAllCategoryGroups();

                // get the related categories list
                PKB__c kbSettings = PKB__c.getValues(pkb_Controller.DEFAULT_SITE_NAME);
                String categoryGroup1 = kbSettings.Category_Group_1__c;
                String categoryGroup2 = kbSettings.Category_Group_2__c;
                String categoryGroup3 = kbSettings.Category_Group_3__c;
                Set<String> categoryGroup1Ignore = (kbSettings == null || isBlank(kbSettings.Category_Group_1_Ignore__c) ? null : new Set<String>(kbSettings.Category_Group_1_Ignore__c.split(',')));
                Set<String> categoryGroup2Ignore = (kbSettings == null || isBlank(kbSettings.Category_Group_2_Ignore__c) ? null : new Set<String>(kbSettings.Category_Group_2_Ignore__c.split(',')));
                Set<String> categoryGroup3Ignore = (kbSettings == null || isBlank(kbSettings.Category_Group_3_Ignore__c) ? null : new Set<String>(kbSettings.Category_Group_3_Ignore__c.split(',')));

                System.debug('\n\n===== [DataCategoryGroupInfos]' +
                    '\n===== Category Group 1: ' + categoryGroup1 +
                    '\n===== Category Group 2: ' + categoryGroup2 +
                    '\n===== Category Group 3: ' + categoryGroup3 +
                    '\n===== Category Group 1 Ignore: ' + categoryGroup1Ignore +
                    '\n===== Category Group 2 Ignore: ' + categoryGroup2Ignore +
                    '\n===== Category Group 3 Ignore: ' + categoryGroup3Ignore);

                // loop through the data category groups and add them to the map
                for (DataCategoryGroupInfo dcgi : dcgis)
                {
                    // check if the data category group is exposed on the PKB
                    if ((!isBlank(categoryGroup1) && dcgi.Name.equalsIgnoreCase(categoryGroup1)) ||
                        (!isBlank(categoryGroup2) && dcgi.Name.equalsIgnoreCase(categoryGroup2)) ||
                        (!isBlank(categoryGroup3) && dcgi.Name.equalsIgnoreCase(categoryGroup3)))
                    {
                        // create a temp var because APEX passes stuff by reference and otherwise the source list is changed
                        DataCategoryGroupInfo tmpDCGI = new DataCategoryGroupInfo(dcgi.Name, dcgi.Label, dcgi.Description, null);

                        // loop through the categories and add them to the temp var
                        for (DataCategoryInfo dci : dcgi.Categories)
                        {
                            // filter out ignored category items, which are set in PKB2 Site Settings
                            if (// Category Group 1
                                (!isBlank(categoryGroup1) && dcgi.Name.equalsIgnoreCase(categoryGroup1) &&
                                (categoryGroup1Ignore == null || !categoryGroup1Ignore.contains(dci.Name))) ||
                                // Category Group 2
                                (!isBlank(categoryGroup2) && dcgi.Name.equalsIgnoreCase(categoryGroup2) &&
                                (categoryGroup2Ignore == null || !categoryGroup2Ignore.contains(dci.Name))) ||
                                // Category Group 3
                                (!isBlank(categoryGroup3) && dcgi.Name.equalsIgnoreCase(categoryGroup3) &&
                                (categoryGroup3Ignore == null || !categoryGroup3Ignore.contains(dci.Name))))
                            {
                                tmpDCGI.addCategory(new DataCategoryInfo(dci.Name, dci.Label, dci.GroupName));
                            }
                            else
                            {
                                System.debug('\n\n===== [DataCategoryGroupInfos] Omitting Category: ' + dci.Url);
                            }
                        }
                        DataCategoryGroupInfos.put(tmpDCGI.Name, tmpDCGI);
                    }
                    else
                    {
                        System.debug('\n\n===== [DataCategoryGroupInfos] Omitting Category Group: ' + dcgi.Name);
                    }
                }
            }

            return DataCategoryGroupInfos;
        }
    }

    private Map<String, Set<Id>> ArticleVersionIdsForProductMap { get; set; }

    private Set<Id> getArticleVersionIdsForProduct(String Product, Boolean ReturnMasterVersionId)
    {
        System.debug('getArticleVersionIdsForProduct() entered\n===== Product: ' + Product +
            '\n===== ReturnMasterVersionId: ' + ReturnMasterVersionId);
        // check if map needs to be initialized
        if (this.ArticleVersionIdsForProductMap == null)
        {
            this.ArticleVersionIdsForProductMap = new Map<String, Set<Id>>();
        }

        // check if we have this cached
        if (!this.ArticleVersionIdsForProductMap.containsKey(Product + ReturnMasterVersionId))
        {
            // get the article id's for the product
            // this has to be done with dynamic SOQL since bind variables in the WITH DATA CATEGORY clause are not
            // supported at this time, see: https://developer.salesforce.com/forums?id=906F00000008xVDIAY
            // This is also helpful: https://www.salesforce.com/us/developer/docs/soql_sosl/Content/sforce_api_calls_sosl_with_data_category.htm
            String qry = 'SELECT Id, IsMasterLanguage, MasterVersionId FROM KnowledgeArticleVersion ' +
                'WHERE PublishStatus = \'' + DEFAULT_PUBLISH_STATUS + '\' AND Language = \'' + this.selectedLanguage + '\' ' +
                WITH_DATA_CATEGORY + 'Products__c' + DATA_CATEGORY_OPERATOR + Product + '__c';
                System.debug('Got here Search 6');
            System.debug('\n\n[DEBUG-PKB CONTROLLER] getArticleVersionIdsForProduct query\n====' + qry + '=====\n');
            List<SObject> articleVersions = Database.query(qry);
     
            // build a set of Article Ids for the product
            Set<Id> articleVersionIds = new Set<Id>();
            for (SObject article : articleVersions)
            {
                //System.debug('Article Version Info:\n===== Id: ' + article.Id + '\n===== IsMasterLanguage: ' +
                //    Boolean.valueOf(article.get('IsMasterLanguage')) + '\n===== MasterVersionId: ' +
                //    article.get('MasterVersionId'));

                // if the master version id is being requested, and the article is not the master, return the master id
                // otherwise return the article id
                articleVersionIds.add(
                    (ReturnMasterVersionId && !Boolean.valueOf(article.get('IsMasterLanguage')) ?
                        (Id) article.get('MasterVersionId') : article.Id));
            }
            System.debug((ReturnMasterVersionId ? 'Master ' : '' ) + 'Article Version Ids: ' + articleVersionIds);

            // add the article id set to the map
            this.ArticleVersionIdsForProductMap.put(Product + ReturnMasterVersionId, articleVersionIds);
        }

        return this.ArticleVersionIdsForProductMap.get(Product + ReturnMasterVersionId);
    }

    private Set<String> getCategoriesWithArticlesForProduct(String Product)
    {
        if (this.NonEmptyCategoriesForProduct == null)
        {
            this.NonEmptyCategoriesForProduct = new Map<String, Set<String>>();
        }

        // check if we have retrieved the non-empty categories for this product already
        if (!this.NonEmptyCategoriesForProduct.containsKey(Product))
        {
            // need to generate
            System.debug('Categories for product \'' + Product + '\' need to be generated.');

            // get set of Article Ids for the product (the master version ids!)
            Set<Id> articleVersionIds = this.getArticleVersionIdsForProduct(Product, true);

            // query for the categories associated with this product
            List<Help_article__DataCategorySelection> categorySelections = [SELECT DataCategoryGroupName, DataCategoryName
                FROM Help_article__DataCategorySelection WHERE ParentId IN :articleVersionIds];
            System.debug('Got here Search 8');

            System.debug('DataCategorySelection Query Row Count: ' + categorySelections.size());

            // init the set that contains the non-empty categories
            Set<String> categories = new Set<String>();

            // loop through the category selections and add them to the set
            for (Help_article__DataCategorySelection categorySelection : categorySelections)
            {
                // build the category 'url'
                String categoryUrl = categorySelection.DataCategoryGroupName + ':' + categorySelection.DataCategoryName;
                System.debug('Got here Search 9');
                // check if we have stored this already
                if (categories.contains(categoryUrl))
                {
                    continue;
                }

                // add the category 'url' to the set
                categories.add(categoryUrl);
            }
            System.debug('Categories: ' + categories);

            // add the set of categories to the map
            this.NonEmptyCategoriesForProduct.put(Product, categories);
        }

        // return the non-empty categories for the product
        return this.NonEmptyCategoriesForProduct.get(Product);
    }

    // Key - Product
    // Value - Set of category urls that have articles for the product & category combination
    private Map<String, Set<String>> NonEmptyCategoriesForProduct { set; get; }

    public DataCategoryGroupInfo ProductCategoryGroupInfo
    {
        get
        {
            if (!DataCategoryGroupInfos.containsKey(categoryGroup2))
            {
                System.debug(LoggingLevel.ERROR, 'The categoryGroup2 data category group is not present! Available groups: ' + DataCategoryGroupInfos.keySet());
            }
            else
            {
                System.debug('\n===== CategoryGroupInfo2 (originally Products) returning: ' + DataCategoryGroupInfos.get(categoryGroup2));
            }
            return (DataCategoryGroupInfos.containsKey(categoryGroup2) ?
                DataCategoryGroupInfos.get(categoryGroup2) :
                null);
        }
    }

    public List<DataCategoryInfo> ProductPageCategories
    {
        private set;
        get
        {
            // check if this has already been generated
            if (this.ProductPageCategories == null)
            {
                // null check
                if (relatedDataCategories != null)
                {
                    // init the list
                    this.ProductPageCategories = new List<DataCategoryInfo>();

                    // loop through the related categories (the member property is CSV formatted)
                    for (String relatedCategory : relatedDataCategories)
                    {
                        // check if the map contains this data category group
                        if (DataCategoryGroupInfos.containsKey(relatedCategory.trim()))
                        {
                            // loop through the data categories for the group
                            for (DataCategoryInfo dci : DataCategoryGroupInfos.get(relatedCategory.trim()).Categories)
                            {
                                // check if this is a category that is configured to be ignored
                                if (categoryGroup1Ignore == null || categoryGroup1Ignore.contains(dci.Name))
                                {
                                    System.debug('This category [' + dci.Name + '] is configured to be ignored. Skipping.');
                                    continue;
                                }

                                // check if the category has results
                                if (!this.getCategoriesWithArticlesForProduct(this.selectedProduct).contains(dci.Url))
                                {
                                    System.debug('This category [' + dci.Name + '] has no articles. Skipping.');
                                    continue;
                                }

                                // add the data category to the ones to be displayed on the product page
                                this.ProductPageCategories.add(dci);
                            }
                        }
                    }
                }
            }

            return this.ProductPageCategories;
        }
    }

    public List<Help_article__kav> TopArticlesForSelectedProduct
    {
        get
        {
            // get set of article ids for selected product (not master articles!)
            Set<Id> articleVersionIds = this.getArticleVersionIdsForProduct(this.selectedProduct, false);

            // query for the articles
            List<Help_article__kav> articles = [SELECT Id, KnowledgeArticleId, Title, UrlName, Summary
                FROM Help_article__kav WHERE Id IN :articleVersionIds AND Rank__c > 0 ORDER BY Rank__c ASC LIMIT 6];

            // save the article urls
            TopArticleUrlsForSelectedProduct = '';
            for (Help_article__kav article : articles)
            {
                TopArticleUrlsForSelectedProduct += article.UrlName + ',';
            }

            return articles;
        }
    }

    public String TopArticleUrlsForSelectedProduct { get; private set; }


    /* ***** KNOWLEDGE ARTICLE DATA (KAD) WRAPPER CLASS ***** */

    /*
      This wrapper class mimics the quasi article/article version object that is given to the loop executed by the
      VF tag knowledge:articleList. It implements all of the fields of that object plus articleNumber, and also exposes a handle to the
      underlying KAV object that was used to populate most of the fields

      A single instance can be instantiated by passing the constructor a single ID of a KnowledgeArticle record (this constructor uses a soql query to retrieve the article)
      or an already-queried KAV record.

      Multiple instances can be instantiated from a list of KnowledgeArticle or KAV IDs by using the KAD static initializers (initFromListOfArticleNumbers, etc).
    */
    public class KnowledgeArticleData
    {
        public String id                     { get; set; } // note this is the ID of the KnowledgeArticle record, not the ID of the KAV record
        public String kavId                  { get; set; } // note this is the ID of the KAV record
        public String title                  { get; set; }
        public String summary                { get; set; }
        public String urlName                { get; set; }
        public String articleTypeName        { get; set; }
        public String articleTypeLabel       { get; set; }
        public DateTime lastModifiedDate     { get; set; }
        public DateTime firstPublishedDate   { get; set; }
        public DateTime lastPublishedDate    { get; set; }
        public String articleNumber          { get; set; }
        public KnowledgeArticleVersion theAV { get; set; }

        // ctor for empty KAD
        public KnowledgeArticleData() { }

        // ctor that takes an already constructed-KAV record
        public KnowledgeArticleData(KnowledgeArticleVersion kav)
        {
            init(kav);
        }

        // ctore that takes the ID of a KnowledgeArticle record and queries the KAV record from it
        public KnowledgeArticleData(Id i, String lang)
        {
            String q = '';
            String pub = pkb_Controller.DEFAULT_PUBLISH_STATUS;
            q += 'select ' + join(kavFields, ',') + ' from KnowledgeArticleVersion';
            q += ' where PublishStatus = :pub and Language = :lang and KnowledgeArticleId = :i limit 1';
            KnowledgeArticleVersion kav = (KnowledgeArticleVersion)Database.query(q);
            System.debug('Got here Search 4');
            init(kav);
        }

        public void init(KnowledgeArticleVersion kav)
        {
            this.theAV = kav;

            id = this.theAV.KnowledgeArticleId;
            kavId = this.theAV.Id;
            title = this.theAV.Title;
            summary = this.theAV.Summary;
            urlName = this.theAV.UrlName;
            articleTypeName = getKAVDescribeById(id).getLocalName();
            articleTypeLabel = getKAVDescribeById(id).getLabel();
            lastModifiedDate = this.theAV.LastModifiedDate;
            firstPublishedDate = this.theAV.FirstPublishedDate;
            lastPublishedDate = this.theAV.LastPublishedDate;
            articleNumber = this.theAV.ArticleNumber;
        }

        // Retrieves a list of data category selections associated to the KAV for the related categories component
        public List<DataCategoryGroupInfo> RelatedDataCategorySelections
        {
            get
            {
                System.debug('RelatedDataCategorySelections::get() entered');
                if (this.RelatedDataCategorySelections == null)
                {
                    // init the list
                    this.RelatedDataCategorySelections = new List<DataCategoryGroupInfo>();

                    // get the related categories list
                    PKB__c kbSettings = PKB__c.getValues(pkb_Controller.DEFAULT_SITE_NAME);

                    // make sure it is populated
                    if (isBlank(kbSettings.Related_Categories__c))
                    {
                        System.debug(LoggingLevel.ERROR, 'Related Categories on PKB Custom Settings is empty!');
                    }
                    else
                    {
                        // split the related data categories so the displayed category groups can be limited to them
                        Set<String> relatedDataCategories = (kbSettings == null || isBlank(kbSettings.Related_Categories__c) ? null : new Set<String>(kbSettings.Related_Categories__c.split(',')));

                        // loop through the associated data category groups & categories and filter for the groups that
                        // should be displayed in the related categories component
                        for (Integer i = 0; i < this.DataCategorySelections.size(); i++)
                        {
                            // check if this is a data category group that should be displayed
                            if (relatedDataCategories == null || !relatedDataCategories.contains(this.DataCategorySelections.get(i).Name))
                            {
                                System.debug('Data Category Group [' + this.DataCategorySelections.get(i).Name + '] is not in the list to be displayed, skipping...');
                                continue;
                            }

                            // add the data category group to the related categories list
                            this.RelatedDataCategorySelections.add(this.DataCategorySelections.get(i));
                        }
                    }
                }
                System.debug('getRelatedDataCategorySelections() returning [' + this.RelatedDataCategorySelections.size() + '] data category selections.');
                return this.RelatedDataCategorySelections;
            }
            private set;
        }

        // Retrieves a list of data category selections associated to the KAV
        public List<DataCategoryGroupInfo> DataCategorySelections
        {
            get
            {
                System.debug('DataCategorySelections::get() entered');
                if (this.DataCategorySelections == null)
                {
                    // init the list
                    this.DataCategorySelections = new List<DataCategoryGroupInfo>();

                    // query for the article data category selections
                    /**/
                    String dcsQuery = 'SELECT Id, DataCategoryGroupName, DataCategoryName FROM ' +
                    this.articleTypeName.replace(KAV_EXTENSION, '') + DCS_EXTENSION + ' WHERE ParentId = \'' + kavId + '\'';
                    System.debug('DataCategorySelection Query: ' + dcsQuery);
                    System.debug('Got here Search 11');
                    List<SObject> dcss = Database.query(dcsQuery);
                    /**/
                    /*/
                    // Test query for returning data category selections using SOQL instead of Database.query()
                    List<SObject> dcss = [SELECT Id, DataCategoryGroupName, DataCategoryName FROM
                        Help_article__DataCategorySelection WHERE ParentId = :kavId];
                    /**/

                    // build a map so I can add only items that are associated to this article
                    Map<String, DataCategoryGroupInfo> dcgis = new Map<String, DataCategoryGroupInfo>();

                    // loop through the results and build the map
                    for (SObject dcs : dcss)
                    {
                        String DataCategoryGroupName = String.valueOf(dcs.get('DataCategoryGroupName'));
                        String DataCategoryName = String.valueOf(dcs.get('DataCategoryName'));
                        System.debug('DataCategoryGroupName: [' + DataCategoryGroupName + '], DataCategoryName: [' + DataCategoryName + ']');

                        // check if map contains this data category
                        if (DataCategoryGroupInfos.containsKey(DataCategoryGroupName))
                        {
                            DataCategoryGroupInfo dcgi = DataCategoryGroupInfos.get(DataCategoryGroupName);
                            if (!dcgis.containsKey(DataCategoryGroupName))
                            {
                                System.debug('Map does not contain [' + DataCategoryGroupName + '], adding...');

                                // NOTE: You MUST 'new' the DataCategoryGroupInfo because otherwise it is using a reference
                                // and you can't control the list of categories
                                dcgis.put(DataCategoryGroupName, new DataCategoryGroupInfo(dcgi.Name, dcgi.Label,
                                          dcgi.Description, new List<DataCategoryInfo>()));
                            }

                            // add the category group info
                            if (dcgi.CategoryMap.containsKey(String.valueOf(dcs.get('DataCategoryName'))))
                            {
                                System.debug('Found [' + dcs.get('DataCategoryName') + '], adding...');
                                // add the category to the return
                                dcgis.get(DataCategoryGroupName).addCategory(dcgi.CategoryMap.get(
                                            String.valueOf(dcs.get('DataCategoryName'))));
                            }
                        }
                        else
                        {
                            System.debug(LoggingLevel.WARN, 'DataCategoryGroupName [' + DataCategoryGroupName + '] does not exist!');
                        }
                    }
                    this.DataCategorySelections.addAll(dcgis.values());
                }
                System.debug('getDataCategorySelections() returning [' + this.DataCategorySelections.size() + '] data category selections.');
                return this.DataCategorySelections;
            }
            private set;
        }
    }

    public static Set<String> excludedSoslWords
    {
        get
        {
            if (excludedSoslWords == null)
            {
                excludedSoslWords = new Set<String>();
                /*{'and','or','the','a'};*/
            }
            return excludedSoslWords;
        }
        private set;
    }

    // these fields must be queried when instantiating a KAD wrapper object, so this set is
    // used in the sosl and soql queries to ensure that all queries get the right fields
    public static Set<String> kavFields
    {
        get
        {
            if (kavFields == null)
            {
                kavFields = new Set<String>
                {
                    'Id'
                    , 'Title'
                    , 'Summary'
                    , 'UrlName'
                    , 'ArticleNumber'
                    , 'LastModifiedDate'
                    , 'FirstPublishedDate'
                    , 'LastPublishedDate'
                    , 'Language'
                    , 'PublishStatus'
                    , 'KnowledgeArticleId'
                };
            }
            return kavFields;
        }
        private set;
    }


    /* ***** KNOWLEDGE ARTICLE DATA CLASS STATIC INITIALIZERS/FACTORIES ***** */

    public static List<KnowledgeArticleData> initFromListOfArticleNumbers(List<String> anums, String lang)
    {
        System.debug('initFromListOfArticleNumbers() entered\n\nanums: ' + anums +
            '\nlang: ' + lang + '\n\n');
        List<KnowledgeArticleData> kads = new List<KnowledgeArticleData>();

        if (anums == null || anums.isEmpty())
        {
            return kads;
        }

        // why doesn't this use initFromListOfKAVs()?
        List<KnowledgeArticleVersion> kavs = initKAVQuery('ArticleNumber', anums, lang);

        for (KnowledgeArticleVersion kav : kavs)
        {
            kads.add(new KnowledgeArticleData(kav));
        }

        System.debug('\n\n[DEBUG-PKB CONTROLLER] initFromListOfArticleNumbers\n====' + kads + '=====\n');
        System.debug('Got here Search 12');
        return kads;
    }

    // instantiates and returns a list of the KAD wrapper class objects from a list of KnowledgeArticle IDs and the specified language.
    public static List<KnowledgeArticleData> initFromListOfArticleIds(List<String> aids, String lang)
    {
        List<KnowledgeArticleData> kads = new List<KnowledgeArticleData>();

        if (aids == null || aids.isEmpty())
        {
            return kads;
        }
        return initFromListOfKAVs(initKAVQuery('KnowledgeArticleId', aids, lang));
    }

    //// instantiates and returns a list of the KAD wrapper class objects from a set of KAV IDs and the specified language.
    //public static List<KnowledgeArticleData> initFromListOfKAVIds(Set<Id> kids, String lang)
    //{
    //    List<String> kavIds = new List<String>();
    //    for (Id kavId : kids)
    //    {
    //        kavIds.add(kavId);
    //    }
    //    return initFromListOfKAVIds(kavIds, lang);
    //}

    // instantiates and returns a list of the KAD wrapper class objects from a list of KAV IDs and the specified language.
    public static List<KnowledgeArticleData> initFromListOfKAVIds(List<String> kids, String lang)
    {
        List<KnowledgeArticleData> kads = new List<KnowledgeArticleData>();

        if (kids == null || kids.isEmpty())
        {
            return kads;
        }
        return initFromListOfKAVs(initKAVQuery('Id', kids, lang));
    }

    // instantiates a list of KADs from already-queried KAVs
    public static List<KnowledgeArticleData> initFromListOfKAVs(List<KnowledgeArticleVersion> kavs)
    {
        List<KnowledgeArticleData> kads = new List<KnowledgeArticleData>();

        if (kavs == null || kavs.isEmpty())
        {
            return kads;
        }

        for (KnowledgeArticleVersion kav : kavs)
        {
            kads.add(new KnowledgeArticleData(kav));
        }
        return kads;
    }

    public static List<KnowledgeArticleVersion> initKAVQuery(String field, List<String> vals, String lang)
    {
        String q = '';
        q += 'SELECT ' + join(kavFields, ',') + ' FROM KnowledgeArticleVersion ';
        q += 'WHERE PublishStatus = \'' + pkb_Controller.DEFAULT_PUBLISH_STATUS + '\' ' +
            'AND Language = \'' + lang + '\' ' +
            'AND ' + field + ' IN :vals ORDER BY LastPublishedDate DESC';
        System.debug('Got here Search 5');
        // listing knowledge articles, but category has already been set
        System.debug('\n\n[DEBUG-PKB CONTROLLER] initKAVQuery query\n==== vals: ' + vals + '=====\n====' + q + '=====\n');

        return (List<KnowledgeArticleVersion>) Database.query(q);
    }

    /* ***** GENERAL UTIL METHODS ***** */

    // returns true if string is null or empty
    public static Boolean isBlank(String s)
    {
        return (s == null || s == '');
    }

    // joins elements in the passed list of strings by the passed string c
    // c can be a single character or a longer string -- useful for joinging segments of a dynamic sosl or soql query
    public static String join(List<String> strings, String c)
    {
        if (strings == null || strings.isEmpty())
        {
            return null;
        }

        String sep = (isBlank(c) ? ',' : c);
        Integer i, size;
        String s = strings[0];

        size = strings.size();
        for (i = 1; i < size; i++)
        {
            s += (sep + strings[i]);
        }
        return s;
    }

    // version of join method that takes a set of strings
    public static String join(Set<String> strings, String c)
    {
        return join(new List<String>(strings), c);
    }


    public static String getPicklistDefault(String so, String field)
    {
        String defVal = null;
        for (Schema.PicklistEntry ple : getActivePicklistEntries(so, field))
        {
            if (ple.isDefaultValue())
            {
                defVal = ple.getValue();
                break;
            }
        }
        return defVal;
    }

    public static Map<String, String> getActivePicklistOptions(String so, String field)
    {
        Map<String, String> options = new Map<String, String>();

        for (Schema.PicklistEntry ple : getActivePicklistEntries(so, field))
        {
            options.put(ple.getValue(), ple.getLabel());
        }
        return options;
    }

    public static List<Schema.PicklistEntry> getActivePicklistEntries(String so, String field)
    {
        Map<String, Schema.SOBjectType> gd = Schema.getGlobalDescribe();
        List<Schema.PicklistEntry> ples = new List<Schema.PicklistEntry>();

        // return empty list if object name was not found in the schema
        if (!gd.containsKey(so))
        {
            return ples;
        }

        Schema.DescribeSObjectResult sor = gd.get(so).getDescribe();
        Map<String, Schema.SObjectField> sofs = sor.fields.getMap();

        // return empty list if field name was not found in the object's field list
        if (!sofs.containsKey(field))
        {
            return ples;
        }

        Schema.DescribeFieldResult dfr = sofs.get(field).getDescribe();

        // return empty list if the field type is not picklist
        if (dfr.getType() != Schema.DisplayType.Picklist)
        {
            return ples;
        }

        for (Schema.PicklistEntry ple : dfr.getPicklistValues())
        {
            if (ple.isActive())
            {
                ples.add(ple);
            }
        }
        return ples;
    }

    public static Boolean isEmail(String s)
    {
        if (isBlank(s))
        {
            return false;
        }

        String p = '\\w+([-+.\']\\w+)*@\\w+([-.]\\w+)*\\.\\w+([-.]\\w+)*';
        Pattern pat = Pattern.compile(p);
        Matcher mat = pat.matcher(s);
        return mat.matches();
    }

    public User siteAdmin
    {
        set;
        get
        {
            if (siteAdmin == null)
            {
                siteAdmin = getSiteAdmin();
            }
            return siteAdmin;
        }
    }

    public static User getSiteAdmin()
    {
        List<Site> sites = [
                               select
                               Id
                               , Name
                               , Admin.Id
                               , Admin.FirstName
                               , Admin.LastName
                               , Admin.Name
                               , Admin.Email
                               from Site
                               where
                               Name = :DEFAULT_SITE_NAME
                           ];

        // send the admin back if it's a site, send null back if not a site
        User u = (!sites.isEmpty() && sites[0].Admin != null ? sites[0].Admin : null);
        return u;
    }

    /*
      Retrieved from http://improveit360.blogspot.com/2010/09/implementing-quicksort-to-sort-list-of.html on 22 July 2011
      Author: Jason Hartfield

      This is a simple quicksort algorithm to sort a SelectOption list (dropdown)
      by label alphabetically.
    */
    public static List<SelectOption> sortOptionList(List<SelectOption> listToSort)
    {
        if (listToSort == null || listToSort.size() <= 1)
        {
            return listToSort;
        }

        List<SelectOption> less = new List<SelectOption>();
        List<SelectOption> greater = new List<SelectOption>();
        integer pivot = listToSort.size() / 2;

        // save the pivot and remove it from the list
        SelectOption pivotValue = listToSort[pivot];
        listToSort.remove(pivot);

        for (SelectOption x : listToSort)
        {
            if (x.getLabel() <= pivotValue.getLabel())
            {
                less.add(x);
            }
            else if (x.getLabel() > pivotValue.getLabel())
            {
                greater.add(x);
            }
        }
        List<SelectOption> returnList = new List<SelectOption> ();
        returnList.addAll(sortOptionList(less));
        returnList.add(pivotValue);
        returnList.addAll(sortOptionList(greater));
        return returnList;
    }

    // Called from Feedback Component when the user clicks on either Yes or No button
    public void createDeflection()
    {
        // validate that the feedback source option is a valid option
        String fs = (feedbackSourceOptions.contains(feedbackSource) ? feedbackSource : null);
        createDeferral(true);

        /*PKB_Article_Feedback_Deflection__c afd = new PKB_Article_Feedback_Deflection__c(
            Article_ID__c = theKad.id,
            Article_Number__c = theKad.articleNumber,
            Article_Title__c = theKad.title,
            Feedback_Source__c = fs,
            Session_ID__c = sessionId,
            Deflection__c = (upDowVote == 'up'),
            Keyword_Searched__c = urlSearchQuery
        );
        insert afd;

        // Based on the whether the user selected Up or Down, show the relevant post voting options
        postVoteOptions = new List<postVoteOption>();
        for (Post_Feedback_Options__c postOption : [SELECT Custom_Label__c
                FROM Post_Feedback_Options__c
                WHERE Vote__c = : upDowVote
                                ORDER BY Sort_Order__c])
        {
            postVoteOptions.add(new postVoteOption(postOption.Custom_Label__c, afd.Id));
        }*/
    }

    // Called on click of the checkboxes in the Feedback component
    public void updateDeflection()
    {
        String val = '';
        String DefId = '';

        // Get all the selected options and update the deflection record
        for (postVoteOption opt : postVoteOptions)
        {
            system.debug('------------------- ' + opt);
            if (opt.Selected)
                val += (opt.SaveValue + ';');     // semi colon is the delimiter for multi-select picklist
        }

        if (val != '')
        {
            // Remove the extra semi colon at the end
            val += '.';
            val = val.replace(';.', '');

            // Get the Deflection Id, all the options will have this field populated so by the time the code
            // comes here, there is at least one value in the collection so directly go for [0] index
            DefId = postVoteOptions[0].DeflectionId;

            PKB_Article_Feedback_Deflection__c afd = new PKB_Article_Feedback_Deflection__c(
                                                            Id = DefId,
                                                            Deflection_Reason__c = val);
            update afd;
        }
    }

    // Once a user votes either Up or Down, system needs to show additional options to qualify the selection
    // This inner class is instantiated once the Up/Down response is recorded. See below for the field usage.
    public class postVoteOption
    {
        public String DeflectionId  { get; set; }   // Article Id
        public String CustomLabel   { get; set; }   // Custom Label
        public String SaveValue     { get; set; }   // This is the value that should be saved in the PKB Article Deflection object.
        public Boolean Selected     { get; set; }   // Indicates whether the user selected a certain option

        public postVoteOption(String defId, String lbl, String saveVal)
        {
            this.DeflectionId   = defId;
            this.CustomLabel    = lbl;
            this.SaveValue      = saveVal;
            this.Selected       = false;
        }
    }

    /* ***** ARTICLE PAGINATION ***** */

/**/
    // Page Size
    public Integer PaginationPageSize { get { return articlesPerPage; } }

    // Keeps track of current page & max size of article list
    private Integer PrivatePaginationCurrentPageNumber = 1;
    public Integer PaginationResultCount
    {
        set;
        get
        {
            System.debug('PaginationResultCount::get()');
            if (this.PaginationResultCount == null)
            {
                this.PaginationResultCount = 0;
                List<KnowledgeArticleVersion> articleVersions = null;
                if (viewingCategory)
                {
                    System.debug('PaginationResultCount::get() viewingCategory');
                    articleVersions = searchByCategory(0);
                    this.PaginationResultCount = articleVersions.size();
                }
                else if (viewingSearch)
                {
                    System.debug('PaginationResultCount::get() viewingSearch');
                    articleVersions = this.search(SOSL_MAX_RESULTS);
                    this.PaginationResultCount = (articleVersions != null ? articleVersions.size() : 0) +
                        (recommendedKads != null ? recommendedKads.size() : 0);
                }
                System.debug('PaginationResultCount: ' + this.PaginationResultCount);
                String debugMsg = 'PaginationResultCount results:';
                if (articleVersions != null)
                {
                    for (KnowledgeArticleVersion kav : articleVersions)
                    {
                        debugMsg += '\n===== Id: ' + kav.Id + ', Title: ' + kav.Title;
                    }
                }
                System.debug(debugMsg);
            }
            return this.PaginationResultCount;
        }
    }

    // Returns whether the previous button is enabled
    public boolean getPaginationPreviousEnabled()
    {
        System.debug('getPaginationPreviousEnabled PaginationCurrentPageNumber: ' + this.PaginationCurrentPageNumber);
        return this.PaginationCurrentPageNumber > 1;
    }

    // Returns whether the next button is enabled
    public boolean getPaginationNextEnabled()
    {
        System.debug('getPaginationNextEnabled PaginationCurrentPageNumber: ' + this.PaginationCurrentPageNumber);
        return this.PaginationCurrentPageNumber * articlesPerPage < this.PaginationResultCount;
    }

    // Returns current page number
    public Decimal PaginationCurrentPageNumber
    {
        get
        {
            System.debug('PaginationCurrentPageNumber::get: ' + this.PrivatePaginationCurrentPageNumber);
            return this.PrivatePaginationCurrentPageNumber;
        }
        set
        {
            System.debug('PaginationCurrentPageNumber::set before: ' +
                this.PrivatePaginationCurrentPageNumber + ', after: ' + value);
            this.PrivatePaginationCurrentPageNumber = Integer.valueOf(value);
        }
    }

    // action for next click
    public PageReference PaginationNext()
    {
        System.debug('PaginationNext PaginationCurrentPageNumber (before): ' + this.PaginationCurrentPageNumber);
        if (this.PaginationResultCount > this.PaginationCurrentPageNumber * articlesPerPage)
        {
            this.PaginationCurrentPageNumber = this.PaginationCurrentPageNumber + 1;
        }
        System.debug('PaginationNext PaginationCurrentPageNumber (after): ' + PrivatePaginationCurrentPageNumber);
        return null;
    }

    // action for previous click
    public PageReference PaginationPrevious()
    {
        System.debug('PaginationPrevious PaginationCurrentPageNumber (before): ' + this.PaginationCurrentPageNumber);
        if (this.PaginationCurrentPageNumber > 1)
        {
            this.PaginationCurrentPageNumber = this.PaginationCurrentPageNumber - 1;
        }
        System.debug('PaginationPrevious PaginationCurrentPageNumber (after): ' + PrivatePaginationCurrentPageNumber);
        return null;
    }

    public PageReference PaginationSetPageNumber()
    {
        System.debug('PaginationSetPageNumber PaginationCurrentPageNumber: ' + this.PaginationCurrentPageNumber);
        // do nothing since presumably the page number was passed in an apex:param tag
        return null;
    }

    public List<Decimal> getPaginationPageLinks()
    {
        System.debug('getPaginationPageLinks()\n' +
            'articlesPerPage: ' + articlesPerPage + '\n' +
            'PaginationResultCount: ' + this.PaginationResultCount);
        List<Decimal> pageLinks = new List<Decimal>();

        // set the first page
        Decimal firstPage = 1;

        // determine last page number
        Decimal lastPage = Integer.valueOf((this.PaginationResultCount / articlesPerPage) +
            // determine if the pages come out even, if we need to add a page for remainder
            (Math.mod(this.PaginationResultCount, articlesPerPage) > 0 ? 1 : 0));

        // start at 1 because we increment at the end of the loop
        Decimal pageNumber = Integer.valueOf(firstPage);

        // use a do/while rather than a while so that the first page is always added
        do
        {
            // only add the first, previous, current, next, and last page numbers
            if (pageNumber == firstPage ||
                pageNumber == lastPage ||
                pageNumber == (this.PaginationCurrentPageNumber - 1) ||
                pageNumber == this.PaginationCurrentPageNumber ||
                pageNumber == (this.PaginationCurrentPageNumber + 1) ||
                (this.PaginationCurrentPageNumber == firstPage && pageNumber == (firstPage + 2)) ||
                (this.PaginationCurrentPageNumber == lastPage && pageNumber == (lastPage - 2)))
            {
                pageLinks.add(pageNumber);
            }
            else
            {
                // insert a 0 so I can squash these down later and create a spacer
                pageLinks.add(0);
            }

            // increment the page number
            pageNumber++;
        }
        while (pageNumber <= lastPage);

        // squash the multiple 0 entries into 1
        // So [1, 0, 0, 0, 5, 6, 7, 0, 0, 10] becomes [1, 0, 5, 6, 7, 0, 10]
        Decimal prevVal = null;
        for (Integer i = 0; i < pageLinks.size(); )
        {
            // check if we have duplicate 0 values to squash into one
            if (prevVal == pageLinks.get(i))
            {
                // remove the item
                // NOTE: removing an item from a list will change the length, so do not increment in the 'for' statement
                pageLinks.remove(i);
            }
            else
            {
                // assign the value to the previous value to remove the duplicates
                prevVal = pageLinks.get(i);

                // increment the counter here
                i++;
            }
        }

        System.debug('Page Links: ' + pageLinks);
        return pageLinks;
    }
/**/

    /*** START: Contact Page ***/
    /* create an instance of the contact page that can be referenced from pkbCon */
    public ContactPageController ContactPage
    {
        set;
        get
        {
            System.debug('ContactPage::get() entered.');
            if (this.ContactPage == null)
            {
                this.ContactPage = new ContactPageController(this.selectedLanguage);
            }
            return this.ContactPage;
        }
    }

    private Boolean SuggestedArticlesCreated = false;

    public Boolean getSuggestedArticlesCreated()
    {
        System.debug('getSuggestedArticlesCreated() entered. SuggestedArticlesCreated=' + SuggestedArticlesCreated);
        return this.SuggestedArticlesCreated;
    }

    public void SuggestArticles()
    {
        System.debug('SuggestArticles() Selected Category: ' + this.selectedCategory);
        this.SuggestedArticlesCreated = true;
    }


    public List<KnowledgeArticleData> SuggestedArticles
    {
        private set;
        get
        {
            System.debug('SuggestedArticles::get() entered. Selected Category: ' + this.selectedCategory);

            // check if the suggested articles have been rendered already
            if (this.SuggestedArticles == null)
            {
                System.debug('Generating suggested articles.');

                // get set of article ids for categories
                List<KnowledgeArticleVersion> articleVersions = this.searchByCategory(6, true);

                // build list of knowledge article data using for loop to preserve order
                List<KnowledgeArticleData> articles = new List<KnowledgeArticleData>();
                for (KnowledgeArticleVersion articleVersion : articleVersions)
                {
                    articles.add(new KnowledgeArticleData(articleVersion));
                }

                this.SuggestedArticles = articles;
            }
            System.debug('SuggestedArticles::get() returning: ' + this.SuggestedArticles.size());
            return this.SuggestedArticles;
        }
    }

    public class ContactPageController
    {
        private final String FORM_PARAM              = 'form';
        private final String FORM_CORP_WELLNESS      = 'cw';
        private final String FORM_PR_MEDIA           = 'pr';
        private final String FORM_FEMALE_HEALTH_TRACKING = 'fht';
        private final String FORM_BRAND_PARTNERSHIPS = 'partnerships';
        private final String FORM_BRAND_PARTNERSHIP  = 'partnership';
        private final String FORM_RETAIL_SALES       = 'sales';
        private final String FORM_GENERAL_INQUIRY    = 'general';
        private final String FORM_SUCCESS_STORIES    = 'stories';
        private final String FORM_CUSTOMER_SUPPORT   = 'cs';
        private final String FORM_CUSTOMER_SUPPORT_MOBILE = 'apps';

        public String formParam { get { return FORM_PARAM; } }

        // store the origin value
        public String Origin { get; set; }

        // Create a String variable for the case language
        public String Language { get; set; }

        // Create a Case object
        public Case caseObj { get; set; }

        // Create an Account object
        public Account accountObj { get; set; }

        // Create a Contact object
        public Contact contactObj { get; set; }

        // map of origin params to the picklist value
        private Map<String, String> OriginShortToLong = new Map<String, String>{
            FORM_CORP_WELLNESS      => 'Web - Corporate Wellness Interest',
            FORM_PR_MEDIA           => 'Web - PR / Media',
            FORM_FEMALE_HEALTH_TRACKING => 'Web - Female Health Tracking',
            FORM_BRAND_PARTNERSHIPS => 'Web - Brand Partnerships',
            FORM_BRAND_PARTNERSHIP  => 'Web - Brand Partnerships',
            FORM_RETAIL_SALES       => 'Web - Retail Sales',
            FORM_GENERAL_INQUIRY    => 'Web - General Inquiry',
            FORM_SUCCESS_STORIES    => 'Web - Success Stories',
            FORM_CUSTOMER_SUPPORT   => 'Web - Customer Support',
            FORM_CUSTOMER_SUPPORT_MOBILE  => 'Mobile App'
        };

        // map of language url params to picklist value
        private Map<String, String> LanguageShortToLong = new Map<String, String>{
            'en_US' => 'English',
            'es' => 'Spanish',
            'zh_CN' => 'Chinese (Simplified)',
            'zh_TW' => 'Chinese (Traditional)',
            'ja' => 'Japanese',
            'de' => 'German',
            'fr' => 'French',
            'it' => 'Italian',
            'ko' => 'Korean',            
            'sv' => 'Swedish',
            'nl_NL' => 'Dutch'
            //'pt_BR' => 'Portuguese (Brazilian)', // Commented for SFDC-4061 by Kartik
            //'es_MX' => 'Spanish (Mexican)' // Commented for SFDC-4061 by Kartik
        };

        public String nameErrorMsg { get; set; }

        public String DescriptionLabel { get; set; }

        // variables used to hold hidden input values
        public String SelectedProduct { get { return this.caseObj.Product__c; } set { this.caseObj.Product__c = value; } }
        public String SelectedCountry { get { return this.caseObj.Country__c; } set { this.caseObj.Country__c = value; } }
        public Boolean SelectedCWCase  { get { return this.caseObj.Corporate_Wellness__c; } set { this.caseObj.Corporate_Wellness__c = value; } }
        public String navPath { get { return this.caseObj.navPath__c; } set { this.caseObj.navPath__c = value; } }
        public String caseOriginDetail { get { return this.caseObj.Case_Origin_Detail__c; } set { this.caseObj.Case_Origin_Detail__c = value; } }
        // added for mobile form 8/27/215
        public String mAppAccount { get { return this.caseObj.m_App_Account__c; } set { this.caseObj.m_App_Account__c = value; } }
        public String mAppVersion { get { return this.caseObj.m_App_Version__c; } set { this.caseObj.m_App_Version__c = value; } }
        public String mAppTimezone { get { return this.caseObj.m_App_Timezone__c; } set { this.caseObj.m_App_Timezone__c = value; } }
        public String mMdeviceBTLELibrary { get { return this.caseObj.m_Mdevice_BTLE_Library__c; } set { this.caseObj.m_Mdevice_BTLE_Library__c = value; } }
        public String mMdeviceDisplay { get { return this.caseObj.m_Mdevice_Display__c; } set { this.caseObj.m_Mdevice_Display__c = value; } }
        public String mMdeviceManufacturer { get { return this.caseObj.m_Mdevice_Manufacturer__c; } set { this.caseObj.m_Mdevice_Manufacturer__c = value; } }
        public String mMdeviceModel { get { return this.caseObj.m_Mdevice_Model__c; } set { this.caseObj.m_Mdevice_Model__c = value; } }
        public String mMdeviceProduct { get { return this.caseObj.m_Mdevice_Product__c; } set { this.caseObj.m_Mdevice_Product__c = value; } }
        public String mMdeviceBrand { get { return this.caseObj.m_Mdevice_Brand__c; } set { this.caseObj.m_Mdevice_Brand__c = value; } }
        public String mMdeviceBoard { get { return this.caseObj.m_Mdevice_Board__c; } set { this.caseObj.m_Mdevice_Board__c = value; } }
        public String mMdeviceVersionRelease { get { return this.caseObj.m_Mdevice_VersionRelease__c; } set { this.caseObj.m_Mdevice_VersionRelease__c = value; } }
        public String mMdeviceVersionSDK { get { return this.caseObj.m_Mdevice_VersionSDK__c; } set { this.caseObj.m_Mdevice_VersionSDK__c = value; } }
        public String mMdeviceBTSupported { get { return this.caseObj.m_Mdevice_BTSupported__c; } set { this.caseObj.m_Mdevice_BTSupported__c = value; } }
        public String mMdeviceBTPowerOn { get { return this.caseObj.m_Mdevice_BTPowerOn__c; } set { this.caseObj.m_Mdevice_BTPowerOn__c = value; } }
        public String mTrackerDeviceName { get { return this.caseObj.m_Tracker_DeviceName__c; } set { this.caseObj.m_Tracker_DeviceName__c = value; } }
        public String mTrackerVersionFW { get { return this.caseObj.m_Tracker_VersionFW__c; } set { this.caseObj.m_Tracker_VersionFW__c = value; } }
        public String mTrackerBTBondStatus { get { return this.caseObj.m_Tracker_BTBondStatus__c; } set { this.caseObj.m_Tracker_BTBondStatus__c = value; } }
        public String mTrackerRSSIBT { get { return this.caseObj.m_Tracker_RSSI_BT__c; } set { this.caseObj.m_Tracker_RSSI_BT__c = value; } }
        public String mTrackerRSSIWiFi { get { return this.caseObj.m_Tracker_RSSI_WiFi__c; } set { this.caseObj.m_Tracker_RSSI_WiFi__c = value; } }
        public String mTrackerBatteryVoltage { get { return this.caseObj.m_Tracker_BatteryVoltage__c; } set { this.caseObj.m_Tracker_BatteryVoltage__c = value; } }
        public String mTrackerSerialNumber { get { return this.caseObj.m_Tracker_SerialNumber__c; } set { this.caseObj.m_Tracker_SerialNumber__c = value; } }
        public String mTrackerWireID { get { return this.caseObj.m_Tracker_WireID__c; } set { this.caseObj.m_Tracker_WireID__c = value; } }
        public String mTrackerLastSyncAt { get { return this.caseObj.m_Tracker_LastSyncAt__c; } set { this.caseObj.m_Tracker_LastSyncAt__c = value; } }
        public String mTrackerLiveDataSupport { get { return this.caseObj.m_Tracker_LiveDataSupport__c; } set { this.caseObj.m_Tracker_LiveDataSupport__c = value; } }
        public String mDebugLog { get { return this.caseObj.m_DebugLog__c; } set { this.caseObj.m_DebugLog__c = value; } }
        public String mData { get { return this.caseObj.m_data__c; } set { this.caseObj.m_data__c = value; } }


        public Boolean OptIn { get; set; }
        public Boolean isCorporateWellness { get { return (FORM_CORP_WELLNESS.equalsIgnoreCase(this.Origin)); } }
        public Boolean isPRMedia { get { return (FORM_PR_MEDIA.equalsIgnoreCase(this.Origin)); } }
        public Boolean isFHT { get { return (FORM_FEMALE_HEALTH_TRACKING.equalsIgnoreCase(this.Origin)); } }
        public Boolean isBrandPartnership { get { return (FORM_BRAND_PARTNERSHIPS.equalsIgnoreCase(this.Origin) ||
            FORM_BRAND_PARTNERSHIP.equalsIgnoreCase(this.Origin)); } }
        public Boolean isRetailSales { get { return (FORM_RETAIL_SALES.equalsIgnoreCase(this.Origin)); } }
        public Boolean isGeneralInquiry { get { return (FORM_GENERAL_INQUIRY.equalsIgnoreCase(this.Origin)); } }
        public Boolean isSuccessStories { get { return (FORM_SUCCESS_STORIES.equalsIgnoreCase(this.Origin)); } }
        public Boolean isCustomerSupport { get { return ((isBlank(this.Origin) ||
            FORM_CUSTOMER_SUPPORT.equalsIgnoreCase(this.Origin)) && isBlank(ApexPages.currentPage().getParameters().get(SPECIAL_INQUIRY_PARAM))); } }
        public Boolean isMobileForm { get { return (FORM_CUSTOMER_SUPPORT_MOBILE.equalsIgnoreCase(this.Origin)); } }
        public Boolean isMobileWrapped { get { return (!isBlank(ApexPages.currentPage().getParameters().get(MOBILE_WRAPPED_PARAM))); } }
        public Boolean isSpecialInquiry  { get { return (!isBlank(ApexPages.currentPage().getParameters().get(SPECIAL_INQUIRY_PARAM))); } }

        // Create an Attachment variable for the case attachments
        public Attachment FileAttachment
        {
            get
            {
                if (this.FileAttachment == null)
                {
                    this.FileAttachment = new Attachment();
                }
                return this.FileAttachment;
            }
            set;
        }

        public String getFormLabel()
        {
            String label = null;
            if (Origin == FORM_CORP_WELLNESS)
            {
                label = System.Label.fb_contact_title_cw;
            }
            else if (Origin == FORM_PR_MEDIA)
            {
                label = System.Label.fb_contact_title_pr;
            }
            else if (Origin == FORM_FEMALE_HEALTH_TRACKING)
            {
                label = System.Label.fb_contact_title_fht;
            }
            else if (Origin == FORM_BRAND_PARTNERSHIPS)
            {
                label = System.Label.fb_contact_title_partnerships;
            }
            else if (Origin == FORM_BRAND_PARTNERSHIP)
            {
                label = System.Label.fb_contact_title_partnership;
            }
            else if (Origin == FORM_RETAIL_SALES)
            {
                label = System.Label.fb_contact_title_sales;
            }
            else if (Origin == FORM_GENERAL_INQUIRY)
            {
                label = System.Label.fb_contact_title_general;
            }
            else if (Origin == FORM_SUCCESS_STORIES)
            {
                label = System.Label.fb_contact_title_stories;
            }
            else if (Origin == FORM_CUSTOMER_SUPPORT)
            {
                label = System.Label.fb_contact_title_cs;
            }
            return label;
        }

        /**
         * The default constructor for the class.
         */
        public ContactPageController()
        {
            System.debug('ContactPageController() entered');

            // create new instances of objects
            this.accountObj = new Account();
            this.contactObj = new Contact();
            this.caseObj = new Case();

            // default the OptIn to false
            this.OptIn = false;

            // get the form being requested (origin)
            this.Origin = (ApexPages.currentPage().getParameters().get(FORM_PARAM) != null ?
                ApexPages.currentPage().getParameters().get(FORM_PARAM).toLowerCase() : FORM_CUSTOMER_SUPPORT);
            System.debug('Origin: [' + this.Origin + ']');

            // set the description label based on the origin
            this.DescriptionLabel = (this.isSuccessStories ?
                Label.fb_contact_placeholder_story : Label.fb_contact_placeholder_description);
        }

        public ContactPageController(String Language)
        {
            // call base constructor, must be first statement in constructor block
            this();

            System.debug('ContactPageController(String Language) entered');
            this.Language = Language;
            System.debug('Language: [' + this.Language + ']');
        }

       // A second method to check is a Contact with the specified email exists and create them if not
        public PageReference submitCase()
        {
            System.debug('-- @@ entered in function ');
            nameErrorMsg = '';
            
            if(!String.isBlank(this.caseObj.First_Name__c)){
                System.debug('-- @@ Case has a first name');
                if(!String.isBlank(this.caseObj.Last_Name__c)){                    
                    string name = this.caseObj.First_Name__c + ' ' + this.caseObj.Last_Name__c;
                    this.caseObj.SuppliedName = name;
                }
                else{
                    string name = this.caseObj.First_Name__c + '  ' + '(null)' ;
                    System.debug('-- @@ name string ' + name);
                    this.caseObj.SuppliedName = name;
                }
                System.debug('-- @@ supplied name ' + this.caseObj.SuppliedName);
            }
            if(String.isBlank(this.caseObj.First_Name__c) && String.isBlank(this.caseObj.SuppliedName)){
                System.debug('-- first name is empty');
                nameErrorMsg = 'You must specify at least a first name!';
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,
                    'You must specify at least a first name!'));                
                return null;
            }
             
            
            Boolean insertResult = false;

            // define the list of primary contacts associated to an account
            List<Contact> primaryContacts = null;

            System.debug('Origin: [' + this.Origin + ']');
            System.debug('Language: [' + this.Language + ']');

            // check if this is the corporate wellness form
            if (this.isCorporateWellness)
            {
                // Check if account exists based on Company field value.
                List<Account> existingAccounts = [SELECT Id, Name, Current_Insurance_Provider__c,
                    Number_of_Eligible_employees__c, Tell_us_about_yourself__c, Wellness_Program_in_Place__c,
                    Wellness_Provider_Name__c
                    FROM Account WHERE Name LIKE :this.accountObj.Name];

                System.debug('Existing Account Count [' + existingAccounts.size() + '] for Name: [' + this.accountObj.Name + ']');

                // check if accounts were found by the supplied account name
                if (existingAccounts.size() == 0)
                {
                    // no existing accounts found, create it

                    // do not set Wellness_Provider_Name__c if Wellness_Program_in_Place__c is not checked
                    if (this.accountObj.Wellness_Program_in_Place__c == false)
                    {
                        // clear the wellness provider name picklist
                        this.accountObj.Wellness_Provider_Name__c = null;
                    }

                    // insert the account
                    if (!this.insertObject(this.accountObj))
                    {
                        // insert failed, return null page reference
                        return null;
                    }
                }
                else
                {
                    // Mapping form values to the existing account fields. This is to fix an issue where an existing account
                    // with blank fields doesn't get updated. Any previous values in fields will be overwritten.
                    existingAccounts[0].Current_Insurance_Provider__c = this.accountObj.Current_Insurance_Provider__c;
                    existingAccounts[0].Number_of_Eligible_employees__c = this.accountObj.Number_of_Eligible_employees__c;
                    existingAccounts[0].Tell_us_about_yourself__c = this.accountObj.Tell_us_about_yourself__c;
                    existingAccounts[0].Wellness_Program_in_Place__c = this.accountObj.Wellness_Program_in_Place__c;
                    existingAccounts[0].Wellness_Provider_Name__c = this.accountObj.Wellness_Provider_Name__c;

                    // assign the first account to the accountObj
                    this.accountObj = existingAccounts.get(0);

                    // update the account object, Edit 9.12.2014, Alan + Karina
                    this.updateObject(this.accountObj);

                    // If account doesn’t have a primary contact, mark the new contact as the account’s primary contact.
                    primaryContacts = [SELECT Id FROM Contact
                        WHERE AccountId = :this.accountObj.Id AND IsPrimary__c = true];

                    System.debug('Primary Contacts: ' + primaryContacts.size());
                }
                System.debug('Account Id: ' + this.accountObj.Id);
            }

            String[] nameParts = null;
            system.debug('Form Case Data: ' + this.caseObj);
            // Just some simple string manipulation to take FirstName <Space> LastName and cut into 2 Strings for First and Last Name fields
            if(String.isBlank(this.caseObj.First_Name__c) && String.isBlank(this.caseObj.Last_Name__c) && !String.isBlank(this.caseObj.SuppliedName)){
                nameParts = this.caseObj.SuppliedName.trim().split(' ', 2);
                System.debug('Supplied Name: ' + this.caseObj.SuppliedName);
                if (nameParts.size() < 1 || nameparts[0].trim().length() == 0){             
                    nameErrorMsg = 'You must specify at least a first name!';
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,
                        'You must specify at least a first name!'));
                    return null;
                }
                System.debug('-- @@ name parts ' + nameParts);
            }
                        
            // Get a list of existing Contacts with the specified email ( ideally there should only be one Contact per email )
            List<Contact> existingContacts = [SELECT Id, LastName, FirstName, Name, Email, Phone FROM Contact
                WHERE Email = :this.contactObj.Email];
            System.debug('Existing Contact Count [' + existingContacts.size() + '] for Email: [' + this.contactObj.Email + ']');
            System.debug('Country: ' + this.caseObj.Country__c);

            // If the list size is not 1 ( assuming emails are unique there can only be a 1 or 0 result from the above query )
            if (existingContacts.size() == 0)
            {
                // Create a new Contact with FirstName, LastName, and Email
                if(String.isBlank(this.caseObj.First_Name__c) && String.isBlank(this.caseObj.Last_Name__c) && nameParts != null){
                    this.contactObj.FirstName = nameParts[0].trim();
                    this.contactObj.LastName = (nameParts.size() > 1 ? nameParts[1].trim() : '(null)');
                }
                else{
                    if(!String.isBlank(this.caseObj.First_Name__c)){
                        this.contactObj.FirstName = this.caseObj.First_Name__c;
                        System.debug('-- @@ entered in block 1');
                    }                                 
                    if(!String.isBlank(this.caseObj.Last_Name__c) && !String.isBlank(this.caseObj.First_Name__c)){
                        this.contactObj.LastName = this.caseObj.Last_Name__c;
                        System.debug('-- @@ entered in block 2');
                    }
                    if(String.isBlank(this.caseObj.Last_Name__c)){
                        System.debug('-- @@ entered in block 3');
                        this.contactObj.LastName = ' (null) ';
                        
                    }  
                }
                System.debug('-- @@ First name in contact ' + this.contactObj.FirstName);
                System.debug('-- @@ Last name in contact ' + this.contactObj.LastName);
                                
                
                
                this.contactObj.MailingCountry = this.caseObj.Country__c;

                // strip non-numeric characters
                if (this.contactObj.Phone != null && this.contactObj.Phone != '' ){
                    this.contactObj.Phone = this.contactObj.Phone.replaceAll('[^\\d]', '');
                }
 
                // check if there is an account to associate the contact to
                if (this.accountObj.Id != null)
                {
                    // associate contact with the account
                    this.contactObj.AccountId = this.accountObj.Id;

                    // If account doesn’t have a primary contact, mark the new contact as the account’s primary contact.
                    this.contactObj.IsPrimary__c = (primaryContacts == null || primaryContacts.size() == 0);
                }

                // Insert the contact
                if (!this.insertObject(this.contactObj))
                {
                    // insert failed, return null page reference
                    return null;
                }
            }
            else
            {
                //save the phone just in case, and strip non-numeric characters
                String phone = null;
                string fitbitEmail = '';
                if (this.contactObj.Phone != null && this.contactObj.Phone != '') {
                    phone = this.contactObj.Phone.replaceAll('[^\\d]', '');
                }
                //update the fitbit email in the existing contact
                if(this.contactObj.FitbitEmail__c != null && this.contactObj.FitbitEmail__c != ''){
                    fitbitEmail = this.contactObj.FitbitEmail__c;
                } 

                // assign the first contact to the contactObj
                this.contactObj = existingContacts.get(0);

                // check if there is an account to associate the contact to
                if (this.accountObj.Id != null)
                {
                    // associate contact with the account
                    this.contactObj.AccountId = this.accountObj.Id;

                    // If account doesn’t have a primary contact, mark the new contact as the account’s primary contact.
                    this.contactObj.IsPrimary__c = (primaryContacts == null || primaryContacts.size() == 0);
                }

                // Update the contact and set phone
                if (phone != null & phone != '' ) {
                    this.contactObj.Phone = phone;
                }
                //update the fitbit email in the existing contact
                if (fitbitEmail != null & fitbitEmail != '' ) {
                    this.contactObj.FitbitEmail__c = fitbitEmail;
                }

                // Update the contact
                if (!this.updateObject(this.contactObj))
                {
                    // update failed, return null page reference
                    return null;
                }
            }

            // associate the contact to the case
            this.caseObj.ContactId = this.contactObj.Id;

            // assign the selected product
            this.caseObj.Product__c = this.SelectedProduct;
            
            // populate case web email field from contact email
            this.caseObj.SuppliedEmail = this.contactObj.Email;
            
            //populate case with first name and lastname            
            if(String.isBlank(this.caseObj.First_Name__c) && String.isBlank(this.caseObj.Last_Name__c) && nameParts != null){
                this.caseObj.First_Name__c = nameParts[0].trim();
                this.caseObj.Last_Name__c = (nameParts.size() > 1 ? nameParts[1].trim() : '(null)');
            } 
           
            if(String.isBlank(this.caseObj.Last_Name__c) && nameParts == null){
                this.caseObj.Last_Name__c = '(null)';
            }

            System.debug('Selected Product: ' + this.SelectedProduct);

            if (this.isCorporateWellness)
            {
                // Generate Corporate Wellness subject
                this.caseObj.Subject = Label.fb_contact_subject_cw + ' ' +
                    (this.accountObj.Name != null ? ' ' + this.accountObj.Name : 'Unknown') +
                    (this.accountObj.Number_of_Eligible_employees__c != null ? ' (' + this.accountObj.Number_of_Eligible_employees__c + ')' : '');

                // Store all CW form responses in custom field, to be output on CW cases
                this.caseObj.CW_Form_Responses__c = '<strong>' + Account.Name.getDescribe().getLabel() + '</strong>: ' + this.accountObj.Name + '<br/>' +
                '<strong>' + Account.Current_Insurance_Provider__c.getDescribe().getLabel() + '</strong>: ' + this.accountObj.Current_Insurance_Provider__c + '<br/>' +
                '<strong>' + Account.Number_of_Eligible_employees__c.getDescribe().getLabel() + '</strong>: ' + this.accountObj.Number_of_Eligible_employees__c + '<br/>' +
                '<strong>' + Account.Tell_us_about_yourself__c.getDescribe().getLabel() + '</strong>: ' + this.accountObj.Tell_us_about_yourself__c + '<br/>' +
                '<strong>' + Account.Wellness_Program_in_Place__c.getDescribe().getLabel() + '</strong>: ' + this.accountObj.Wellness_Program_in_Place__c + '<br/>' +
                '<strong>' + Account.Wellness_Provider_Name__c.getDescribe().getLabel() + '</strong>: ' + this.accountObj.Wellness_Provider_Name__c;

            }
            else if (this.isPRMedia || this.isBrandPartnership || this.isRetailSales || this.isGeneralInquiry || this.isSuccessStories)
            {
                // Generate General subject
                this.caseObj.Subject = Label.fb_contact_subject_general;

            }
            else
            {
                // Generate Customer Support subject
                this.caseObj.Subject = (this.caseObj.Product__c != null ? this.caseObj.Product__c : '') +
                    // Add customer-facing issue to subject
                    (this.caseObj.External_Issue_Level_1__c != null ? ' - ' + this.caseObj.External_Issue_Level_1__c : '') +
                    // If issue level 1 exists, add it to subject too (this should only happen for special cases like the Security form)
                    // BUT only if external issue is null
                    ((this.caseObj.Issue_level_1__c != null && this.caseObj.External_Issue_Level_1__c == null) ? ' - ' + this.caseObj.Issue_level_1__c : '') +
                    (this.caseObj.Issue_level_2__c != null ? ' - ' + this.caseObj.Issue_level_2__c : '') +
                    (this.caseObj.Platform__c != null ? ' - ' + this.caseObj.Platform__c : '');
                // overwrite subject for special inquiries
                if(this.isSpecialInquiry){
                    this.caseObj.Subject = System.Label.fb_contact_title_cs;
                }
                
                System.debug('Product: ' + this.caseObj.Product__c);
                System.debug('External issue: ' + this.caseObj.External_Issue_Level_1__c);
                System.debug('Issue Level 1: ' + this.caseObj.Issue_level_1__c);
                System.debug('Issue Level 2: ' + this.caseObj.Issue_level_2__c);
                System.debug('Platform: ' + this.caseObj.Platform__c);
                System.debug('Subject: ' + this.caseObj.Subject);
            }

            // check the map to see if it contains a mapping for the origin short-code (url param) to the picklist value
            // and return the mapped value, otherwise use the default 'customer support' value
            this.caseObj.Origin = (this.OriginShortToLong.containsKey(this.Origin) ?
                this.OriginShortToLong.get(this.Origin) : // use the picklist value found in map
                this.OriginShortToLong.get(FORM_CUSTOMER_SUPPORT)); // default value
            System.debug('Case Origin: ' + this.caseObj.Origin);

            // set case language using a map, similar to Origin above
            this.caseObj.Language__c = (this.LanguageShortToLong.containsKey(this.Language) ?
                this.LanguageShortToLong.get(this.Language) : // use the picklist value found in map
                this.LanguageShortToLong.get('en_US')); // default value
            System.debug('Case Language: ' + this.caseObj.Language__c);

            // Specify DML options to ensure the assignment/routing rules are executed
            if(!this.isSuccessStories){ // Check added to exclude the Success Stories cases to run Auto Assignment rules SFDC-3180 by Kartik
                Database.DMLOptions dmlOpts = new Database.DMLOptions();
                dmlOpts.AssignmentRuleHeader.useDefaultRule = true;
                dmlOpts.EmailHeader.triggerAutoResponseEmail = true;
                this.caseObj.setOptions(dmlOpts);
            }

            // Assign default value to Product, Platform, and Issue level 1 if no value. This to avoid potential 401 errors.
            if(this.caseObj.Product__c == null || this.caseObj.Product__c == '')
            {
              this.caseObj.Product__c = 'Not sure';
            }

            if(this.caseObj.Platform__c == null || this.caseObj.Platform__c == '')
            {
              this.caseObj.Platform__c = 'Not Applicable';
            }

            if(this.caseObj.Subject.contains('Female Health Tracking') && this.caseObj.Subject.contains('Not Applicable'))
            {
              this.caseObj.Subject = 'Female Health Tracking ';
            }

            if(this.caseObj.Issue_level_1__c == null)
            {
              this.caseObj.Issue_level_1__c = '';
            }

            // Set external issue to Other if value is null
            if(this.caseObj.External_Issue_Level_1__c == null)
            {
              this.caseObj.External_Issue_Level_1__c = '';
            }

            System.debug('Case Product ' + this.caseObj.Product__c);
            System.debug('Case Platform ' + this.caseObj.Platform__c);
            System.debug('Case Issue 1 ' + this.caseObj.Issue_level_1__c);
            System.debug('External issue ' + this.caseObj.External_Issue_Level_1__c);
            
            //Addition done By Neha
            String reviewParam  = System.Label.chat_Review_Id_param_Label;
            if(ApexPages.currentPage().getParameters() != null && ApexPages.currentPage().getParameters().get(reviewParam) != null){
                string reviewParamVal = ApexPages.currentPage().getParameters().get(reviewParam);
                this.caseObj.Review_ID__c = reviewParamVal;
            }
            //Addition done by Neha ends


            // Insert the case
            if (!this.insertObject(this.caseObj))
            {
                // insert failed, return null page reference
                return null;
            }

            // send description as an email so it shows in the feed
            EmailMessage msg = new EmailMessage(
                FromAddress = this.caseObj.SuppliedEmail,
                FromName = this.caseObj.SuppliedName,
                ToAddress = this.caseObj.Origin,
                Subject = this.caseObj.Subject,
                TextBody = this.caseObj.Description,
                ParentId = this.caseObj.Id,
                Incoming = true,
                Status = '0' // New (https://developer.salesforce.com/forums?id=906F00000008um5IAA)
            );
            System.debug('Email Message: ' + msg);

            // Insert the email message
            if (!this.insertObject(msg))
            {
                // insert failed, return null page reference
                return null;
            }


            // upload the attachment
            uploadAttachment();

            // check if the user has opt'd in
            if (this.OptIn == true)
            {
                // build the special redirect URL and redirect the user there, URL encode the email, name, and form origin
                String OptInUrl =  'http://fitbit.createsend.com/t/r/s/pklhyu/?cm-pklhyu-pklhyu=' +
                    EncodingUtil.urlEncode(this.contactObj.Email, 'UTF-8') + '&cm-name=' +
                    EncodingUtil.urlEncode(this.contactObj.Name, 'UTF-8') +
                    '&cm-f-jkjimi=' + this.Origin;
                System.debug('Opt-In URL: ' + OptInUrl);
                return new PageReference(OptInUrl);
            }

            // conditionally add parameter to thank you page URL
            String mobileParamVar = '';
            if (isMobileWrapped){
                    mobileParamVar = '&' + MOBILE_WRAPPED_PARAM + '=1';
            }
            // Return to the "Thanks" page
            return new PageReference('/?t=1&form=' + this.Origin + mobileParamVar);
        }

        private Boolean insertObject(Sobject obj)
        {
            try
            {
                Database.SaveResult saveResult = Database.insert(obj, true);
                this.processSaveResult(saveResult);
            }
            catch (Exception e)
            {
                ////ApexPages.addMessages(e);
                //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Message: ' + e.getMessage()));
                //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Cause: ' + e.getCause()));
                //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Line Number: ' + e.getLineNumber()));
                //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Type Name: ' + e.getTypeName()));
                //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Stack Trace: ' + e.getStackTraceString()));
                throw e;
                return false;
            }
            return true;
        }

        private Boolean updateObject(Sobject obj)
        {
            try
            {
                Database.SaveResult saveResult = Database.update(obj, true);
                this.processSaveResult(saveResult);
            }
            catch (Exception e)
            {
                ////ApexPages.addMessages(e);
                //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Message: ' + e.getMessage()));
                //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Cause: ' + e.getCause()));
                //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Line Number: ' + e.getLineNumber()));
                //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Type Name: ' + e.getTypeName()));
                //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Stack Trace: ' + e.getStackTraceString()));
                throw e;
                return false;
            }
            return true;
        }

        private void processSaveResult(Database.SaveResult saveResult)
        {
            // check if the insert succeeded
            if (!saveResult.isSuccess())
            {
                // print the errors
                for (Database.Error err : saveResult.getErrors())
                {
                    // print the error to the page
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, err.getMessage() +
                        ' (' + err.getStatusCode() + ') Fields: [' + err.getFields() + ']'));
                }
            }
        }

        /**
         * Method used to upload file attachments
         */
        private void uploadAttachment()
        {
            // check if there is an attachment to upload
            if (this.FileAttachment.Body == null)
            {
                return;
            }

            // set the owner to the current user
            //attachment.OwnerId = UserInfo.getUserId();

            // the record the file is attached to
            this.FileAttachment.ParentId = this.caseObj.Id;

            // flag which indicates if the attachment is private
            this.FileAttachment.IsPrivate = false;

            System.debug('Creating attachment [' + this.FileAttachment.Name + '] associated to Case Id: [' + this.caseObj.Id + ']');

            // insert the attachment
            if (!this.insertObject(this.FileAttachment))
            {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Error uploading attachment'));
            }

            // new the attachment object
            this.FileAttachment = new Attachment();
        }
    }
    /*** END: Contact Page ***/

}