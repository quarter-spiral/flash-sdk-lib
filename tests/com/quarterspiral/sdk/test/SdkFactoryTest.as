package com.quarterspiral.sdk.test
{
	import com.quarterspiral.sdk.DomSdk;
	import com.quarterspiral.sdk.SdkFactory;
	
	import flash.utils.getQualifiedClassName;
	
	import flexunit.framework.Assert;
	
	public class SdkFactoryTest
	{		
		[Before]
		public function setUp():void
		{
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
		public function testGetInstance():void
		{		
			SdkFactory.testing = false;
			var sdk:DomSdk = DomSdk(SdkFactory.getInstance("http://canvas.example.com"));
			Assert.assertEquals("com.quarterspiral.sdk::BrowserDomSdkDriver", getDriverName(sdk))
		}
		
		[Test]
		public function testGetInstanceInTestMode():void
		{
			SdkFactory.testing = true;
			var sdk:DomSdk = DomSdk(SdkFactory.getInstance("http://canvas.example.com"));
			Assert.assertEquals("com.quarterspiral.sdk::MockDomSdkDriver", getDriverName(sdk))
		}
		
		private function getDriverName(sdk:DomSdk):String {
			return flash.utils.getQualifiedClassName(sdk.driver);
		}
	}
}