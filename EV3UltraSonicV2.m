state = 0;

while state ~= 6
    
    wallDistance =  brick.UltrasonicDist(3);
    
    %where we would want the robot to be around
    distanceWall = 22;
    
    %deviation from center desired
    distanceRoom = 6;
    
    %Distance to indicate when to turn right.
    distanceMax = 50;
    
    speedA = -25;
    speedB = -25;
    %Equations to slow down the speed as it gets closer to the center
    driftLeftEquation = -speedA + (wallDistance / 20);
    driftRightEquation = (20 / wallDistance) - speedB;
    
    disp(wallDistance);
    
    disp(wallDistance);
    if wallDistance > (distanceWall - distanceRoom) && wallDistance < (distanceWall + distanceRoom) %Keepmoving forward
       %if statement used to keep moving forward if it is in the center and room inside the room of error.
            fprintf("Moving Forward");
            brick.MoveMotor('A', speedA);
            brick.MoveMotor('B', speedB);
            pause(1);
            
        
        
    elseif wallDistance > (distanceWall + distanceRoom) %Drifiting left
        fprintf("Drifting Left");
      
           brick.MoveMotor('B', -(driftLeftEquation));
           brick.MoveMotor('A', speedA);
           pause(1);

   elseif (wallDistance > distanceWall) % turning right
         % fprintf("turning right");
        
   elseif wallDistance < (distanceWall - distanceRoom) %Drifitng right
          fprintf("Drifting Right");
      
             brick.MoveMotor('B', speedB);
             brick.MoveMotor('A', -(driftRightEquation));
             pause(1);
          

        
   end
    
end
