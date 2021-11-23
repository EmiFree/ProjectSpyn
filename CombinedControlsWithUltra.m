global speedA
global speedB
speedA = -30;
speedB = -30;

global loop
loop = 1;
brick.SetColorMode(1, 2);


    while(loop == 1)        %main loop, runs scanning functions, moves the robot       
    colorCheck(brick);
    pause(0.02);
    touchCheck(brick);
    pause(0.05);
    ultraCheck(brick);
    pause(0.01); 
    brick.MoveMotor('A', speedA);       
    brick.MoveMotor('B',speedB);
    
    fprintf("SpeedA: ");
    disp(speedA);
    fprintf("SpeedB: ");
    disp(speedB);
    end
    
    %END OF MAIN LOOP, ALL CODE IN THIS ZONE IS EXIT CODE
    
    brick.StopMotor('A', 'Brake');          %stop robot to finish
    brick.StopMotor('B', 'Brake');
    
    %END OF EXIT CODE, ALL CODE BEYOND HERE ARE METHODS    


function turn(brick, angle)                 %uses gyro to turn exact angle, CCW/left negative
                                            %CW/right positive
    brick.StopMotor('A', 'Brake');          %stop robot
    brick.StopMotor('B', 'Brake');
    pause(0.5);
    brick.GyroCalibrate(2);                 %set current angle to 0 degrees
    pause(0.5);
    brick.playTone(20, 530, 166.67);
    curAngle = brick.GyroAngle(2);          %read current angle measure
    curAngle = brick.GyroAngle(2);
    curAngle = brick.GyroAngle(2);
    disp(angle);
    disp(curAngle);
    if(angle > 0)                           %positive, so turn CW/right
        fprintf("CW");
        disp(curAngle);
       while (curAngle < (angle - 6))                           %check when to stop spinning when desired angle is met
           brick.MoveMotorAngleRel('A', 25, 5, 'Brake');        %spin a tiny ammount then stop
           brick.MoveMotorAngleRel('B', -25, 5, 'Brake');       
           curAngle = brick.GyroAngle(2);                       %read angle measure
           curAngle = brick.GyroAngle(2);
           curAngle = brick.GyroAngle(2);           
           disp(curAngle);
           
       end                             
    else                                    %negative, so turn CCW/left
        fprintf("CCW");
        while(curAngle > (angle + 6))                           %check when to stop spinning when desired angle is met
           brick.MoveMotorAngleRel('A', -25, 5, 'Brake');       %spin a tiny ammount then stop
           brick.MoveMotorAngleRel('B', 25, 5, 'Brake');
           curAngle = brick.GyroAngle(2);                       %read angle measure
           curAngle = brick.GyroAngle(2);   
           curAngle = brick.GyroAngle(2);
           disp(curAngle);

        end      
    end    

end

function touchCheck(brick)
    frontWall = brick.TouchPressed(4);   
    if(frontWall == 1)
        fprintf("bump!");
        brick.StopMotor('A');                               %stops robot
        brick.StopMotor('B');
        brick.MoveMotorAngleRel('A', 25, 200, 'Brake');     %move backwards to give room to turn
        brick.MoveMotorAngleRel('B', 25, 200, 'Brake');
        pause(2);
        turn(brick, -90);                                   %turn left 90 degrees
    end
    frontWall = 0;                                          %set touch sensor back to 0
end

function colorCheck(brick)
   global loop
   colorState = brick.ColorCode(1);
   
    switch colorState 
             case 0
                 fprintf("Continue :)");
             case 5                                         %Case when color is RED
                 brick.StopMotor('A', 'Brake');
                 brick.StopMotor('B', 'Brake');               
                 fprintf("Stopped at red line");
                 pause(3);
                 brick.MoveMotorAngleRel('AB', -30, 180, 'Brake');
                 pause(1);
                 
             case 4                                         %Case when color is YELLOW
                 if (green == true)
                    brick.StopMotor('A', 'Brake');
                    brick.StopMotor('B', 'Brake');
                    yellow(brick);
                    music(brick);
                 end    
                 fprintf("Yellow ");
                 %turn around, drop off passenger, and end program
                 loop = 0;
                 
             case 3                                         %Case when color is GREEN
                 if(green == false)
                     brick.StopMotor('A', 'Brake');
                     brick.StopMotor('B', 'Brake');
                     fprintf("Green ");
                     green = true;
                     manualControl(brick);      %switch to manual controls
                 end 
    end
    

