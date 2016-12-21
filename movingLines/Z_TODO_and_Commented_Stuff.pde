 /*
 ToDos:
 
 - Save
 
 - Spout & Resolume
 - 
 
 
 */
 
 
 /*
 
 
 
 
      ArrayList<PVector> objCornerPoints = obj.cornerPoints;
      
      for (int i = 0; i < objCornerPoints.size(); i++) {
        PVector v = objCornerPoints.get(i);

        PVector vOrig = objCornerPoints.get(i);
        //  println(i);
        float r1 = random(-spread, spread);
        float r2 = random(-spread, spread);
        v.x += random(-1, 1);
        if (dist(v.x + r1, v.y, vOrig.x, vOrig.y) > slowMovePointMaxDistSwitchDir) {
          v.x -= r1;
        }

        if (dist(v.x, v.y + r2, vOrig.x, vOrig.y) > slowMovePointMaxDistSwitchDir) {
          v.y -= r2;
        }

        if (dist(v.x, v.y, vOrig.x, vOrig.y) > slowMovePointMaxDistReset ) {
          v.x = vOrig.x;
          v.y = vOrig.y;
        }

        obj.extraPointsMoving.set(i, v);

        for (int j = 1; j < obj.extraPointsMoving.size(); j++) {
          PVector v1 =  obj.extraPointsMoving.get(j);

          if (dist(v.x, v.y, v1.x, v1.y) < slowMoveMaxEdgeLength && dist(v.x, v.y, v1.x, v1.y) > slowMoveMinEdgeLength ) {

            line(v.x, v.y, v1.x, v1.y);
          }
        }
      }
      
      */