using HorizonSideRobots
function movetoend!(stop_condition::Function, robot, side)
    n=0
    while !stop_condition()
        move!(robot, side)
        n+=1
    end
    return n
end
function snake!(stop_condition::Function, robot, sides::NTuple{2,HorizonSide})
    s=sides[1]
    while !stop_condition()
        movetoend!(()->stop_condition() || isborder(robot, s), robot,s)
        if stop_condition()
            break
        end
        s = rotate(s,2)
        move!(robot, sides[2])
    end
end
function spiral!(stop_condition::Function, robot)
    steps = 1
    side = Nord
    while true
        side = rotate(side,1)
        moveSteps(robot, side, steps, breakFunc = stop_condition)
        if stop_condition()
            break
        end
        side = rotate(side,1)
        moveSteps(robot, side, steps, breakFunc = stop_condition)
        if stop_condition()
            break
        end
        steps += 1
    end
end