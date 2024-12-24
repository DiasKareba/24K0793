using HorizonSideRobots
mutable struct SmartRobot #обертка робота
    robot::Robot#сам робот
    x::Int #координаты робота
    y::Int
    allowPaint::Bool #разрешение красить(если == false, то робот не сможет ставить маркеры)
    update::Function #функция, которая выполняется роботом каждый шаг
end
function SmartRobot(robot::Robot) #конструктор робота, ставит стандартные значения всему кроме самого робота( ()->0 это пустая функция )
    return SmartRobot(robot, 0, 0, true, ()->0)
end
function SetUpdateFunc(robot::SmartRobot, func = ()->0)# устанавливает функцию обновления робота, если не ставить новую функция, то будет поставлена пустая функция
    robot.update = func
end
function resetCoords(robot::SmartRobot)#ставит координаты на 0 0
    robot.x = 0
    robot.y = 0
end
function getHomeCoords(moves)#считает координаты начальной клетки из пути до угла
    homeX = 0
    homeY = 0
    for move in moves 
        if move[1] == Nord
            homeY += move[2]
        elseif move[1] == Sud
            homeY -= move[2]
        elseif move[1] == West
            homeX += move[2]
        elseif move[1] == Ost
            homeX -= move[2]
        end
    end
    return (homeX, homeY)
end
function HorizonSideRobots.move!(robot::SmartRobot, side)#обертка move!, обновляет координаты и выполняет функцию обновления
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
    robot.update()
end
function HorizonSideRobots.putmarker!(robot::SmartRobot)#обертка putmarker!, ставит маркер, только если allowPaint == true
    if robot.allowPaint
        putmarker!(robot.robot)
    end
end
function HorizonSideRobots.isborder(robot::SmartRobot, side)
    return isborder(robot.robot, side)
end
function HorizonSideRobots.ismarker(robot::SmartRobot)
    return ismarker(robot.robot)
end