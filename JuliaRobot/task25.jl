using HorizonSideRobots
include("MainFuncs.jl")#загружаем доп. функции
robot = Robot(animate = true)
sitedit!(robot, "untitled.sit")#загружаем уровень из .sit файла
function recChessA(robot, side)
    if !isborder(robot, side)
        move!(robot, side)
        recChessB(robot, side)
    end
end
function recChessB(robot, side)
    putmarker!(robot)
    if !isborder(robot, side)
        move!(robot, side)
        recChessA(robot, side)
    end
end
recChessA(robot, Sud)