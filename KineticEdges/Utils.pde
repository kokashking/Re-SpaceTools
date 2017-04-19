public boolean contains(PVector test, ArrayList<PVector> pList) {
  int nPoints = pList.size();

  PVector[] points = new PVector[nPoints];
  ;

  PVector actP;

  for (int i = 0; i < nPoints; i++) {
    actP = new PVector(pList.get(i).x, pList.get(i).y);
    points[i] = actP;
  }

  int i;
  int j;
  boolean result = false;
  for (i = 0, j = points.length - 1; i < points.length; j = i++) {
    if ((points[i].y > test.y) != (points[j].y > test.y) &&
      (test.x < (points[j].x - points[i].x) * (test.y - points[i].y) / (points[j].y-points[i].y) + points[i].x)) {
      result = !result;
    }
  }
  return result;
}


public ArrayList<PVector> translateList(ArrayList<PVector> inList, PVector delta) {
  ArrayList<PVector> outList = cloneList(inList);

  for (PVector item : outList) 
    item.add(delta);

  return outList;
}

public static ArrayList<PVector> cloneList(ArrayList<PVector> list) {
  ArrayList<PVector> clone = new ArrayList<PVector>(list.size());
  for (PVector item : list) clone.add(new PVector(item.x, item.y));
  return clone;
}

ArrayList<Double> crtsnToPlr(int x, int y) {
  ArrayList<Double> radiusAndAngle = new ArrayList<Double>();
  Double radius = Math.sqrt( x * x + y * y );
  Double angleInRadians = Math.acos( x / radius );
  
  radiusAndAngle.add(radius);
  radiusAndAngle.add(angleInRadians);
  
  return radiusAndAngle;
}