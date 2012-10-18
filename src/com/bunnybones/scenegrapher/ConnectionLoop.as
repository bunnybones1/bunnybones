package com.bunnybones.scenegrapher 
{
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Collision.Shapes.b2CircleShape;
	import Box2D.Dynamics.Joints.b2DistanceJoint;
	import com.bunnybones.MouseToolTip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author Tomasz Dysinski
	 */
	public class ConnectionLoop extends Connection 
	{
		
		public function ConnectionLoop(joint:b2DistanceJoint, id:int) 
		{
			super(joint, id);
			(joint.GetBodyB().GetUserData() as Handle).contentType = ContentType.ACTION;
			contentType = ContentType.ACTION;
		}
		
		override protected function drawShape():void 
		{
			graphics.drawCircle(50, 0, 50);
		}
		
		override protected function onEnterFrame(e:Event):void 
		{
			var posA:b2Vec2 = joint.GetBodyA().GetPosition();
			var posB:b2Vec2 = joint.GetBodyB().GetPosition();
			var delta:b2Vec2 = posA.Copy();
			delta.Subtract(posB);
			
			var radiusA:Number = (joint.GetBodyA().GetFixtureList().GetShape() as b2CircleShape).GetRadius();
			var radiusB:Number = (joint.GetBodyB().GetFixtureList().GetShape() as b2CircleShape).GetRadius();
			var radiusDeltaA:b2Vec2 = posA.Copy();
			radiusDeltaA.Subtract(posB);
			radiusDeltaA.Normalize();
			radiusDeltaA.Multiply(radiusA);
			
			x = posA.x / SceneGrapherMain.WORLDSCALE;
			y = posA.y / SceneGrapherMain.WORLDSCALE;
			scaleX = delta.Length();
			scaleY = scaleX *.5;
			rotation = Math.atan2(delta.y, delta.x) / Math.PI / 2 * 360 + 180;
			
			if (dirty) draw();
		}
		
		override protected function onRollOver(e:MouseEvent):void 
		{
			description = StringUtils.nameToActionName(name);
			MouseToolTip.show(description);
		}
		
		override public function get description():String
		{
			return StringUtils.nameToActionName(name);
		}
	}

}