import { LightningElement, wire } from 'lwc';
import holidaysEndpoint from '@salesforce/apex/HolidaysIntegrationCalls.holidaysEndpoint';
export default class HolidaysUi extends LightningElement {
    result;
    error;
    yearvalue='2022';
    countryvalue = 'ca';
    countrylabel = 'Canada';
    heading = 'Public Holidays in '+ this.countrylabel +' - '+this.yearvalue;
    total;
    get yearoptions() {
        return [
            { label: '2021', value: '2021' },
            { label: '2022', value: '2022' },
            { label: '2023', value: '2023' },
        ];
    }
    get countryoptions(){
        return [
            { label: 'Canada', value: 'ca' },
            { label: 'United States', value: 'us' },
            { label: 'United Kingdom', value: 'gb' },
            { label: 'India', value: 'in' }
        ];
    }
    @wire(holidaysEndpoint,{ yearupdate: '$yearvalue',countryupdate:'$countryvalue'})
    wiredHolidays({ error, data }) {
        if (data) {
            this.result = data;
            this.total = data.length;
            this.error = undefined;
        } else if (error) {
            this.error = error;
            this.result = undefined;
        }
    }

    handleYearChange(event) {
        this.yearvalue = event.detail.value;
        this.heading = 'Public Holidays in '+ this.countrylabel +' - '+this.yearvalue;
    }
    handleCountryChange(event) {
        this.countrylabel = event.target.options.find(opt => opt.value === event.detail.value).label;
        this.countryvalue = event.detail.value;
        this.heading = 'Public Holidays in '+ this.countrylabel +' - '+this.yearvalue;
    }
}