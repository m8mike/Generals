package {
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	* ...
	* @author Mad Mike
	*/
	public class Generals extends MovieClip {
		private static var units:Array = [];
		private static var selectedUnits:Array = [];
		
		private static var buildings:Array = [];
		
		public function Generals() {
			units.push(new Unit(this, new Point(100, 100)));
			units.push(new Unit(this, new Point(100, 160)));
			units.push(new Unit(this, new Point(100, 260)));
			units.push(new Unit(this, new Point(100, 360)));
			units.push(new Unit(this, new Point(150, 120)));
			units.push(new Unit(this, new Point(290, 130)));
			units.push(new Unit(this, new Point(200, 220)));
			units.push(new Unit(this, new Point(300, 160)));
			units.push(new Unit(this, new Point(300, 60)));
			buildings.push(new Building(this, new Point(400, 140)));
			new CircleSelectionTool(this);
			stage.addEventListener(MouseEvent.CLICK, send);
			addEventListener(Event.ENTER_FRAME, gameCycle);
		}
		
		private function gameCycle(e:Event):void {
			for each (var unit:Unit in units) {
				unit.update();
				var rect:Rectangle = new Rectangle(unit.location.x - 15, unit.location.y - 15, 20, 20);
				checkIntersection(rect, unit);
			}
			for each (var building:Building in buildings) {
				checkIntersection(building.rect);
			}
		}
		
		private function send(e:MouseEvent):void {
			if (!e.ctrlKey) return void;
			var destination:Point = new Point(e.stageX, e.stageY);
			for each (var unit:Unit in selectedUnits) {
				unit.sendTo(destination, selectedUnits.indexOf(unit));
			}
		}
		
		public static function checkIntersection(rect:Rectangle, pusher:Unit = null):void {
			for each (var unit:Unit in units) {
				if (unit == pusher) {
					continue;
				}
				if (unit.checkIntersection(rect)) {
					unit.pushFrom(rect);
				}
			}
		}
		
		public static function selectUnit(unitToSelect:Unit):void {
			for each (var unit:Unit in selectedUnits) {
				unit.diselect();
			}
			selectedUnits = [];
			unitToSelect.select();
			selectedUnits.push(unitToSelect);
		}
		
		public static function checkSelection(rect:Rectangle):void {
			for each (var unit:Unit in units) {
				if (unit.checkSelection(rect)) {
					if (selectedUnits.indexOf(unit) == -1) {
						selectedUnits.push(unit);
					}
				} else if (selectedUnits.indexOf(unit) != -1) {
					selectedUnits.splice(selectedUnits.indexOf(unit), 1);
				}
			}
		}
		
		public static function checkCircleSelection(center:Point, areaRadius:Number):void {
			for each (var unit:Unit in units) {
				var inside:Boolean = Point.distance(unit.location, center) <= areaRadius;
				if (inside) {
					if (selectedUnits.indexOf(unit) == -1) {
						selectedUnits.push(unit);
						unit.select();
					}
				} else {
					if (selectedUnits.indexOf(unit) != -1) {
						selectedUnits.splice(selectedUnits.indexOf(unit), 1);
					}
					unit.diselect();
				}
			}
		}
	}
}