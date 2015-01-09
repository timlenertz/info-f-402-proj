Polygon2D polygon;
Line2D L;
Point2D i1, i2;

class Updater extends Object2D {	
	Object2D update() {
		i1.visible = false;
		i2.visible = false;

		if(! polygon.isConvex()) { polygon.strokeColor = #ff0000; return; }
		else polygon.strokeColor = #000000;
		
		int n = polygon.points.size();
		Object[] f = new float[n], g = new float[n];
		for(int i = 0; i < n; ++i) {
			f[i] = {i, polygon.pointOrientedDistanceToLine(i, L, polygon.points.get(0))};
			g[i] = {i, polygon.pointOrientedDistanceToLineG(i, L, polygon.points.get(0))};
		}

		document.linePolygonIntersectionPlot.setData([g, f]);
		document.linePolygonIntersectionPlot.setupGrid();
		document.linePolygonIntersectionPlot.draw();
		
		Point2D[] intersection = polygon.lineIntersection(L);
		if(intersection.length == 1) {
			i1.visible = true;
			i1.x = intersection[0].x;
			i1.y = intersection[0].y;
		} else if(intersection.length == 2) {
			i1.visible = true;
			i1.x = intersection[0].x;
			i1.y = intersection[0].y;
			i2.visible = true;
			i2.x = intersection[1].x;
			i2.y = intersection[1].y;			
		}
	}
}

void setup() {
	polygon = Polygon2D.generateRandomConvex(12, new PVector(10, 40), new PVector(140, 260));
	L = new Line2D(new Point2D(100, 80), new Point2D(140, 230));
	L.strokeColor = #0000ff; L.label = "L";
	i1 = new Point2D(0, 0);
	i2 = new Point2D(0, 0);
	i1.strokeColor = #ff0000; i1.label = "I1"; i1.visible = true; i1.draggable = false;
	i2.strokeColor = #ff0000; i2.label = "I2"; i2.visible = true; i2.draggable = false;
	line.label = "L";
	polygon.label = "P";
	for(int i = 0; i < polygon.points.size(); ++i) polygon.points.get(i).label = "p"+(i+1);
	
	polygon.points.get(0).strokeColor = #0000ff;
	scene.add(L.a).add(L.b).add(L).addAll(polygon.points).add(polygon).add(i1).add(i2);
	scene.add(new Updater);
			
	size(300, 300);
}
