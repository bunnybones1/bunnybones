package com.bunnybones.away3d.pano 
{
	import away3d.containers.Scene3D;
	import com.bunnybones.away3d.pano.tools.Brush;
	import com.bunnybones.MouseToolTip;
	import com.bunnybones.ui.keyboard.StageKeyBoard;
	import flash.display.BitmapData;
	import flash.ui.Keyboard;
	/**
	 * ...
	 * @author Tomasz Dysinski
	 */
	public class LayerManager 
	{
		
		private var _layers:Vector.<Layer> = new Vector.<Layer>;
		private var _currentLayer:Layer;
		private var scene:Scene3D;
		public function LayerManager(scene:Scene3D) 
		{
			this.scene = scene;
			StageKeyBoard.bindKey(Keyboard.N, initNewLayer, null, true);
			StageKeyBoard.bindKey(Keyboard.M, initNewLayer, null, true);
			StageKeyBoard.bindKey(Keyboard.PAGE_DOWN, drawOnNextLayer);
			StageKeyBoard.bindKey(Keyboard.PAGE_UP, drawOnPreviousLayer);
		}
		
		private function drawOnNextLayer():void 
		{
			currentLayer = _layers[(_layers.indexOf(_currentLayer) + 1) % _layers.length];
		}
		
		private function drawOnPreviousLayer():void 
		{
			currentLayer = _layers[(_layers.indexOf(_currentLayer) - 1 + _layers.length) % _layers.length];
		}
		
		private function initNewLayer():void 
		{
			LayerMaker.visit(this, "newLayerDrawable");
		}
		
		public function newLayerDrawable(source:BitmapData = null, name:String = "new layer"):void
		{
			newLayer(source, name, false, false, true);
		}
		
		public function newLayer(source:BitmapData = null, name:String = "new layer", flip:Boolean = true, blink:Boolean = true, drawable:Boolean = false):void
		{
			var layer:Layer = new Layer(source, name, flip, blink, drawable);
			//if(currentLayer) layer.radius = currentLayer.radius - 1;
			scene.addChild(layer);
			layers.push(layer);
			layer.scaleX = layer.scaleY = layer.scaleZ = 1 / layers.length;
			currentLayer = layer;
			trace("scale", layer.scaleX);
		}
		
		public function deleteLayer(currentLayer:Layer):void 
		{
			scene.removeChild(currentLayer);
			layers.splice(layers.indexOf(currentLayer), 1);
			currentLayer = null;
		}
		
		public function get currentLayer():Layer 
		{
			return _currentLayer;
		}
		
		public function set currentLayer(value:Layer):void 
		{
			_currentLayer = value;
			if (_currentLayer.drawable)
			{
				Brush.initBrush(_currentLayer);
				MouseToolTip.notify("drawing on Layer: " + _currentLayer.name);
			}
		}
		
		public function get layers():Vector.<Layer> 
		{
			return _layers;
		}
	}

}