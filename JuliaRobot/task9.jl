using HorizonSideRobots
include("MainFuncs.jl")
robot = Robot(animate = true)
sitedit!(robot, "untitled.sit")
function layChessStrip(robot, side, lay = false)
    while true
        if lay
            putmarker!(robot)
        end
        lay = !lay
        if isborder(robot, Ost)
            break
        end
        move!(robot, side)
    end
end
function task9(robot)
    moves = MoveToCorner(robot)
    offs = (sum([x[2] for x=moves])%2 == 0)
    while true
        layChessStrip(robot, Ost, offs)
        offs = !offs
        moveUntilWall(robot, West)
        if isborder(robot, Sud)
            break
        end
        move!(robot, Sud)
    end
    ReturnHome(robot, moves)
end
task9(robot)