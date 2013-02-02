package com.bunnybones.away3d.pano.tools 
{
	import away3d.containers.Scene3D;
	import away3d.materials.TextureMaterial;
	import com.bunnybones.color.Color;
	import com.bunnybones.away3d.pano.Layer;
	import away3d.events.MouseEvent3D;
	import com.bunnybones.away3d.pano.LayerMaker;
	import com.bunnybones.away3d.pano.LayerManager;
	import com.bunnybones.ui.keyboard.StageKeyBoard;
	import com.greensock.TweenLite;
	import flash.geom.Point;
	import flash.ui.Keyboard;
	/**
	 * ...
	 * @author Tomasz Dysinski
	 */
	public class ColorPicker 
	{
		static private var lastUV:Point;
		static private var _active:Boolean = false;
		static private var layerManager:LayerManager;
		
		public function ColorPicker() 
		{
		}
		
		static public function bind(layerManager:LayerManager):void
		{
			ColorPicker.layerManager = layerManager;
			StageKeyBoard.bindKey(Keyboard.ALTERNATE, enableColorPicking, disableColorPicking, false, false, true, true);
			dtrace("ColorPicker initd");
		}
		
		static private function enableColorPicking():void 
		{
			if (!Brush.layer) return;
			if (active) return;
			active = true;
			Brush.active = false;
			Brush.layer.addEventListener(MouseEvent3D.MOUSE_DOWN, onMouseDownLayer);
		}
		
		static private function disableColorPicking():void 
		{
			if (!Brush.layer) return;
			active = false;
			Brush.active = true;
			Brush.layer.removeEventListener(MouseEvent3D.MOUSE_DOWN, onMouseDownLayer);
		}
		
		static private function onMouseDownLayer(e:MouseEvent3D):void 
		{
			var layer:Layer = e.target as Layer;
			dtrace(layer.name);
			layer.addEventListener(MouseEvent3D.MOUSE_UP, onMouseUpLayer);
			layer.addEventListener(MouseEvent3D.MOUSE_MOVE, onMouseMoveLayer);
			lastUV = e.uv;
		}
		
		static private function onMouseMoveLayer(e:MouseEvent3D):void 
		{
			var multilayerSample:Color = new Color(0);
			for each (var layer:Layer in layerManager.layers) 
			{
				multilayerSample.blend(new Color(layer.sampleAtUV(e.uv), true), (layer.material as TextureMaterial).alpha, true);
				dtrace(layer.name);
			}
			Brush.brushColor.r = multilayerSample.r;
			Brush.brushColor.g = multilayerSample.g;
			Brush.brushColor.b = multilayerSample.b;
		}
		
		static private function onMouseUpLayer(e:MouseEvent3D):void 
		{
			var layer:Layer = e.target as Layer;
			layer.removeEventListener(MouseEvent3D.MOUSE_MOVE, onMouseMoveLayer);
			layer.removeEventListener(MouseEvent3D.MOUSE_UP, onMouseUpLayer);
		}
		
		static public function get active():Boolean 
		{
			return _active;
		}
		
		static public function set active(value:Boolean):void 
		{
			dtrace("colorpicker active", value);
			_active = value;
		}

	}

}