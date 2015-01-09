class Polygon2D extends Object2D {
	ArrayList points;
	boolean hasFillColor;
	color fillColor;
	
	static Polygon2D generateRandom(int nbPoints, PVector low, PVector high) {
		Polygon2D poly = new Polygon2D;
		for(int i = 0; i < nbPoints; ++i) {
			float x = random(low.x, high.x);
			float y = random(low.y, high.y);
			Point2D pt = new Point2D(x, y);
			poly.points.add(pt);
		}
		poly.linkPoints();
		poly.randomShiftPoints();
		return poly;
	}
	
	static Polygon2D generateRandomConvexWithMaximalNumberOfPoints(int nbPoints, PVector low, PVector high) {
		Polygon2D poly = Polygon2D.generateRandom(nbPoints, low, high);
		Polygon2D cpoly = poly.convexHull();
		cpoly.randomShiftPoints();
		return cpoly;
	}

	static Polygon2D generateRandomConvex(int nbPoints, PVector low, PVector high) {
		Polygon2D poly = Polygon2D.generateRandomConvexWithMaximalNumberOfPoints(2 * nbPoints, low, high);
		float m = 2;
		while(poly.points.size() < nbPoints) {
			m += 0.5;
			poly = Polygon2D.generateRandomConvexWithMaximalNumberOfPoints(m * nbPoints, low, high);
		}
		for(int remaining = poly.points.size() - nbPoints; remaining > 0; --remaining) {
			int i = floor(random(0, poly.points.size() - 1));
			poly.points.remove(i);
		}
		poly.linkPoints();
		return poly;
	}
	
	Polygon2D() {
		points = new ArrayList();
	}
	
	Polygon2D(ArrayList pts) {
		points = new ArrayList(pts);
		linkPoints();
	}
	
	boolean isConvex() {
		Point p1 = points.get(points.size() - 2);
		Point p2 = points.get(points.size() - 1);
		Point p3 = points.get(0);
		int need_sign = Point2D.turn(p1, p2, p3);
		for(int i = 1; i < points.size(); ++i) {
			p1 = p2;
			p2 = p3;
			p3 = points.get(i);
			int sign = Point2D.turn(p1, p2, p3);
			if(sign != need_sign) return false;
		}
		return true;
	}
	
	void linkPoints() {
		for(int i = 1; i < points.size(); ++i) {
			points.get(i - 1).next = points.get(i);
			points.get(i).previous = points.get(i - 1);
		}
		points.get(points.size() - 1).next = points.get(0);
		points.get(0).previous = points.get(points.size() - 1);
	}
	
	PVector center() {
		PVector c = new PVector(0, 0);
		for(int i = 0; i < points.size(); ++i) {
			c.add(points.get(i).toPVector());
		}
		c.div(points.size());
		return c;
	}
	
	void translation(PVector v) {
		for(int i = 0; i < points.size(); ++i) {
			points.get(i).translation(v);
		}
	}
	
	protected void draw_() {
		if(hasFillColor) fill(fillColor);
		else noFill();
		stroke(strokeColor);

		beginShape();
		for(int i = 0; i < points.size(); ++i) {
			Point2D pt = points.get(i);
			vertex(pt.x, pt.y);
		}
		endShape(CLOSE);
	}

	
	Polygon2D convexHull() {
		// from http://www.cs.uu.nl/docs/vakken/ga/slides1.pdf
		ArrayList pts = new ArrayList(points);
		
		Point2D.sortPoints(pts, 0, true);
				
		ArrayList upper = new ArrayList();
		upper.add(pts.get(0)); upper.add(pts.get(1));
		for(int i = 2; i < pts.size(); ++i) {
			upper.add(pts.get(i));
			int l = upper.size() - 1;
			while(upper.size() > 2 && Point2D.turn(upper.get(l-2), upper.get(l-1), upper.get(l)) > 0) {
				upper.remove(l-1);
				l = upper.size() - 1;
			}
		}
						
		Point2D.sortPoints(pts, 0, false);
		ArrayList lower = new ArrayList();
		lower.add(pts.get(0)); lower.add(pts.get(1));
		for(int i = 2; i < pts.size(); ++i) {
			lower.add(pts.get(i));
			int l = lower.size() - 1;
			while(lower.size() > 2 && Point2D.turn(lower.get(l-2), lower.get(l-1), lower.get(l)) > 0) {
				lower.remove(l-1);
				l = lower.size() - 1;
			}
		}
		
		for(int i = 1; i < lower.size() - 1; ++i) {
			upper.add(lower.get(i));
		}
		
		return new Polygon2D(upper);
	}
	
	ArrayList segments() {
		ArrayList segments = new ArrayList();
		for(int i = 1; i < points.size(); ++i) {
			segments.add(new Segment2D(points.get(i - 1), points.get(i)));
		}
		segments.add(new Segment2D(points.get(points.size() - 1), points.get(0)));
		return segments;
	}
	
	Segment2D segment(int i) {
		i = i % points.size();
		if(i < 0) i += points.size();
		if(i < points.size() - 1) return new Segment2D(points.get(i), points.get(i + 1));
		else return new Segment2D(points.get(points.size() - 1), points.get(0));
	}
	
	boolean containsPoint(PVector v) {
		boolean c = false;
		int j = points.size() - 1;
		for(int i = 0; i < points.size(); j = i++) {
			Point2D pi = points.get(i);
			Point2D pj = points.get(j);
			if(
				((pi.y > v.y) != (pj.y > v.y)) &&
				(v.x < (pj.x-pi.x) * (v.y-pi.y) / (pj.y-pi.y) + pi.x)
			) c = !c;
		}
		return c;
	}
	
	boolean isUnderMouse() {
		return containsPoint(new PVector(mouseX, mouseY));
	}
	
	boolean isClockwise() {
		float sum = 0;
		ArrayList seg = segments();
		for(int i = 0; i < seg.size(); ++i) {
			Segment2D s = seg.get(i);
			sum += (s.b.x - s.a.x) * (s.b.y + s.a.y);
		}
		return (sum > 0);
	}
	
	ArrayList reversedPoints() {
		ArrayList reversed = new ArrayList;
		for(int i = points.size() - 1; i >= 0; --i) {
			reversed.add(points.get(i));
		}
		return reversed;
	}
	
	void reversePoints() {
		points = reversedPoints();
		linkPoints();
	}
	
	void shiftPoints(int s) {
		ArrayList newPoints = new ArrayList;
		
		for(int i = 0; i < points.size(); ++i) {
			int j = (i - s) % points.size();
			if(s > i) j += points.size();
			newPoints.add(points.get(j));
		}
		points = newPoints;
	}
	
	void randomShiftPoints() {
		shiftPoints(floor(random(1, points.size() - 1)));
	}
	
	float pointOrientedDistanceToLine(int i, Line2D line, Point2D v) {
		return line.orientedOrthogonalDistance(points.get(i), v);
	}
	
	float pointOrientedDistanceToLineG(int i, Line2D line, Point2D v) {
		float f = pointOrientedDistanceToLine(i, line, v);
		float f1 = pointOrientedDistanceToLine(0, line, v);
		float fn = pointOrientedDistanceToLine(points.size() - 1, line, v);
		float t = f1 + (fn - f1)*(i/(points.size() - 1));
		return min(f, t);
	}
	
	float segmentPointsOrientedDistancesDifference(int i, Line2D line, Point2D v) {
		Segment2D seg = segment(i);
		float da = pointOrientedDistanceToLine(i, line, v);
		float db = pointOrientedDistanceToLine((i + 1) % points.size(), line, v);
		return db - da;
	}
	
	float segmentPointsOrientedDistancesDifferenceG(int i, Line2D line, Point2D v) {
		Segment2D seg = segment(i);
		float da = pointOrientedDistanceToLineG(i, line, v);
		float db = pointOrientedDistanceToLineG((i + 1) % points.size(), line, v);
		return db - da;
	}
	
	float lineDistance(Line2D line, Point2D v) {
		int mn = 0, mx = points.size() - 1;
		while(abs(mn - mx) > 1) {
			int i = floor(mn + (mx - mn)/2);
			float dfi = segmentPointsOrientedDistancesDifferenceG(i, line, v);
			if(dfi < 0) mn = i;
			else mx = i;
		}
		w = mn + 1;
		return pointOrientedDistanceToLine(w, line, v);
	}
	
	int[] lineIntersectionSegmentIndices(Line2D line, Point2D v) {
		if(v == null) v = points.get(0);
		
		float f1 = pointOrientedDistanceToLineG(0, line, v);
		float f2 = pointOrientedDistanceToLineG(1, line, v);
		float fn = pointOrientedDistanceToLineG(points.size() - 1, line, v);
		int w; float fw;
		
		int mn = 0, mx = points.size() - 1;
		while(abs(mn - mx) > 1) {
			int i = floor(mn + (mx - mn)/2);
			float dfi = segmentPointsOrientedDistancesDifferenceG(i, line, v);
			if(dfi < 0) mn = i;
			else mx = i;
		}
		w = mn + 1;
		fw = pointOrientedDistanceToLine(w, line, v);

		if(fw > 0) {
			int[] inter = {};
			return inter;
		} else if(fw == 0) {
			int[] inter = { w };
			return inter;
		} else {
			int[] inter = {null, null};

			int mn = 0, mx = w;
			while(abs(mn - mx) > 1) {
				int i = floor(mn + (mx - mn)/2);
				float fi = pointOrientedDistanceToLine(i, line, v);
				if(fi > 0) mn = i;
				else mx = i;
			}
			inter[0] = mn;

			int mn = w, mx = points.size();
			while(abs(mn - mx) > 1) {
				int i = floor(mn + (mx - mn)/2);
				float fi = pointOrientedDistanceToLine(i, line, v);
				if(fi < 0) mn = i;
				else mx = i;
			}
			inter[1] = mn;
			
			return inter;
		}
	}
	
	Segment2D[] lineIntersectionSegments(Line2D l, Point2D v) {
		int[] segs = lineIntersectionSegmentIndices(l, v);
		if(segs.length == 0) {
			Segment2D[] segs = {};
			return segs;
		} else if(segs.length == 1) {
			Segment2D[] segs = { segment(segs[0]) };
			return segs;
		} else if(segs.length == 2) {
			Segment2D[] segs = { segment(segs[0]), segment(segs[1]) };
			return segs;
		}
	}
	
	Point2D[] lineIntersection(Line2D l, Point2D v) {
		Segment2D[] segs = lineIntersectionSegments(l, v);
		if(segs.length == 0) {
			Point2D[] pts = {};
			return pts;
		} else if(segs.length == 1) {
			Point2D[] pts = { segs[0].lineIntersection(l) };
			return pts;
		} else if(segs.length == 2) {
			Point2D[] pts = { segs[0].lineIntersection(l), segs[1].lineIntersection(l) };
			return pts;
		}
	}
	
	Segment2D[] rayItersectionSegments(Ray2D r, Point2D v) {
		Segment2D[] segs = lineIntersectionSegments(r, v);
		if(segs == null) return null;
		Point2D p1 = r.lineIntersection(segs[0]);
		Point2D p2 = r.lineIntersection(segs[1]);
		if(p1 != null && p2 != null) {
			return segs;
		} else if(p1 != null) {
			Segment2D[] res = { segs[0] }; return res;
		} else if(p1 != null) {
			Segment2D[] res = { segs[1] }; return res;
		}
	}
	
	Ray2D[] pencil(Polygon2D Q) {
		Point2D qc = Point2D.fromPVector(Q.center());
		Point2D p1 = points.get(0);
		Segment2D[] segs = Q.lineIntersectionSegments(new Line2D(qc, p1));
		if(segs == null) return null;
	
		Point2D t, u;
	
		float max_a = 0.0;
		PVector p1qc = new PVector(qc.x - p1.x, qc.y - p1.y);
		for(Point2D q = segs[1].b; q != segs[0].a.next; q = q.next) {
			PVector p1q = new PVector(q.x - p1.x, q.y - p1.y);
			float a = PVector.angleBetween(p1qc, p1q);
			if(a > max_a) { max_a = a; t = q; }
		}
		
		max_a = 0.0;
		for(Point2D q = segs[0].b; q != segs[1].a.next; q = q.next) {
			PVector p1q = new PVector(q.x - p1.x, q.y - p1.y);
			float a = PVector.angleBetween(p1qc, p1q);
			if(a > max_a) { max_a = a; u = q; }
		}
		
		Ray2D[] p = {null, null};
		if(Point2D.turn(t, p1, u) == Point2D.turn(t, t.next, t.next.next)) {
			p[0] = new Ray2D(p1, t); p[1] = new Ray2D(p1, u);
		} else {
			p[1] = new Ray2D(p1, t); p[0] = new Ray2D(p1, u);
		}

		return p;
	}
	
	Object2D[] pencilOrIntersectionPoint(Polygon2D Q) {
		Point2D qc = Point2D.fromPVector(Q.center());
		Point2D p1 = points.get(0);
		Line2D l = new Line2D(qc, p1);
		Point2D[] ab = Q.lineIntersection(l);
		PVector p1a = (new Segment2D(p1, ab[0])).toPVector();
		PVector p1b = (new Segment2D(p1, ab[1])).toPVector();
		if(PVector.dot(p1a, p1b) < 0) {
			Object2D ret = { null, p1 };
			return ret;
		}
		
		return pencil(Q);
	}
	
	int indexModulo(int index) {
		boolean negative = (index < 0);
		index %= points.size();
		if(negative) index += points.size();
		return index;
	}

	ArrayList pencilOwnPolyline(Ray2D[] pencil) {
		if(pencil[0].a != pencil[1].a) { console.log("rays don't have same origin"); return null; }
		Point2D o = pencil[0].a; // == pencil.b
		Point2D v = o.next; // must not be o
		int n = points.size();
		
		int first = -1, last = -1;
		Point2D firstp = o, lastp = o;
		
		int[] inter1 = lineIntersectionSegmentIndices(pencil[0], v);
		
		if(inter1.length == 2) {
			if(inter1[0] == 0 || inter1[0] == n) first = inter1[1];
			else first = inter1[0];

			firstp = segment(first).lineIntersection(pencil[0]);
			if(PVector.dot(pencil[0].toPVector(), Point2D.makePVector(o, firstp)) < 0) {
				firstp = o; first = -1;
			}
		}

		
		int[] inter2 = lineIntersectionSegmentIndices(pencil[1], v);
		if(inter2.length == 2) {
			if(inter2[0] == 0 || inter2[0] == n) last = inter2[1];
			else last = inter2[0];

			lastp = segment(last).lineIntersection(pencil[1]);
			if(PVector.dot(pencil[1].toPVector(), Point2D.makePVector(o, lastp)) < 0) {
				lastp = o; last = -1;
			}
		}
				
		if(first == -1 && last == -1) {
			if(! Ray2D.enclosePoints(pencil, o.next)) return new ArrayList;		
		} else if(first == -1) {
			if(Ray2D.enclosePoints(pencil, o.next)) first = 0;
			else first = n;
		} else if(last == -1) {
			if(Ray2D.enclosePoints(pencil, o.next)) last = 0;
			else last = n;
		}
		
		if(first > last) {
			int tmp = first;
			first = last;
			last = tmp;
			Point2D tmpp = firstp;
			firstp = lastp;
			lastp = tmpp;
		}
		
		Point2D secondp = (first == -1 ? o.next : points.get(indexModulo(first + 1)));
		Point2D secondlastp = (last == -1 ? o.previous : points.get(indexModulo(last)));

		
		ArrayList pts = new ArrayList;
		pts.add(firstp);
		for(Point2D pt = secondp; pt != secondlastp.next; pt = pt.next) {
			pts.add(pt);
		}
		pts.add(lastp);
		
		return pts;
	}
	
	Segment2D minimalDistance(Polygon2D Q) {
		return minimalDistanceDebug(Q, 0, false);
	}
	
	Segment2D minimalDistanceDebug(Polygon2D Q, int steps, boolean debug) {
		Polygon2D P = this;
		
		Ray2D[] pencilP = P.pencil(Q);
		Ray2D[] pencilQ = Q.pencil(P);
		
		ArrayList ps = new ArrayList;
		for(Point2D p = pencilQ[0].b; p != pencilQ[1].b.next; p = p.next) ps.add(p);

		ArrayList qs = new ArrayList;
		for(Point2D q = pencilP[0].b; q != pencilP[1].b.next; q = q.next) qs.add(q);

		int p1 = 0, p2 = ps.size() - 1, np = ps.size();
		int q1 = 0, q2 = qs.size() - 1, nq = qs.size();

		if(debug) {
			for(int i = points.size() - 1; i >= 0; --i) { points.get(i).strokeColor = #000000; points.get(i).label = i; }	
			for(int i = Q.points.size() - 1; i >= 0; --i) { Q.points.get(i).strokeColor = #000000; Q.points.get(i).label = i; }
		}
		
		int currStep = 0;
		while(np > 2 || nq > 2) {
			if(++currStep == steps) break;
			
			int oldnp = np, oldnq = nq;
			
			int mpi = p1 + ceil((p2-p1) / 2);
			int mqi = q1 + ceil((q2-q1) / 2);
			Point2D mp = ps.get(mpi);
			Point2D mq = qs.get(mqi);
			if(mp == null || mq == null) return null;
						
			float a1 = Point2D.angle(mq, mp, mp.previous);
			float a2 = Point2D.angle(mp.next, mp, mq);
			if(a1 > PI && a2 > PI) { a1 -= TWO_PI; a2 -= TWO_PI; }
				
			float b1 = Point2D.angle(mq.previous, mq, mp);
			float b2 = Point2D.angle(mp, mq, mq.next);
			if(b1 > PI && b2 > PI) { b1 -= TWO_PI; b2 -= TWO_PI; }
			
			//////////// DEBUG ////////////
			if(debug && currStep == steps-1) {
				Segment2D dseg = new Segment2D(mp, mq);
				dseg.label = currStep;
				dseg.draw();	
	
				ps.get(p1).strokeColor = #0000ff;
				ps.get(p1).label = "P1";
				ps.get(p2).strokeColor = #ff0000;
				ps.get(p2).label = "P2";
				
				qs.get(q1).strokeColor = #0000ff;
				qs.get(q1).label = "Q1";
				qs.get(q2).strokeColor = #ff0000;
				qs.get(q2).label = "Q2";
				
				stroke(50);
				float d = 180.0 / PI;
				textAlign(LEFT);
				text("a2 = " + formatNumber(a2*d, 2), mp.x + 5, mp.y - 15);
				text("a1 = " + formatNumber(a1*d, 2), mp.x + 5, mp.y + 15);
				textAlign(RIGHT);
				text("b2 = " + formatNumber(b2*d, 2), mq.x - 5, mq.y - 15);
				text("b1 = " + formatNumber(b1*d, 2), mq.x - 5, mq.y + 15);
			}
			//////////// END DEBUG ////////////

			if(np == 1) {
				if(debug) console.log("P: one vertex");
				if(b1 >= HALF_PI) q1 = mqi;
				if(b2 >= HALF_PI) q2 = mqi;
				
			} else if(nq == 1) {
				if(debug) console.log("Q: one vertex");
				if(a1 >= HALF_PI) p1 = mpi;
				if(a2 >= HALF_PI) p2 = mpi;
				
			} else if(np == 2) {
				if(debug) console.log("P: two vertices");
				if(a1 > 0) {
					if(a1 + b1 > PI) {
						if(a1 >= HALF_PI) p1 = p2;
						if(b1 >= HALF_PI) q1 = mqi;
					}
					if(b2 >= HALF_PI) q2 = mqi;
					if(a1 < b2 && b2 < HALF_PI) {
						Segment2D p1p2seg = new Segment2D(ps.get(p1), ps.get(p2));
						if(p1p2seg.projectionIsOnSegment(mq)) q2 = mqi;
						else p2 = p1;
					}
				} else {
					p2 = p1;
					if(b1 >= PI) q1 = mqi;
					if(b2 >= PI) q2 = mqi;
				}
				
			} else if(nq == 2) {
				if(debug) console.log("Q: two vertices");
				if(b2 > 0) {
					if(a1 + b1 > PI) {
						if(b1 >= HALF_PI) q1 = q2;
						if(a1 >= HALF_PI) p1 = mpi;
					}
					if(a2 >= HALF_PI) p2 = mpi;
					if(b1 < a2 && a2 < HALF_PI) {
						Segment2D q1q2seg = new Segment2D(qs.get(q1), qs.get(q2));
						if(q1q2seg.projectionIsOnSegment(mp)) p2 = mpi;
						else q2 = q1;
					}
				} else {
					q2 = q1;
					if(a1 >= PI) p1 = mpi;
					if(a2 >= PI) p2 = mpi;
				}
				
			} else if(a1 >= 0 && a2 >= 0 && b1 >= 0 && b2 >= 0) {
				if(debug) console.log("> 3 vertices: all angles positive");
				if(a1 + b1 > PI) {
					if(a1 >= HALF_PI) p1 = mpi;
					if(b1 >= HALF_PI) q1 = mqi;
				}
				if(a2 + b2 > PI) {
					if(a2 >= HALF_PI) p2 = mpi;
					if(b2 >= HALF_PI) q2 = mqi;
				}
				
			} else if(a1 < 0) {
				if(debug) console.log("> 3 vertices: a1 and a2 negative");
				if(a1 > a2) p2 = mpi;
				else p1 = mpi;
				if(b1 > PI) q1 = mqi;
				if(b2 > PI) q2 = mqi;
				

			} else if(b1 < 0) {
				if(debug) console.log("> 3 vertices: b1 and b2 negative");
				if(b1 > b2) q2 = mqi;
				else q1 = mqi;
				if(a1 > PI) p1 = mpi;
				if(a2 > PI) p2 = mpi;
				
			}

			np = p2 - p1 + 1;
			nq = q2 - q1 + 1;
			
			if(np >= oldnp && nq >= oldnq) {
				if(debug) console.log("loop");
				return null;
			}
			
			if(debug) console.log(oldnp, oldnq, "->", np, nq);
		}
		
		if(debug) {
			ps.get(p1).label = ps.get(p1).label + " (P1)";
			ps.get(p2).label = ps.get(p2).label + " (P2)";
			qs.get(q1).label = qs.get(q1).label + " (Q1)";
			qs.get(q2).label = qs.get(q2).label + " (Q2)";
		}
		
		if(np > 2 || nq > 2) return null;		
		
		Point2D p1_ = ps.get(p1), p2_ = ps.get(p2), q1_ = qs.get(q1), q2_ = qs.get(q2);
		if(p1_ == null || p2_ == null || q1_ == null || q2_ == null) return null;
		
		if(np == 1 && nq == 1) {
			if(debug) console.log("two vertices");
			return new Segment2D(ps.get(p1), qs.get(q1));
			
		} else if(np == 1) {
			if(debug) console.log("edge in Q");
			Point2D r, q;
			Segment2D q1q2 = new Segment2D(q1_, q2_);
			if(q1q2.projectionIsOnSegment(p1_)) r = q1q2.projection(p1_); else r = q1_;
			
			float d1 = Point2D.sqDistance(q1_, p1_), d2 = Point2D.sqDistance(q2_, p1_), dr = Point2D.sqDistance(r, p1_);
			if(d1 < d2) { if(dr < d1) q = r; else q = q1_; }
			else { if(dr < d2) q = r; else q = q2_; }
			
			return new Segment2D(p1_, q);
			
		} else if(nq == 1) {
			if(debug) console.log("edge in Q");
			Point2D r, p;
			Segment2D p1p2 = new Segment2D(p1_, p2_);
			if(p1p2.projectionIsOnSegment(q1_)) r = p1p2.projection(q1_); else r = p1_;
			
			float d1 = Point2D.sqDistance(p1_, q1_), d2 = Point2D.sqDistance(p2_, q1_), dr = Point2D.sqDistance(r, q1_);
			if(d1 < d2) { if(dr < d1) p = r; else p = p1_; }
			else { if(dr < d2) p = r; else p = p2_; }
			
			return new Segment2D(p, q1_);
			
		} else {
			if(debug) console.log("2 edges");
			Segment2D q1q2 = new Segment2D(q1_, q2_), p1p2 = new Segment2D(p1_, p2_);
			
			Segment2D[] segs = new Segment2D[8];
			int nseg = 3;
			segs[0] = new Segment2D(p1_, q1_);
			segs[1] = new Segment2D(p1_, q2_);
			segs[2] = new Segment2D(p2_, q1_);
			segs[3] = new Segment2D(p2_, q2_);
			if(q1q2.projectionIsOnSegment(p1_)) segs[++nseg] = new Segment2D(p1_, q1q2.projection(p1_));
			if(q1q2.projectionIsOnSegment(p2_)) segs[++nseg] = new Segment2D(p2_, q1q2.projection(p2_));
			if(p1p2.projectionIsOnSegment(q1_)) segs[++nseg] = new Segment2D(q1_, p1p2.projection(q1_));
			if(p1p2.projectionIsOnSegment(q2_)) segs[++nseg] = new Segment2D(q2_, p1p2.projection(q2_));

			float min_d;
			Segment2D min_seg = null;
			for(int i = 0; i <= nseg; ++i) {
				Segment2D seg = segs[i];
				float d = seg.sqNorm();
				if(min_seg == null || d < min_d) { min_d = d; min_seg = seg; }
			}
			
			return min_seg;
		}
	}
}
