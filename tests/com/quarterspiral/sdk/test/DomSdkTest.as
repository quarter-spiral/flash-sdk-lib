package com.quarterspiral.sdk.test
{
	import com.quarterspiral.sdk.DomSdk;
	import com.quarterspiral.sdk.MockDomSdkDriver;
	import com.quarterspiral.sdk.PlayerInformation;
	import com.quarterspiral.sdk.RetrievalState;
	import com.quarterspiral.sdk.SetPlayerDataResponse;
	
	import flash.utils.Dictionary;
	
	import org.flexunit.Assert;

	public class DomSdkTest
	{		
		private var sdk:DomSdk;
		private var driver:MockDomSdkDriver;
		
		[Before]
		public function setUp():void
		{
			driver = new MockDomSdkDriver();
			sdk = new DomSdk(driver); 
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
		public function sdkShouldBeReadyWhenItsInitialized() : void
		{
			Assert.assertFalse(sdk.ready);
			
			driver.initializationState = RetrievalStateUtils.initialState();
			Assert.assertFalse(sdk.ready);
			
			driver.initializationState = RetrievalStateUtils.loadingState();
			Assert.assertFalse(sdk.ready);
			
			driver.initializationState = RetrievalStateUtils.errorState();
			Assert.assertFalse(sdk.ready);
			
			driver.initializationState = RetrievalStateUtils.readyState();
			Assert.assertTrue(sdk.ready);
		}
		
		[Test]
		public function sdkShouldHavePlayerDataReadyWhenTheDriverSignalsIt():void
		{
			driver.initializationState = RetrievalStateUtils.readyState();
			Assert.assertFalse(sdk.playerDataReady);
			driver.playerDataRetrievalState = RetrievalStateUtils.initialState();
			Assert.assertFalse(sdk.playerDataReady);
			driver.playerDataRetrievalState = RetrievalStateUtils.loadingState();
			Assert.assertFalse(sdk.playerDataReady);
			driver.playerDataRetrievalState = RetrievalStateUtils.errorState();
			Assert.assertFalse(sdk.playerDataReady);
			driver.playerDataRetrievalState = RetrievalStateUtils.readyState();
			Assert.assertTrue(sdk.playerDataReady);
			
			driver.initializationState = null;
			Assert.assertFalse(sdk.playerDataReady);
		}
		
		[Test]
		public function playerDataReturnsNullWhenNotReady():void
		{
			var data:Dictionary = new Dictionary();
			data['highscore'] = 123;
			driver.playerData = data;
			Assert.assertNull(sdk.playerData);
			driver.initializationState = RetrievalStateUtils.readyState();
			Assert.assertNull(sdk.playerData);
			driver.playerDataRetrievalState = RetrievalStateUtils.readyState();
			Assert.assertStrictlyEquals(data, sdk.playerData);
		}
		
		[Test]
		public function sdkShouldHavePlayerInformationReadyWhenTheDriverSignalsIt():void
		{
			driver.initializationState = RetrievalStateUtils.readyState();
			Assert.assertFalse(sdk.playerInformationReady);
			driver.playerInformationRetrievalState = RetrievalStateUtils.initialState();
			Assert.assertFalse(sdk.playerInformationReady);
			driver.playerInformationRetrievalState  = RetrievalStateUtils.loadingState();
			Assert.assertFalse(sdk.playerInformationReady);
			driver.playerInformationRetrievalState  = RetrievalStateUtils.errorState();
			Assert.assertFalse(sdk.playerInformationReady);
			driver.playerInformationRetrievalState  = RetrievalStateUtils.readyState();
			Assert.assertTrue(sdk.playerInformationReady);
			
			driver.initializationState = null;
			Assert.assertFalse(sdk.playerDataReady);
		}
		
		[Test]
		public function playerInformationReturnsNullWhenNotReady():void
		{
			var information:PlayerInformation = new PlayerInformation("12345-67890", "Peter S", "peter@example.com");
			driver.playerInformation = information;
			Assert.assertNull(sdk.playerInformation);
			driver.initializationState = RetrievalStateUtils.readyState();
			Assert.assertNull(sdk.playerInformation);
			driver.playerInformationRetrievalState = RetrievalStateUtils.readyState();
			Assert.assertTrue(information.equals(sdk.playerInformation))
		}
		
		[Test]
		public function usesQueueToSetPlayerData():void
		{
			Assert.assertFalse(sdk.ready);
			var response1:SetPlayerDataResponse = sdk.setPlayerData("bla", "blub");
			var response2:SetPlayerDataResponse = sdk.setPlayerData("highScore", 123);
			
			Assert.assertFalse(response1.ready);
			Assert.assertFalse(response2.ready);
			
			driver.initializationState.updateTo(RetrievalState.LOADING);
			driver.initializationState.updateTo(RetrievalState.READY);
			
			Assert.assertTrue(response1.ready);
			Assert.assertTrue(response2.ready);
			var response3:SetPlayerDataResponse = sdk.setPlayerData("level", "Tower");
			Assert.assertTrue(response3.ready);
		}
	}
}