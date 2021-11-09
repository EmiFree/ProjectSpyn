state = 0;

while (state ~= 6) 
	switch state
		case 0
			check(brick);

        case 1 % Turning left 
            turn(90);
            % transition to checking
            fprintf("State 1");
            state = 0;

        case 2 % Turning right
            turn(-90);
            % transition to moving forward
            fprintf("State 2");
            state = 4;

        case 3 % Pick Up
            manual(brick);
            % back to checking
            fprintf("State 3");
            state = 0;

        case 4 % Moving Forward 24” until specific color, touch sensor, or ultrasonic.
            int detect = 0;
            fprintf("State 4");
            moveCell(brick);

        case 5 % Pause for 3 sec then move forward 12
            stopAndMove(brick);
            % back to checking
            fprintf("State 5");
            state = 0;

        case 6 % Dropping off
            fprintf("State 6");
            dropOff(brick);
    
    
end    
end

function check(brick) 

            pause(1);
            rightWall =  brick.UltrasonicDist(4);
            frontWall = brick.TouchPressed(2);
            bumps = brick.TouchBumps(4);
            %display(bumps)
            display(frontWall);

            if (rightWall > 21 && rightWall < 30 && frontWall == 0)
                %There is a right wall and no front wall.
                brick.MoveMotor('AB', -50);
                %Moving Forward
                state = 4;
                
            elseif (rightWall > 21 && rightWall < 30 && frontWall == 1)
                %There is a right wall and there is a wall in front.
                brick.StopAllMotors('Brake');  %stops robot
                brick.MoveMotor('AB', 50);
                %Turning left
                state = 1;

            elseif (rightWall > 30 && frontWall == 1)  
                %There is no right wall and a wall in front.  
                brick.StopAllMotors('Brake');  %stops robot
                %Turning Right
                state = 2;
            end
            
            if (frontWall == 0)
                state = 4;
            end

end

function moveCell(brick)
    
    brick.SetColorMode(1, 2);
    colorState = brick.ColorCode(1);

   while(colorState ~= 0)

        brick.MoveMotor('A',-50);
        brick.MoveMotor('B',-50);
        colorState = brick.ColorCode(1);
        check(brick);

        switch colorState 
                 case 0
                     fprintf("Continue :)");
                 case 5
                     fprintf("Red ");
                     state = 5;
                 case 4
                     fprintf("Yellow ");
                     state = 2;
                 case 3
                     fprintf("Green ");
                     state = 2;
        end
    end
    
    brick.StopMotor('A', 'Brake');
    brick.StopMotor('B', 'Brake');


    if (detect == 0) % no color
        % back to checking
        state = 0;
    end
    if (detect == 1) % detects green
         % transition to pick up
         state = 3;
    end
    if (detect == 2) % detects red
         % transition to pause
         state = 5;
    end
    if (detect == 3) % detects yellow
         % transition to drop off
         state = 6;
    end
    
end

function manual(brick)
    global key
    InitKeyboard(); %Stores value of "key" based on what is pressed.

    while 1 %Infinite loop that will continue until "break" requirements is met
        pause(0.1);
        switch key %Runs the instructions based on what key is pressed
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
                brick.MoveMotorAngleRel('C', 10, 75, 'Brake');
            case 'p'
                brick.MoveMotorAngleRel('C', -10, 75, 'Brake');


            case 'q'
                break; %Stops running the program
        end
    end
    CloseKeyboard(); %Closes keyboard inputs


end
