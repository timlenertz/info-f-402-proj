class Point2D extends Object2D {
	float x;
	float y;
	Point2D next;
	Point2D previous;
	
	static Point2D fromPVector(PVector v) {
		return new Point2D(v.x, v.y);
	}
	
	static Point2D makePVector(Point2D a, Point2D b) {
		return new PVector(b.x - a.x, b.y - a.y);
	}
	
	Point2D(float nx, float ny) {
		x = nx;
		y = ny;
	}
	
	protected void draw_() {		
		noStroke();
		fill(strokeColor);

		ellipseMode(CENTER);
		ellipse(x, y, 3, 3);
	}
	
	boolean isUnderMouse() {
		float minOffset = 3;
		float dx = abs(x - mouseX);
		float dy = abs(y - mouseY);
		return (dx <= minOffset) && (dy <= minOffset);
	}
	
	PVector center() {
		return toPVector();
	}
	
	PVector toPVector() {
		return new PVector(x, y);
	}
	
	void translation(PVector v) {
		x += v.x;
		y += v.y;
	}
	
	static int turn(Point2D a, Point2D b, Point2D c) {
		PVector ba = new PVector(a.x - b.x, a.y - b.y);
		PVector bc = new PVector(c.x - b.x, c.y - b.y);
		PVector cross = ba.cross(bc);
		return sign(cross.z);
	}
	
	static float angle(Point2D a, Point2D b, Point2D c) {
		PVector ba = new PVector(a.x - b.x, a.y - b.y); ba.normalize();
		PVector bc = new PVector(c.x - b.x, c.y - b.y); bc.normalize();
		float an = acos(PVector.dot(ba, bc));
		if(PVector.cross(ba, bc).z < 0) return TWO_PI - an;
		else return an;
	}

	static float sqDistance(Point2D a, Point2D b) {
		float x = a.x - b.x;
		float y = a.y - b.y;
		return x*x + y*y;
	}
	
	static float distance(Point2D a, Point2D b) {
		return sqrt(sqDistance(a, b));
	}
	
	static void sortPoints(ArrayList pts, int coordinate, boolean ascending) {
		boolean cont = false;
		int lim = pts.size();
		do {
			for(int i = 1; i < lim; ++i) {
				Point2D p1 = pts.get(i - 1);
				Point2D p2 = pts.get(i);
				boolean swap = false;
				if(coordinate == 0) swap = (p1.x > p2.x);
				else if(coordinate == 1) swap = (p1.y > p2.y);
				if(! ascending) swap = !swap;
				if(swap) {
					cont = true;
					pts.set(i - 1, p2);
					pts.set(i, p1);
				}
			}
			--lim;
		} while(cont && lim);
	}
}
