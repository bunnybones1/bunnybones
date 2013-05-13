package com.bunnybones.away3d.pano 
{
	import away3d.containers.Scene3D;
	import com.bunnybones.away3d.pano.tools.Brush;
	import com.bunnybones.MouseToolTip;
	import com.bunnybones.panoPainter.model.PanoramaModel;
	import com.bunnybones.panoPainter.model.PanoramaLayerModel;
	import com.bunnybones.ui.keyboard.StageKeyBoard;
	import flash.display.BitmapModel;
	import flash.ui.Keyboard;
	/**
	 * ...
	 * @author Tomasz Dysinski
	 */
	public class LayerManager 
	{
		private var _model:PanoramaModel;
		private var _layers:Vector.<Layer> = new Vector.<Layer>;
		private var _currentLayer:Layer;
		private var _scene:Scene3D;
		public function LayerManager(scene:Scene3D) 
		{
			this.scene = scene;
			StageKeyBoard.bindKey("New Layer", Keyboard.L, newLayer, null, true);
			StageKeyBoard.bindKey("Next Layer", Keyboard.PAGE_DOWN, drawOnNextLayer);
			StageKeyBoard.bindKey("Prev Layer", Keyboard.PAGE_UP, drawOnPreviousLayer);
		}
		
		private function drawOnNextLayer():void 
		{
			currentLayer = _layers[(_layers.indexOf(_currentLayer) + 1) % _layers.length];
		}
		
		private function drawOnPreviousLayer():void 
		{
			currentLayer = _layers[(_layers.indexOf(_currentLayer) - 1 + _layers.length) % _layers.length];
		}
		
		public function newLayer(model:PanoramaLayerModel = null, source:BitmapModel = null, name:String = "new layer", flip:Boolean = true, blink:Boolean = false, drawable:Boolean = true):void
		{
			model = model || new PanoramaLayerModel();
			var layer:Layer = new Layer(model, source, name, flip, blink, drawable);
			//if(currentLayer) layer.radius = currentLayer.radius - 1;
			this.model.addLayer(model);
			_scene.addChild(layer);
			layers.push(layer);
			layer.scaleX = layer.scaleY = layer.scaleZ = 1 / layers.length;
			currentLayer = layer;
			//trace("scale", layer.scaleX);
		}
		
		public function deleteLayer(currentLayer:Layer):void 
		{
			_scene.removeChild(currentLayer);
			layers.splice(layers.indexOf(currentLayer), 1);
			currentLayer = null;
		}
		
		public function reset():void 
		{
			var totalChildren:int = _scene.numChildren;
			for (var i:int = totalChildren - 1; i > 0; i--) {
				_scene.removeChild(_scene.getChildAt(i));
			}
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
		
		public function set scene(value:Scene3D):void 
		{
			_scene = value;
		}
		
		public function get model():PanoramaModel 
		{
			return _model;
		}
		
		public function set model(value:PanoramaModel):void 
		{
			_model = value;
		}
	}

}