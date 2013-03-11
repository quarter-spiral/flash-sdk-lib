package com.quarterspiral.sdk
{
	public class PlayerInformation
	{
		private var rawName:String;
		private var rawUuid:String;
		private var rawEmail:String;
		
		public function PlayerInformation(uuid:String, name:String, email:String) {
			this.rawUuid = uuid;
			this.rawName = name;
			this.rawEmail = email;
		}
		
		public function get name():String {
			return this.rawName;
		}
		
		public function get uuid():String {
			return this.rawUuid;
		}
		
		public function get email():String {
			return this.rawEmail;
		}
		
		public function equals(otherPlayerInformation:PlayerInformation):Boolean {
			return uuid === otherPlayerInformation.uuid && name === otherPlayerInformation.name && email === otherPlayerInformation.email;
		}
	}
}