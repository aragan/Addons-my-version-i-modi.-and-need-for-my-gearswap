    if args[1] == nil or args[1] == "help" then
        log('Use //gametime or //gt as follows:')
        log('Positioning:')
        log('//gt [timex/timey/daysx/daysy] <pos> :: example: //gt timex 125')
        log('//gt [time/days] reset :: example: //gt days reset')
        
        log('Text features:')
        log('//gt timeSize <size> :: example: //gt timeSize 10')
        log('//gt timeFont <fontName> :: example: //gt timeFont Verdana')
        log('//gt daySize <size> :: example: //gt daySize 10')
        log('//gt dayFont <fontName> :: example: //gt dayFont Verdana')
        
        log('Visibility:')
        log('//gt [time/days] [show/hide] :: example //gt time hide')
        log('//gt axis [horizontal/vertical] :: week display axis')
        log('//gt [time/days] alpha 1-255. :: Sets the transparency. Lowest numbers = more transparent.')
        log('//gt mode 1-4 :: Fullday; Abbreviated; Element names; Compact')
        
        log('Routes:')
        log('//gt route :: Displays route names.')
        log('//gt route [route name] :: Displays arrival time for route.')
        
        log('Misc:')
        log('//gt zero [on/off] :: Displays the time with leading zeros. 04:05 instead of 4:05')
        log('//gt days [1-8] :: Limits the number of days displayed')
        log('//gt alert :: Toggle display in chat log for day and moon changes')
        log('Remember to //gt save when you\'re happy with your settings.')