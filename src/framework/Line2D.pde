class Line2D extends Object2D {
	Point2D a;
	Point2D b;

	Line2D(Point2D na, Point2D nb) {
		a = na;
		b = nb;
	}

	static Line2D fromVector(Point2D o, PVector dir) {
		return new Line2D(a, new Point2D(o.x + dir.x, o.y + dir.y));
	}
	
	PVector direction() {
		PVector dir = toPVector();
		dir.normalize();
		return dir;
	}
	
	Point2D firstPoint() {
		return a;
	}
	
	Point2D secondPoint() {
		return b;
	}
	
	PVector toPVector() {
		return new PVector(b.x - a.x, b.y - a.y);
	}
	
	protected void draw_() {		
		noFill();
		stroke(strokeColor);

		Point2D p1 = pointAtX(0);
		Point2D p2 = pointAtX(width);
		line(p1.x, p1.y, p2.x, p2.y);
	}
		
	void translation(PVector v) {
		a.translation(v);
		b.translation(v);
	}
	
	PVector center() {
		return new PVector(
			a.x + (b.x - a.x)/2,
			a.y + (b.y - a.y)/2
		);
	}
	
	boolean isXAligned() {
		return (a.y == b.y);
	}
	
	boolean isYAligned() {
		return (a.x == b.x);
	}
	
	float slope() {
		PVector v = toPVector();
		return v.y / v.x;
	}
	
	float offset() {
		return a.y - slope()*a.x;
	}
	
	void reverse() {
		Point2D tmp = a;
		a = b;
		b = tmp;
	}
	
	int side(Point2D p) {
		return Point2D.turn(a, b, p);
	}
	
	Point2D pointAtX(float x) {
		float y = slope()*x + offset();
		return new Point2D(x, y);
	}
	
	Segment2D orthogonalRejection(Point2D p) {
		PVector dir = direction();
		PVector pa = PVector.sub(a.toPVector(), p.toPVector());
		float projectionLength = pa.dot(dir);
		PVector projection = PVector.mult(dir, projectionLength);
		PVector rejection = PVector.sub(pa, projection);
		return Segment2D.fromVector(p, rejection);
	}
	
	float orthogonalDistance(Point2D p) {
		return orthogonalRejection(p).norm();
	}
	
	boolean isUnderMouse() {
		Point2D m = new Point2D(mouseX, mouseY);
		return (orthogonalDistance(m) <= 3)
	}
	
	float orientedOrthogonalDistance(Point2D p, Point2D v) {
		float d = orthogonalDistance(p);
		if(side(p) != side(v)) return -d;
		return d;
	}
	
	Point2D lineIntersection(Line2D l2) {
		float x1 = a.x, y1 = a.y;
		float x2 = b.x, y2 = b.y;
		float x3 = l2.a.x, y3 = l2.a.y;
		float x4 = l2.b.x, y4 = l2.b.y;
		return new Point2D(
			  ( (x1*y2 - y1*x2)*(x3 - x4) - (x1 - x2)*(x3*y4 - y3*x4) )
			/ ( (x1 - x2)*(y3 - y4) - (y1 - y2)*(x3 - x4) ),
			
			  ( (x1*y2 - y1*x2)*(y3 - y4) - (y1 - y2)*(x3*y4 - y3*x4) )
			/ ( (x1 - x2)*(y3 - y4) - (y1 - y2)*(x3 - x4) )
		);
	}
	
	Point2D projection(Point2D p) {
		PVector ab = toPVector();
		PVector ap = Point2D.makePVector(a, p);
		ab.normalize();
		float l = PVector.dot(ab, ap);
		ab.mult(l);
		return new Point2D(a.x + ab.x, a.y + ab.y);
	}
}
