function ultraCheck(brick)
    wallDistance =  brick.UltrasonicDist(3);
    global speedA;
    global speedB;
    %where we would want the robot to be around
    distanceWall = 22;
    
    %deviation from center desired
    distanceRoom = 1;
    
    %Distance to indicate when to turn right.
    distanceMax = 40;
    
    %Equations to slow down the speed as it gets closer to the center
    driftLeftEquation = -speedA + (27 / (30 - wallDistance^3));
    driftRightEquation = ( 2 / (10 * wallDistance - 30)) - speedB;
    
    disp(wallDistance);
    
    disp(wallDistance);
    if wallDistance > (distanceWall - distanceRoom) && wallDistance < (distanceWall + distanceRoom) %Keepmoving forward
       %if statement used to keep moving forward if it is in the center and room inside the room of error.
            fprintf("Moving Forward");
            
            
        
        
    elseif wallDistance > (distanceWall + distanceRoom) && wallDistance < distanceMax %Drifiting left
        fprintf("Drifting Left");
      
           speedA = -(driftLeftEquation);
          

   elseif (wallDistance > distanceMax) % turning right
         fprintf("turning right");
         turn(brick, 90);
        
   elseif wallDistance < (distanceWall - distanceRoom) %Drifitng right
          fprintf("Drifting Right");
      
             
             speedB = -(driftRightEquation);
             
          

        
   end

end
