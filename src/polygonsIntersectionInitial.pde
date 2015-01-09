Polygon2D P, Q;
Point2D X, Y;

class Updater extends Object2D {
	Ray2D[] pencilP_; // origin in P, encloses Q
	Ray2D[] pencilQ_; // origin in Q, encloses P
	
	void update_() {
		pencilP_ = null; pencilQ_ = null;
		
		pencilP_ = P.pencilOrIntersectionPoint(Q);
		pencilQ_ = Q.pencilOrIntersectionPoint(P);
	}
	

	Object2D update() {
		boolean convex = true;		
		if(! P.isConvex()) { P.strokeColor = #FF0000; convex = false; }
		else P.strokeColor = #000000;
		if(! Q.isConvex()) { Q.strokeColor = #FF0000; convex = false; }
		else Q.strokeColor = #000000;
	
		for(int i = 0; i < P.points.size(); ++i) P.points.get(i).label = null;
		for(int i = 0; i < Q.points.size(); ++i) Q.points.get(i).label = null;
	
		if(convex) update_();
		
		Point2D nX = pencilP_[0].lineIntersection(pencilQ_[1]);
		if(nX != null) { X.x = nX.x; X.y = nX.y; X.visible = true; }
		else X.visible = false;
		
		Point2D nY = pencilP_[1].lineIntersection(pencilQ_[0]);
		if(nY != null) { Y.x = nY.x; Y.y = nY.y; Y.visible = true; }
		else Y.visible = false;
	}
	
	private void drawPencil_(Polygon2D poly, Ray2D[] pencil, color pencilCol, color col, String lb, String olb) {
		if(pencil == null || pencil[0] == null) return;
		pencil[0].strokeColor = pencilCol;
		pencil[0].draw();
		pencil[1].strokeColor = pencilCol;
		pencil[1].draw();
		
		strokeWeight(3);
		ArrayList pts = poly.pencilOwnPolyline(pencil);
		for(int j = 1; j < pts.size(); ++j) {
			Segment2D seg = new Segment2D(pts.get(j-1), pts.get(j));
			seg.strokeColor = col;
			seg.draw();
		}
		strokeWeight(1);
		for(int j = 0; j < pts.size(); ++j) {
			Point2D pt = pts.get(j);
			pt.strokeColor = col;
			pt.label = lb + (j + 1);
			pt.draw();
		}
		
		if(pencil[0].a.label != null) pencil[0].a.label = pencil[0].a.label + " = " + olb;
		else pencil[0].a.label = olb;
		pencil[0].a.strokeColor = col;
		pencil[0].a.draw();

	}
	
	protected void draw_() {
		drawPencil_(P, pencilP_, color(0, 0, 255, 200), color(0, 0, 255, 255), "v", "A");
		drawPencil_(Q, pencilQ_, color(255, 0, 0, 200), color(255, 0, 0, 555), "w", "B");
	}
}

void setup() {
	P = Polygon2D.generateRandomConvexWithMaximalNumberOfPoints(30, new PVector(10, 40), new PVector(240, 260));
	Q = Polygon2D.generateRandomConvexWithMaximalNumberOfPoints(100, new PVector(350, 80), new PVector(590, 220));
	X = new Point2D(0, 0); X.label = "X"; X.draggable = false; X.visible = false;
	Y = new Point2D(0, 0); Y.label = "Y"; Y.draggable = false; Y.visible = false;
	P.fillColor = color(0, 0, 0, 20); Q.fillColor = color(0, 0, 0, 20);
	P.label = "P"; Q.label = "Q";
	scene.addAll(P.points).addAll(Q.points).add(P).add(Q).add(X).add(Y);

	scene.add(new Updater);	

	size(600, 300);
}
