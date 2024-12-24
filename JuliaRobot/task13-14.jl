using HorizonSideRobots
include("MainFuncs.jl")#загружаем доп. функции
robot = Robot(animate = true)
sitedit!(robot, "task6.sit")#загружаем уровень из .sit файла
include("SmartRobot.jl")
function stop(robot)
    return GetBorders(robot) == [Ost, Sud]
end
function paintCheckers(robot, homeParity)
    if (robot.x+robot.y)%2 == homeParity
        putmarker!(robot)
    end
end
function chess(robot)
    robot = SmartRobot(robot)
    moves = MoveToCorner(robot)
    resetCoords(robot)
    parity = sum(getHomeCoords(moves))%2
    SetUpdateFunc(robot, ()->paintCheckers(robot, parity))
    paintCheckers(robot, parity)
    snakeWithNav(robot, (Ost, Sud))
    SetUpdateFunc(robot)
    ReturnHome(robot, moves)
end
chess(robot)