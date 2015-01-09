class Object2D {
	boolean visible;
	color strokeColor;
	String label;
	boolean draggable;
	boolean kinetic;
	PVector velocity;
	
	Object2D() {
		velocity = new PVector(0, 0);
		draggable = true;
		kinetic = false;
		visible = true;
		strokeColor = color(0);
		label = null;
	}
	
	Object2D update() {
		return null;
	}
	
	void draw() {
		if(! visible) return;
		draw_();
		if(label != null) {
			fill(strokeColor);
			PVector c = center();
			textAlign(CENTER);
			text(label, c.x + 5, c.y + 10);
		}
	}
	
	protected void draw_() { }
	PVector center() { return null; }
	void translation(PVector v) { }
	
	boolean isUnderMouse() { return false; }
}
