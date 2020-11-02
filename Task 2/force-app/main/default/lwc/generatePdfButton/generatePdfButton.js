import { LightningElement, api, track } from 'lwc';
import GENERATE_PDF_FIELD from '@salesforce/schema/Account.Generate_PDF__c';
import ID_FIELD from '@salesforce/schema/Account.Id';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { updateRecord } from 'lightning/uiRecordApi';

export default class GeneratePdfButton extends LightningElement {

  SUCSESS_MESSAGE = 'PDF generated!';

  ERROR_TITLE = 'Error generating PDF!';
  ERROR_VARIANT = 'error';

  @api recordId;
  @track processing; 
  @track resultMessage;

  connectedCallback() {
    this.resultMessage = 'Processing your request...';
    this.processing = true;
    this.generatePdf();
  }

  generatePdf() {
    const fields = {};
    fields[ID_FIELD.fieldApiName] = this.recordId;
    fields[GENERATE_PDF_FIELD.fieldApiName] = true;

    const recordInput = { fields };

    updateRecord(recordInput)
                .then(() => {
                  this.resultMessage = this.SUCSESS_MESSAGE;
                  this.processing = false;
                })
                .catch(error => {
                  this.resultMessage = error.body.message;
                  this.processing = false;
                });
  }
}