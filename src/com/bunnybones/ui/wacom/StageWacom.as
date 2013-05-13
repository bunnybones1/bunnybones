package com.bunnybones.ui.wacom 
{
	import com.gugga.events.LocaleEvent;
	import com.wacom.maxi.core.DockConnectionManager;
	import com.wacom.maxi.core.DockConnectionManagerSettings;
	import com.wacom.mini.core.BambooMiniImpl;
	import com.wacom.mini.core.chrome.ChromeSettings;
	import com.wacom.mini.core.tablet.ITabletState;
	import com.wacom.mini.core.tablet.TabletEvent;
	import com.wacom.mini.flash.BambooMiniGlobals;
	import com.wacom.mini.flash.FlashFactory;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.StageOrientationEvent;
	/**
	 * ...
	 * @author Tomasz Dysinski
	 */
	public class StageWacom
	{
		static private var _instance:StageWacom;
		
		private var bambooDockBridge:BambooMiniImpl;
		private var _dockConnection:DockConnectionManager;
		
		private var stage:Stage;
		private var pressureBindings:Vector.<ValueBinding>;
		public function StageWacom() 
		{
			
		}
		
		private function onConnectionOpenedHandler(e:Event):void 
		{
			//dtrace(e);
		}
		 
		private function onLocaleChanged(evt:LocaleEvent):void
		{
		  //Change the AIR Mini language
		}
		 
		private function onConnectionClosedHandler(evt:Event):void
		{
		  //Do actions for proper close of application
		  //...
		  //nativeApplication.exit();
		}
		
		public function bind(stage:Stage, base:DisplayObjectContainer):void 
		{
			dtrace("StageWacom bound to stage.!!");
			this.stage = stage;
			bambooDockBridge = new BambooMiniImpl(base, new FlashFactory(new ChromeSettings(false)), 1024, 768);

			var settings:DockConnectionManagerSettings = new DockConnectionManagerSettings();
			settings.closeOnExit=false;
			settings.dispatchTabletEvents=true;
			settings.mini=bambooDockBridge;
			settings.usePressure=true;
			settings.windowedApplication=base;
			_dockConnection = new DockConnectionManager();
			//we need to make this only if we need to handle some special cases during exit
			_dockConnection.addEventListener(Event.CLOSE, onConnectionClosedHandler, false, 0, true);

			_dockConnection.addEventListener(LocaleEvent.LOCALE_CHANGED, onLocaleChanged, false, 0, true);
			_dockConnection.settings=settings;
			bambooDockBridge.bambooMiniDescriptor = new XML("<descriptor></descriptor>");
			BambooMiniGlobals.dispatchTabletEvents = true;
			pressureBindings = new Vector.<ValueBinding>;
			stage.addEventListener(TabletEvent.PEN_PRESSURE_CHANGE, onPressureChange);
			//stage.addEventListener(Event.ENTER_FRAME, onEnterFrameCheckTablet);
		}
		
		private function onEnterFrameCheckTablet(e:Event):void 
		{
			var state:ITabletState = BambooMiniGlobals.tabletState;
		}
		
		private function onPressureChange(e:TabletEvent):void 
		{
			var pressureRatio:Number = e.pressure / 1024;
			for each(var pressureBinding:ValueBinding in pressureBindings) {
				pressureBinding.applyValue(pressureRatio);
			}
		}
		
		public function bindPressureValue(object:Object, propName:String):void 
		{
			pressureBindings.push(new ValueBinding(object, propName));
		}
		
		static public function get instance():StageWacom 
		{
			if (_instance) return _instance;
			else return _instance = new StageWacom();
		}
		
	}

}

class ValueBinding {
	private var object:Object;
	private var propName:String;
	public function ValueBinding(object:Object, propName:String = "x") {
		this.propName = propName;
		this.object = object;
	}
	
	public function applyValue(value:Object):void 
	{
		object[propName] = value;
	}
	
}