end

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
    fprintf("wall distance : ");    
    disp(wallDistance);
    %if wallDistance > (distanceWall - distanceRoom) && wallDistance < (distanceWall + distanceRoom) %Keepmoving forward
       %if statement used to keep moving forward if it is in the center and room inside the room of error.
     %       fprintf("Moving Forward");
      driftRightEquation = ( (700* wallDistance) / wallDistance^3) +30;      
      driftLeftEquation = 50 + (3^(wallDistance-25) - 20);      
                
    if (wallDistance > distanceMax) % turning right
        fprintf("turning right");
         brick.StopMotor('B', 'Brake');
         brick.StopMotor('A', 'Brake');
         
         pause(1);
         brick.playTone(20, 440, 166.67);
         
         brick.MoveMotorAngleRel('A', -30, 720, 'Brake');
         brick.MoveMotorAngleRel('B', -30, 720, 'Brake');
         pause(3);
         
         
         turn(brick, 90);
         brick.playTone(20, 300, 166.67);
         pause(0.2);
         
         brick.MoveMotorAngleRel('A', -30, 720, 'Brake');
         brick.MoveMotorAngleRel('B', -30, 720, 'Brake');
         pause(3);
                  
   elseif wallDistance < (distanceWall - distanceRoom) %Drifitng right
        fprintf("Drifting Right");
        speedA = -(driftRightEquation);    

   elseif wallDistance > (distanceWall + distanceRoom) && wallDistance < distanceMax %Drifiting left
        fprintf("Drifting Left");
        speedB = -(driftLeftEquation);
                
   end

end

function manualControl(brick)
    global key
    InitKeyboard();     %Stores value of "key" based on what is pressed.
    manLoop = 1;
    while(manLoop == 1)
        pause(0.1);
        switch key      %Runs the instructions based on what key is pressed
            case 'w'
                disp('Going Forward');
                brick.MoveMotorAngleRel('A', -30, 200, 'Brake');
                brick.MoveMotorAngleRel('B', -30, 200, 'Brake');
            case 's'
                disp('Going Back');
                brick.MoveMotorAngleRel('A', 30, 200, 'Brake');
                brick.MoveMotorAngleRel('B', 30, 200, 'Brake');
            case 'd'
                disp('Going Left');
                brick.MoveMotorAngleRel('A', 10, 75, 'Brake');
                brick.MoveMotorAngleRel('B', -5, 75, 'Brake');
            case 'a'
                disp('Going Right');
                 brick.MoveMotorAngleRel('A', -5, 75, 'Brake');
                brick.MoveMotorAngleRel('B', 10, 75, 'Brake');
            case 'o'
                brick.MoveMotorAngleRel('C', 60, 270, 'Brake');
            case 'p'
                brick.MoveMotorAngleRel('C', -60, 270, 'Brake');
            case 'm'
                music(brick);

            case 'q'
                manLoop = 0; %Stops running the program
        end
    end
    CloseKeyboard(); %Closes keyboard inputs

end

function music(brick)
            volume = 10;
            brick.playTone(volume, 349.23, 166.67);
            pause(0.16667);
            brick.playTone(volume, 466.16, 166.67);
            pause(0.16667);
            brick.playTone(volume, 587.33, 166.67);
            pause(0.16667);
            brick.playTone(volume, 698.46, 275);
            pause(0.300);
            brick.playTone(volume, 587.33, 125);
            pause(0.125);
            brick.playTone(volume, 698.46, 1000);
end

function yellow(brick)
    brick.StopMotor('A', 'Brake');
    brick.StopMotor('B', 'Brake');
    fprintf("Yellow ");
    turn(brick,180);
    pause(5);
    
    brick.MoveMotorAngleRel('C', 60, 4000, 'Brake'); 
    pause(3);
    brick.MoveMotorAngleRel('A', -30, 200, 'Brake');
    brick.MoveMotorAngleRel('B', -30, 200, 'Brake')
end
