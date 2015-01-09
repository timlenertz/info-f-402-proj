ArrayList points = new ArrayList();
Point draggingPoint;

bool splitScreen = false;

void mouseMoved() {
	if(! mousePressed) {
		if(pointUnderMouse()) cursor(HAND);
		else cursor(ARROW);
	}
}

void mousePressed() {
	draggingPoint = pointUnderMouse();
	cursor(HAND);
}

void mouseReleased() {
	draggingPoint = null;
	cursor(ARROW);
}

void mouseDragged() {
	if(draggingPoint) {
		if(splitScreen) draggingPoint.x = min(width/2, mouseX);
		else draggingPoint.x = mouseX;
		draggingPoint.y = mouseY;
	}
}

void drawPoints() {
	for(int i = 0; i < points.size(); ++i) points.get(i).draw();
}

Point pointUnderMouse() {
	for(int i = 0; i < points.size(); ++i) {
		if(points.get(i).underMouse()) return points.get(i);
	}
	return null;
}

ArrayList randomPointsList(int number) {
	ArrayList result = new ArrayList;
	int offset = 40;
	for(int i = 0; i < number; ++i) {
		float x = random(offset, (splitScreen ? width/2 : width) - 2*offset);
		float y = random(offset, height - 2*offset);
		Point p = new Point(x, y);
		result.add(p);
	}
	return result;
}

void generateRandomPoints(int number) {
	points = randomPointsList(number);
}

void randomColorizePoints(ArrayList pts) {
	color availableColors = [
		color(255, 0, 0),
		color(0, 200, 0),
		color(0, 0, 255),
		color(150, 150, 0),
		color(150, 0, 150),
		color(0, 150, 150),
		color(0, 0, 0),
		color(100, 200, 100)
	];

	for(int i = 0; i < pts.size(); ++i) {
		Point pt = pts.get(i);
		pt.col = availableColors[i % 7];
	}
}

int sign(float f) {
	if(f > 0) return 1;
	else if(f == 0) return 0;
	else return -1;
}

ArrayList convexHullByTriangles(ArrayList pts) {
	ArrayList result = pts.clone();
	for(int i = 0; i < pts.size(); ++i) {
		Point a = pts.get(i);
		for(int j = i + 1; j < pts.size(); ++j) {
			Point b = pts.get(j);
			for(int k = j + 1; k < pts.size(); ++k) {
				Point c = pts.get(k);
				Triangle abc = new Triangle(a, b, c);
				for(int l = 0; l < result.size(); ++l) {
					Point p = result.get(l);
					if(abc.containsPoint(p)) result.remove(l--);
				}
			}
		}
	}
	return result;
}

ArrayList convexHullBySides(ArrayList pts) {
	ArrayList result = new ArrayList();
	for(int i = 0; i < pts.size(); ++i) {
		Point a = pts.get(i);
		for(int j = 0; j < pts.size(); ++j) {
			if(i == j) continue;
			Point b = pts.get(j);
			Segment ab = new Segment(a, b);
			boolean valid = true;
			for(int k = 0; k < pts.size(); ++k) {
				Vector ak = Vector.fromPoints(a, pts.get(k));
				if(Vector.cross(ab, ak) < 0) {
					valid = false;
					break;
				}
			}
			if(valid) result.add(ab);
		}
	}
	return result;
}

void sortConvexHullSegments(ArrayList segs) {
	boolean cont = true;
	int iteration = 0;
	while(cont) {
		cont = false;
		for(int i = iteration++; i < segs.size()-1; ++i) {
			Segment s1 = segs.get(i);
			Segment s2 = segs.get(i+1);
			if(Vector.cross(s1, s2) < 0) {
				cont = true;
				segs.set(i, s2);
				segs.set(i+1, s1);
			}
		}
	}
}

