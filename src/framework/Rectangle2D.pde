class Rectangle2D extends Object2D {
	Point2D origin;
	PVector sides;
	
	Rectangle2D(float x, float y, float w, float h) {
		origin = new Point2D(x, y);
		sides = new PVector(w, h);
	}
	
	boolean isUnderMouse() {
		float x2 = origin.x + sides.x;
		float y2 = origin.y + sides.y;
		return (origin.x <= mouseX) && (x2 >= mouseX) && (origin.y <= mouseY) && (y2 >= mouseY);
	}
	
	PVector center() {
		return new PVector(
			origin.position.x + sides.x/2,
			origin.position.y + sides.y/2		
		);
	}
	
	void translation(PVector v) {
		origin.translation(v);
	}
	
	protected void draw_() {
		fill(fillColor);
		stroke(strokeColor);

		rect(origin.x, origin.y, sides.x, sides.y);
	}
}
