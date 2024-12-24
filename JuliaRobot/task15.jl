using HorizonSideRobots
include("MainFuncs.jl")#загружаем доп. функции
include("SmartRobot.jl")
robot = Robot(animate = true)
sitedit!(robot, "task6.sit")#загружаем уровень из .sit файла
function markOnDiagonal(robot)
    if abs(robot.x) == abs(robot.y) != 0
        putmarker!(robot)
    end
end
function task15(robot)
    robot = SmartRobot(robot)
    home = MoveToCorner(robot)
    SetUpdateFunc(robot, ()->markOnDiagonal(robot))
    snakeWithNav(robot, (Sud, Ost))
    ReturnHome(robot, home)
end
task15(robot)