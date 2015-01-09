class Ray2D extends Line2D {
	static Ray2D fromVector(Point2D o, PVector dir) {
		return new Ray2D(o, new Point2D(o.x + dir.x, o.y + dir.y));
	}
	
	Ray2D(Point2D na, Point2D nb) {
		super(na, nb);
	}
	
	protected void draw_() {		
		noFill();
		stroke(strokeColor);

		Point2D p2 = (a.x < b.x ? pointAtX(width) : pointAtX(0));
		line(a.x, a.y, p2.x, p2.y);
	}
	
	boolean isUnderMouse() {
		return false;
	}
	
	Point2D lineIntersection(Line2D l) {
		Point2D i = super.lineIntersection(l);
		PVector ia = new PVector(a.x - i.x, a.y - i.y);
		PVector ba = new PVector(a.x - b.x, a.y - b.y);
		if(PVector.dot(ia, ba) < 0.0) return null;
		else return i;
	}
	
	static boolean enclosePoints(Ray2D r[], Point2D pt) {
		Point2D o = r[0].a;
		PVector oa = r[0].toPVector();
		PVector ob = r[1].toPVector();
		PVector op = new PVector(pt.x - o.x, pt.y - o.y);
		PVector b = PVector.add(oa, ob);
		
		float turn1 = PVector.cross(ob, op).z;
		float turn2 = PVector.cross(oa, op).z;
		return (turn1*turn2 < 0) && (PVector.dot(op, b) > 0);
	}
}
