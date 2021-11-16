global speedA
global speedB
speedA = -40;
speedB = -40;

global loop
loop = 1;
brick.SetColorMode(1, 2);


    while(loop == 1)        %main loop, runs scanning functions, moves the robot
 
    brick.MoveMotor('A', speedA);       %need to check how speed increments in a loop work
    brick.MoveMotor('B',speedB);        %and make sure that you can change speed without using a stop motor command
    
    colorCheck(brick);
    pause(0.05);
    touchCheck(brick);
    pause(0.05); 
    ultraCheck(brick);
    pause(0.05); 
    fprintf("SpeedA: ");
    disp(speedA);
    fprintf("SpeedB: ");
    disp(speedB);
    end

    


function turn(brick, angle)     %uses gyro to turn exact angle, CCW/left negative
                                %CW/right positive
    brick.StopMotor('A', 'Brake');
    brick.StopMotor('B', 'Brake');
    brick.GyroCalibrate(2);
    pause(0.5);
    curAngle = brick.GyroAngle(2);
    curAngle = brick.GyroAngle(2);
    curAngle = brick.GyroAngle(2);
    disp(angle);
    disp(curAngle);
    if(angle > 0)               %positive, so turn CW/right
        fprintf("CW");
        disp(curAngle);
       while (curAngle < (angle - 6))
           brick.MoveMotorAngleRel('A', 25, 5, 'Brake');
           brick.MoveMotorAngleRel('B', -25, 5, 'Brake');
           curAngle = brick.GyroAngle(2);
           curAngle = brick.GyroAngle(2);
           curAngle = brick.GyroAngle(2);           
           disp(curAngle);
           
       end                             
    else                        %negative, so turn CCW/left
        fprintf("CCW");
        while(curAngle > (angle + 6))
           brick.MoveMotorAngleRel('A', -25, 5, 'Brake');
           brick.MoveMotorAngleRel('B', 25, 5, 'Brake');
           curAngle = brick.GyroAngle(2);
           curAngle = brick.GyroAngle(2);
           curAngle = brick.GyroAngle(2);
                      disp(curAngle);

        end      
    end    

end

function touchCheck(brick)
    %do whatever turning thing is needed when the touch sensor is pressed
    frontWall = brick.TouchPressed(4);
    
    if(frontWall == 1)
        fprintf("bump!");
        brick.StopMotor('A');  %stops robot
        brick.StopMotor('B');
        brick.MoveMotorAngleRel('A', 25, 200, 'Brake');
        brick.MoveMotorAngleRel('B', 25, 200, 'Brake');
        pause(2);
        turn(brick, -90); 
    end
    frontWall = 0;
end

function colorCheck(brick)
   global loop
   colorState = brick.ColorCode(1);
   
    switch colorState 
             case 0
                 fprintf("Continue :)");
             case 5
                 brick.StopMotor('A', 'Brake');
                 brick.StopMotor('B', 'Brake');               
                 fprintf("Stopped at red line");
                 pause(3);
                 
             case 4
                 brick.StopMotor('A', 'Brake');
                 brick.StopMotor('B', 'Brake');
                 fprintf("Yellow ");
                 %turn around, drop off passenger, and end program.
                 music(brick);
                 loop = 0;
                 
             case 3
                 brick.StopMotor('A', 'Brake');
                 brick.StopMotor('B', 'Brake');
                 fprintf("Green ");
                 manualControl(brick);      %switch to manual controls
    end
    

end

function ultraCheck(brick)
    wallDistance =  brick.UltrasonicDist(3);
    global speedA;
    global speedB;
    %where we would want the robot to be around
    distanceWall = 22;
    
    %deviation from center desired
    distanceRoom = 6;
    
    %Distance to indicate when to turn right.
    distanceMax = 50;
    
    %Equations to slow down the speed as it gets closer to the center
    driftLeftEquation = -speedA + (wallDistance / 30);
    driftRightEquation = (10 / wallDistance) - speedB;
    
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

   elseif (wallDistance > distanceMax) % turning right
            fprintf("turning right");
            brick.MoveMotor('A', speedA);
            brick.MoveMotor('B', 30);
            pause(1);
            
   elseif wallDistance < (distanceWall - distanceRoom) %Drifitng right
          fprintf("Drifting Right");
      
             brick.MoveMotor('B', speedB);
             brick.MoveMotor('A', -(driftRightEquation));
             pause(1);
          

        
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
