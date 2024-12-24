using HorizonSideRobots
include("MainFuncs.jl")#загружаем доп. функции
robot = Robot(animate = true)
sitedit!(robot, "untitled.sit")#загружаем уровень из .sit файла
function func(robot)
    #код сюда
end
func(robot)