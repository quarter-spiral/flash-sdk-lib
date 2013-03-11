package com.quarterspiral.sdk
{
	import flash.utils.Dictionary;
	
	import mx.events.PropertyChangeEvent;

	public class DomSdk implements Sdk
	{
		private var sdkDriver:DomSdkDriver;
		private var setPlayerDataQueue:Array = [];
		
		public function DomSdk(driver:DomSdkDriver)
		{
			this.sdkDriver = driver;
			
			this.sdkDriver.initializationState.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE, function(event:PropertyChangeEvent):void {
				if (event.property === 'state' && event.newValue === RetrievalState.READY) {
					runSetPlayerDataQueue();
				}
			});
		}
		
		public function get ready():Boolean {
			return driver.initializationState !== null && driver.initializationState.state === RetrievalState.READY;
		}
		
		public function get driver():DomSdkDriver {
			return this.sdkDriver;
		}
		
		public function get playerData():Dictionary
		{
			if (!ready || !playerDataReady) {
				return null
			}
			return sdkDriver.playerData;
		}
		
		public function get playerDataReady():Boolean
		{
			return ready && sdkDriver.playerDataRetrievalState !== null && sdkDriver.playerDataRetrievalState.state === RetrievalState.READY;
		}
		
		public function get playerInformation():PlayerInformation
		{
			if (!ready || !playerInformationReady) {
				return null;
			}
			return sdkDriver.playerInformation;
		}
		
		public function get playerInformationReady():Boolean
		{
			return ready && sdkDriver.playerInformationRetrievalState !== null && sdkDriver.playerInformationRetrievalState.state === RetrievalState.READY; 
		}
		
		public function setPlayerData(attribute:Object, value:Object = null):SetPlayerDataResponse
		{
			var response:SetPlayerDataResponse = addToSetPlayerDataQueue(attribute, value);
			runSetPlayerDataQueue();
			return response;	
		}
		
		private function addToSetPlayerDataQueue(attribute:Object, value:Object = null):SetPlayerDataResponse
		{ 
			var request:SetPlayerDataRequest = new SetPlayerDataRequest(attribute, value);
			setPlayerDataQueue.push(request);
			return request.response;
		}
		
		private function runSetPlayerDataQueue():void
		{
			if (!ready || setPlayerDataQueue.length < 1) {
				return;
			}
			
			var request:SetPlayerDataRequest = setPlayerDataQueue.pop();
			
			var realResponse:SetPlayerDataResponse;
			if (typeof request.attribute === 'string' && request.value !== null) {
				 realResponse = sdkDriver.setPlayerDataKeyValuePair(String(request.attribute), request.value);
			} else {
				realResponse = sdkDriver.setPlayerData(Dictionary(request.attribute));
			}
			request.bindToRealResponse(realResponse);
			
			runSetPlayerDataQueue();
		}
	}
}