public with sharing class HolidaysIntegrationCalls {
    @AuraEnabled(cacheable=true)
    public static List<HolidayWrapper> holidaysEndpoint(String yearupdate, String countryupdate){
        
        List<HolidayWrapper> holidays= new List<HolidayWrapper>();

        try {
            Http http = new Http();
            HolidayApiKey__c hak = HolidayApiKey__c.getOrgDefaults();
            String apiKey = hak.apikey__c;
            String country = countryupdate;//'ca';
            String year = yearupdate;
            String baseUrl = 'https://calendarific.com/api/v2';
            HttpRequest request = new HttpRequest();
            request.setEndpoint(baseUrl+'/holidays?api_key='+apiKey+'&country='+country+'&year='+year);
            request.setMethod('GET');
            HttpResponse response = http.send(request);
            if(response.getStatusCode() == 200){
                System.debug('Response OK');
                Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
                Map<String, Object> res = (Map<String, Object>) results.get('response');
                List<Object> holidayList = (List<Object>) res.get('holidays');
                Integer i = 0;
                for(Object obj : holidayList){
                    Map<String, Object> holidayAtt = (Map<String, Object>)obj;
                    Map<String, Object> dateAtt = (Map<String, Object>)holidayAtt.get('date');
                    String dateStr = (String)dateAtt.get('iso');
                    HolidayWrapper hw = new HolidayWrapper();
                    hw.holidayId = i++ +'';
                    hw.holidayName = (String)holidayAtt.get('name');
                    hw.holidayDate = (String)dateStr.substring(0, 10);
                    hw.holidayDescription = (String)holidayAtt.get('description');
                    holidays.add(hw);
                }
            }else{
                System.debug('Response Not OK');
            }
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
        return holidays;
    }


    @AuraEnabled
    public static void saveEvent(String title,String holidayDate,String holidayDescription){
        String data = holidayDate+'T03:00:01.711-02:00';
        Datetime dt = (DateTime)JSON.deserialize('"' + data + '"', DateTime.class);
        List<Event> evList = new List<Event>();
        Event ev = new Event();
        ev.Subject = title;
        ev.StartDateTime = dt;
        ev.EndDateTime = dt;
        ev.Description = holidayDescription;
        evList.add(ev);
        insert evList;
    }

}
//Event - object name
//Subject - will contain title
//StartDateTime - will contain start date - date in this case
//EndDateTime - will contain end date - date in this case
//Description - event date description