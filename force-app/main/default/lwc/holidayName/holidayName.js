import { LightningElement,api } from 'lwc';
import saveEvent from '@salesforce/apex/HolidaysIntegrationCalls.saveEvent';


export default class HolidayName extends LightningElement {
    @api title;
    @api holidaydate;
    @api holidaydescription;

    handleClick(event){
        saveEvent({title:this.title,holidayDate:this.holidaydate,holidayDescription:this.holidaydescription})
        .then(result=>{
            console.log('Results value: '+result);
            alert('Date Saved to your calendar: '+this.holidaydate);
        }).catch(error=>{
            console.log('Error: '+error);
        })
    }
}

//Event - object name
//Subject - will contain title
//StartDateTime - will contain start date - date in this case
//EndDateTime - will contain end date - date in this case
//Description - event date description