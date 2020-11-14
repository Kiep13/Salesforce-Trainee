import { LightningElement, api } from 'lwc';
import { subscribe, unsubscribe, onError } from 'lightning/empApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

import MESSAGE_FIELD from '@salesforce/schema/Account_Change__e.Message__c';
import ID_FIELD from '@salesforce/schema/Account_Change__e.Id__c';

export default class AccountChangesDetector extends LightningElement {

  @api recordId;

  channelName = '/event/Account_Change__e';

  subscription = {};

  connectedCallback() {    
    const messageCallback = (response) => {
      if(this.recordId == response.data.payload[ID_FIELD.fieldApiName]) {
        const message = response.data.payload[MESSAGE_FIELD.fieldApiName];
        this.showToast('Account changes', message);
      }
    };

    subscribe(this.channelName, -1, messageCallback).then(response => {
      this.subscription = response;
    });
      
    this.registerErrorListener();      
  }

  registerErrorListener() {
    onError(error => {
      console.log('Received error from server: ', JSON.stringify(error));
    });
  }

  showToast(title, message) {
    console.log(title);

    const event = new ShowToastEvent({
      title, message
    });
    this.dispatchEvent(event);
  }

  disconnectedCallback() {
    unsubscribe(this.subscription, response => {
      console.log('unsubscribe() response: ', JSON.stringify(response));
    });
  }
}