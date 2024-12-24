using HorizonSideRobots
function recMoveUntilWall(robot, side, steps = 0)
    if isborder(robot, side)
        return steps
    else
        move!(robot, side)
        recMove(robot, side, steps+1)
    end
end
function recMoveSteps(robot, side, steps)
    if steps == 0
        return true
    elseif isborder(robot, side)
        return false
    else
        move!(robot, side)
        steps -= 1
        recMoveSteps(robot, side, steps)
    end
end
function recWallNav(robot, side, sideStep = [rotate(side, 1), 0])
    if !isborder(robot, side)
        move!(robot, side)
        recMoveSteps(robot, rotate(sideStep[1], 2), ceil(sideStep[2]/2))
    else
        sideStep[1] = rotate(sideStep[1], 2)
        sideStep[2] += 1
        recMoveSteps(robot, sideStep[1], sideStep[2])
        recWallNav(robot, side, sideStep)
    end
end

mutable struct LabBot
    robot
    x::Int
    y::Int
    coords
end
LabBot(robot) = LabBot(robot, 0, 0, Set())
function HorizonSideRobots.move!(robot::LabBot, side)
    push!(robot.coords, (robot.x, robot.y))
    if side == Nord
        robot.y -= 1
    elseif side == Sud
        robot.y += 1
    elseif side == West
        robot.x -= 1
    elseif side == Ost
        robot.x += 1
    end
    move!(robot.robot, side)
end
function HorizonSideRobots.putmarker!(robot::LabBot)
    putmarker!(robot.robot)
end
function HorizonSideRobots.isborder(robot::LabBot, side)
    return isborder(robot.robot, side)
end
function getFreeSides(robot)
    sides = []
    for side in [Nord, Ost, Sud, West]
        if !isborder(robot, side)
            push!(sides, side)
        end
    end
    return sides
end
function walkLabyrinth(robot; isGoodSide = (side)->!isborder(robot, side))
    if (robot.x, robot.y) in robot.coords
        return false
    end
    for side in [Nord, Ost, Sud, West]
        if isGoodSide(side)
            move!(robot, side)
            walkLabyrinth(robot)
            move!(robot, rotate(side, 2))
        end
    end
end