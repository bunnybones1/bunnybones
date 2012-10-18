package com.bunnybones.scenegrapher 
{
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.Joints.b2DistanceJoint;
	import Box2D.Dynamics.Joints.b2DistanceJointDef;
	import Box2D.Dynamics.Joints.b2JointEdge;
	import Box2D.Dynamics.Joints.b2WeldJointDef;
	import com.bunnybones.scenegrapher.tools.Destroyer;
	import com.bunnybones.MouseToolTip;
	import com.bunnybones.scenegrapher.tools.Selection;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.ui.Keyboard;
	
	/**
	 * ...
	 * @author Tomasz Dysinski
	 */
	public class LabelledCircleHandle extends CircleHandle 
	{
		private var textfield:TextField;
		
		public function LabelledCircleHandle(body:b2Body, id:int = -1)
		{
			super(body, id);
		}
		
		override protected function onAddedToStage(e:Event):void 
		{
			super.onAddedToStage(e);
			addEventListener(MouseEvent.DOUBLE_CLICK, onDoubleClick);
			addEventListener(MouseEvent.ROLL_OVER, onRollOver);
			addEventListener(MouseEvent.ROLL_OUT, onRollOut);
			var textFormat:TextFormat = new TextFormat("Arial", 16, 0xffffff);
			textfield = new TextField();
			textfield.defaultTextFormat = textFormat;
			textfield.width = 1;
			textfield.y = -10;
			textfield.autoSize = TextFieldAutoSize.CENTER;
			textfield.multiline = false;
			textfield.mouseEnabled = false;
			//textfield.background = true;
			textfield.backgroundColor = 0x202020;
			addChild(textfield);
			textfield.addEventListener(Event.CHANGE, onTextChange);
			name = "Hello World";
			contentType = ContentType.LOCATION;
		}
		
		private function onTextChange(e:Event):void 
		{
			if (!parent) return;
			var diagnalLength:Number = Math.sqrt(Math.pow(textfield.textWidth, 2) + Math.pow(textfield.textHeight, 2));
			textfield.scaleX = textfield.scaleY = (radius * 1.7 / diagnalLength) / SceneGrapherMain.WORLDSCALE;
			textfield.y = textfield.height * -.5;
		}
		
		private function onDoubleClick(e:MouseEvent):void 
		{
			initRename();
		}
		
		override public function initRename():void 
		{
			Selection.deselectAll();
			textfield.type = TextFieldType.INPUT;
			stage.focus = textfield;
			textfield.background = true;
			textfield.transform.colorTransform = new ColorTransform(-1, -1, -1, 1, 255, 255, 225, 0);
			textfield.setSelection(0, textfield.length);
			textfield.addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStageTextfield);
			textfield.addEventListener(FocusEvent.FOCUS_OUT, onTextFocusOut);
			textfield.addEventListener(KeyboardEvent.KEY_DOWN, onTextKeyDown);
		}
		
		private function onRemovedFromStageTextfield(e:Event):void 
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStageTextfield);
			textfield.addEventListener(FocusEvent.FOCUS_OUT, onTextFocusOut);
			textfield.addEventListener(KeyboardEvent.KEY_DOWN, onTextKeyDown);
		}
		
		private function onTextKeyDown(e:KeyboardEvent):void 
		{
			if (e.keyCode == Keyboard.ENTER)
			{
				stage.focus = null;
			}
			else if (e.keyCode == Keyboard.ESCAPE || (e.keyCode == Keyboard.B && e.ctrlKey))
			{
				textfield.text = name;
				stage.focus = null;
			}
		}
		
		private function onTextFocusOut(e:FocusEvent):void 
		{
			name = textfield.text;
			removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStageTextfield);
			textfield.removeEventListener(FocusEvent.FOCUS_OUT, onTextFocusOut);
			textfield.removeEventListener(KeyboardEvent.KEY_DOWN, onTextKeyDown);
			textfield.type = TextFieldType.DYNAMIC;
			textfield.background = false;
			textfield.transform.colorTransform = new ColorTransform(1, 1, 1, 1, 0, 0, 0, 0);
		}
		
		override protected function onRemovedFromStage(e:Event):void 
		{
			removeEventListener(MouseEvent.DOUBLE_CLICK, onDoubleClick);
			textfield.addEventListener(Event.CHANGE, onTextChange);
			removeEventListener(MouseEvent.ROLL_OVER, onRollOver);
			removeEventListener(MouseEvent.ROLL_OUT, onRollOut);
			super.onRemovedFromStage(e);
		}
		
		private function onRollOver(e:MouseEvent):void 
		{
			MouseToolTip.show(description);
		}
		
		private function onRollOut(e:MouseEvent):void 
		{
			MouseToolTip.hide();
		}
		
		override public function set name(value:String):void
		{
			textfield.text = value;
			super.name = value;
			onTextChange(null);
		}
		
		override public function get description():String
		{
			
			super.description = StringUtils.nameToTransitionName(name);
			for (var jointEdge:b2JointEdge = body.GetJointList(); jointEdge; jointEdge = jointEdge.next)
			{
				var handle:Handle = jointEdge.joint.GetUserData();
				if (handle is ConnectionLoop && body == jointEdge.joint.GetBodyB())
				{
					super.description = StringUtils.nameToActionName(handle.name);
				}
			}
			return super.description;
		}
	}

}