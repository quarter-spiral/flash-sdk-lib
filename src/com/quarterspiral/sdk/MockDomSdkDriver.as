package com.quarterspiral.sdk
{
	import flash.utils.Dictionary;

	public class MockDomSdkDriver implements DomSdkDriver
	{
		private var rawInitializationState:RetrievalState = null;
		private var rawPlayerData:Dictionary = null;
		private var rawPlayerDataRetrievalState:RetrievalState = null;
		private var rawPlayerInformation:PlayerInformation = null;
		private var rawPlayerInformationRetrievalState:RetrievalState = null;
		private var rawNextPlayerDataResponse:SetPlayerDataResponse;
		
		public function MockDomSdkDriver() {
			rawInitializationState = new RetrievalState();
		}
		
		/**
		 * A state that can be set on the driver. Is initiated by default.
		 */
		public function get initializationState():RetrievalState
		{
			return rawInitializationState;
		}
		
		/**
		 * @private
		 */
		public function set initializationState(state:RetrievalState):void {
			rawInitializationState = state;
		}
		
		/**
		 * Player data that can be set on the driver. <code>null</code> by default;
		 */
		public function get playerData():Dictionary
		{
			return rawPlayerData;
		}
		
		/**
		 * @private
		 */
		public function set playerData(playerData:Dictionary):void
		{
			rawPlayerData = playerData;
		}
		
		/**
		 * State of the retrieval of the player data that can be set on the driver. <code>null</code> by default.
		 */
		public function get playerDataRetrievalState():RetrievalState
		{
			return rawPlayerDataRetrievalState;
		}
		
		/**
		 * @private
		 */
		public function set playerDataRetrievalState(state:RetrievalState):void
		{
			rawPlayerDataRetrievalState = state;
		}
		
		/**
		 * Player information that can be set on the driver. <code>null</code> by default;
		 */
		public function get playerInformation():PlayerInformation
		{
			return rawPlayerInformation;
		}
		
		/**
		 * @private
		 */
		public function set playerInformation(playerInformation:PlayerInformation):void
		{
			rawPlayerInformation = playerInformation;
		}
		
		/**
		 * State of the retrieval of the player information that can be set on the driver. <code>null</code> by default.
		 */
		public function get playerInformationRetrievalState():RetrievalState
		{
			return rawPlayerInformationRetrievalState;
		}
		
		/**
		 * @private
		 */
		public function set playerInformationRetrievalState(state:RetrievalState):void
		{
			rawPlayerInformationRetrievalState = state;
		}
		
		/**
		 * Set the response to return for the next call to <code>setPlayerData</code> or <code>setPlayerDataKeyValuePair</code>
		 * 
		 * <p>The response is cleared out after any call two one of the two methods and needs to be reset.</p>
		 * <p><strong>Important:</strong>If no response is set, the mock driver will automatically generate a successful one.
		 * Also  if there is a response set but it's <code>newPlayerData</code> is <code>null</code> the mock driver will
		 * fill in the data automatically. Therefore the driver is going to copy the results, so please make sure NOT to check
		 * for object identity when checking on the response.</p> 
		 */
		public function set nextPlayerDataResponse(response:SetPlayerDataResponse):void {
			rawNextPlayerDataResponse = response;
		}
		
		public function setPlayerData(data:Dictionary):SetPlayerDataResponse
		{
			rawPlayerData = data;
			
			return adoptedResponse();
		}
		
		public function setPlayerDataKeyValuePair(key:String, value:Object):SetPlayerDataResponse
		{
			if (rawPlayerData === null) {
				rawPlayerData = new Dictionary();
			}
			rawPlayerData[key] = value;
			
			return adoptedResponse();
		}
		
		private function adoptedResponse():SetPlayerDataResponse
		{
			var response:SetPlayerDataResponse = new SetPlayerDataResponse()
			if (rawNextPlayerDataResponse !== null && rawNextPlayerDataResponse.ready) {
				var data:Dictionary = rawNextPlayerDataResponse.newPlayerData;
				if (data === null) {
					data = rawPlayerData;
				}
				response.fullfilRequest(rawNextPlayerDataResponse.successful, data);
			}
			if (!response.ready) {
				response.fullfilRequest(true, rawPlayerData);
			}
			
			rawNextPlayerDataResponse = null;
			return response;
		}
		
		public function retrievePlayerData():void
		{
			if (rawPlayerDataRetrievalState === null) {
				rawPlayerDataRetrievalState = new RetrievalState();
			}
		}
		
		public function retrievePlayerInformation():void
		{
			if (rawPlayerInformationRetrievalState === null) {
				rawPlayerInformationRetrievalState = new RetrievalState();
			}
		}
	}
}