package com.quarterspiral.sdk.test
{
	import com.quarterspiral.sdk.SetPlayerDataResponse;
	
	import flash.utils.Dictionary;
	
	import flexunit.framework.Assert;

	public class SetPlayerDataResponseTest
	{		
		private var response:SetPlayerDataResponse;
		
		[Before]
		public function setUp():void
		{
			response = new SetPlayerDataResponse();
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
		public function initialStateTest():void
		{
			Assert.assertFalse(response.ready);
			Assert.assertFalse(response.successful);
			Assert.assertNull(response.newPlayerData);
		}
		
		[Test]
		public function setsSuccessfulCorrectly():void
		{
			var data:Dictionary = new Dictionary();
			data['highScore'] = 123;
			
			response.fullfilRequest(true, data);	
			Assert.assertTrue(response.ready);
			Assert.assertTrue(response.successful);
			Assert.assertStrictlyEquals(data, response.newPlayerData);
		}
		
		[Test]
		public function setsErrorneousCorrectly():void
		{
			var data:Dictionary = new Dictionary();
			data['highScore'] = 456;
			
			response.fullfilRequest(false, data);	
			Assert.assertTrue(response.ready);
			Assert.assertFalse(response.successful);
			Assert.assertStrictlyEquals(data, response.newPlayerData);
		}
		
		[Test]
		public function callsTheResultHandler():void
		{
			var handlerResponse:SetPlayerDataResponse;
			var handler:Function = function(response:SetPlayerDataResponse):void {
				handlerResponse = response;
			}
			response.setResultHandler(handler);
			Assert.assertNull(handlerResponse);
			response.fullfilRequest(true, new Dictionary());
			Assert.assertNotNull(handlerResponse);
			Assert.assertStrictlyEquals(response, handlerResponse);
		}
		
		[Test]
		public function callsTheResultHandlerEvenWhenRegisteredTooLate():void
		{
			var handlerResponse:SetPlayerDataResponse;
			var handler:Function = function(response:SetPlayerDataResponse):void {
				handlerResponse = response;
			}
			response.fullfilRequest(true, new Dictionary());
			response.setResultHandler(handler);
			Assert.assertNotNull(handlerResponse);
			Assert.assertStrictlyEquals(response, handlerResponse);
		}
	}
}