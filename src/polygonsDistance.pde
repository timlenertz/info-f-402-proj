Polygon2D P, Q;
Segment2D d;
Point2D lvl;

class Updater extends Object2D {
	Ray2D[] pencilP_; // origin in P, encloses Q
	Ray2D[] pencilQ_; // origin in Q, encloses P
	

	Object2D update() {
		pencilP_ = null; pencilQ_ = null;

		boolean convex = true;		
		if(! P.isConvex()) { P.strokeColor = #FF0000; convex = false; }
		else P.strokeColor = #000000;
		if(! Q.isConvex()) { Q.strokeColor = #FF0000; convex = false; }
		else Q.strokeColor = #000000;
	
		if(! convex) return null;

		pencilP_ = P.pencilOrIntersectionPoint(Q);
		pencilQ_ = Q.pencilOrIntersectionPoint(P);
		
		Segment2D nd = P.minimalDistance(Q);
		if(nd != null) {
			d.visible = true;
			d.a = nd.a;
			d.b = nd.b;
			d.label = "d = " + formatNumber(d.norm(), 2);
		} else {
			d.visible = false;
		}
	}
	
	private void drawPencil_(Ray2D[] pencil, color col) {
		if(pencil == null || pencil[0] == null) return;
		pencil[0].strokeColor = col;
		pencil[0].draw();
		pencil[1].strokeColor = col;
		pencil[1].draw();
				
		strokeWeight(3);
		Point2D prev = pencil[0].b;
		for(Point2D curr = prev.next; prev != pencil[1].b; prev = curr, curr = curr.next) {
			Segment2D seg = new Segment2D(prev, curr);
			seg.draw();
		}
		strokeWeight(1);
	}
	
	protected void draw_() {
		drawPencil_(pencilP_, color(0, 0, 255));
		drawPencil_(pencilQ_, color(255, 0, 0));
	}
}

void setup() {
	P = Polygon2D.generateRandomConvex(7, new PVector(10, 40), new PVector(240, 260));
	Q = Polygon2D.generateRandomConvex(15, new PVector(350, 180), new PVector(590, 320));
	if(Q.isClockwise()) Q.reversePoints();
	if(! P.isClockwise()) P.reversePoints();
	d = new Segment2D(new Point2D(0, 0), new Point2D(0, 0));
	P.label = "P"; Q.label = "Q";
	for(int i = 0; i < P.points.size(); ++i) P.points.get(i).label = "p"+(i+1);
	for(int i = 0; i < Q.points.size(); ++i) Q.points.get(i).label = "q"+(i+1);
	scene.addAll(P.points).addAll(Q.points).add(P).add(Q).add(d);
	d.draggable = false; d.strokeColor = #005500;

	scene.add(new Updater);	

	size(600, 300);
}
