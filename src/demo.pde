Polygon2D P, Q;

class Updater extends Object2D {
	Segment2D d;
	
	private PVector acceleration(float d, PVector dir) {
		float acc = 1 / sq(d); acc /= 5;
		if(acc > 0.1) acc = 0.1;
		PVector v = new PVector(dir.x, dir.y);
		v.normalize(); v.mult(acc);
		return v;
	}
	
	void wallForce(Polygon2D p) {
		Line2D top = new Line2D(new Point2D(0, 0), new Point2D(width, 0));
		Line2D bottom = new Line2D(new Point2D(0, height), new Point2D(width, height));
		Line2D left = new Line2D(new Point2D(0, 0), new Point2D(0, height));
		Line2D right = new Line2D(new Point2D(width, 0), new Point2D(width, height));
		
		float dt = p.lineDistance(top, new Point2D(0, 1));
		p.velocity.add(acceleration(dt, new PVector(0, 1)));

		float db = p.lineDistance(bottom, new Point2D(0, height - 1));
		p.velocity.add(acceleration(db, new PVector(0, -1)));
		
		float dl = p.lineDistance(left, new Point2D(1, 0));
		p.velocity.add(acceleration(dl, new PVector(1, 0)));

		float dr = p.lineDistance(right, new Point2D(width - 1, 0));
		p.velocity.add(acceleration(dr, new PVector(-1, 0)));
	}
	
	Object2D update() {
		d = P.minimalDistance(Q);
		if(d == null) return;
		
		PVector dvP = acceleration(d.norm(), d.toPVector()); dvP.mult(-1);
		PVector dvQ = acceleration(d.norm(), d.toPVector());
		
		P.velocity.add(dvP);
		Q.velocity.add(dvQ);
		
		wallForce(P); wallForce(Q);
		
		int col = 255 - (dvP.mag() * 300000);
		if(col < 0) col = 0; else if(col > 255) col = 255;
		d.strokeColor = col;
		strokeWeight(2);
		d.draw();
		strokeWeight(1);
	}

}

void setup() {
	P = Polygon2D.generateRandomConvex(7, new PVector(10, 80), new PVector(100, 130));
	Q = Polygon2D.generateRandomConvex(9, new PVector(150, 150), new PVector(250, 200));
	if(Q.isClockwise()) Q.reversePoints();
	if(! P.isClockwise()) P.reversePoints();
	scene.add(P).add(Q);
	P.kinetic = true; Q.kinetic = true;
	P.velocity = new PVector(0.02, 0.005);

	scene.add(new Updater);
	scene.drawFrame = true;	
	
	size(300, 300);
}

void reinit() {
	scene.clear();
	setup();
	redraw();
}
