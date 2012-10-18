package com.bunnybones.Box2d 
{
	import Box2D.Dynamics.b2DestructionListener;
	import Box2D.Dynamics.b2Fixture;
	import Box2D.Dynamics.Joints.b2Joint;
	import com.bunnybones.scenegrapher.Connection;
	
	/**
	 * ...
	 * @author Tomasz Dysinski
	 */
	public class b2DestructionListenerCustom extends b2DestructionListener 
	{
		
		public function b2DestructionListenerCustom() 
		{
			
		}
		override public function SayGoodbyeFixture(fixture:b2Fixture):void 
		{
			//trace("destroy", fixture);
			super.SayGoodbyeFixture(fixture);
		}
		override public function SayGoodbyeJoint(joint:b2Joint):void 
		{
			//trace("destroy", joint);
			var connection:Connection = joint.GetUserData();
			connection.parent.removeChild(connection);
			super.SayGoodbyeJoint(joint);
		}
	}

}