module MapDisplay exposing (..)
import MapGenerator exposing (..)
import Model exposing (..)
import Map exposing (recInit)





showMap : List Room -> Int -> Map -> Map
showMap rooms number drawnrooms=
    let
        roomNowTemp = List.head rooms 
        getRoomNow = 
            case roomNowTemp of 
                Just a ->
                    a
                Nothing ->
                    roomConfig
        roomNow = getRoomNow 
        newRooms = List.drop 1 rooms

        monstersNew = drawMonsters roomNow 
        obstaclesNew= drawObstacle roomNow 
        roadsNew=drawRoads roomNow
        wallsNew=drawWalls roomNow
        doorsNew=drawDoors roomNow
    in
        if number == 0 then 
            drawnrooms
        else 
            showMap newRooms (number-1)  {drawnrooms|walls=drawnrooms.walls++wallsNew,roads=drawnrooms.roads++roadsNew,obstacles=drawnrooms.obstacles++obstaclesNew,monsters=drawnrooms.monsters++monstersNew,doors=drawnrooms.doors++doorsNew}


drawMonsters : Room -> List Rectangle
drawMonsters room =
    []

drawObstacle : Room -> List Rectangle
drawObstacle room =
    []

drawDoors : Room -> List Rectangle
drawDoors room =
    let
        (x,y) = room.position
        newX = toFloat (2500*x)
        newY = toFloat (2500*y)

        recPosition model =
            case model of 
                (2,1) ->
                    Rectangle (newX+1800) (newY+900) 100 200 recInit
                (1,2) ->
                    Rectangle (newX+900) (newY+1800) 200 100 recInit
                (0,1) ->
                    Rectangle (newX+100) (newY+900) 100 200 recInit
                (1,0) ->
                    Rectangle (newX+900) (newY+100) 200 100 recInit
                _ ->
                    Rectangle 0 0 0 0 recInit
            
        
        roadList1 = room.road
        roadList2 = List.map (\value -> ( Tuple.first value-x+1, Tuple.second value-y+1)) roadList1
    in
        List.map recUpdate <| List.map recPosition roadList2


drawRoads : Room -> List Rectangle
drawRoads room = 
    let
        (x,y) = room.position
        newX = toFloat (2500*x)
        newY = toFloat (2500*y)

        recPosition model =
            case model of 
                (2,1) ->
                    [Rectangle (newX+2000) (newY+800) 500 100 recInit,Rectangle (newX+2000) (newY+1100) 500 100 recInit]
                (1,2) ->
                    [Rectangle (newX+800) (newY+2000) 100 500 recInit,Rectangle (newX+1100) (newY+2000) 100 500 recInit]
                (0,1) ->
                    [Rectangle (newX-500) (newY+800) 500 100 recInit,Rectangle (newX-500) (newY+1100) 500 100 recInit]
                (1,0) ->
                    [Rectangle (newX+800) (newY-500) 100 500 recInit,Rectangle (newX+1100) (newY-500) 100 500 recInit]
                _ ->
                    [Rectangle 0 0 0 0 recInit]
            
        
        roadList1 = room.road
        roadList2 = List.map (\value -> ( Tuple.first value-x+1, Tuple.second value-y+1)) roadList1
    in
        List.map recUpdate <| List.concat <| List.map recPosition roadList2
    

drawWalls : Room -> List Rectangle
drawWalls room=
    let
        (x,y) = room.position
        newX = toFloat (2000*x+500*x)
        newY = toFloat (2000*y+500*y)

        roadList1 = room.road

        -- d1=Debug.log "p" room.position
        -- d2=Debug.log "edge" roadList1


        roadList2 = List.map (\value -> ( Tuple.first value-x+1, Tuple.second value-y+1)) roadList1

        -- d3 = Debug.log "update" roadList2 
        newRec1 = 
            if List.member (0,1) roadList2 then
                [Rectangle newX newY 200 900 recInit,Rectangle newX (newY+1100) 200 900 recInit]
                -- []
            else
                [Rectangle newX newY 200 2000 recInit]
        newRec2 = 
            if List.member (1,0) roadList2 then 
                [Rectangle newX newY 900 200 recInit,Rectangle (newX+1100) newY 900 200 recInit]
                -- []
            else  
                [Rectangle newX newY 2000 200 recInit]
        newRec3 = 
            if List.member (2,1) roadList2 then
                [Rectangle (newX+1800) newY 200 900 recInit,Rectangle (newX+1800) (newY+1100) 200 900 recInit]
                -- []
            else 
                [Rectangle (newX+1800) newY 200 2000 recInit]
        newRec4 = 
            if List.member (1,2) roadList2 then
                [Rectangle newX (newY+1800) 900 200 recInit,Rectangle (newX+1100) (newY+1800) 900 200 recInit]
                -- []
            else 
                [Rectangle newX (newY+1800) 2000 200 recInit]
        
    in
        List.map recUpdate (List.concat [newRec1,newRec2,newRec3,newRec4])