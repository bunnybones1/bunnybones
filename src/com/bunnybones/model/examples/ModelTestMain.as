package com.bunnybones.model.examples 
{
	import com.bunnybones.console.Console;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedSuperclassName;
	import flash.utils.getQualifiedClassName;
	
	/**
	 * ...
	 * @author Tomasz Dysinski
	 */
	public class ModelTestMain extends Sprite 
	{
		
		public function ModelTestMain() 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			init();
		}
		
		public function init():void
		{
			addChild(new Console(this));
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			generateModel();
		}
		
		public function generateModel():void
		{
			var model:DemoModel = new DemoModel();
			model.color = "BLACK" + String(Math.round(Math.random()*0xffff));
			var model2:DemoModel = new DemoModel();
			model2.color = "BLACK";
			
			var model3:DemoModel = DemoModel.fromXML(model.composeXML());
			model3.name = "hi";
			var model4:DemoModel = DemoModel.fromXML(model2.composeXML());
			
			var xml:XML = <xml />;
			xml.appendChild(model.composeXML());
			xml.appendChild(model2.composeXML());
			xml.appendChild(model3.composeXML());
			xml.appendChild(model4.composeXML());
			//xml.appendChild(textTemplate.composeXML());
			trace(xml);
		}
		
	}

}