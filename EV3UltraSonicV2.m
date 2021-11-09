state = 0;

while state ~= 6
    
    wallDistance =  brick.UltrasonicDist(3);
    
    %where we would want the robot to be around
    distanceWall = 22;
    
    %deviation from center desired
    distanceRoom = 1.5;
    
    %Distance to indicate when to turn right.
    distanceMax = 50;
    
    %Equations to slow down the speed as it gets closer to the center
    driftLeftEquation = 30 + (wallDistance / 15);
    driftRightEquation = 33 - (wallDistance / 15);
    
    disp(wallDistance);
    
    disp(wallDistance);
    if wallDistance > (distanceWall - distanceRoom) && wallDistance < (distanceWall + distanceRoom) %Keepmoving forward
       
        fprintf("1");
        brick.MoveMotorAngleRel('A', 30, 200, 'Brake');
        brick.MoveMotorAngleRel('B', 30, 200, 'Brake');
        pause(1);
        
        
    elseif wallDistance > (distanceWall + distanceRoom) %Drifiting left
        fprintf("2");
       % while wallDistance > (distanceWall - distanceRoom) 
            brick.MoveMotorAngleRel('A', (driftLeftEquation), 100, 'Brake');
            brick.MoveMotorAngleRel('B', 30, 100, 'Brake');
            pause(1);
       % end
        

   elseif (wallDistance > distanceWall) % turning right
      %  fprintf("turning right");
        
   elseif wallDistance < (distanceWall + distanceRoom) %Drifitng right
          fprintf("3");
        
          brick.MoveMotorAngleRel('A', 30, 150, 'Brake');
          brick.MoveMotorAngleRel('B', (driftRightEquation), 150, 'Brake');
          pause(1);

        
   end
    
end
