import { LightningElement } from 'lwc';
import { subscribe, unsubscribe, onError } from 'lightning/empApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class AccountChangesDetector extends LightningElement {
  channelName = '/event/Account_Change__e';

  subscription = {};

  connectedCallback() {    
      const messageCallback = (response) => {
      const message = response['data']['payload']['Message__c'];

      console.log(message);

      this.showToast('Account changes', message);
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