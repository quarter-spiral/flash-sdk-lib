package com.quarterspiral.sdk
{
	import flash.utils.Dictionary;

	/**
	 * Response to a request to set player data
	 * 
	 * <p>As this response is returned immediately after issuing the request it
	 * will change it's state as soon as the request has been fulfilled. If you want to be
	 * informed when this state changed happens register a handler with <code>setResultHandler</code>.</p> 
	 */
	public class SetPlayerDataResponse
	{
		private var rawReady:Boolean;
		private var rawSuccessful:Boolean;
		private var rawNewPlayerData:Dictionary;
		private var resultHandler:Function;
		
		/**
		 * Indicates if the response is completed
		 */
		public function get ready():Boolean
		{
			return rawReady;			
		}
		
		/**
		 * Indicates if the request has been successfully fulfilled
		 * 
		 * @returns <code>true</code>/<code>false</code> depending on the success of the request
		 * 			if the request has already been fullfilled, <code>false</code> otherwise. 
		 */
		public function get successful():Boolean
		{
			return rawSuccessful;
		}
		
		/**
		 * The player data after the request has been fullfilled
		 * 
		 * @returns The player data after the request has been fullfilled of the request
		 * 			has already been fullfilledm <code>null</code> otherwise.
		 */
		public function get newPlayerData():Dictionary
		{
			return rawNewPlayerData;
		}
		
		/**
		 * Registers a function that is called when the state of the request changes.
		 * 
		 * @param callback A function that takes one parameter which is this response itself.
		 * 		  The function is called as soon as the request is fullfilled.
		 */
		public function setResultHandler(callback:Function):void {
			if (ready) {
				callback.call(this, this);
			} else {
				resultHandler = callback;
			}
		}
		
		/**
		 * Marks the request as fullfilled and sets the state and player data
		 * 
		 * @param successful Indictaes if the respone has been successful
		 * @param newPlayerData The player data after the request is fullfilled
		 */
		public function fullfilRequest(successful:Boolean, newPlayerData:Dictionary):void {
			rawReady = true;
			rawSuccessful = successful;
			rawNewPlayerData = newPlayerData;
			if (resultHandler !== null) {
				resultHandler.call(this, this);
			}
		}
	}
}