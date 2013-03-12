package com.quarterspiral.sdk
{
	import flash.utils.Dictionary;
	
	public class DomSdk implements Sdk
	{
		private var sdkDriver:DomSdkDriver;
		private var setPlayerDataQueue:Array = [];
		private var playerInformationHandlerRegistered:Boolean = false;
		private var playerDataHandlerRegistered:Boolean = false;
		private var playerInformationReadyCallbacks:Array = [];
		private var playerDataReadyCallbacks:Array = [];
		
		public function DomSdk(driver:DomSdkDriver)
		{
			this.sdkDriver = driver;
			
			this.sdkDriver.initializationState.addEventListener(StateChangeEvent.STATE_CHANGE, function(event:StateChangeEvent):void {
				if (event.newState === RetrievalState.READY) {
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
			if (sdkDriver.playerDataRetrievalState !== null) {
				if (sdkDriver.playerDataRetrievalState.state === RetrievalState.READY) {
					return sdkDriver.playerData;
				}
			} else {
				sdkDriver.retrievePlayerData();
				retrievePlayerData();
			}
			return null;
		}
		
		public function onPlayerDataReady(callback:Function):void
		{
			if (playerData) {
				callback.call(this, playerData)
			} else {
				playerDataReadyCallbacks.push(callback);
			}
		}
		
		public function onPlayerInformationReady(callback:Function):void
		{
			if (playerInformation) {
				callback.call(this, playerInformation)
			} else {
				playerInformationReadyCallbacks.push(callback);
			}
		}
		
		public function get playerDataReady():Boolean
		{
			return ready && sdkDriver.playerDataRetrievalState !== null && sdkDriver.playerDataRetrievalState.state === RetrievalState.READY;
		}
		
		public function get playerInformation():PlayerInformation
		{
			if (sdkDriver.playerInformationRetrievalState !== null) {
				if (sdkDriver.playerInformationRetrievalState.state === RetrievalState.READY) {
					return sdkDriver.playerInformation;
				}
			} else {
				retrievePlayerInformation();
			}
			return null;
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
		
		private function retrievePlayerInformation():void {
			sdkDriver.retrievePlayerInformation();
			if (!playerInformationHandlerRegistered) {
				sdkDriver.playerInformationRetrievalState.addEventListener(StateChangeEvent.STATE_CHANGE, function(event:StateChangeEvent):void {
					if (event.newState === RetrievalState.READY) {
						while (playerInformationReadyCallbacks.length > 0) {
							var callback:Function = playerInformationReadyCallbacks.pop();
							callback.call(this, sdkDriver.playerInformation);
						}
					}
				});
				playerInformationHandlerRegistered = true;
			}
		}
		
		private function retrievePlayerData():void {
			sdkDriver.retrievePlayerData();
			if (!playerDataHandlerRegistered) {
				sdkDriver.playerDataRetrievalState.addEventListener(StateChangeEvent.STATE_CHANGE, function(event:StateChangeEvent):void {
					if (event.newState === RetrievalState.READY) {
						while (playerDataReadyCallbacks.length > 0) {
							var callback:Function = playerDataReadyCallbacks.pop();
							callback.call(this, sdkDriver.playerData);
						}
					}
				});
				playerDataHandlerRegistered = true;
			}
		}
	}
}