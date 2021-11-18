function yellow(brick, angle) 
    brick.StopMotor('A', 'Brake');
    brick.StopMotor('B', 'Brake');
    brick.GyroCalibrate(2);
    pause(0.5);
    
    curAngle = brick.GyroAngle(2);
    curAngle = brick.GyroAngle(2);
    curAngle = brick.GyroAngle(2);
    while (curAngle < (angle - 6))
           brick.MoveMotorAngleRel('A', 25, 5, 'Brake');
           brick.MoveMotorAngleRel('B', -25, 5, 'Brake');
           curAngle = brick.GyroAngle(2);
           curAngle = brick.GyroAngle(2);
           curAngle = brick.GyroAngle(2);           
           disp(curAngle);
    end 
    brick.MoveMotorAngleRel('C', 60, 4000, 'Brake'); 
    brick.MoveMotorAngleRel('A', -30, 200, 'Brake');
    brick.MoveMotorAngleRel('B', -30, 200, 'Brake');
    
end