package com.quarterspiral.sdk
{
	public class SetPlayerDataRequest
	{
		private var rawAttribute:Object;
		private var rawValue:Object;
		private var rawResponse:SetPlayerDataResponse;
		
		public function SetPlayerDataRequest(attribute:Object, value:Object)
		{
			this.rawAttribute = attribute;
			this.rawValue = value;
		}
		
		public function get attribute():Object
		{
			return rawAttribute;
		}
		
		public function get value():Object
		{
			return rawValue;
		}
		
		public function get response():SetPlayerDataResponse
		{
			if (rawResponse === null) {
				rawResponse = new SetPlayerDataResponse();
			}
			return rawResponse;
		}
		
		public function bindToRealResponse(realResponse:SetPlayerDataResponse):void
		{
			var self:SetPlayerDataRequest = this;
			realResponse.setResultHandler(function(callbackResponse:SetPlayerDataResponse):void {
				self.response.fullfilRequest(callbackResponse.successful, callbackResponse.newPlayerData);
			});
		}
			
	}
}