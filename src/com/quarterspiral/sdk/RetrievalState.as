package com.quarterspiral.sdk
{
	import flash.events.EventDispatcher;

	/**
	 * State of asynchroniously retrieved information. 
	 */
	public class RetrievalState extends EventDispatcher
	{
		/**
		 * State when the retrieval process has not yet started
		 */
		public static const INIT:int = 1;
		
		/**
		 * State when the retrieval process is in progress but has not yet finished
		 */
		public static const LOADING:int = 2;
		
		/**
		 * State when the retrieval process has been finished successfully
		 */
		public static const READY:int = 3;
		
		/**
		 * State when the retrieval process failed
		 */
		public static const ERROR:int = 4;
		
		private static const TRANSITIONS:Object = {};
		{
			TRANSITIONS[INIT] = [LOADING];
			TRANSITIONS[LOADING] = [READY, ERROR];
			TRANSITIONS[READY] = [];
			TRANSITIONS[ERROR] = [];
		}
		
		private var rawState:int;
		
		public function RetrievalState() {
			state = INIT;
		}
		
		/**
		 * Current state
		 * 
		 * @return One of RetrievalState.INIT, RetrievalState.LOADING, RetrievalState.READY or RetrievalState.ERROR
		 */
		[Bindable]
		public function get state():int {
			return rawState;
		}
		
		private function set state(newState:int):void {
			rawState = newState;
		}
		
		/**
		 * Updates current state to a new state.
		 * 
		 * <p>Throws an <code>RetrievalStateChangeError</code> when not allowed to enter the <code>newState</code>.</p>
		 * 
		 * @param newState The state to switch to
		 */
		public function updateTo(newState:int):void {
			if (newState === state) {
				return;
			}
			if (TRANSITIONS[state].indexOf(newState) === -1) {
				throw new RetrievalStateChangeError("Can not transition from " + state + " to " + newState);
			}
			state = newState;
		}
	}
}