class Scene {
	ArrayList objects;
	Object2D draggingObject;
	PVector dragLastMousePosition;
	boolean drawFrame = false;
	boolean doUpdate = true;
	
	Scene() {
		objects = new ArrayList;
		noLoop();
	}
	
	Scene add(Object obj) {
		objects.add(obj);
		return this;
	}
	
	Scene addAll(ArrayList objs) {
		objects.addAll(objs);
		return this;
	}
	
	void clear() {
		objects = new ArrayList;
		draggingObject = null;
	}
	
	void draw() {
		background(255);
		if(doUpdate) for(int i = 0; i < objects.size(); ++i) {
			Object2D updated = objects.get(i).update();
			if(updated != null) objects.set(i, updated);
		}
		for(int i = 0; i < objects.size(); ++i) {
			objects.get(i).draw();
		}
		if(drawFrame) {
			stroke(0); noFill();
			rect(0, 0, width - 1, height - 1);
		}
	}
	
	void drag() {
		if(draggingObject != null && dragLastMousePosition != null) {
			PVector mousePosition = new PVector(mouseX, mouseY);
			PVector offset = PVector.sub(mousePosition, dragLastMousePosition);
			dragLastMousePosition = mousePosition;
			draggingObject.translation(offset);
		}
		redraw();
	}
	
	boolean tick(float dtime) {
		boolean animation = false;
		for(int i = 0; i < objects.size(); ++i) {
			Object2D obj = objects.get(i);
			if(obj.kinetic && obj.velocity != null) {
				if(doUpdate) obj.translation(PVector.mult(obj.velocity, dtime));
				animation = true;
			}
		}
		return animation;
	}
	
	Object2D draggableObjectUnderMouse() {
		for(int i = 0; i < objects.size(); ++i) {
			Object2D obj = objects.get(i);
			if(obj.draggable && obj.isUnderMouse()) return obj;
		}
		return null;
	}
}




Scene scene = new Scene;
float lastTime = 0;

void draw() {
	float time = millis();
	float dtime = time - lastTime;
	lastTime = time;
	if(dtime > 500) dtime = 0;
	
	scene.draw();
	boolean animation = scene.tick(dtime);
	
	if(! animation) noLoop();
}

void mouseMoved() {
	Object2D obj = scene.draggableObjectUnderMouse();
	if(obj == null) cursor(ARROW);
	else cursor(HAND);
}

void mousePressed() {
	Object2D obj = scene.draggableObjectUnderMouse();
	if(obj == null) {
		cursor(ARROW);
	} else {
		cursor(HAND);
		scene.draggingObject = obj;
		scene.dragLastMousePosition = new PVector(mouseX, mouseY);
	}
}

void mouseReleased() {
	if(scene.draggingObject) {
		scene.draggingObject = null;
		scene.dragLastMousePosition = null;
		cursor(HAND);
	}
}

void mouseDragged() {
	scene.drag();
}
