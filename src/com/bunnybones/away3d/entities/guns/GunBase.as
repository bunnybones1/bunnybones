package com.bunnybones.away3d.entities.guns 
{
	import away3d.core.base.Geometry;
	import away3d.entities.Entity;
	import away3d.entities.Mesh;
	import away3d.materials.ColorMaterial;
	import away3d.materials.MaterialBase;
	import away3d.primitives.CylinderGeometry;
	
	/**
	 * ...
	 * @author Tomasz Dysinski
	 */
	public class GunBase extends Mesh 
	{
		private var _button0:Boolean;
		private var _button1:Boolean;
		private var _button2:Boolean;
		private var _button3:Boolean;
		private var _button4:Boolean;
		private var _button5:Boolean;
		private var _button6:Boolean;
		private var _button7:Boolean;
		private var _button8:Boolean;
		private var _button9:Boolean;
		public var button10:Boolean;
		public var button11:Boolean;
		public var button12:Boolean;
		public var button13:Boolean;
		public var button14:Boolean;
		public var button15:Boolean;
		
		public function GunBase() 
		{
			super(generateGeometry(), generateMaterial());
			rotationX = 90;
			rotationZ = 90;
		}
		
		protected function generateMaterial():MaterialBase 
		{
			return new ColorMaterial();
		}
		
		protected function generateGeometry():Geometry 
		{
			return new CylinderGeometry(.1, .1, 1, 32);
		}
		
		public function get button0():Boolean 
		{
			return _button0;
		}
		
		public function set button0(value:Boolean):void 
		{
			if (value) dtrace("select");
			_button0 = value;
		}
		
		public function get button1():Boolean 
		{
			return _button1;
		}
		
		public function set button1(value:Boolean):void 
		{
			if (value) dtrace("back");
			_button1 = value;
		}
		
		public function get button4():Boolean 
		{
			return _button4;
		}
		
		public function set button4(value:Boolean):void 
		{
			if (value) dtrace("bumper_left");
			_button4 = value;
		}
		
		public function get button5():Boolean 
		{
			return _button5;
		}
		
		public function set button5(value:Boolean):void 
		{
			if (value) dtrace("bumper_right");
			_button5 = value;
		}
		
		public function get button8():Boolean 
		{
			return _button8;
		}
		
		public function set button8(value:Boolean):void 
		{
			if (value) dtrace("analog_stick_left");
			_button8 = value;
		}
		
		public function get button9():Boolean 
		{
			return _button9;
		}
		
		public function set button9(value:Boolean):void 
		{
			if (value) dtrace("analog_stick_right");
			_button9 = value;
		}
		
		public function get button6():Boolean 
		{
			return _button6;
		}
		
		public function set button6(value:Boolean):void 
		{
			if (value) dtrace("select");
			_button6 = value;
		}
		
		public function get button7():Boolean 
		{
			return _button7;
		}
		
		public function set button7(value:Boolean):void 
		{
			if (value) dtrace("start");
			_button7 = value;
		}
		
		public function get button2():Boolean 
		{
			return _button2;
		}
		
		public function set button2(value:Boolean):void 
		{
			if (value) dtrace("X");
			_button2 = value;
		}
		
		public function get button3():Boolean 
		{
			return _button3;
		}
		
		public function set button3(value:Boolean):void 
		{
			if (value) dtrace("Y");
			_button3 = value;
		}
		
		
		
	}

}