void sortPoints(ArrayList pts, int coordinate, bool ascending) {
	boot cont = false;
	int lim = pts.size();
	do {
		for(int i = 1; i < lim; ++i) {
			Point p1 = pts.get(i - 1);
			Point p2 = pts.get(i);
			bool swap = false;
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

ArrayList convexHull(ArrayList pts) {
	// from http://www.cs.uu.nl/docs/vakken/ga/slides1.pdf
	sortPoints(pts, 0, true);
	ArrayList upper = new ArrayList();
	upper.add(pts.get(0)); upper.add(pts.get(1));
	for(int i = 2; i < pts.size(); ++i) {
		upper.add(pts.get(i));
		int l = upper.size() - 1;
		while(upper.size() > 2 && Point.turn(upper.get(l-2), upper.get(l-1), upper.get(l)) > 0) {
			upper.remove(l-1);
			l = upper.size() - 1;
		}
	}
	
	
	sortPoints(pts, 0, false);
	ArrayList lower = new ArrayList();
	lower.add(pts.get(0)); lower.add(pts.get(1));
	for(int i = 2; i < pts.size(); ++i) {
		lower.add(pts.get(i));
		int l = lower.size() - 1;
		while(lower.size() > 2 && Point.turn(lower.get(l-2), lower.get(l-1), lower.get(l)) > 0) {
			lower.remove(l-1);
			l = lower.size() - 1;
		}
	}
	
	for(int i = 1; i < lower.size() - 1; ++i) {
		upper.add(lower.get(i));
	}
	
	return upper;
}

class Point {
	float x;
	float y;
	String label;
	color col = color(0);
	
	Point(float nx, float ny) {
		x = nx;
		y = ny;
	}
	
	Point(float nx, float ny, String nlabel) {
		x = nx;
		y = ny;
		label = nlabel;
	}
	
	static Segment makeSegment(Point a, Vector v) {
		Point b = new Point(a.x + v.x, a.y + v.y);
		return new Segment(a, b);
	}
	
	static float angle(Point a, Point b, Point c) {
		Vector u = Vector.fromPoints(b, a);
		Vector v = Vector.fromPoints(b, c);
		return Vector.angle(u, v);
	}
	
	void draw(int xoff) {
		if(splitScreen) if(x < 0 || x > width/2) return;
	
		fill(col);
		stroke(col);
		ellipseMode(CENTER);
		ellipse(xoff + x, y, 3, 3);
		if(label != null) text(label, xoff + x + 5, y + 3);
	}
	
	void draw() {
		draw(0);
	}
	
	boolean underMouse() {
		float minOffset = 3;
		float dx = abs(x - mouseX);
		float dy = abs(y - mouseY);
		return (dx <= minOffset) && (dy <= minOffset);
	}
	
	static int turn(Point a, Point b, Point c) {
		Vector ba = Vector.fromPoints(b, a);
		Vector bc = Vector.fromPoints(b, c);
		float p = Vector.cross(ba, bc);
		return sign(p);
	}

	static bool leftTurn(Point a, Point b, Point c) {
		return (Point.turn(a, b, c) > 0);
	}
	
	static bool rightTurn(Point a, Point b, Point c) {
		return (Point.turn(a, b, c) < 0);
	}
	
	bool equals(Point p) {
		return (x == p.x) && (y == p.y);
	}
}

class Vector {
	float x;
	float y;
	
	Vector(Vector v) {
		x = v.x;
		y = v.y;
	}
	
	Vector(float nx, float ny) {
		x = nx;
		y = ny;
	}
	
	static Vector fromPoints(Point a, Point b) {
		return new Vector(b.x - a.x, b.y - a.y);
	}
	
	float norm() {
		return sqrt(x*x + y*y);
	}
	
	Vector normalize() {
		float n = norm();
		return new Vector(x/n, y/n);
	}
	
	Vector normalize(float len) {
		float n = norm();
		return new Vector(len*x/n, len*y/n);
	}
	
	float scalarProjection(Vector v) {
		return Vector.dot(this, v.normalize());
	}
	
	Vector orthogonalProjection(Vector v) {
		float scalar = scalarProjection(v);
		return Vector.multiply(v.normalize(), scalar);
	}
	
	Vector rejection(Vector v) {
		return Vector.minus(this, scalarProjection(v));
	}
	
	static float cross(Vector u, Vector v) {
		return u.x*v.y - u.y*v.x;
	}
	
	static float dot(Vector u, Vector v) {
		return v.x*u.x + v.y*u.y;
	}
	
	static Vector multiply(Vector u, float f) {
		return new Vector(u.x * f, u.y * f);
	}
	
	static Vector divide(Vector u, float f) {
		return new Vector(u.x / f, u.y / f);
	}
	
	static Vector plus(Vector u, Vector v) {
		return new Vector(u.x + v.x, u.y + v.y);
	}
	
	static Vector minus(Vector u, Vector v) {
		return new Vector(u.x - v.x, u.y - v.y);
	}
	
	static float angle(Vector u, Vector v) {
		return acos(dot(u, v) / (u.norm() * v.norm()));
	}
}

class Line extends Vector {
	Point o;
	
	Line(Point no, Vector v) {
		super(v.x, v.y);
		o = no;
	}
	
	static Line fromSegment(Segment s) {
		return new Line(s.a, s);
	}
	
	void draw(int xoff) {
		int factor = width;
		if(splitScreen) {
			int xmax = width/2;
			Point p1 = new Point(0, o.y - (o.x/x)*y);
			Point p2 = new Point(xmax, o.y + ((xmax-o.x)/x)*y);
		} else {
			int factor = width;
			Point p1 = new Point(o.x - factor*x, o.y - factor*y);
			Point p2 = new Point(o.x + factor*x, o.y + factor*y);		
		}
		stroke(o.col);
		line(p1.x + xoff, p1.y, p2.x + xoff, p2.y);
	}
	
	void draw() {
		draw(0);
	}
	
	Point pointAtX(float px) {
		// Get equation y = mx + c
		float m = y/x;
		float c = o.y - m*o.x;
		float py = m*px + c;
		return new Point(px, py);
	}
}

class Segment extends Vector {
	Point a;
	Point b;
	String label;
	
	Segment(Point na, Point nb) {
		super(nb.x - na.x, nb.y - na.y);
		a = na;
		b = nb;
	}
	
	Point center() {
		return new Point(
			a.x + (b.x - a.x)/2,
			a.y + (b.y - a.y)/2
		);
	}
	
	void draw() {
		line(a.x, a.y, b.x, b.y);
		if(label != null) {
			Point c = center();
			text(label, c.x + 5, c.y + 3);
		}
	}
	
	void drawArrow() {
		draw();
		float halfWidth = 4;
		float height = 10;
		Vector unit = Vector.divide(this, -norm());
		Vector perp = new Vector(-unit.y, unit.x);
		Vector h = Vector.multiply(unit, height);
		Vector w = Vector.multiply(perp, halfWidth);
		Vector v1 = Vector.plus(h, w);
		Vector v2 = Vector.minus(h, w);
		Segment s1 = Point.makeSegment(b, v1);
		Segment s2 = Point.makeSegment(b, v2);
		s1.draw();
		s2.draw();
	}
	
	bool intersects(Segment s) {	
		Point a1 = a;  Point a2 = s.a;
		Point b1 = b;  Point b2 = s.b;
		
		float de = (b2.y - a2.y)*(b1.x - a1.x) - (b2.x - a2.x)*(b1.y - a1.y);
		if(de == 0) return false; // parallel
		
		float na = (b2.x - a2.x)*(a1.y - a2.y) - (b2.y - a2.y)*(a1.x - a2.x);
		float nb = (b1.x - a1.x)*(a1.y - a2.y) - (b1.y - a1.y)*(a1.x - a2.x);
		float ua = na / de;
		float ub = nb / de;
		
		bool intersects = (ua >= 0) && (ua <= 1) && (ub >= 0) && (ub <= 1);
		
		return intersects;
	}
}

class Triangle {
	Point a;
	Point b;
	Point c;
	
	Triangle(Point na, Point nb, Point nc) {
		a = na;
		b = nb;
		c = nc;
	}
	
	bool containsPoint(Point p) {
		Vector ab = Vector.fromPoints(a, b);
		Vector ap = Vector.fromPoints(a, p);
		int as = sign(Vector.cross(ap, ab));
		
		Vector bc = Vector.fromPoints(b, c);
		Vector bp = Vector.fromPoints(b, p);
		int bs = sign(Vector.cross(bp, bc));

		Vector ca = Vector.fromPoints(c, a);
		Vector cp = Vector.fromPoints(c, p);
		int cs = sign(Vector.cross(cp, ca));

		return (as == bs) && (bs == cs);
	}
	
	Point centroid() {
		return new Point(
			(a.x + b.x + c.x)/3,
			(a.y + b.y + c.y)/3
		);
	}
	
	bool hasPoint(Point p) {
		return (a == p) || (b == p) || (c == p);
	}
	
	bool isConnectedWith(Triangle t) {	
		return (hasPoint(t.a) && hasPoint(t.b)) || (hasPoint(t.a) && hasPoint(t.c)) || (hasPoint(t.b) && hasPoint(t.c));
	}
	
	void draw() {
		triangle(a.x, a.y, b.x, b.y, c.x, c.y);
	}
}

class Polygon {
	ArrayList points;
	
	static Polygon generateRandom(int nbPoints) {
		Polygon poly = new Polygon;
		poly.points = randomPointsList(nbPoints);
		return poly;
	}
	
	static Polygon generateRandomSimple(int nbPoints) {
		int maxTries = 2000;
		int loops = 0;
		Polygon poly;
		do {
			if(++loops > maxTries) return poly;
			poly = Polygon.generateRandom(nbPoints);
		} while(! poly.isSimple());
		return poly;
	}
	
	static Polygon generateRandomConvexWithMaximalNumberOfPoints(int nbPoints) {
		Polygon poly = Polygon.generateRandom(nbPoints);
		Polygon cpoly = new Polygon();
		cpoly.points = convexHull(poly.points);
		return cpoly;
	}

	static Polygon generateRandomConvex(int nbPoints) {
		Polygon poly = Polygon.generateRandomConvexWithMaximalNumberOfPoints(2 * nbPoints);
		while(poly.points.size() < nbPoints) poly = Polygon.generateRandomConvexWithMaximalNumberOfPoints(2 * nbPoints);
		
		for(int remaining = poly.points.size() - nbPoints; remaining > 0; --remaining) {
			int i = floor(random(0, poly.points.size() - 1));
			poly.points.remove(i);
		}
		
		return poly;
	}
	
	Polygon() {
		points = new ArrayList();
	}

	ArrayList segments() {
		ArrayList result = new ArrayList();
		Point p1 = points.get(points.size() - 1);
		for(int i = 0; i < points.size(); ++i) {
			Point p2 = points.get(i);
			Segment seg = new Segment(p1, p2);
			result.add(seg);
			p1 = p2;
		}
		return result;
	}
	
	bool isConvex() {
		Point p1 = points.get(points.size() - 2);
		Point p2 = points.get(points.size() - 1);
		Point p3 = points.get(0);
		int need_sign = Point.turn(p1, p2, p3);
		for(int i = 1; i < points.size(); ++i) {
			p1 = p2;
			p2 = p3;
			p3 = points.get(i);
			int sign = Point.turn(p1, p2, p3);
			if(sign != need_sign) return false;
		}
		return true;
	}
	
	bool isSimple() {		
		ArrayList seg = segments();
		for(int i = 0; i < seg.size(); ++i) {
			Seg s1 = seg.get(i);
			for(int j = i + 2; j < seg.size(); ++j) {
				Seg s2 = seg.get(j);
				if( (s2.a == s1.a) || (s2.a == s1.b) || (s2.b == s1.a) || (s2.b == s1.b) ) continue;
				if(s2.intersects(s1)) return false;
			}
		}
		return true;
	}
	
	bool isEar(int i) {
		int a = i - 1;
		if(a == -1) a = points.size() - 1;
		int b = i + 1;
		if(b == points.size()) b = 0;

		Point A = points.get(a);
		Point B = points.get(b);
		Point C = points.get(i);
		
		// Distinguish ear from mouth. Polygon must be clockwise
		if(Point.turn(A, C, B) < 0) return false;
		
		// Check that no other point is in ear triangle
		Triangle ABC = new Triangle(A, B, C);
		for(int j = 0; j < points.size(); ++j) {
			if(i == j || i == a || i == b) continue;
			Point P = points.get(j);
			if(ABC.containsPoint(P)) return false;
		}
		
		return true;
	}
	
	int findEar() {
		for(int i = 0; i < points.size(); ++i) {
			if(isEar(i)) return i;
		}
		return -1;
	}
	
	bool removeEar() {
		int ear = findEar();
		if(ear != -1) {
			points.remove(ear);
			return true;
		} else {
			return false;
		}
	}
	
	Triangle removeAndReturnEar() {
		int ear = findEar();
		if(ear != -1) {
			Triangle tri = earTriangle(ear);
			points.remove(ear);
			return tri;
		} else {
			return null;
		}
	}
	
	Triangle earTriangle(int i) {
		// Assert: ear is an ear
		int a = i - 1;
		if(a == -1) a = points.size() - 1;
		int b = i + 1;
		if(b == points.size()) b = 0;

		Point A = points.get(a);
		Point B = points.get(b);
		Point C = points.get(i);

		return new Triangle(A, B, C);
	}
	
	bool isClockwise() {
		float sum = 0;
		ArrayList seg = segments();
		for(int i = 0; i < seg.size(); ++i) {
			Seg s = seg.get(i);
			sum += (s.b.x - s.a.x) * (s.b.y + s.a.y);
		}
		return (sum > 0);
	}
	
	void makeClockwise() {
		if(isClockwise()) return;
		
		ArrayList newPoints = new ArrayList();
		for(int i = points.size() - 1; i >= 0; --i) {
			newPoints.add(points.get(i));
		}
		points = newPoints;
	}
	
	void draw() {
		beginShape(LINES);
		Point p1 = points.get(0);
		for(int i = 1; i < points.size(); ++i) {
			Point p2 = points.get(i);
			vertex(p1.x, p1.y);
			vertex(p2.x, p2.y);
			p1 = p2;
		}
		vertex(p2.x, p2.y);
		endShape(CLOSE);
	}
}
