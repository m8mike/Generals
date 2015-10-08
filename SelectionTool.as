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
	public class SelectionTool extends MovieClip {
		private var area:MovieClip;
		private var locationStart:Point;
		private var locationFinish:Point;
		
		public function SelectionTool(parent:DisplayObjectContainer) {
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
			area.graphics.drawRect(0, 0, 1, 1);
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
			var areaWidth:Number = Math.abs(locationStart.x - locationFinish.x);
			var areaHeight:Number = Math.abs(locationStart.y - locationFinish.y);
			var areaX:Number = 0;
			var areaY:Number = 0;
			if (locationStart.x < locationFinish.x) {
				areaX = locationStart.x;
			} else {
				areaX = locationFinish.x;
			}
			if (locationStart.y < locationFinish.y) {
				areaY = locationStart.y;
			} else {
				areaY = locationFinish.y;
			}
			area.graphics.clear();
			area.graphics.beginFill(0xFFFF80, 0.3);
			area.graphics.drawRect(0, 0, areaWidth, areaHeight);
			area.graphics.endFill();
			area.x = areaX;
			area.y = areaY;
		}
		
		private function select(e:MouseEvent):void {
			var rectX:Number = (locationStart.x < locationFinish.x)?locationStart.x:locationFinish.x;
			var rectY:Number = (locationStart.y < locationFinish.y)?locationStart.y:locationFinish.y;
			var rectW:Number = Math.abs(locationStart.x - locationFinish.x);
			var rectH:Number = Math.abs(locationStart.y - locationFinish.y);
			Generals.checkSelection(new Rectangle(rectX, rectY, rectW?rectW:1, rectH?rectH:1));
			area.graphics.clear();
			removeChild(area);
			parent.stage.removeEventListener(MouseEvent.MOUSE_UP, select);
			parent.stage.addEventListener(MouseEvent.MOUSE_DOWN, start);
		}
	
	}
}