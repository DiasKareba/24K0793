using HorizonSideRobots
include("MainFuncs.jl")
robot = Robot(animate = true)
sitedit!(robot, "untitled.sit")
function DrawSquare(robot, size)
    counter = 0
    for i in 1:size
        putmarker!(robot)
        moveSteps(robot, West, moveSteps(robot, Ost, size-1, true))
        if i < size && !isborder(robot, Nord)
            move!(robot, Nord)
            counter += 1
        end
    end
    moveSteps(robot, Sud, counter)
end
function task10(robot, n, flag = true)
    moves = MoveToCorner(robot, (Sud, West))
    counter = 0
    while true
        if flag
            DrawSquare(robot, n)
        end
        flag = !flag
        if moveSteps(robot, Ost, n) != n
            moveUntilWall(robot, West)
            if moveSteps(robot, Nord, n) != n
                break
            end
            counter += 1
            flag = counter%2 == 0
        end
    end
    ReturnHome(robot, moves, (Sud, West))
end
task10(robot, 3)