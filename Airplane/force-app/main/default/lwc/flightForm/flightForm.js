import { LightningElement, api, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import saveFlight from '@salesforce/apex/FlightController.saveFlight';
import { NavigationMixin } from 'lightning/navigation';

export default class FlightForm extends NavigationMixin(LightningElement) {
  
  @api flightRecord;
  isSucess = false;  
  clickedButtonLabel;

  setRedirect(){    
  this[NavigationMixin.Navigate]({
    type: 'standard__recordPage',
    attributes: {
        recordId: this.flightRecord.Id,
        objectApiName: 'Flight__c', 
        actionName: 'view'
    }    
});
  }
  handleSubmit(event) {
    event.preventDefault();
    const fields = event.detail.fields;
    saveFlight({ flight: fields })
      .then(result => {
        this.flightRecord = result;
        this.flightRecord.Distance__c = parseFloat(this.flightRecord.Distance__c).toFixed(2);
        if(this.flightRecord != null){
          this.isSucess = true;
        }
        this.dispatchEvent(
          new ShowToastEvent({
            title: 'Success',
            message: 'Voo salvo com sucesso.',
            variant: 'success',
          }),
        );
      })
      .catch(error => {
        this.dispatchEvent(
          new ShowToastEvent({
            title: 'Erro',
            message: error.body.message,
            variant: 'error',
          }),
        );
      });
  }  
  handleClick(event) {
      this.isSucess = false;
  }
}
