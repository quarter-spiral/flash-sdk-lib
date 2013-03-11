package com.quarterspiral.sdk
{
	import flash.utils.Dictionary;

	public interface Sdk
	{	
		/**
		 * Indicates if the SDK has been initialized. The initialization process is started automatically but taks a while to complete. This property lets you look up wether the SDK is ready to be used already or not.
		 */
		function get ready():Boolean;
		
		/**
		 * Indicates if the player information of the current player is ready to be used.
		 * 
		 * @see playerInformation
		 */
		function get playerInformationReady():Boolean;
		
		/**
		 * Indicates if the player data of the current player is ready to be used.
		 * 
		 * @see playerData
		 */
		function get playerDataReady():Boolean;
		
		/**
		 * Information about the player.
		 * 
		 * @return <code>null</code> if information has not been retrieved yet, an instance of <code>PlayerInformation</code> otherwise.
		 * @see PlayerInformation
		 */
		function get playerInformation():PlayerInformation;
		
		/**
		 * Custom data of the player.
		 * 
		 * @return <code>null</code> if information has not been retrieved yet, an <code>Object</code> otherwise.
		 */
		function get playerData():Dictionary;
		
		/**
		 * Saves data for the current player.
		 * 
		 * <p>The method can either take a single <code>Dictionary</code> or a key and a value instead.
		 * If just a <code>Dictionary</code> is provided all of the player's existing data will be overwritten.
		 * If a key/value pair is provided only that one key will be written, keeping all of the other data of the player</p>
		 * 
		 * <p>The implementation should use a mechanism to queue up all requests that cannot be carried out immediately and process
		 * them in order as soon as possible.</p>
		 * 
		 * @param attribute Either a <code>Dictionary</code> or the name of the key
		 * @param value If <code>attribute</code> is a <code>Dictionary</code> this parameter is omitted, otherwise it's the value to store
		 * 
		 * @see playerData
		 * @see SetPlayerDataResponse
		 */
		function setPlayerData(attribute:Object, value:Object = null):SetPlayerDataResponse;
	}
}