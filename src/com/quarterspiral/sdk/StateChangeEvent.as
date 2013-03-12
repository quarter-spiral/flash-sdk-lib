package com.quarterspiral.sdk
{
	import flash.events.Event;
	
	public class StateChangeEvent extends Event
	{
		public static const STATE_CHANGE:String = "QsStateChange";
		
		private var rawOldState:int;
		private var rawNewState:int;
		
		public function StateChangeEvent(oldState:int, newState:int)
		{
			rawOldState = oldState;
			rawNewState = newState;
			super(STATE_CHANGE, true, false);
		}
		
		public function get oldState():int {
			return rawOldState;
		}
		
		public function get newState():int {
			return rawNewState;
		}
	}
}