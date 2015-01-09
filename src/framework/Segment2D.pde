class Segment2D extends Line2D {
	static Segment2D fromVector(Point2D o, PVector dir) {
		return new Segment2D(o, new Point2D(o.x + dir.x, o.y + dir.y));
	}
	
	Segment2D(Point2D na, Point2D nb) {
		super(na, nb);
	}
	
	protected void draw_() {		
		noFill();
		stroke(strokeColor);

		line(a.x, a.y, b.x, b.y);
	}
	
	boolean isUnderMouse() {
		return super() && projectionIsOnSegment(new Point2D(mouseX, mouseY));
	}
		
	float norm() {
		return sqrt(sqNorm());
	}
	
	float sqNorm() {
		return sq(a.x - b.x) + sq(a.y - b.y);
	}
	
	Point2D segmentIntersection(Segment2D seg) {
		Point2D i = super.lineIntersection(seg);
		PVector ia = new PVector(a.x - i.x, a.y - i.y);
		PVector ib = new PVector(b.x - i.x, b.y - i.y);
		if(PVector.dot(ia, ib) > 0.0) return null;
		ia = new PVector(seg.a.x - i.x, seg.a.y - i.y);
		ib = new PVector(seg.b.x - i.x, seg.b.y - i.y);
		if(PVector.dot(ia, ib) > 0.0) return null;
		else return i;
	}
	
	boolean projectionIsOnSegment(Point2D p) {
		PVector v = toPVector();
		return (PVector.dot(v, Point2D.makePVector(a, p)) > 0 && PVector.dot(v, Point2D.makePVector(b, p)) < 0);
	}
}
