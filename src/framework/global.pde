int sign(float f) {
	if(f > 0.0) return 1;
	else if(f < 0.0) return -1;
	else return 0;
}

boolean isUnimodalSequence(ArrayList seq) {
	boolean changed = false;
	boolean increasing = (seq.get(0) < seq.get(1));
	float prev = seq.get(1);
	for(int i = 2; i < seq.size(); ++i) {
		float curr = seq.get(i);
		boolean cmp = (prev < curr);
		if(cmp != increasing) {
			if(changed) return false;
			else { increasing = cmp; changed = true; }
		}
		prev = curr;
	}
	return changed;
}

float unimodalSequenceMaximum(ArrayList seq) {
	
}

float unimodalSequenceMinimum(ArrayList seq) {
	
}

String formatNumber(float n, int decimals) {
	int m = pow(10, decimals);
	n *= m;
	n = round(n);
	return n / m;
}
