package com.quarterspiral.sdk
{
	import flash.external.ExternalInterface;
	import flash.system.Security;
	import flash.utils.Dictionary;

	public class BrowserDomSdkDriver implements DomSdkDriver
	{
		private var rawInitializationState:RetrievalState;
		private var rawPlayerData:Dictionary;
		private var rawPlayerDataRetrievalState:RetrievalState;
		private var readyHandler:Array =  [];
		private var rawPlayerInformation:PlayerInformation;
		private var rawPlayerInformationRetrievalState:RetrievalState;
		private var rawLastPlayerDataSetResponse:SetPlayerDataResponse;
		
		public function BrowserDomSdkDriver(canvasUrl:String)
		{
			flash.system.Security.allowInsecureDomain(canvasUrl)
			flash.system.Security.allowDomain(canvasUrl)
				
			rawInitializationState = new RetrievalState();
			
			if (!ExternalInterface.available) {
				trace("External Interface not available. QS SDK will not work!");
				rawInitializationState.updateTo(RetrievalState.LOADING);
				rawInitializationState.updateTo(RetrievalState.ERROR);
				return;
			}
			
			var initializationState:RetrievalState = rawInitializationState;
			var qsSetupCallback:Function = function(qs:Object):void {
				initializationState.updateTo(RetrievalState.READY);
				addPlayerDataHandlers();
				runReadyHandlers();
			}
			ExternalInterface.addCallback('qsSetupCallback', qsSetupCallback);
			var qsSetupErrorCallback:Function = function(message:String):void {
				initializationState.updateTo(RetrievalState.ERROR);
			}
			ExternalInterface.addCallback('qsSetupErrorCallback', qsSetupErrorCallback);
			ExternalInterface.call('QS.setup')
			initializationState.updateTo(RetrievalState.LOADING);
		}
		
		public function get initializationState():RetrievalState
		{
			return rawInitializationState;
		}
		
		public function get playerData():Dictionary
		{
			return rawPlayerData;
		}
		
		public function get playerDataRetrievalState():RetrievalState
		{
			return rawPlayerDataRetrievalState;
		}
		
		public function get playerInformation():PlayerInformation
		{
			return rawPlayerInformation;
		}
		
		public function get playerInformationRetrievalState():RetrievalState
		{
			return rawPlayerInformationRetrievalState;
		}
		
		public function setPlayerData(data:Dictionary):SetPlayerDataResponse
		{
			rawLastPlayerDataSetResponse = new SetPlayerDataResponse();
			ExternalInterface.call('QS.flash.setPlayerData', data)
			return rawLastPlayerDataSetResponse;
		}
		
		public function setPlayerDataKeyValuePair(key:String, value:Object):SetPlayerDataResponse
		{
			rawLastPlayerDataSetResponse = new SetPlayerDataResponse();
			ExternalInterface.call('QS.flash.setPlayerData', key, value);
			return rawLastPlayerDataSetResponse;
		}
		
		public function retrievePlayerInformation():void
		{
			if (playerInformationRetrievalState !== null) {
				return;
			}
			
			rawPlayerInformationRetrievalState = new RetrievalState();
			var retrievalState:RetrievalState = rawPlayerInformationRetrievalState;
			onReady(function():void {
				addPlayerInformationLoadedCallback(retrievalState);
				addPlayerInformationErrorCallback(retrievalState);
				
				ExternalInterface.call('QS.flash.retrievePlayerInfo')
				retrievalState.updateTo(RetrievalState.LOADING);
			});
		}
		
		public function retrievePlayerData():void
		{
			if (playerDataRetrievalState !== null) {
				return;
			}
			
			rawPlayerDataRetrievalState = new RetrievalState();
			var retrievalState:RetrievalState = rawPlayerDataRetrievalState;
			onReady(function():void {
				addPlayerDataLoadedCallback(retrievalState);
				addPlayerDataErrorCallback(retrievalState);
				
				ExternalInterface.call('QS.flash.retrievePlayerData')
				retrievalState.updateTo(RetrievalState.LOADING);
			});
		}
		
		private function addPlayerDataLoadedCallback(retrievalState:RetrievalState):void
		{
			var qsPlayerDataCallback:Function = function(data:Object):void {
				rawPlayerData = convertPlayerData(data);
				retrievalState.updateTo(RetrievalState.READY);
			}
			ExternalInterface.addCallback('qsPlayerDataCallback', qsPlayerDataCallback);
		}
		
		private function addPlayerDataErrorCallback(retrievalState:RetrievalState):void
		{
			var qsPlayerDataErrorCallback:Function = function(message:String):void {
				retrievalState.updateTo(RetrievalState.ERROR);
			}
			ExternalInterface.addCallback('qsPlayerDataErrorCallback', qsPlayerDataErrorCallback);
		}
		
		private function addPlayerInformationLoadedCallback(retrievalState:RetrievalState):void
		{
			var qsPlayerInfoCallback:Function = function(player:Object):void {
				rawPlayerInformation = new PlayerInformation(player.uuid, player.name, player.email);
				retrievalState.updateTo(RetrievalState.READY);
			}
			ExternalInterface.addCallback('qsPlayerInfoCallback', qsPlayerInfoCallback);
		}
		
		private function addPlayerInformationErrorCallback(retrievalState:RetrievalState):void
		{
			var qsPlayerInfoErrorCallback:Function = function(message:String):void {
				retrievalState.updateTo(RetrievalState.ERROR);
			}
			ExternalInterface.addCallback('qsPlayerInfoErrorCallback', qsPlayerInfoErrorCallback);
		}
		
		private function onReady(callback:Function):void
		{
			addReadyHandler(callback);
			if (initializationState !== null && initializationState.state === RetrievalState.READY) {
				runReadyHandlers();
			}
		}
		
		private function addReadyHandler(callback:Function):void
		{
			readyHandler.push(callback);
		}
										 
		private function runReadyHandlers():void {
			while (readyHandler.length > 0) {
				var handler:Function = readyHandler.pop();
				handler.call();
			}
		}
		
		private function addPlayerDataHandlers():void {
			var retrievalResponse:Function = function():SetPlayerDataResponse {
				return this.rawLastPlayerDataSetResponse;
			}
			var self:BrowserDomSdkDriver = this;
				
			var qsPlayerDataSetCallback:Function = function(data:Object):void {
				var response:SetPlayerDataResponse = retrievalResponse.apply(self);
				var newData:Dictionary = convertPlayerData(data);
				if (response !== null) {
					response.fullfilRequest(true, newData);
				}
			}
			ExternalInterface.addCallback('qsPlayerDataSetCallback', qsPlayerDataSetCallback);
			
			var qsPlayerDataSetErrorCallback:Function = function(message:String):void {
				var response:SetPlayerDataResponse = retrievalResponse.apply(self);
				if (response !== null) {
					response.fullfilRequest(false, rawPlayerData);
				}
			}
			ExternalInterface.addCallback('qsPlayerDataSetErrorCallback', qsPlayerDataSetErrorCallback);
		}
		
		private function convertPlayerData(data:Object):Dictionary
		{
			var newData:Dictionary = new Dictionary();
			for each (var key:String in data) {
				if (data.hasOwnProperty(key)) {
					newData[key] = data[key]; 
				}
			}
			return newData;
		}
	}
}