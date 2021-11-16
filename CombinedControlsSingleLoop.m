global speedA
global speedB
speedA = -50;
speedB = -50;

global loop
loop = 1;
brick.SetColorMode(1, 2);


    while(loop == 1)        %main loop, runs scanning functions, moves the robot
 
    brick.MoveMotor('A', speedA);       %need to check how speed increments in a loop work
    brick.MoveMotor('B',speedB);        %and make sure that you can change speed without using a stop motor command
    
    touchCheck(brick);
    
    colorCheck(brick);
    
    ultraCheck(brick);
    

    end
turn(brick, 90);        %need to test this method, probably doesn't work well but its a start
    
CloseKeyboard(); %Closes keyboard inputs


function turn(brick, angle)     %uses gyro to turn exact angle, CCW/left positive
                                %CW/right negative
    brick.StopMotor('A', 'Brake');
    brick.StopMotor('B', 'Brake');
    brick.GyroCalibrate(2);
    curAngle = brick.GyroAngle(2);
    
    if(angle > 0)               %positive, so turn CCW/left
       while(curAngle < angle)
           brick.MoveMotorAngleRel('A', -25, 20, 'Brake');
           brick.MoveMotorAngleRel('B', 25, 20, 'Brake');
           curAngle = brick.GyroAngle(2);         
       end                             
    else                        %negative, so turn CW/right
        while(curAngle > angle)
           brick.MoveMotorAngleRel('A', 25, 20, 'Brake');
           brick.MoveMotorAngleRel('B', -25, 20, 'Brake');
           curAngle = brick.GyroAngle(2);         
        end      
    end    

end

function touchCheck(brick)
    %do whatever turning thing is needed when the touch sensor is pressed
    frontWall = brick.TouchPressed(4);
    
    if(frontWall == 1)
        fprintf("bump!");
        brick.StopAllMotors('Brake');  %stops robot
        brick.MoveMotorAngleRel('B', 25, 20, 'Brake');
        turn(brick, 90); 
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
    %add ultrasonic testing and adjustments to speedA and speedB here
    music(brick);           %temp code so method is not empty
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
            case 'a'
                disp('Going Left');
                brick.MoveMotorAngleRel('A', 10, 75, 'Brake');
                brick.MoveMotorAngleRel('B', -5, 75, 'Brake');
            case 'd'
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

end

function music(brick)
            volume = 100;
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


%test edit
