package com.quarterspiral.sdk.test
{
	import com.quarterspiral.sdk.RetrievalState;
	import com.quarterspiral.sdk.RetrievalStateChangeError;
	
	import flexunit.framework.Assert;

	public class RetrivalStateTest
	{		
		private static var stateNames:Object = {};
		
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
			stateNames[RetrievalState.INIT] = 'INIT';
			stateNames[RetrievalState.LOADING] = 'LOADING';
			stateNames[RetrievalState.READY] = 'READY';
			stateNames[RetrievalState.ERROR] = 'ERROR';
		}
		
		[AfterClass]
		public static function tearDownAfterClass():void
		{
		}
		
		[Test]
		public function testInitialState():void
		{
			var state:RetrievalState = new RetrievalState();
			Assert.assertEquals(RetrievalState.INIT, state.state);
		}
		
		[Test]
		public function testTransitionsFromInit():void
		{
			assertCanTransitionTo(RetrievalStateUtils.initialState, RetrievalState.INIT)
			assertCanTransitionTo(RetrievalStateUtils.initialState, RetrievalState.LOADING)
			assertCannotTransitionTo(RetrievalStateUtils.initialState, RetrievalState.READY)
			assertCannotTransitionTo(RetrievalStateUtils.initialState, RetrievalState.ERROR)
		}
		
		[Test]
		public function testTransitionsFromLoading():void
		{
			assertCannotTransitionTo(RetrievalStateUtils.loadingState, RetrievalState.INIT)
			assertCanTransitionTo(RetrievalStateUtils.loadingState, RetrievalState.LOADING)
			assertCanTransitionTo(RetrievalStateUtils.loadingState, RetrievalState.READY)
			assertCanTransitionTo(RetrievalStateUtils.loadingState, RetrievalState.ERROR)
		}
		
		[Test]
		public function testTransitionsFromReady():void
		{
			assertCannotTransitionTo(RetrievalStateUtils.readyState, RetrievalState.INIT)
			assertCannotTransitionTo(RetrievalStateUtils.readyState, RetrievalState.LOADING)
			assertCanTransitionTo(RetrievalStateUtils.readyState, RetrievalState.READY)
			assertCannotTransitionTo(RetrievalStateUtils.readyState, RetrievalState.ERROR)
		}
		
		[Test]
		public function testTransitionsFromError():void
		{
			assertCannotTransitionTo(RetrievalStateUtils.errorState, RetrievalState.INIT)
			assertCannotTransitionTo(RetrievalStateUtils.errorState, RetrievalState.LOADING)
			assertCannotTransitionTo(RetrievalStateUtils.errorState, RetrievalState.READY)
			assertCanTransitionTo(RetrievalStateUtils.errorState, RetrievalState.ERROR)
		}
		
		private function assertCanTransitionTo(stateGenerator:Function, newState:int):void {
			var state:RetrievalState = stateGenerator();
			var oldState:int = state.state;
			try {
				state.updateTo(newState)
			} catch (error:RetrievalStateChangeError) {
				Assert.fail("Should be able to transition from " + stateNames[oldState] + " to " + stateNames[newState] + " but could not!");
			}
		}
		
		private function assertCannotTransitionTo(stateGenerator:Function, newState:int):void {
			var state:RetrievalState = stateGenerator();
			try {
				var oldState:int = state.state;
				state.updateTo(newState)
				Assert.fail("Should not be able to transition from " + stateNames[oldState] + " to " + stateNames[newState] + " but could!") 
			} catch(error:RetrievalStateChangeError) {
				//Expected
			}
		}
	}
}