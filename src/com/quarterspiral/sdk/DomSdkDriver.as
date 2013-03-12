package com.quarterspiral.sdk
{
	import flash.utils.Dictionary;

	public interface DomSdkDriver
	{
		/**
		 * Indicates the current state of the initialization of the SDK
		 */
		function get initializationState():RetrievalState;
		
		
		/**
		 * The information about the current player
		 * 
		 * @returns The player information if readily available, <code>null</code> if not
		 */
		function get playerInformation():PlayerInformation;
		
		/**
		 * Triggers a retrieval of the player information. Should only run if the data has not been retrieved yet.
		 * 
		 * <p>If the SDK is not yet initialized it should run as soon as this is the case.</p>
		 */
		function retrievePlayerInformation():void;
		
		/**
		 * The current state of the retrieval process for the <code>playerInformation</code>
		 * 
		 * @returns <code>RetrievalState</code> if a retrieval has been triggered, yet. <code>null</code> otherwise.
		 */
		function get playerInformationRetrievalState():RetrievalState;
		
		/**
		 * Returns the retrieved data of a player.
		 * 
		 * @returns The player's data if readily available, <code>null</code> if not
		 */
		function get playerData():Dictionary;
		
		/**
		 * Triggers a retrieval of the player data. Should only run if the data has not been retrieved yet.
		 * 
		 * <p>If the SDK is not yet initialized it should run as soon as this is the case.</p>
		 */
		function retrievePlayerData():void;
		
		/**
		 * The current state of the retrieval process for the <code>playerData</code>
		 * 
		 * @returns <code>RetrievalState</code> if a retrieval has been triggered, yet. <code>null</code> otherwise.
		 */
		function get playerDataRetrievalState():RetrievalState;
		
		/**
		 * Sets a single key/value pair in the player data while keeping all other data as is.
		 */
		function setPlayerDataKeyValuePair(key:String, value:Object):SetPlayerDataResponse;
		
		/**
		 * Sets a complete player data.
		 */
		function setPlayerData(data:Dictionary):SetPlayerDataResponse;
	}
}