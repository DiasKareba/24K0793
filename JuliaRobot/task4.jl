using HorizonSideRobots
include("MainFuncs.jl")
include("SmartRobot.jl")
robot = Robot(animate = true)
sitedit!(robot, "untitled.sit")
function DrawDiagonal(robot, side)
    counter = 0
    while true
        if !(isborder(robot, side) || isborder(robot, rotate(side, 1)))
            counter += 1
            move!(robot, side)
            move!(robot, rotate(side, 1))
            putmarker!(robot)
        else
            break
        end
    end
    for _ in 1:counter 
        move!(robot, rotate(side, 2))
        move!(robot, rotate(side, 3))
    end
end
function task4(robot)
    for side in [Ost, Nord, West, Sud]
        DrawDiagonal(robot, side)
    end
end
task4(robot)