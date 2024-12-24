using HorizonSideRobots
include("MainFuncs.jl")#загружаем доп. функции
robot = Robot(animate = true)
sitedit!(robot, "untitled.sit")#загружаем уровень из .sit файла
function superBounceMove(robot, side, steps = 0, bounced = false)
    if isborder(robot, side) && !bounced
        bounced = true
        side = rotate(side, 2)
        steps *= 2
    end
    if isborder(robot, side) && bounced
        return false
    end
    if steps == 0 && bounced
        return true
    end
    move!(robot, side)
    if !bounced
        steps += 1
    else
        steps -= 1
    end
    superBounceMove(robot, side, steps, bounced)
end
superBounceMove(robot, Nord)