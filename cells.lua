---- ##########################################################################################################
---- #                                                                                                        #
---- # Battery % telemetry script for FrSky X7/X7S and Xlite series                                           #
---- #                                                                                                        #
---- # Uses "Cels" Sensor name as voltage input, Compatible with MLVSS and FLVSS Sensor                       #
-----# Gives a accurate percentage of battery voltage left.                                                   #
-----#                                                                                                        #
---- # License GPLv3: http://www.gnu.org/licenses/gpl-3.0.html                                                #
---- #                                                                                                        #
---- # This program is free software; you can redistribute it and/or modify                                   #
---- # it under the terms of the GNU General Public License version 3 as                                      #
---- # published by the Free Software Foundation.                                                             #
---- #                                                                                                        #
---- #                                                                                                        #
---- # Björn Pasteuning / Hobby4life 2019                                                                     #
---- #                                                                                                        #
---- ##########################################################################################################


local BatterySensor ="Cels"
local Percent = 0
local Voltage = 0

local function init_func() -- Called once when model is loaded
  MySensor = getValue(BatterySensor)
end

local function bg_func() -- Called periodically when screen is not visible
  if Voltage == 0 then 
    MySensor = getValue(BatterySensor)
  end
 end

local function run_func(event) -- Called periodically when screen is visible
  bg_func()
  MySensor = getValue(BatterySensor)
  Cells = getCellCount(MySensor)
  Voltage = getCellSum(MySensor)
  Percent = getCellPercent(Voltage / Cells) or 0
  Draw_Screen()
end

--- This function returns the number of cels
function getCellCount(cellData)
  
  if cellData == NIL or cellData == 0 then
    return 0
  else
    return #cellData
  end
end

--- This function parse each individual cell and return the sum of all cels
function getCellSum(cellData)
    cellSum = 0
  if type(cellData) == "table" then
    for k, v in pairs(cellData) do cellSum = cellSum + v end
  end
  return cellSum
end


function Draw_Screen()
  lcd.clear()  
  Gauge_Width = 80
  Gauge_Height = 18
  
  if Cells == 0 then
    lcd.drawText((LCD_W / 2) - ((string.len("NO SENSOR") * 8.5) / 2) ,45,"NO SENSOR", MIDSIZE + BLINK) 
  else
    if Percent < 30 then
      lcd.drawText(LCD_W - 5, 5, Percent.."%", RIGHT + MIDSIZE + BLINK)
      lcd.drawNumber (35,5, (Voltage * 100), RIGHT + MIDSIZE + PREC2 + BLINK)
      lcd.drawText(35, 5, "V", MIDSIZE + BLINK)   
      lcd.drawText((LCD_W / 2) - ((string.len("BATT EMPTY") * 8.5) / 2) ,45,"BATT EMPTY", MIDSIZE + BLINK)
    else
      lcd.drawText(LCD_W - 5, 5, Percent.."%", RIGHT + MIDSIZE)   
      lcd.drawNumber (35,5, (Voltage * 100), RIGHT + MIDSIZE + PREC2)
      lcd.drawText(35, 5, "V", MIDSIZE)     
    end
  end
  
  lcd.drawGauge(5, ((LCD_H / 2) - (Gauge_Height /2)), (LCD_W - 10), Gauge_Height, Percent, 100) 
  if Cells > 0 then
    lcd.drawText((LCD_W / 2) + 16, 8, Cells.." Cell", RIGHT) 
  end
end

--- This function return the percentage remaining in a single Lipo cel
function getCellPercent(cellValue)
  --## Data gathered from commercial lipo sensors
  local myArrayPercentList =
  {
  {3.000, 0},
  {3.093, 1},
  {3.196, 2},
  {3.301, 3},
  {3.401, 4},
  {3.477, 5},
  {3.544, 6},
  {3.601, 7},
  {3.637, 8},
  {3.664, 9},
  {3.679, 10},
  {3.683, 11},
  {3.689, 12},
  {3.692, 13},
  {3.705, 14},
  {3.710, 15},
  {3.713, 16},
  {3.715, 17},
  {3.720, 18},
  {3.731, 19},
  {3.735, 20},
  {3.744, 21},
  {3.753, 22},
  {3.756, 23},
  {3.758, 24},
  {3.762, 25},
  {3.767, 26},
  {3.774, 27},
  {3.780, 28},
  {3.783, 29},
  {3.786, 30},
  {3.789, 31},
  {3.794, 32},
  {3.797, 33},
  {3.800, 34},
  {3.802, 35},
  {3.805, 36},
  {3.808, 37},
  {3.811, 38},
  {3.815, 39},
  {3.818, 40},
  {3.822, 41},
  {3.825, 42},
  {3.829, 43},
  {3.833, 44},
  {3.836, 45},
  {3.840, 46},
  {3.843, 47},
  {3.847, 48},
  {3.850, 49},
  {3.854, 50},
  {3.857, 51},
  {3.860, 52},
  {3.863, 53},
  {3.866, 54},
  {3.870, 55},
  {3.874, 56},
  {3.879, 57},
  {3.888, 58},
  {3.893, 59},
  {3.897, 60},
  {3.902, 61},
  {3.906, 62}, 
  {3.911, 63}, 
  {3.918, 64},
  {3.923, 65},
  {3.928, 66}, 
  {3.939, 67},
  {3.943, 68},
  {3.949, 69},
  {3.955, 70},
  {3.961, 71}, 
  {3.968, 72},
  {3.974, 73},
  {3.981, 74},
  {3.987, 75},
  {3.994, 76},
  {4.001, 77}, 
  {4.007, 78}, 
  {4.014, 79},
  {4.021, 80},
  {4.029, 81},
  {4.036, 82},
  {4.044, 83},
  {4.052, 84},
  {4.062, 85},
  {4.074, 86},
  {4.085, 87},
  {4.095, 88},
  {4.105, 89},
  {4.111, 90},
  {4.116, 91},
  {4.120, 92},
  {4.125, 93},
  {4.129, 94},
  {4.135, 95},
  {4.145, 96},
  {4.176, 97},
  {4.179, 98},
  {4.193, 99},
  {4.200, 100}
  }

  if cellValue >= 4.2 then
		cellValue = 4.2
	elseif cellValue <= 3 then
		result = 0
		return result
	end
  
  for i, v in ipairs( myArrayPercentList ) do
    if v[ 1 ] >= cellValue then
      result =  v[ 2 ]
     break
     end
  end
  
  return result
 end



return { run=run_func, background=bg_func, init=init_func  }
