package com.quarterspiral.sdk.test
{
	import com.quarterspiral.sdk.RetrievalState;

	public class RetrievalStateUtils
	{
		
		public static function initialState():RetrievalState
		{
			var state:RetrievalState = new RetrievalState();
			return state;
		}
		
		public static function loadingState():RetrievalState
		{
			var state:RetrievalState = initialState();
			state.updateTo(RetrievalState.LOADING);
			return state;
		}
		
		public static function readyState():RetrievalState
		{
			var state:RetrievalState = loadingState();
			state.updateTo(RetrievalState.READY);
			return state;
		}
		
		public static function errorState():RetrievalState
		{
			var state:RetrievalState = loadingState();
			state.updateTo(RetrievalState.ERROR);
			return state;
		}
	}
}