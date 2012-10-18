package com.bunnybones.scenegrapher 
{
	import Box2D.Collision.Shapes.b2CircleShape;
	import Box2D.Collision.Shapes.b2Shape;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2Fixture;
	import Box2D.Dynamics.b2FixtureDef;
	import flash.events.Event;
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author Tomasz Dysinski
	 */
	public class CursorCircleHandle extends CircleHandle 
	{
		static private var replaceFixture:Boolean = true;
		
		public function CursorCircleHandle(body:b2Body, id:int=-2) 
		{
			super(body, id, false);
		}
		
		override protected function onEnterFrame(e:Event):void 
		{
			var fixture:b2Fixture;
			var tempDelta:Point = (parent as SceneGrapherMain).lastMouseMovePositionLocal.clone();
			tempDelta = tempDelta.subtract((parent as SceneGrapherMain).lastMouseDownPositionLocal);
			var minSize:Number = 20 / (parent as SceneGrapherMain).transform.matrix.a;
			//trace(minSize);
			if (replaceFixture)
			{
				for (fixture = body.GetFixtureList(); fixture; fixture = fixture.GetNext())
				{
					body.DestroyFixture(fixture);
				}
				var fixtureDef:b2FixtureDef = new b2FixtureDef();
				fixtureDef.shape = new b2CircleShape( Math.max(tempDelta.length, minSize) * SceneGrapherMain.WORLDSCALE);
				body.CreateFixture(fixtureDef);
			}
			else
			{
				for (fixture = body.GetFixtureList(); fixture; fixture = fixture.GetNext())
				{
					var shape:b2Shape = fixture.GetShape();
					if (shape is b2CircleShape)
					{
						//trace((parent as SceneGrapherMain).lastMouseMovePositionLocal);
						//trace((parent as SceneGrapherMain).lastMouseDownPositionLocal);
						//trace(tempDelta);
						(shape as b2CircleShape).SetRadius(Math.max(tempDelta.length, minSize) * SceneGrapherMain.WORLDSCALE);
					}
				}
			}
			dirty = true;
			super.onEnterFrame(e);
		}
	}

}