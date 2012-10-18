package com.bunnybones.scenegrapher 
{
	import Box2D.Collision.Shapes.b2CircleShape;
	import Box2D.Collision.Shapes.b2Shape;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2DebugDraw;
	import Box2D.Dynamics.b2Fixture;
	import Box2D.Dynamics.b2FixtureDef;
	import Box2D.Dynamics.b2World;
	import Box2D.Dynamics.Joints.b2DistanceJoint;
	import Box2D.Dynamics.Joints.b2DistanceJointDef;
	import Box2D.Dynamics.Joints.b2Joint;
	import com.bunnybones.Box2d.b2DestructionListenerCustom;
	import com.bunnybones.scenegrapher.data.SceneData;
	import com.bunnybones.scenegrapher.tools.ColorPicker;
	import com.bunnybones.scenegrapher.tools.Destroyer;
	import com.bunnybones.scenegrapher.tools.MouseTool;
	import com.bunnybones.scenegrapher.tools.MouseToolNewCircle;
	import com.bunnybones.scenegrapher.tools.MouseToolNewPolyLine;
	import com.bunnybones.MouseToolTip;
	import com.bunnybones.scenegrapher.tools.Selection;
	import com.bunnybones.ui.keyboard.StageKeyBoard;
	import com.bunnybones.NavigableSprite;
	import com.jam3media.xml.io.DataIOAir;
	import com.jam3media.xml.NetData;
	import com.jam3media.xml.SessionData;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.display.StageDisplayState;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.net.URLLoader;
	import flash.system.System;
	import flash.ui.Keyboard;
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;
	import flash.utils.getDefinitionByName;
	import flash.xml.XMLDocument;
	import Box2D.Dynamics.Controllers.b2BuoyancyController;
	import com.bunnybones.MouseToolTip;
	/**
	 * ...
	 * @author Tomasz Dysinski
	 */
	public class SceneGrapherMain extends NavigableSprite
	{
		static public const WORLDSCALE:Number = .01;
		private var gravity:b2Vec2 = new b2Vec2(0, 10);
		
		public var graph:b2World;
		private var graphDebug:b2DebugDraw;
		private var sessionData:SessionData;
		private var sceneData:SceneData;
		public var handlesByID:Dictionary = new Dictionary();
		public var atmosphere:b2BuoyancyController;
		public var waterline:b2BuoyancyController;
		
		protected var graphXML:XMLDocument;
		protected var xmlLoader:URLLoader;
		public function SceneGrapherMain(useMode3D:Boolean = false) 
		{
			super(useMode3D);
		}
		
		override protected function init():void 
		{
			Destroyer.staticInit();
			ColorPicker.bind(stage);
			MouseToolTip.bind(stage);
			MouseTool.bind(this);
			sessionData = new SessionData();
			sessionData.init("session.xml");
			sessionData.addEventListener(Event.COMPLETE, onSessionDataComplete);
			for each(var mouseTool:Class in GlobalSettings.instance.mouseTools)
			{
				new mouseTool();
			}
			super.init();
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
			
			graph = new b2World(gravity, false);
			atmosphere = new b2BuoyancyController();
			atmosphere.normal.Set(0,-1);
			atmosphere.offset = 100;
			atmosphere.density = 1;
			atmosphere.linearDrag = 5;
			atmosphere.angularDrag = 2;
			atmosphere.useWorldGravity = true;
			atmosphere.useDensity = true;
			graph.AddController(atmosphere);
			
			waterline = new b2BuoyancyController();
			waterline.normal.Set(0,-1);
			waterline.offset = -10;
			waterline.density = 10.0;
			waterline.linearDrag = 5;
			waterline.angularDrag = 2;
			waterline.useWorldGravity = true;
			waterline.useDensity = true;
			graph.AddController(waterline);
			
			var destructionListener:b2DestructionListenerCustom = new b2DestructionListenerCustom();
			//graph.
			//trace(destructionListener);
			graph.SetDestructionListener(destructionListener);
			graphDebug = new b2DebugDraw();
			graphDebug.AppendFlags(b2DebugDraw.e_shapeBit);
			graphDebug.AppendFlags(b2DebugDraw.e_jointBit);
			graphDebug.AppendFlags(b2DebugDraw.e_controllerBit);
			graphDebug.SetSprite(this);
			graphDebug.SetDrawScale(1/WORLDSCALE);
			graph.SetDebugDraw(graphDebug);
		}
		
		private function onSessionDataComplete(e:Event):void 
		{
			sceneData = new SceneData();
			sceneData.init(sessionData.settingsFileName);
		}
		
		
		private function onEnterFrame(e:Event):void 
		{
			graph.Step(.033, 20, 20);
			graph.ClearForces();
			//graph.DrawDebugData();
		}
		
		
		
		
		public function createHandle(object:Object, userDataClass:Class, id:int = -1):Handle 
		{
			var handle:Handle = new userDataClass(object, id);
			if (object is b2Body)
			{
				addChild(handle);
			}
			else 
			{
				addChildAt(handle, 0);
			}
			object.SetUserData(handle);
			handlesByID[handle.id] = handle;
			return handle;
		}
		
		private function destroyAllHandles():void 
		{
			Selection.selectAll();
			Destroyer.destroySelected();
		}
		
		protected function onKeyDown(event:KeyboardEvent):void
		{
			switch(event.keyCode)
			{
				case Keyboard.S:
					if(event.ctrlKey) quicksave();
					break;
				case Keyboard.F5:
					quicksave();
					break;
				case Keyboard.F6:
					System.setClipboard(list(exportGraph()));
					break;
				case Keyboard.E:
					if(event.ctrlKey) System.setClipboard(list(exportGraph()));
					break;
				case Keyboard.F9:
					quickload();
					break;
				case Keyboard.F:
					stage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE;
					break;
			}
			
		}
		
		protected function quicksave():void 
		{
			trace("quicksave");
		}
		
		protected function quickload():void
		{
			trace("quickload");
		}
		
		protected function onXMLLoadComplete(e:Event):void
		{
			var xml:XML = XML(xmlLoader.data);
			trace("COMPLETE");
			trace(xml);
			destroyAllHandles();
			importGraph(xml);
			//defaultXML.parseXML(xml.toXMLString());
		}
		
		protected function exportGraph():XML 
		{
			var handle:Handle;
			var descriptionNode:XML;
			var xml:XML = <graph/>;
			for (var body:b2Body = graph.GetBodyList(); body; body = body.GetNext())
			{
				if (body.GetFixtureList())
				{
					var bodyNode:XML = <body/>;
					handle = body.GetUserData() as Handle;
					bodyNode.@id = handle.id;
					bodyNode.@name = handle.name;
					bodyNode.@colorLine = handle.colorLine;
					bodyNode.@colorFill = handle.colorFill;
					bodyNode.@x = body.GetPosition().x;
					bodyNode.@y = body.GetPosition().y;
					bodyNode.@angle = body.GetAngle();
					bodyNode.@linearDamping = body.GetLinearDamping();
					bodyNode.@type = body.GetType();
					bodyNode.@contentType = handle.contentType;
					bodyNode.@userDataClassName = getQualifiedClassName(body.GetUserData());
					descriptionNode = <description/>;
					descriptionNode.text = new XML("<![CDATA[" + handle.description + "]]>");
					bodyNode.appendChild(descriptionNode);
					for (var fixture:b2Fixture = body.GetFixtureList(); fixture; fixture = fixture.GetNext())
					{
						var fixtureNode:XML = <fixture/>;
						fixtureNode.@density = fixture.GetDensity();
						fixtureNode.@friction = fixture.GetFriction();
						fixtureNode.@restitution = fixture.GetRestitution();
						bodyNode.appendChild(fixtureNode);
						var shape:b2Shape = fixture.GetShape();
						var shapeNode:XML = <shape/>;
						shapeNode.@className = getQualifiedClassName(shape);
						if (shape is b2CircleShape)
						{
							var shapeCircle:b2CircleShape = shape as b2CircleShape;
							shapeNode.@radius = shapeCircle.GetRadius();
							shapeNode.@x = shapeCircle.GetLocalPosition().x;
							shapeNode.@y = shapeCircle.GetLocalPosition().y;
						}
						fixtureNode.appendChild(shapeNode);
					}
					
					xml.appendChild(bodyNode);
				}
			}
			
			for (var joint:b2Joint = graph.GetJointList(); joint; joint = joint.GetNext())
			{
				if(!(joint is b2DistanceJoint))
				{
					continue;
				}
				var jointNode:XML = <joint/>;
				handle = joint.GetUserData() as Handle;
				jointNode.@id = handle.id;
				jointNode.@name = handle.name;
				jointNode.@colorLine = handle.colorLine;
				jointNode.@colorFill = handle.colorFill;
				jointNode.@className = getQualifiedClassName(joint);
				if (joint is b2DistanceJoint)
				{
					var jointDistance:b2DistanceJoint = joint as b2DistanceJoint;
					jointNode.@length = jointDistance.GetLength();
					jointNode.@dampingRatio = jointDistance.GetDampingRatio();
					jointNode.@frequency = jointDistance.GetFrequency();
				}
				jointNode.@bodyAid = (joint.GetBodyA().GetUserData() as Handle).id;
				jointNode.@bodyBid = (joint.GetBodyB().GetUserData() as Handle).id;
				jointNode.@contentType = handle.contentType;
				jointNode.@userDataClassName = getQualifiedClassName(handle);
				descriptionNode = <description/>;
				descriptionNode.text = new XML("<![CDATA[" + handle.description + "]]>");
				jointNode.appendChild(descriptionNode);
				xml.appendChild(jointNode);
			}
			return xml;
		}
		
		protected function importGraph(xml:XML):void 
		{
			var handle:Handle;
			for each (var bodyNode:XML in xml.body)
			{
				var bodyDef:b2BodyDef = new b2BodyDef();
				bodyDef.position.x = Number(bodyNode.@x);
				bodyDef.position.y = Number(bodyNode.@y);
				bodyDef.angle = Number(bodyNode.@angle);
				bodyDef.type = int(bodyNode.@type);
				bodyDef.linearDamping = Number(bodyNode.@linearDamping);
				var body:b2Body = graph.CreateBody(bodyDef);
				atmosphere.AddBody(body);
				waterline.AddBody(body);
				for each(var fixtureNode:XML in bodyNode.fixture)
				{
					var fixtureDef:b2FixtureDef = new b2FixtureDef();
					fixtureDef.friction = Number(fixtureNode.@friction);
					fixtureDef.density = Number(fixtureNode.@density);
					fixtureDef.restitution = Number(fixtureNode.@restitution);
					for each(var shapeNode:XML in fixtureNode.shape)
					{
						switch(getDefinitionByName(shapeNode.@className))
						{
							case b2CircleShape:
								var shapeCircle:b2CircleShape = new b2CircleShape(Number(shapeNode.@radius));
								shapeCircle.SetLocalPosition(new b2Vec2(Number(shapeNode.@x), Number(shapeNode.@y)));
								fixtureDef.shape = shapeCircle;
								break;
							default:
						}
					}
					body.CreateFixture(fixtureDef);
				}
				handle = createHandle(body, getDefinitionByName(bodyNode.@userDataClassName) as Class, bodyNode.@id);
				handle.name = bodyNode.@name;
				handle.colorLine = bodyNode.@colorLine;
				handle.colorFill = bodyNode.@colorFill;
			}
			
			for each (var jointNode:XML in xml.joint)
			{
				var jointDef:b2DistanceJointDef = new b2DistanceJointDef();
				jointDef.bodyA = (handlesByID[int(jointNode.@bodyAid)] as CircleHandle).body;
				jointDef.bodyB = (handlesByID[int(jointNode.@bodyBid)] as CircleHandle).body;
				jointDef.length = jointNode.@length;
				jointDef.frequencyHz = jointNode.@frequency;
				jointDef.dampingRatio = jointNode.@dampingRatio;
				var joint:b2Joint = graph.CreateJoint(jointDef);
				handle = createHandle(joint, getDefinitionByName(jointNode.@userDataClassName) as Class, jointNode.@id);
				handle.colorLine = jointNode.@colorLine;
				handle.colorFill = jointNode.@colorFill;
			}
		}
		
		protected function list(xml:XML):String 
		{
			var fileSuffix:String = ".flv"
			var list:String = "";
			list += "Locations:\r\n";
			var bodyNode:XML;
			for each (bodyNode in xml.body)
			{
				if (bodyNode.@contentType == ContentType.LOCATION)
				{
					var locationName:String = StringUtils.nameToTransitionName(bodyNode.description);
					list += "\t" + locationName + fileSuffix + "\r\n";
				}
			}
			list += "Transitions:\r\n";
			for each (var jointNode:XML in xml.joint)
			{
				if (jointNode.@contentType == ContentType.TRANSITION)
				{
					var transitionName:String = StringUtils.nameToTransitionName(jointNode.description);
					var status:String = "";
					if (uint(jointNode.@colorLine) == 16744192) status += " ---- PREVIS supplied";
					else if (uint(jointNode.@colorLine) == 16776960) status += " ---- DRAFT supplied";
					else if (uint(jointNode.@colorLine) == 8388352) status += " ---- FINAL supplied";
					else if (uint(jointNode.@colorLine) == 16711680) status += " ---- PROBLEM: supplied animation was corrupted?";
					
					list += "\t" + transitionName + fileSuffix + status + "\r\n";
				}
			}
			list += "Actions:\r\n";
			for each (bodyNode in xml.body)
			{
				if (bodyNode.@contentType == ContentType.ACTION)
				{
					var actionName:String = StringUtils.nameToActionName(bodyNode.description);
					list += "\t" + actionName + fileSuffix + "\r\n";
				}
			}
			trace(list);
			return list;
		}
	}

}