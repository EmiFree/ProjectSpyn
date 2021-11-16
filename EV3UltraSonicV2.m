state = 0;

while state ~= 6
    
    wallDistance =  brick.UltrasonicDist(3);
    
    %where we would want the robot to be around
    distanceWall = 22;
    
    %deviation from center desired
    distanceRoom = 0.5;
    
    %Distance to indicate when to turn right.
    distanceMax = 50;
    
    %Equations to slow down the speed as it gets closer to the center
    driftLeftEquation = 30 + (wallDistance / 20);
    driftRightEquation = (19 / wallDistance) + 30;
    
    disp(wallDistance);
    
    if wallDistance > (distanceWall - distanceRoom) && wallDistance < (distanceWall + distanceRoom) %Keepmoving forward
       %if statement used to keep moving forward if it is in the center and
       %room inside the room of error.
            fprintf("Moving Forward");
            brick.MoveMotorAngleRel('A', -30, 200, 'Brake');
            brick.MoveMotorAngleRel('B', -30, 200, 'Brake');
            pause(1);
        
        
    elseif wallDistance > (distanceWall + distanceRoom) %Drifiting left
        fprintf("Drifting Left");
       % while wallDistance > (distanceWall - distanceRoom) 
            brick.MoveMotorAngleRel('B', -(driftLeftEquation), 100, 'Brake');
            brick.MoveMotorAngleRel('A', -30, 100, 'Brake');
            pause(1);
       % end
        

   elseif (wallDistance > distanceWall) % turning right
         % fprintf("turning right");
        
   elseif wallDistance < (distanceWall - distanceRoom) %Drifitng right
          fprintf("Drifting Right");
        
          brick.MoveMotorAngleRel('B', -30, 150, 'Brake');
          brick.MoveMotorAngleRel('A', -(driftRightEquation), 150, 'Brake');
          pause(1);

        
   end
    
end
