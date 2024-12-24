using HorizonSideRobots
include("MainFuncs.jl")
robot = Robot(animate = true)
sitedit!(robot, "untitled.sit")
function task3(robot)
    moves = MoveToCorner(robot)
    side = Ost
    while true
        putmarker!(robot)
        moveUntilWall(robot, side, true)
        side = rotate(side,2)
        if !isborder(robot, Sud)
            move!(robot, Sud)
        else
            break
        end
    end
    ReturnHome(robot, moves)
end
task3(robot)