
while (state ~= 6)
    touch = brick.TouchPressed(4);
    state = 0;
    bumps = brick.TouchBumps(4);
     %Moving it forward
     display(bumps);
     fprintf("-----");
     
     if touch == 0
         brick.MoveMotorAngleRel('B', -20, 100, 'Brake');
         brick.MoveMotorAngleRel('A', -20, 100, 'Brake');
         pause(1);
     
     elseif touch == 1
         brick.MoveMotorAngleRel('B', 30, 200, 'Brake');
         brick.MoveMotorAngleRel('A', 30, 200, 'Brake');
         pause(1);
         
         brick.MoveMotorAngleRel('B', 18.5, 200, 'Brake');
         brick.MoveMotorAngleRel('A', -18.5, 200, 'Brake');
         pause(1);
     end
end
