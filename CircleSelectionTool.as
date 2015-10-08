package {
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	* ...
	* @author Mad Mike
	*/
	public class CircleSelectionTool extends MovieClip {
		private var area:MovieClip;
		private var locationStart:Point;
		private var locationFinish:Point;
		
		public function CircleSelectionTool(parent:DisplayObjectContainer) {
			parent.addChild(this);
			parent.stage.addEventListener(MouseEvent.MOUSE_DOWN, start);
		}
		
		private function start(e:MouseEvent):void {
			if (e.ctrlKey) return void;
			locationStart = new Point(e.stageX, e.stageY);
			locationFinish = locationStart.clone();
			locationFinish.x += 1;
			locationFinish.y += 1;
			area = new MovieClip();
			area.graphics.beginFill(0xFFFF80, 0.3);
			area.graphics.drawCircle(0, 0, 1);
			area.graphics.endFill();
			area.x = locationStart.x;
			area.y = locationStart.y;
			addChild(area);
			parent.stage.removeEventListener(MouseEvent.MOUSE_DOWN, start);
			parent.stage.addEventListener(MouseEvent.MOUSE_UP, select);
			parent.stage.addEventListener(MouseEvent.MOUSE_MOVE, move);
		}
		
		private function move(e:MouseEvent):void {
			locationFinish = new Point(e.stageX, e.stageY);
			if (locationStart.x == locationFinish.x) {
				locationFinish.x++;
			}
			if (locationStart.y == locationFinish.y) {
				locationFinish.y++;
			}
			var areaRadius:Number = Point.distance(locationStart, locationFinish);
			area.graphics.clear();
			area.graphics.beginFill(0xFFFF80, 0.5);
			area.graphics.drawCircle(0, 0, areaRadius);
			area.graphics.endFill();
		}
		
		private function select(e:MouseEvent):void {
			var areaX:Number = (locationStart.x < locationFinish.x)?locationStart.x:locationFinish.x;
			var areaY:Number = (locationStart.y < locationFinish.y)?locationStart.y:locationFinish.y;
			var areaRadius:Number = Point.distance(locationStart, locationFinish);
			Generals.checkCircleSelection(new Point(area.x, area.y), areaRadius);
			area.graphics.clear();
			removeChild(area);
			parent.stage.removeEventListener(MouseEvent.MOUSE_UP, select);
			parent.stage.addEventListener(MouseEvent.MOUSE_DOWN, start);
		}
	
	}
}