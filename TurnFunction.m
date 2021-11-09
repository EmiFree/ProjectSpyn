turn(brick, 180);        %need to test this method, probably doesn't work well but its a start
    

function turn(brick, angle)     %uses gyro to turn exact angle, CCW/left positive
                                %CW/right negative
    %brick.StopMotor('A', 'Brake');
    %brick.StopMotor('B', 'Brake');
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
       while (curAngle < angle - 2)
           brick.MoveMotorAngleRel('A', 25, 5, 'Brake');
           brick.MoveMotorAngleRel('B', -25, 5, 'Brake');
           curAngle = brick.GyroAngle(2);
           curAngle = brick.GyroAngle(2);
           curAngle = brick.GyroAngle(2);           
           disp(curAngle);
           
       end                             
    else                        %negative, so turn CCW/left
        fprintf("CCW");
        while(curAngle > angle)
           brick.MoveMotorAngleRel('A', 25, 5, 'Brake');
           brick.MoveMotorAngleRel('B', -25, 5, 'Brake');
           curAngle = brick.GyroAngle(2);
           curAngle = brick.GyroAngle(2);
           curAngle = brick.GyroAngle(2);
                      disp(curAngle);

        end      
    end    

end

