using HorizonSideRobots
include("MainFuncs.jl")
sitedit!(robot, "untitled.sit")
function perimeter(robot)
    moves = MoveToCorner(robot)
    for side in [Ost, Sud, West, Nord]
        moveUntilWall(robot, side, true)
    end
    ReturnHome(robot, moves)
end
perimeter(robot)