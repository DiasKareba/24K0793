using HorizonSideRobots
include("MainFuncs.jl")
robot = Robot(animate = true)
sitedit!(robot, "task5.sit")

function GetBorders(robot)
    borders = []
    for side in [Ost, Sud, West, Nord]
        if isborder(robot, side)
            push!(borders, side)
        end
    end
    return borders
end
function DrawOuterPerimeter(robot)
    while lastindex(GetBorders(robot)) != 0
        side = GetBorders(robot)[1]
        putmarker!(robot)
        move!(robot, rotate(side,1))
        if ismarker(robot)
            break
        end
        if lastindex(GetBorders(robot)) == 0
            putmarker!(robot)
            move!(robot, side)
        end
    end
end
function task5(robot)
    moves = MoveToCorner(robot)
    [moveUntilWall(robot, side, true) for side = [Ost, Sud, West, Nord]]
    height = moveUntilWall(robot, Sud)
    moveUntilWall(robot, Nord)
    while !isborder(robot, Ost)
        move!(robot, Ost)
        length = moveUntilWall(robot, Sud)
        if length !=height
            DrawOuterPerimeter(robot)
            break
        end
        moveUntilWall(robot, Nord)
    end
    ReturnHome(robot, moves)
end

task5(robot)