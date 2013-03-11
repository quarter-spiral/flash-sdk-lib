package com.quarterspiral.sdk.test
{
	import com.quarterspiral.sdk.MockDomSdkDriver;
	import com.quarterspiral.sdk.PlayerInformation;
	import com.quarterspiral.sdk.RetrievalState;
	import com.quarterspiral.sdk.SetPlayerDataResponse;
	
	import flash.utils.Dictionary;
	
	import flexunit.framework.Assert;

	public class MockDomSdkDriverTest
	{
		
		private var driver:MockDomSdkDriver;
		
		[Before]
		public function setUp():void
		{
			driver = new MockDomSdkDriver();
		}
		
		[After]
		public function tearDown():void
		{
		}
		
		[BeforeClass]
		public static function setUpBeforeClass():void
		{
		}
		
		[AfterClass]
		public static function tearDownAfterClass():void
		{
		}
		
		[Test]
		public function testInitialState():void
		{
			Assert.assertNotNull(driver.initializationState);
			Assert.assertNull(driver.playerData);
			Assert.assertNull(driver.playerDataRetrievalState);
			Assert.assertNull(driver.playerInformation);
			Assert.assertNull(driver.playerInformationRetrievalState);
		}
		
		[Test]
		public function testInitialiationState():void
		{
			var state:RetrievalState = new RetrievalState();
			state.updateTo(RetrievalState.LOADING);
			driver.initializationState = state;
			
			Assert.assertStrictlyEquals(state, driver.initializationState);
		}
		
		[Test]
		public function testPlayerData():void
		{
			var data:Dictionary = new Dictionary();
			data['highscore'] = 123;
			driver.playerData = data;
			
			Assert.assertStrictlyEquals(data, driver.playerData);
		}
		
		[Test]
		public function testPlayerDataRetrievalState():void
		{
			var state:RetrievalState = new RetrievalState();
			state.updateTo(RetrievalState.LOADING);
			state.updateTo(RetrievalState.ERROR);
			driver.playerDataRetrievalState = state;
			
			Assert.assertStrictlyEquals(state, driver.playerDataRetrievalState);
		}
		
		[Test]
		public function testPlayerInformation():void
		{
			var information:PlayerInformation = new PlayerInformation('12345-67890', "Peter S", "peter@example.com");
			driver.playerInformation = information;
			Assert.assertTrue(information.equals(driver.playerInformation));
		}
		
		[Test]
		public function testPlayerInformationRetrievalState():void
		{
			var state:RetrievalState = new RetrievalState();
			state.updateTo(RetrievalState.LOADING);
			state.updateTo(RetrievalState.READY);
			driver.playerInformationRetrievalState = state;
			
			Assert.assertStrictlyEquals(state, driver.playerInformationRetrievalState);
		}
		
		
		[Test]
		public function testSetPlayerDataResponse():void
		{
			var data:Dictionary = new Dictionary();
			data['highScore'] = 123;
			
			var response:SetPlayerDataResponse = driver.setPlayerData(data);
			Assert.assertTrue(response.ready);
			Assert.assertTrue(response.successful);
			Assert.assertTrue(compareDictionaries(data, response.newPlayerData));
			
			response = driver.setPlayerDataKeyValuePair("level", "Tower");
			var data2:Dictionary = new Dictionary();
			data2['highScore'] = 123;
			data2['level'] = 'Tower';
			Assert.assertTrue(response.ready);
			Assert.assertTrue(response.successful);
			Assert.assertTrue(compareDictionaries(data2, response.newPlayerData));
			
			var setResponse:SetPlayerDataResponse = new SetPlayerDataResponse();
			var fakeData:Dictionary = new Dictionary();
			fakeData['fake'] = 'yeah';
			setResponse.fullfilRequest(false, fakeData);
			driver.nextPlayerDataResponse = setResponse;
			response = driver.setPlayerData(data);
			Assert.assertTrue(response.ready);
			Assert.assertFalse(response.successful);
			Assert.assertTrue(compareDictionaries(fakeData, response.newPlayerData));
		}
		
		private function compareDictionaries( d1:Dictionary, d2:Dictionary ):Boolean
		{
			// quick check for the same object
			if( d1 == d2 )
				return true;
			
			// check for null
			if( d1 == null || d2 == null )
				return false;
			
			// go through the keys in d1 and check if they're in d2 - also keep a count
			var count:int = 0;
			for( var key:* in d1 )
			{
				// check if the key exists
				if( !( key in d2 ) )
					return false;
				
				// check that the values are the same
				if( d1[key] != d2[key] )
					return false;
				
				count++;
			}
			
			// now just make sure d2 has the same number of keys
			var count2:int = 0;
			for( key in d2 )
				count2++;
			
			// return if they're the same size
			return ( count == count2 );
		}
	}
}