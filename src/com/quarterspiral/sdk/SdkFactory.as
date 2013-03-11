package com.quarterspiral.sdk
{
	import flash.display.DisplayObject;
	import flash.display.LoaderInfo;

	/**
	 * Used to retrieve an instance of the Quarter Spiral SDK
	 * 
	 * <p>Use the <code>getInstance</code> method in your game to get an instance of the SDK.</p>
	 */
	public class SdkFactory
	{
		private static var sdk:Sdk = null;
		private static var testingSdk:Sdk = null;
		private static var testingEnabled:Boolean = false;
		
		/**
		 * Returns an instance of <code>Sdk</code> to use in your code.
		 * 
		 * @param canvasUrlDeterminator To determine the URL of the Quarter Spiral canvas host you should
		 * 								either pass in any <code>DisplayObject</code> of your project (e.g. your <code>Stage</code>).
		 * 								In edge cases where this is not possible you might also pass in the plain canvas URL as a string.
		 */
		public static function getInstance(canvasUrlDeterminator:Object):Sdk {
			initializeSdks(extractCanvasUrl(canvasUrlDeterminator));
			if (testing) {
				return testingSdk;
			}
			return sdk;
		}
		
		/**
		 * @private
		 */
		public static function set testing(enable:Boolean):void {
			testingEnabled = enable;
		}
		
		/**
		 * Indicates if the factory is in mocking mode
		 * 
		 * <p>If testing is enabled the <code>getInstance</code> method returns an instance of <code>DomSdk</code> using the <code>MockDomSdkDriver</code> instead of the normal <code>BrowserDomSdkDriver</code>. See the documentation of <code>MockDomSdkDriver</code> for how to use that in your own tests. To make the testing mode work correctly, please make sure to enable testing mode before any call to <code>getInstance</code>!</p>
		 */
		public static function get testing():Boolean {
			return testingEnabled;
		}
		
		private static function extractCanvasUrl(canvasUrlDeterminator:Object):String {
			if (canvasUrlDeterminator is DisplayObject) {
				return LoaderInfo(DisplayObject(canvasUrlDeterminator).root.loaderInfo).parameters.qsCanvasHost;
			} else if (canvasUrlDeterminator is String) {
				return String(canvasUrlDeterminator);
			} else {
				throw new Error("Must provide canvas URL as DisplayObject or plain String!");
			}
		}
		
		private static function initializeSdks(canvasUrl:String):void {
			if (testing) {
				if (testingSdk === null) {
					testingSdk = new DomSdk(new MockDomSdkDriver());
				}
			} else {
				if (sdk === null) {
					sdk = new DomSdk(new BrowserDomSdkDriver(canvasUrl));
				}
			}
		}
	}
}